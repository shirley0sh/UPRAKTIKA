// Клиентская логика для работы с графом и вызова Python алгоритма Дейкстры

let verticesData = [];     // { id: number, x, y, dom, labelIndex }
let edgesList = [];        // { fromId, toId, weight }
let currentN = 4;
let syncingFromMatrix = false;
let syncingFromCanvas = false;
let nextVertexId = 1;

// DOM элементы
const canvasDiv = document.getElementById('canvas');
const linesSvg = document.getElementById('lines-layer');
const pointsLayer = document.getElementById('points-layer');
const matrixContainer = document.getElementById('matrix-container');
const weightMatrixTable = document.getElementById('weight-matrix');
const resultsPanel = document.getElementById('results-panel');

// Отрисовка всех линий и весов
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

// Обновить матрицу из графа
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

// Обновить граф из матрицы (создать/обновить рёбра)
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
}

// Создать вершины на канвасе (по кругу)
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
        const pointId = nextVertexId++;
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

// Построить матрицу весов
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
    const mat = [[]]; // 1-индексация, 0-й индекс пустой
    for (let i = 1; i <= currentN; i++) {
        mat[i] = [];
        for (let j = 1; j <= currentN; j++) {
            const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
            mat[i][j] = inp ? parseFloat(inp.value) : 0;
        }
    }
    return mat;
}

// Вызов алгоритма Дейкстры через Python
async function runDijkstra(matrix, start) {
    const response = await fetch('/api/dijkstra', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({
            matrix: matrix,
            start: start
        })
    });

    if (!response.ok) {
        throw new Error('Ошибка при вызове алгоритма');
    }

    return await response.json();
}

function displayResults(start, dist, paths) {
    if (!resultsPanel) return;
    const n = dist.length;
    const tbody = document.getElementById('distances-tbody');
    const pathDiv = document.getElementById('path-list');
    tbody.innerHTML = '';
    pathDiv.innerHTML = '';

    for (let i = 1; i <= n; i++) {
        const row = document.createElement('tr');
        const tdV = document.createElement('td');
        const tdD = document.createElement('td');
        tdV.textContent = i;
        if (dist[i - 1] === Infinity || dist[i - 1] === null) {
            tdD.textContent = '∞ (недостижима)';
            tdD.classList.add('unreachable');
        } else {
            tdD.textContent = dist[i - 1];
        }
        row.appendChild(tdV); row.appendChild(tdD);
        tbody.appendChild(row);
    }

    for (let i = 1; i <= n; i++) {
        const item = document.createElement('div');
        item.className = 'path-item';
        if (i === start) {
            item.textContent = `Путь до вершины ${i}: ${i} (стартовая), длина = 0`;
        } else if (dist[i - 1] === Infinity || dist[i - 1] === null) {
            item.innerHTML = `<span class="unreachable">Вершина ${i} недостижима из стартовой ${start}</span>`;
        } else {
            const path = paths[i];
            if (path && path.length > 0) {
                item.textContent = `Путь до ${i}: ${path.join(' → ')}  (длина = ${dist[i - 1]})`;
            } else {
                item.textContent = `Путь до ${i}: ${i}  (длина = ${dist[i - 1]})`;
            }
        }
        pathDiv.appendChild(item);
    }
    resultsPanel.style.display = 'block';
}

document.getElementById('generate-matrix-btn').addEventListener('click', () => {
    initGraphAndMatrix();
});

document.getElementById('calculate-btn').addEventListener('click', async () => {
    const err = validateMatrix();
    if (err) { showError(err); return; }
    const startVal = parseInt(document.getElementById('start-vertex-select').value);
    if (!startVal) { showError('Выберите стартовую вершину'); return; }
    const matrix = getWeightMatrixFromDOM();

    try {
        const result = await runDijkstra(matrix, startVal);
        displayResults(startVal, result.dist, result.paths);
    } catch (error) {
        showError('Ошибка при вычислении: ' + error.message);
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