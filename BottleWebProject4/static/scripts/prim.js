// Глобальные переменные
let points = [];
let selectedPointId = null;
let selectedLine = null;
let pointsLayer = null;
let linesSvg = null;
let draggable = null;
let currentMST = null;

// Функция генерации случайных расстояний
async function generateRandomDistancesPrim() {
    const minInput = document.getElementById('random-min');
    const maxInput = document.getElementById('random-max');

    if (!minInput || !maxInput) {
        console.error('Input elements not found');
        alert('Error: Input elements not found');
        return;
    }

    let min = parseInt(minInput.value);
    let max = parseInt(maxInput.value);

    if (isNaN(min)) {
        alert('Please enter a valid minimum value');
        minInput.focus();
        return;
    }
    if (isNaN(max)) {
        alert('Please enter a valid maximum value');
        maxInput.focus();
        return;
    }
    if (min >= max) {
        alert('Minimum must be less than maximum');
        minInput.focus();
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

            // Обновляем выпадающий список вершин
            updateStartVertexSelect();
            // Очищаем предыдущий результат MST
            clearMSTResult();
            alert(`Random distances assigned to ${data.count} line(s)!`);
        }

    } catch (error) {
        console.error('Error generating random distances:', error);
        alert('Error generating random distances');
    }
}

// Функция очистки графа
async function clearGraphPrim() {
    if (!confirm('Clear all points and lines?')) return;

    points.forEach(p => {
        if (p.element) p.element.remove();
    });
    points = [];
    window.lineConnections = [];
    selectedPointId = null;
    selectedLine = null;
    currentMST = null;

    await fetch('/api/graph/update', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ vertices: {}, edges: [] })
    });

    redrawAll();
    updateStartVertexSelect();
    clearMSTResult();
}

// Обновление выпадающего списка вершин
function updateStartVertexSelect() {
    const select = document.getElementById('start-vertex-select');
    if (!select) return;

    select.innerHTML = '<option value="">-- Select a vertex --</option>';

    points.forEach(point => {
        const option = document.createElement('option');
        option.value = point.id;
        option.textContent = `Vertex ${point.id}`;
        select.appendChild(option);
    });
}

// Очистка результатов MST
function clearMSTResult() {
    const resultDiv = document.getElementById('mst-result');
    const edgesList = document.getElementById('mst-edges-list');
    const totalDiv = document.getElementById('mst-total');

    if (resultDiv) resultDiv.classList.remove('show');
    if (edgesList) edgesList.innerHTML = '';
    if (totalDiv) totalDiv.innerHTML = '';

    // Снимаем подсветку с рёбер
    if (linesSvg) {
        const allLines = linesSvg.querySelectorAll('line');
        allLines.forEach(line => {
            line.style.stroke = '#bdc2ce';
            line.style.strokeWidth = '2';
        });
    }

    currentMST = null;
}

// Подсветка рёбер MST
function highlightMSTEdges(mstEdges) {
    if (!linesSvg) return;

    // Сначала сбрасываем все рёбра
    const allLines = linesSvg.querySelectorAll('line');
    allLines.forEach(line => {
        line.style.stroke = '#bdc2ce';
        line.style.strokeWidth = '2';
    });

    // Подсвечиваем рёбра MST
    mstEdges.forEach(edge => {
        const lineElement = document.querySelector(`line[data-from="${edge.from}"][data-to="${edge.to}"]`) ||
            document.querySelector(`line[data-from="${edge.to}"][data-to="${edge.from}"]`);
        if (lineElement) {
            lineElement.style.stroke = '#4caf50';
            lineElement.style.strokeWidth = '4';
        }
    });
}

// Отображение результатов MST
function displayMSTResult(mstData) {
    const resultDiv = document.getElementById('mst-result');
    const edgesList = document.getElementById('mst-edges-list');
    const totalDiv = document.getElementById('mst-total');

    if (!resultDiv || !edgesList || !totalDiv) return;

    if (!mstData.success || !mstData.mst || mstData.mst.length === 0) {
        edgesList.innerHTML = '<div style="color: #c62828;">No MST found. Make sure the graph is connected.</div>';
        totalDiv.innerHTML = '';
        resultDiv.classList.add('show');
        return;
    }

    edgesList.innerHTML = '';
    let totalWeight = 0;

    mstData.mst.forEach((edge, index) => {
        const edgeDiv = document.createElement('div');
        edgeDiv.className = 'mst-edge';
        edgeDiv.innerHTML = `${index + 1}. ${edge.from} → ${edge.to} : <strong>${edge.weight.toFixed(2)}</strong>`;
        edgesList.appendChild(edgeDiv);
        totalWeight += edge.weight;
    });

    totalDiv.innerHTML = `Total MST Weight: <strong style="font-size: 16px;">${totalWeight.toFixed(2)}</strong>`;
    resultDiv.classList.add('show');

    // Подсвечиваем рёбра MST
    highlightMSTEdges(mstData.mst);

    currentMST = mstData.mst;
}

// Алгоритм Прима
async function computePrimMST() {
    const select = document.getElementById('start-vertex-select');
    const startVertex = select ? select.value : null;

    if (!startVertex) {
        alert('Please select a starting vertex for Prim\'s algorithm!');
        return;
    }

    if (points.length === 0) {
        alert('No vertices in graph. Add some points first.');
        return;
    }

    try {
        const response = await fetch('/api/prim/mst', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ start_vertex: parseInt(startVertex) })
        });

        const data = await response.json();

        if (data.success) {
            displayMSTResult(data);
        } else {
            alert(data.error || 'Error computing MST');
        }

    } catch (error) {
        console.error('Error:', error);
        alert('Error computing Minimum Spanning Tree');
    }
}

// Инициализация редактора Прима
function initPrimEditor() {
    console.log('Initializing Prim editor...');

    pointsLayer = document.getElementById('points-layer');
    linesSvg = document.getElementById('lines-layer');
    draggable = document.getElementById('point-drag');

    window.pointsLayer = pointsLayer;
    window.linesSvg = linesSvg;
    window.draggable = draggable;

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

    loadGraph();

    const randomBtn = document.getElementById('random-btn');
    if (randomBtn) {
        randomBtn.onclick = generateRandomDistancesPrim;
    }

    const clearBtn = document.getElementById('clear-graph-btn');
    if (clearBtn) {
        clearBtn.onclick = clearGraphPrim;
    }

    const primBtn = document.getElementById('prim-btn');
    if (primBtn) {
        primBtn.onclick = computePrimMST;
    }

    // Наблюдаем за изменениями графа для обновления списка вершин
    const observer = new MutationObserver(() => {
        updateStartVertexSelect();
    });

    if (pointsLayer) {
        observer.observe(pointsLayer, { childList: true, subtree: true });
    }

    updateStartVertexSelect();
}

// Переопределяем функции addPoint и removePoint для обновления списка вершин
const originalAddPoint = window.addPoint;
if (originalAddPoint) {
    window.addPoint = function (x, y) {
        originalAddPoint(x, y);
        setTimeout(updateStartVertexSelect, 100);
    };
}

const originalRemovePoint = window.removePoint;
if (originalRemovePoint) {
    window.removePoint = function (pointId) {
        originalRemovePoint(pointId);
        setTimeout(() => {
            updateStartVertexSelect();
            clearMSTResult();
        }, 100);
    };
}

// Автоматический запуск инициализации
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initPrimEditor);
} else {
    initPrimEditor();
}