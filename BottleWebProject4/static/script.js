// Глобальные переменные
const MAX_POINTS = 10;
const MIN_DISTANCE = 0.0001; // строго больше 0
const MAX_DISTANCE = 1000000; // меньше или равно миллиону

let points = [];
let lines = [];
let selectedPointId = null;
let selectedLine = null;
let isDragging = false;
let dragTarget = null;
let dragTargetId = null;
let dragStartX = 0, dragStartY = 0;
let dragStarted = false;

// DOM элементы для основного редактора
let pointsLayer = document.getElementById('points-layer');
let linesSvg = document.getElementById('lines-layer');
let draggable = document.getElementById('point-drag');

window.lineConnections = [];

// Загрузка графа
async function loadGraph() {
    try {
        const response = await fetch('/api/graph');
        const data = await response.json();

        // Очищаем существующие точки
        points.forEach(point => {
            if (point.element && point.element.parentNode) {
                point.element.remove();
            }
        });
        points = [];

        if (data.vertices) {
            const vertexEntries = Object.entries(data.vertices);
            // Берём только первые 15 точек
            const limitedVertices = vertexEntries.slice(0, MAX_POINTS);

            for (const [id, point] of limitedVertices) {
                points.push({
                    id: parseInt(id),
                            x: point.x,
                            y: point.y,
                            element: null
                });
            }

            // Если точек было больше лимита, показываем предупреждение
            if (vertexEntries.length > MAX_POINTS) {
                alert(`Only ${MAX_POINTS} points loaded (maximum limit).`);
            }
        }

        if (data.edges) {
            window.lineConnections = data.edges;
        } else {
            window.lineConnections = [];
        }

        redrawAll();
        updateVertexSelect();
    } catch (error) {
        console.error('Error loading graph:', error);
    }
}


// Сохранение графа
async function saveGraph() {
    const graphData = {
        vertices: {},
        edges: window.lineConnections
    };

    points.forEach(point => {
        graphData.vertices[point.id] = { x: point.x, y: point.y };
    });

    try {
        await fetch('/api/graph/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(graphData)
        });
    } catch (error) {
        console.error('Error saving graph:', error);
    }
}

// Отрисовка линий
function redrawLines() {
    if (!linesSvg) return;
    linesSvg.innerHTML = '';
    lines = [];

    if (!window.lineConnections) return;

    window.lineConnections.forEach(conn => {
        const fromPoint = points.find(p => p.id === conn.from);
        const toPoint = points.find(p => p.id === conn.to);

        if (!fromPoint || !toPoint) return;

        const distance = conn.distance || 0;

        const lineElem = document.createElementNS('http://www.w3.org/2000/svg', 'line');
        lineElem.setAttribute('x1', fromPoint.x);
        lineElem.setAttribute('y1', fromPoint.y);
        lineElem.setAttribute('x2', toPoint.x);
        lineElem.setAttribute('y2', toPoint.y);
        lineElem.classList.add('line');

        lineElem.addEventListener('click', (e) => {
            e.stopPropagation();
            selectLine(lineElem, conn.from, conn.to);
        });

        lineElem.addEventListener('dblclick', (e) => {
            e.stopPropagation();
            editLineDistance(conn.from, conn.to);
        });

        linesSvg.appendChild(lineElem);

        const midX = (fromPoint.x + toPoint.x) / 2;
        const midY = (fromPoint.y + toPoint.y) / 2;
        const angle = Math.atan2(toPoint.y - fromPoint.y, toPoint.x - fromPoint.x);
        const offsetX = Math.sin(angle) * 15;
        const offsetY = -Math.cos(angle) * 15;

        const textElem = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        textElem.setAttribute('x', midX + offsetX);
        textElem.setAttribute('y', midY + offsetY);
        textElem.setAttribute('text-anchor', 'middle');
        textElem.setAttribute('font-size', '12');
        textElem.setAttribute('font-weight', 'bold');

        if (distance > 0) {
            textElem.textContent = distance.toFixed(2);
            textElem.setAttribute('fill', '#e74c3c');
        } else {
            textElem.textContent = '?';
            textElem.setAttribute('fill', '#999');
        }

        linesSvg.appendChild(textElem);

        lines.push({
            fromId: conn.from,
            toId: conn.to,
            element: lineElem,
            label: textElem,
            distance: distance
        });
    });
}

// Отрисовка точек
function redrawPoints() {
    if (!pointsLayer) return;

    points.forEach(point => {
        let pointDiv = point.element;

        if (!pointDiv || !pointDiv.parentNode) {
            pointDiv = document.createElement('div');
            pointDiv.className = 'point';
            pointDiv.textContent = point.id;
            pointDiv.dataset.id = point.id;

            pointDiv.addEventListener('click', onPointClick);
            pointDiv.addEventListener('mousedown', startDrag);
            pointDiv.addEventListener('dragstart', (e) => e.preventDefault());

            pointsLayer.appendChild(pointDiv);
            point.element = pointDiv;
        }

        pointDiv.style.left = point.x + 'px';
        pointDiv.style.top = point.y + 'px';

        if (selectedPointId === point.id) {
            pointDiv.classList.add('selected');
        } else {
            pointDiv.classList.remove('selected');
        }
    });
}

// Обработчик клика по точке
function onPointClick(e) {
    e.stopPropagation();

    if (dragStarted) {
        dragStarted = false;
        return;
    }

    const pointDiv = e.target;
    const id = parseInt(pointDiv.dataset.id);

    if (selectedPointId === null) {
        clearSelectedPoints();
        selectedPointId = id;
        pointDiv.classList.add('selected');
    } else if (selectedPointId !== id) {
        const exists = window.lineConnections.some(conn =>
        (conn.from === selectedPointId && conn.to === id) ||
        (conn.from === id && conn.to === selectedPointId)
        );

        if (!exists) {
            addEdge(selectedPointId, id);
        }
        clearSelectedPoints();
    } else {
        clearSelectedPoints();
    }
}

// Добавление ребра
async function addEdge(v1, v2) {
    try {
        await fetch('/api/graph/edge', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ v1: v1, v2: v2 })
        });

        window.lineConnections.push({ from: v1, to: v2, distance: 0 });
        redrawLines();
        saveGraph();

    } catch (error) {
        console.error('Error adding edge:', error);
    }
}

// Редактирование расстояния
async function editLineDistance(v1, v2) {
    const conn = window.lineConnections.find(c =>
    (c.from === v1 && c.to === v2) ||
    (c.from === v2 && c.to === v1)
    );

    const currentDist = conn && conn.distance ? conn.distance : 0;
    const newDist = prompt('Enter distance:', currentDist > 0 ? currentDist : '');

    if (newDist) {
        const dist = parseFloat(newDist);

        if (isNaN(dist)) {
            alert('Please enter a valid number');
            return;
        }

        if (dist <= MIN_DISTANCE) {
            alert(`Distance must be greater than ${MIN_DISTANCE}`);
            return;
        }

        if (dist > MAX_DISTANCE) {
            alert(`Длина не должна превышать ${MAX_DISTANCE}`);
            return;
        }

        try {
            await fetch('/api/graph/edge/distance', {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ v1: v1, v2: v2, distance: dist })
            });

            if (conn) {
                conn.distance = dist;
            }

            redrawLines();
            saveGraph();
        } catch (error) {
            console.error('Ошибка установки длины:', error);
        }
    }
}


// Выделение линии
function selectLine(lineElement, fromId, toId) {
    if (selectedLine) {
        selectedLine.style.stroke = '#bdc2ce';
        selectedLine.style.strokeWidth = '3';
    }
    selectedLine = lineElement;
    selectedLine.style.stroke = '#5a4d5e';
    selectedLine.style.strokeWidth = '5';
    clearSelectedPoints();
}

// Удаление выделенной линии
async function deleteSelectedLine() {
    if (!selectedLine) return;

    const lineIndex = lines.findIndex(l => l.element === selectedLine);
    if (lineIndex === -1) return;

    const line = lines[lineIndex];

    try {
        await fetch('/api/graph/edge', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ v1: line.fromId, v2: line.toId })
        });

        window.lineConnections = window.lineConnections.filter(conn =>
        !((conn.from === line.fromId && conn.to === line.toId) ||
        (conn.from === line.toId && conn.to === line.fromId))
        );

        if (line.label) line.label.remove();
        line.element.remove();
        lines.splice(lineIndex, 1);
        selectedLine = null;
        saveGraph();

    } catch (error) {
        console.error('Ошибка удаления линии:', error);
    }
}

// Добавление новой точки
async function addPoint(x, y) {
    if (points.length >= MAX_POINTS) {
        alert('Достигнут лимит количества точек (10)');
        return;
    }

    try {
        const response = await fetch('/api/graph/vertex', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ x: x, y: y })
        });

        const data = await response.json();

        const exists = points.some(p => p.id === data.id);
        if (!exists) {
            points.push({
                id: data.id,
                x: data.x,
                y: data.y,
                element: null
            });

            redrawPoints();
            saveGraph();
            updateVertexSelect();
        }
    } catch (error) {
        console.error('Ошибка добавления точки:', error);
    }
}


// Удаление точки
async function removePoint(id) {
    try {
        await fetch(`/api/graph/vertex/${id}`, { method: 'DELETE' });

        const index = points.findIndex(p => p.id === id);
        if (index !== -1) {
            if (points[index].element) points[index].element.remove();
            points.splice(index, 1);
        }

        window.lineConnections = window.lineConnections.filter(conn =>
        conn.from !== id && conn.to !== id
        );

        if (selectedPointId === id) selectedPointId = null;

        redrawAll();
        saveGraph();
        updateVertexSelect();

    } catch (error) {
        console.error('Ошибка удаления точки:', error);
    }
}

// Генерация случайных расстояний для главной страницы
async function generateRandomDistances() {
    const minInput = document.getElementById('random-min');
    const maxInput = document.getElementById('random-max');

    let min = parseInt(minInput.value);
    let max = parseInt(maxInput.value);

    // Проверка на корректность ввода
    if (isNaN(min)) {
        alert('Пожалуйста введите коректный минмимум');
        return;
    }
    if (isNaN(max)) {
        alert('Пожалуйста введите коректный максимум');
        return;
    }

    // Проверка диапазона расстояний
    if (min <= MIN_DISTANCE) {
        alert(`Минимальная длина должна быть больше ${MIN_DISTANCE}`);
        return;
    }
    if (max > MAX_DISTANCE) {
        alert(`Максимальная длина не может превышать ${MAX_DISTANCE}`);
        return;
    }
    if (min >= max) {
        alert('Минимум должен быть меньше максимума');
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
            const graphResponse = await fetch('/api/graph');
            const graphData = await graphResponse.json();

            if (graphData.edges) {
                window.lineConnections = graphData.edges;
                redrawLines();
            }

            alert(`Random distances assigned to ${data.count} line(s)!`);
        }
    } catch (error) {
        console.error('Error generating random distances:', error);
        alert('Error generating random distances');
    }
}


// Очистка графа для главной страницы
async function clearGraph() {
    if (!confirm('Clear all points and lines?')) return;

    points.forEach(p => {
        if (p.element) p.element.remove();
    });
        points = [];
        window.lineConnections = [];
        selectedPointId = null;
        selectedLine = null;

        await fetch('/api/graph/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ vertices: {}, edges: [] })
        });

        redrawAll();
        updateVertexSelect();
}

// Отрисовка всего
function redrawAll() {
    redrawLines();
    redrawPoints();
}

// Очистка выделения точек
function clearSelectedPoints() {
    if (selectedPointId !== null) {
        const oldSelected = points.find(p => p.id === selectedPointId);
        if (oldSelected && oldSelected.element) {
            oldSelected.element.classList.remove('selected');
        }
        selectedPointId = null;
    }
}

// Обновление селекта для Дейкстры
function updateVertexSelect() {
    const select = document.getElementById('source-select');
    if (!select) return;

    select.innerHTML = '<option value="">Select source vertex</option>';
    points.sort((a, b) => a.id - b.id).forEach(point => {
        const option = document.createElement('option');
        option.value = point.id;
        option.textContent = `Vertex ${point.id}`;
        select.appendChild(option);
    });
}

// Перетаскивание
function startDrag(e) {
    const target = e.target.classList.contains('point') ? e.target : null;
    if (!target) return;

    e.stopPropagation();
    e.preventDefault();

    dragStarted = false;
    isDragging = true;
    dragTarget = target;
    dragTargetId = parseInt(dragTarget.dataset.id);
    const point = points.find(p => p.id === dragTargetId);

    if (point) {
        dragStartX = e.clientX - point.x;
        dragStartY = e.clientY - point.y;
    }

    dragTarget.style.cursor = 'grabbing';
    document.addEventListener('mousemove', onDrag);
    document.addEventListener('mouseup', stopDrag);
}

async function onDrag(e) {
    if (!isDragging || !dragTarget) return;
    e.preventDefault();

    dragStarted = true;

    const parentRect = pointsLayer.getBoundingClientRect();
    let newX = e.clientX - dragStartX;
    let newY = e.clientY - dragStartY;

    newX = Math.max(0, Math.min(newX, parentRect.width - 38));
    newY = Math.max(0, Math.min(newY, parentRect.height - 38));

    dragTarget.style.left = newX + 'px';
    dragTarget.style.top = newY + 'px';

    const point = points.find(p => p.id === dragTargetId);
    if (point) {
        point.x = newX;
        point.y = newY;

        await fetch(`/api/graph/vertex/${dragTargetId}/position`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ x: newX, y: newY })
        });
    }

    // Обновляем линии
    lines.forEach(line => {
        const fromPoint = points.find(p => p.id === line.fromId);
        const toPoint = points.find(p => p.id === line.toId);
        if (fromPoint && toPoint && line.element) {
            line.element.setAttribute('x1', fromPoint.x);
            line.element.setAttribute('y1', fromPoint.y);
            line.element.setAttribute('x2', toPoint.x);
            line.element.setAttribute('y2', toPoint.y);

            const midX = (fromPoint.x + toPoint.x) / 2;
            const midY = (fromPoint.y + toPoint.y) / 2;
            const angle = Math.atan2(toPoint.y - fromPoint.y, toPoint.x - fromPoint.x);
            const offsetX = Math.sin(angle) * 15;
            const offsetY = -Math.cos(angle) * 15;

            if (line.label) {
                line.label.setAttribute('x', midX + offsetX);
                line.label.setAttribute('y', midY + offsetY);
            }
        }
    });
}

function stopDrag(e) {
    isDragging = false;
    if (dragTarget) dragTarget.style.cursor = 'grab';
    dragTarget = null;
    dragTargetId = null;
    document.removeEventListener('mousemove', onDrag);
    document.removeEventListener('mouseup', stopDrag);
}

// Инициализация UI для главной страницы
function initUI() {
    const randomBtn = document.getElementById('random-btn');
    if (randomBtn) {
        randomBtn.onclick = generateRandomDistances;
    }

    const clearBtn = document.getElementById('clear-graph-btn');
    if (clearBtn) {
        clearBtn.onclick = clearGraph;
    }
}

// Настройка Drag & Drop для главной страницы
function setupDragAndDrop() {
    if (draggable) {
        draggable.addEventListener('dragstart', (e) => {
            e.dataTransfer.setData('text/plain', 'point');
        });
    }

    if (pointsLayer) {
        pointsLayer.addEventListener('dragover', (e) => e.preventDefault());

        pointsLayer.addEventListener('drop', (e) => {
            e.preventDefault();
            const rect = pointsLayer.getBoundingClientRect();
            addPoint(e.clientX - rect.left, e.clientY - rect.top);
        });

        pointsLayer.addEventListener('dblclick', (e) => {
            const target = e.target;
            if (target.classList && target.classList.contains('point')) {
                removePoint(parseInt(target.dataset.id));
            }
        });

        pointsLayer.addEventListener('click', () => {
            clearSelectedPoints();
            if (selectedLine) {
                selectedLine.style.stroke = '#bdc2ce';
                selectedLine = null;
            }
        });
    }

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Delete') {
            deleteSelectedLine();
        }
    });
}

// Инициализация главного редактора
// Инициализация главного редактора
function initGraphEditor() {
    // Проверяем, не страница ли это Флойда (чтобы не было двойной инициализации)
    if (window.location.pathname === '/floyd') {
        console.log('Floyd page detected, skipping main editor init');
        return;
    }

    console.log('Initializing main graph editor...');

    // Переопределяем DOM элементы
    pointsLayer = document.getElementById('points-layer');
    linesSvg = document.getElementById('lines-layer');
    draggable = document.getElementById('point-drag');

    setupDragAndDrop();
    loadGraph();
    initUI();
}

// Универсальная функция генерации случайных расстояний
window.generateRandomDistancesUniversal = async function(minInputId, maxInputId) {
    const minInput = document.getElementById(minInputId);
    const maxInput = document.getElementById(maxInputId);

    if (!minInput || !maxInput) {
        console.error('Input elements not found');
        return;
    }

    let min = parseInt(minInput.value);
    let max = parseInt(maxInput.value);

    if (isNaN(min)) {
        alert('Please enter a valid minimum value');
        return;
    }
    if (isNaN(max)) {
        alert('Please enter a valid maximum value');
        return;
    }
    if (min >= max) {
        alert('Minimum must be less than maximum');
        return;
    }
    if (min < 0 || max < 0) {
        alert('Values cannot be negative');
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
            const graphResponse = await fetch('/api/graph');
            const graphData = await graphResponse.json();

            if (graphData.edges) {
                window.lineConnections = graphData.edges;
                redrawLines();
            }

            alert(`Random distances assigned to ${data.count} line(s)!`);
        }

    } catch (error) {
        console.error('Error generating random distances:', error);
        alert('Error generating random distances');
    }
};

// Запуск главного редактора
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initGraphEditor);
} else {
    initGraphEditor();
}
