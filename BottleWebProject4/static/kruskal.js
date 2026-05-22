// Флаг для предотвращения двойной инициализации
let isKruskalInitialized = false;

// Функция генерации случайных расстояний для страницы Краскала
async function generateRandomDistancesKruskal() {
    const minInput = document.getElementById('random-min');
    const maxInput = document.getElementById('random-max');

    if (!minInput || !maxInput) {
        console.error('Input elements not found');
        alert('Ошибка: элементы ввода не найдены');
        return;
    }

    let min = parseInt(minInput.value);
    let max = parseInt(maxInput.value);

    if (isNaN(min)) {
        alert('Введите корректное минимальное значение');
        minInput.focus();
        return;
    }
    if (isNaN(max)) {
        alert('Введите корректное максимальное значение');
        maxInput.focus();
        return;
    }
    if (min >= max) {
        alert('Минимум должен быть меньше максимума');
        minInput.focus();
        return;
    }
    if (min < 0 || max < 0) {
        alert('Значения не могут быть отрицательными');
        return;
    }

    try {
        const response = await fetch('/api/graph/random-distances', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ min: min, max: max })
        });

        const data = await response.json();

        if (data.success) {
            // Обновляем локальные данные
            const graphResponse = await fetch('/api/graph');
            const graphData = await graphResponse.json();

            if (graphData.edges) {
                window.lineConnections = graphData.edges;
                if (typeof redrawLines === 'function') {
                    redrawLines();
                }
            }

            alert(`Случайные расстояния присвоены ${data.count} ребру(ам)!`);
        }

    } catch (error) {
        console.error('Error generating random distances:', error);
        alert('Ошибка генерации случайных расстояний');
    }
}

// Функция очистки графа для страницы Краскала
async function clearGraphKruskal() {
    if (!confirm('Очистить все точки и линии?')) return;

    // Очищаем точки из DOM
    if (points && points.length) {
        points.forEach(p => {
            if (p.element && p.element.parentNode) {
                p.element.remove();
            }
        });
    }

    points = [];
    window.lineConnections = [];
    selectedPointId = null;
    selectedLine = null;

    // Очищаем SVG линии
    if (linesSvg) {
        linesSvg.innerHTML = '';
    }
    lines = [];

    await fetch('/api/graph/update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ vertices: {}, edges: [] })
    });

    if (typeof redrawAll === 'function') {
        redrawAll();
    }
    
    // Скрываем панель результатов
    const resultPanel = document.getElementById('result-panel');
    if (resultPanel) {
        resultPanel.style.display = 'none';
    }
}

// Показать результаты алгоритма Краскала
async function showKruskalMST() {
    try {
        const pointsCount = points.length;
        
        if (pointsCount === 0) {
            alert('Нет вершин в графе. Добавьте несколько точек.');
            return;
        }
        
        if (pointsCount < 2) {
            alert('Для построения минимального остова нужно минимум 2 вершины.');
            return;
        }
        
        // Строим матрицу смежности
        const n = pointsCount;
        const INF = 999999;
        const matrix = Array(n).fill().map(() => Array(n).fill(INF));
        
        // Заполняем диагональ нулями
        for (let i = 0; i < n; i++) {
            matrix[i][i] = 0;
        }
        
        // Создаём карту id вершины -> индекс
        const vertexIds = points.map(p => p.id).sort((a,b) => a - b);
        const idToIndex = {};
        vertexIds.forEach((id, idx) => { idToIndex[id] = idx; });
        
        // Заполняем матрицу весами из рёбер
        for (const conn of window.lineConnections) {
            const fromIdx = idToIndex[conn.from];
            const toIdx = idToIndex[conn.to];
            const dist = conn.distance || 0;
            if (dist > 0) {
                matrix[fromIdx][toIdx] = dist;
                matrix[toIdx][fromIdx] = dist;
            }
        }
        
        // Отправляем запрос на сервер
        const response = await fetch('/api/kruskal/calculate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ matrix: matrix, n: n })
        });
        
        const data = await response.json();
        
        if (data.success) {
            displayKruskalResult(data.edges, data.totalWeight, vertexIds);
            highlightKruskalEdges(data.edges, vertexIds);
        } else {
            alert(data.message || 'Ошибка выполнения алгоритма');
            clearKruskalHighlight();
        }
        
    } catch (error) {
        console.error('Error:', error);
        alert('Ошибка вычисления минимального остова');
    }
}

// Отображение результатов
function displayKruskalResult(edges, totalWeight, vertexIds) {
    const resultPanel = document.getElementById('result-panel');
    const resultEdgesDiv = document.getElementById('result-edges');
    const totalWeightDiv = document.getElementById('total-weight');
    
    if (!resultPanel || !resultEdgesDiv || !totalWeightDiv) return;
    
    resultPanel.style.display = 'block';
    
    if (!edges || edges.length === 0) {
        resultEdgesDiv.innerHTML = '<div class="error-message">Нет рёбер в остове</div>';
        totalWeightDiv.innerHTML = '';
        return;
    }
    
    // Создаём HTML для списка рёбер
    let html = '';
    for (const edge of edges) {
        // Преобразуем индексы обратно в ID вершин
        const uId = vertexIds[edge.u - 1];
        const vId = vertexIds[edge.v - 1];
        html += `
            <div class="edge-item">
                <span>📌 Вершина ${uId} — Вершина ${vId}</span>
                <span class="edge-weight">вес: ${edge.weight}</span>
            </div>
        `;
    }
    resultEdgesDiv.innerHTML = html;
    totalWeightDiv.innerHTML = `🎯 Суммарный вес остова: ${totalWeight}`;
}

// Подсветка рёбер, входящих в MST
function highlightKruskalEdges(mstEdges, vertexIds) {
    // Создаём Set для быстрого поиска
    const mstSet = new Set();
    for (const edge of mstEdges) {
        const uId = vertexIds[edge.u - 1];
        const vId = vertexIds[edge.v - 1];
        const key = `${Math.min(uId, vId)}-${Math.max(uId, vId)}`;
        mstSet.add(key);
    }
    
    // Проходим по всем линиям и подсвечиваем нужные
    lines.forEach(line => {
        const key = `${Math.min(line.fromId, line.toId)}-${Math.max(line.fromId, line.toId)}`;
        if (mstSet.has(key)) {
            line.element.setAttribute('stroke', '#27ae60');
            line.element.setAttribute('stroke-width', '5');
            if (line.label) {
                line.label.setAttribute('fill', '#27ae60');
                line.label.setAttribute('font-weight', 'bold');
            }
        } else {
            line.element.setAttribute('stroke', '#bdc2ce');
            line.element.setAttribute('stroke-width', '3');
            if (line.label) {
                line.label.setAttribute('fill', '#e74c3c');
                line.label.setAttribute('font-weight', 'normal');
            }
        }
    });
}

// Очистка подсветки
function clearKruskalHighlight() {
    lines.forEach(line => {
        line.element.setAttribute('stroke', '#bdc2ce');
        line.element.setAttribute('stroke-width', '3');
        if (line.label) {
            line.label.setAttribute('fill', '#e74c3c');
            line.label.setAttribute('font-weight', 'normal');
        }
    });
    
    const resultPanel = document.getElementById('result-panel');
    if (resultPanel) {
        resultPanel.style.display = 'none';
    }
}

// Инициализация редактора Краскала (только один раз)
function initKruskalEditor() {
    // Защита от двойной инициализации
    if (isKruskalInitialized) {
        console.log('Kruskal editor already initialized, skipping...');
        return;
    }

    // Проверяем, что мы на странице Краскала
    if (window.location.pathname !== '/kruskal') {
        console.log('Not on Kruskal page, skipping init');
        return;
    }

    isKruskalInitialized = true;
    console.log('Initializing Kruskal editor...');

    // Получаем DOM элементы
    const canvas = document.getElementById('canvas');
    pointsLayer = document.getElementById('points-layer');
    linesSvg = document.getElementById('lines-layer');
    draggable = document.getElementById('point-drag');

    if (!pointsLayer || !linesSvg) {
        console.error('Required DOM elements not found');
        return;
    }

    // Очищаем слой точек (чтобы не было дублей)
    pointsLayer.innerHTML = '';

    // Очищаем глобальные массивы
    if (typeof points !== 'undefined' && points.length) {
        points = [];
    }
    if (typeof window.lineConnections !== 'undefined') {
        window.lineConnections = [];
    }
    if (typeof lines !== 'undefined') {
        lines = [];
    }
    selectedPointId = null;
    selectedLine = null;

    // Настройка Drag & Drop для перетаскивания кнопки
    if (draggable) {
        // Удаляем старый обработчик через клон
        const newDraggable = draggable.cloneNode(true);
        draggable.parentNode.replaceChild(newDraggable, draggable);
        draggable = newDraggable;

        draggable.addEventListener('dragstart', (e) => {
            e.dataTransfer.setData('text/plain', 'point');
        });
    }

    // Настройка слоя точек
    pointsLayer.addEventListener('dragover', (e) => e.preventDefault());

    pointsLayer.addEventListener('drop', (e) => {
        e.preventDefault();
        const rect = pointsLayer.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        if (typeof addPoint === 'function') {
            addPoint(x, y);
        }
    });

    pointsLayer.addEventListener('dblclick', (e) => {
        const target = e.target;
        if (target.classList && target.classList.contains('point')) {
            const id = parseInt(target.dataset.id);
            if (typeof removePoint === 'function') {
                removePoint(id);
                clearKruskalHighlight();
            }
        }
    });

    pointsLayer.addEventListener('click', () => {
        if (typeof clearSelectedPoints === 'function') {
            clearSelectedPoints();
        }
        if (selectedLine) {
            if (selectedLine.style) {
                selectedLine.style.stroke = '#bdc2ce';
            }
            selectedLine = null;
        }
    });

    // Настройка SVG слоя для линий
    linesSvg.style.pointerEvents = 'none';

    // Загружаем граф с сервера
    if (typeof loadGraph === 'function') {
        loadGraph();
    }

    // Назначаем обработчики кнопок
    const randomBtn = document.getElementById('random-btn');
    if (randomBtn) {
        randomBtn.onclick = generateRandomDistancesKruskal;
    }

    const clearBtn = document.getElementById('clear-graph-btn');
    if (clearBtn) {
        clearBtn.onclick = clearGraphKruskal;
    }

    const computeBtn = document.getElementById('kruskal-btn');
    if (computeBtn) {
        computeBtn.onclick = showKruskalMST;
    }
    
    // Обработчик кнопки очистки результатов
    const clearResultBtn = document.getElementById('clear-result-btn');
    if (clearResultBtn) {
        clearResultBtn.onclick = clearKruskalHighlight;
    }
}

// Инициализация при загрузке страницы (только для /kruskal)
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        if (window.location.pathname === '/kruskal') {
            setTimeout(initKruskalEditor, 100);
        }
    });
} else {
    if (window.location.pathname === '/kruskal') {
        setTimeout(initKruskalEditor, 100);
    }
}