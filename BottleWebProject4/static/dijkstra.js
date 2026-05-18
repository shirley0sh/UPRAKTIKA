// Клиентская логика для работы с графом и вызова Python алгоритма Дейкстры

let verticesData = [];
let edgesList = [];
let currentN = 4;
let syncingFromMatrix = false;
let syncingFromCanvas = false;
let nextVertexId = 1;

const canvasDiv = document.getElementById('canvas');
const linesSvg = document.getElementById('lines-layer');
const pointsLayer = document.getElementById('points-layer');
const matrixContainer = document.getElementById('matrix-container');
const weightMatrixTable = document.getElementById('weight-matrix');
const resultsPanel = document.getElementById('results-panel');

function redrawLinesAndLabels() {
    if (!linesSvg || !canvasDiv) return;
    const rect = canvasDiv.getBoundingClientRect();
    const width = rect.width || 800;
    const height = rect.height || 460;
    linesSvg.setAttribute('viewBox', `0 0 ${width} ${height}`);
    linesSvg.innerHTML = '';
    document.querySelectorAll('.edge-weight-label').forEach(l => l.remove());

    for (let edge of edgesList) {
        if (edge.weight <= 0) continue;
        const fromV = verticesData.find(v => v.id === edge.fromId);
        const toV = verticesData.find(v => v.id === edge.toId);
        if (!fromV || !toV) continue;

        const x1 = fromV.x, y1 = fromV.y;
        const x2 = toV.x, y2 = toV.y;
        const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", x1);
        line.setAttribute("y1", y1);
        line.setAttribute("x2", x2);
        line.setAttribute("y2", y2);
        line.setAttribute("stroke", "#5a4d5e");
        line.setAttribute("stroke-width", "3");
        line.setAttribute("stroke-opacity", "0.85");
        linesSvg.appendChild(line);

        const midX = (x1 + x2) / 2;
        const midY = (y1 + y2) / 2;
        const labelDiv = document.createElement('div');
        labelDiv.className = 'edge-weight-label';
        labelDiv.textContent = edge.weight;
        labelDiv.style.left = midX + 'px';
        labelDiv.style.top = midY + 'px';
        labelDiv.style.position = 'absolute';
        canvasDiv.appendChild(labelDiv);
    }
}

function updateMatrixFromGraph() {
    if (syncingFromMatrix) return;
    syncingFromCanvas = true;
    if (!weightMatrixTable) return;
    for (let i = 1; i <= currentN; i++) {
        for (let j = 1; j <= currentN; j++) {
            if (i !== j) {
                const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
                if (inp) inp.value = '0';
            }
        }
    }
    for (let edge of edgesList) {
        const fromIdx = verticesData.find(v => v.id === edge.fromId)?.labelIndex;
        const toIdx = verticesData.find(v => v.id === edge.toId)?.labelIndex;
        if (fromIdx && toIdx && edge.weight > 0) {
            const inp1 = document.querySelector(`input[data-row='${fromIdx}'][data-col='${toIdx}']`);
            const inp2 = document.querySelector(`input[data-row='${toIdx}'][data-col='${fromIdx}']`);
            if (inp1) inp1.value = edge.weight;
            if (inp2) inp2.value = edge.weight;
        }
    }
    syncingFromCanvas = false;
}

function updateGraphFromMatrix() {
    if (syncingFromCanvas) return;
    syncingFromMatrix = true;
    const newEdgesMap = new Map();
    for (let i = 1; i <= currentN; i++) {
        for (let j = i + 1; j <= currentN; j++) {
            const input = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
            if (!input) continue;
            let val = parseFloat(input.value);
            if (isNaN(val)) val = 0;
            if (val < 0) val = 0;
            if (val > 0) {
                const fromVertex = verticesData.find(v => v.labelIndex === i);
                const toVertex = verticesData.find(v => v.labelIndex === j);
                if (fromVertex && toVertex) {
                    const key = `${Math.min(fromVertex.id, toVertex.id)}-${Math.max(fromVertex.id, toVertex.id)}`;
                    newEdgesMap.set(key, { fromId: fromVertex.id, toId: toVertex.id, weight: val });
                }
            }
        }
    }
    edgesList = Array.from(newEdgesMap.values());
    redrawLinesAndLabels();
    if (resultsPanel) resultsPanel.style.display = 'none';
    syncingFromMatrix = false;

    // Синхронизируем с сервером после изменения графа
    syncGraphToServer();
}

function createVerticesOnCanvas(n) {
    pointsLayer.innerHTML = '';
    verticesData = [];
    edgesList = [];
    const rect = canvasDiv.getBoundingClientRect();
    const w = rect.width || 800;
    const h = rect.height || 460;
    const centerX = w / 2;
    const centerY = h / 2;
    const radius = Math.min(w, h) * 0.32;
    const angleStep = (2 * Math.PI) / n;

    for (let idx = 1; idx <= n; idx++) {
        const angle = angleStep * (idx - 1) - Math.PI / 2;
        const x = centerX + radius * Math.cos(angle);
        const y = centerY + radius * Math.sin(angle);
        const pointId = idx; // Используем label как id для простоты
        const pointDiv = document.createElement('div');
        pointDiv.className = 'graph-point';
        pointDiv.textContent = idx;
        pointDiv.setAttribute('data-id', pointId);
        pointDiv.style.left = (x - 21) + 'px';
        pointDiv.style.top = (y - 21) + 'px';
        pointDiv.draggable = true;

        pointDiv.addEventListener('dragstart', (e) => {
            e.dataTransfer.setData('text/plain', pointId);
            e.dataTransfer.effectAllowed = 'move';
            pointDiv.style.opacity = '0.7';
        });
        pointDiv.addEventListener('dragend', (e) => {
            pointDiv.style.opacity = '1';
        });
        pointDiv.addEventListener('drag', (e) => {
            if (e.clientX === 0 && e.clientY === 0) return;
            const canvasRect = canvasDiv.getBoundingClientRect();
            let newX = e.clientX - canvasRect.left - 21;
            let newY = e.clientY - canvasRect.top - 21;
            newX = Math.min(Math.max(8, newX), canvasRect.width - 42);
            newY = Math.min(Math.max(8, newY), canvasRect.height - 42);
            pointDiv.style.left = newX + 'px';
            pointDiv.style.top = newY + 'px';
            const vertex = verticesData.find(v => v.id === pointId);
            if (vertex) {
                vertex.x = newX + 21;
                vertex.y = newY + 21;
                updateVertexPosition(pointId, vertex.x, vertex.y);
            }
            redrawLinesAndLabels();
        });
        pointsLayer.appendChild(pointDiv);
        verticesData.push({
            id: pointId,
            labelIndex: idx,
            x: x, y: y,
            dom: pointDiv
        });
    }
    verticesData.forEach(v => {
        v.dom.style.left = (v.x - 21) + 'px';
        v.dom.style.top = (v.y - 21) + 'px';
    });
    redrawLinesAndLabels();
}

async function updateVertexPosition(vid, x, y) {
    try {
        await fetch(`/api/graph/vertex/${vid}/position`, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ x: x, y: y })
        });
    } catch (error) {
        console.error('Error updating vertex position:', error);
    }
}

function buildMatrixTable(n) {
    weightMatrixTable.innerHTML = '';
    const thead = document.createElement('thead');
    const headerRow = document.createElement('tr');
    headerRow.appendChild(document.createElement('th'));
    for (let i = 1; i <= n; i++) {
        const th = document.createElement('th');
        th.textContent = i;
        headerRow.appendChild(th);
    }
    thead.appendChild(headerRow);
    weightMatrixTable.appendChild(thead);

    const tbody = document.createElement('tbody');
    for (let i = 1; i <= n; i++) {
        const tr = document.createElement('tr');
        const thRow = document.createElement('th');
        thRow.textContent = i;
        tr.appendChild(thRow);
        for (let j = 1; j <= n; j++) {
            const td = document.createElement('td');
            const input = document.createElement('input');
            input.type = 'number';
            input.min = '0';
            input.value = '0';
            input.setAttribute('data-row', i);
            input.setAttribute('data-col', j);
            if (i === j) {
                input.disabled = true;
                input.style.background = '#e8e8e8';
            }
            input.addEventListener('input', function () {
                if (syncingFromCanvas) return;
                let val = parseFloat(this.value);
                if (isNaN(val)) val = 0;
                if (val < 0) val = 0;
                const rowIdx = parseInt(this.dataset.row);
                const colIdx = parseInt(this.dataset.col);
                if (rowIdx !== colIdx) {
                    const symmetric = document.querySelector(`input[data-row='${colIdx}'][data-col='${rowIdx}']`);
                    if (symmetric && symmetric !== this) symmetric.value = val;
                }
                updateGraphFromMatrix();
            });
            td.appendChild(input);
            tr.appendChild(td);
        }
        tbody.appendChild(tr);
    }
    weightMatrixTable.appendChild(tbody);
}

function initGraphAndMatrix() {
    const nInput = document.getElementById('vertex-count');
    let n = parseInt(nInput.value);
    if (isNaN(n) || n < 2) n = 2;
    if (n > 8) n = 8;
    currentN = n;
    if (resultsPanel) resultsPanel.style.display = 'none';
    matrixContainer.style.display = 'block';
    buildMatrixTable(currentN);
    createVerticesOnCanvas(currentN);
    edgesList = [];
    for (let i = 1; i <= currentN; i++) {
        for (let j = 1; j <= currentN; j++) {
            if (i !== j) {
                const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
                if (inp) inp.value = '0';
            }
        }
    }
    updateGraphFromMatrix();
    updateStartVertexSelect(currentN);
}

function updateStartVertexSelect(n) {
    const select = document.getElementById('start-vertex-select');
    select.innerHTML = '<option value="">Выберите стартовую вершину</option>';
    for (let i = 1; i <= n; i++) {
        const opt = document.createElement('option');
        opt.value = i;
        opt.textContent = `Вершина ${i}`;
        select.appendChild(opt);
    }
    document.getElementById('start-vertex-section').style.display = 'block';
}

function validateMatrix() {
    const inputs = document.querySelectorAll('#weight-matrix input:not([disabled])');
    for (let inp of inputs) {
        const val = parseFloat(inp.value);
        if (isNaN(val)) return 'Все ячейки матрицы должны содержать числа';
        if (val < 0) return 'Алгоритм Дейкстры не работает с отрицательными весами';
    }
    return null;
}

function showError(msg) {
    const errDiv = document.getElementById('error-message');
    errDiv.textContent = msg;
    errDiv.style.display = 'block';
    setTimeout(() => errDiv.style.display = 'none', 4000);
}

function getWeightMatrixFromDOM() {
    const mat = [[]];
    for (let i = 1; i <= currentN; i++) {
        mat[i] = [];
        for (let j = 1; j <= currentN; j++) {
            const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
            mat[i][j] = inp ? parseFloat(inp.value) : 0;
        }
    }
    return mat;
}

// Синхронизация графа с сервером
async function syncGraphToServer() {
    // Строим данные для отправки на сервер в формате, который ожидает graph.from_dict()
    const vertices = {};
    for (let v of verticesData) {
        vertices[v.id] = {
            x: v.x,
            y: v.y,
            label_index: v.labelIndex
        };
    }

    const edges = [];
    for (let edge of edgesList) {
        edges.push({
            from: edge.fromId,
            to: edge.toId,
            distance: edge.weight
        });
    }

    const graphData = {
        vertices: vertices,
        edges: edges,
        next_id: nextVertexId
    };

    try {
        await fetch('/api/graph/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(graphData)
        });
    } catch (error) {
        console.error('Error syncing graph:', error);
    }
}

// Вызов алгоритма Дейкстры на сервере
async function runDijkstra(start) {
    const response = await fetch('/api/dijkstra/calculate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ source: start })
    });

    if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.error || 'Ошибка сервера');
    }

    const data = await response.json();

    if (data.error) {
        throw new Error(data.error);
    }

    return data;
}

// Отображение результатов
function displayResults(start, responseData) {
    if (!resultsPanel) return;

    const results = responseData.results;
    if (!results || !Array.isArray(results)) {
        showError('Неверный формат ответа от сервера');
        console.error('Invalid response:', responseData);
        return;
    }

    const tbody = document.getElementById('distances-tbody');
    const pathDiv = document.getElementById('path-list');
    tbody.innerHTML = '';
    pathDiv.innerHTML = '';

    for (let item of results) {
        const row = document.createElement('tr');
        const tdV = document.createElement('td');
        const tdD = document.createElement('td');
        tdV.textContent = item.vertex;

        if (item.distance === null || item.distance === Infinity || item.distance === undefined) {
            tdD.textContent = '∞ (недостижима)';
            tdD.classList.add('unreachable');
        } else {
            tdD.textContent = item.distance;
        }
        row.appendChild(tdV);
        row.appendChild(tdD);
        tbody.appendChild(row);

        const pathItem = document.createElement('div');
        pathItem.className = 'path-item';

        if (item.vertex === start) {
            pathItem.textContent = `Путь до вершины ${item.vertex}: ${item.vertex} (стартовая), длина = 0`;
        } else if (item.distance === null || item.distance === Infinity || item.distance === undefined) {
            pathItem.innerHTML = `<span class="unreachable">Вершина ${item.vertex} недостижима из стартовой ${start}</span>`;
        } else {
            const path = item.path || [];
            const pathStr = path.length > 0 ? path.join(' → ') : String(item.vertex);
            pathItem.textContent = `Путь до ${item.vertex}: ${pathStr} (длина = ${item.distance})`;
        }
        pathDiv.appendChild(pathItem);
    }

    resultsPanel.style.display = 'block';
}

// Обработчики событий
document.getElementById('generate-matrix-btn').addEventListener('click', () => {
    initGraphAndMatrix();
});

document.getElementById('calculate-btn').addEventListener('click', async () => {
    const err = validateMatrix();
    if (err) { showError(err); return; }
    const startVal = parseInt(document.getElementById('start-vertex-select').value);
    if (!startVal) { showError('Выберите стартовую вершину'); return; }

    try {
        // Сначала синхронизируем текущий граф с сервером
        await syncGraphToServer();
        // Затем вызываем алгоритм
        const result = await runDijkstra(startVal);
        displayResults(startVal, result);
    } catch (error) {
        showError('Ошибка при вычислении: ' + error.message);
        console.error('Dijkstra error:', error);
    }
});

window.addEventListener('resize', () => {
    if (verticesData.length === currentN) {
        redrawLinesAndLabels();
    }
});

setInterval(() => {
    if (!syncingFromMatrix && matrixContainer.style.display !== 'none') {
        updateMatrixFromGraph();
    }
}, 400);

setTimeout(() => { initGraphAndMatrix(); }, 100);