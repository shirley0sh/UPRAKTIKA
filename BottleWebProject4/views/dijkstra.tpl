<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Графовый редактор - Дейкстра</title>
    <link rel="stylesheet" href="/static/style.css">
    <style>
       
        body {
            background: background.png;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }

        /* Контейнер с двухколоночной сеткой */
        .container {
            display: flex;
            gap: 24px;
            padding: 20px;
            max-width: 1600px;
            margin: 0 auto;
        }

        /* Левая панель (toolbar) - делаем прозрачнее, без сплошного бежевого фона */
        .toolbar {
            flex: 1.2;
            background: rgba(255, 255, 248, 0.65);
            border-radius: 20px;
            padding: 20px;
            backdrop-filter: blur(6px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            height: fit-content;
            max-height: 90vh;
            overflow-y: auto;
        }

        /* Правая область: граф + результаты */
        .right-area {

            flex: 2;
            display: flex;
            flex-direction: column;
            gap: 20px;
            min-width: 480px;
        }

        /* Канвас */
        .canvas {
            position: relative;
            background: #f8f9fc;
            border-radius: 16px;
            box-shadow: inset 0 0 0 1px rgba(0,0,0,0.05), 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
            height: 460px;
        }

        .lines-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 5;
        }

        .points-layer {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 10;
        }

        .graph-point {
            position: absolute;
            width: 42px;
            height: 42px;
            background: #5a4d5e;
            border: 3px solid #f4d58c;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 18px;
            color: white;
            cursor: grab;
            transition: 0.05s linear;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            z-index: 20;
            font-family: monospace;
        }

        .graph-point:active {
            cursor: grabbing;
        }

        .edge-weight-label {
            position: absolute;
            background: rgba(0,0,0,0.7);
            color: #ffec82;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
            pointer-events: none;
            font-family: monospace;
            z-index: 15;
            backdrop-filter: blur(4px);
            transform: translate(-50%, -50%);
        }

        /* Блок результатов под канвасом — ГОРИЗОНТАЛЬНЫЙ (в одну строку) */
        .results-panel {
            background: rgba(255, 255, 248, 0.65);
            backdrop-filter: blur(4px);
            padding: 18px 20px;
            border-radius: 16px;
            display: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .results-panel h4 {
            margin: 0 0 16px 0;
            color: #2c3e50;
            font-size: 1.2rem;
            font-weight: 600;
        }

        /* Горизонтальный контейнер для двух колонок */
        .results-horizontal {
            display: flex;
            gap: 28px;
            flex-wrap: wrap;
            align-items: flex-start;
        }

        .distances-col {
            flex: 1;
            min-width: 220px;
        }

        .paths-col {
            flex: 2;
            min-width: 280px;
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            font-size: 13px;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
        }

        .results-table th,
        .results-table td {
            border: 1px solid #ddd;
            padding: 8px 12px;
            text-align: left;
        }

        .results-table th {
            background: #5a4d5e;
            color: white;
            font-weight: bold;
        }

        .path-list {
            background: white;
            padding: 12px;
            border-radius: 12px;
            max-height: 280px;
            overflow-y: auto;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
        }

        .path-item {
            padding: 8px 8px;
            border-bottom: 1px solid #eef2f7;
            font-size: 13px;
            font-family: monospace;
        }

        .path-item:last-child {
            border-bottom: none;
        }

        .unreachable {
            color: #e74c3c;
            font-style: italic;
            font-weight: 500;
        }

        /* Стили для навигации и форм (полностью из оригинала) */
        .nav-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            padding: 10px;
            background: rgba(187, 195, 208, 0.9);
            border-radius: 10px;
        }

        .nav-btn {
            padding: 10px 20px;
            background: #5a4d5e;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: all 0.3s;
        }

        .nav-btn:hover {
            background: #94899c;
            transform: translateY(-2px);
        }

        .algorithm-btn {
            background: #3498db;
        }

        .algorithm-btn:hover {
            background: #2980b9;
        }

        .input-section {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(2px);
            padding: 15px;
            border-radius: 12px;
            margin: 15px 0;
        }

        .input-section h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 16px;
        }

        /* Компактная строка: поле + кнопка в одну линию */
        .inline-group {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .inline-group label {
            font-weight: bold;
            color: #2c3e50;
            font-size: 13px;
            white-space: nowrap;
        }

        .small-number-input {
            width: 70px;
            padding: 8px;
            border: 1px solid #bdc2ce;
            border-radius: 6px;
            font-size: 14px;
            text-align: center;
        }

        .btn-generate-inline {
            background: rgba(187, 195, 208, 0.9);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 8px 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-generate-inline:hover {
            background: #94899c;
            transform: scale(0.97);
        }

        .matrix-container {
            margin-top: 12px;
            overflow-x: auto;
            max-height: 280px;
            overflow-y: auto;
        }

        .matrix-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            font-size: 12px;
            border-radius: 12px;
        }

        .matrix-table th,
        .matrix-table td {
            border: 1px solid #ddd;
            padding: 6px;
            text-align: center;
            min-width: 40px;
        }

        .matrix-table th {
            background: #5a4d5e;
            color: white;
            font-weight: bold;
        }

        .matrix-table input {
            width: 100%;
            padding: 4px;
            border: 1px solid #ccc;
            text-align: center;
            font-size: 12px;
            border-radius: 6px;
        }

        .matrix-table input:disabled {
            background: #f0f0f0;
        }

        .start-vertex-section {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(2px);
            padding: 15px;
            border-radius: 12px;
            margin: 15px 0;
        }

        .start-vertex-section h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 16px;
        }

        .start-vertex-select {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #bdc2ce;
            font-size: 14px;
            margin-bottom: 10px;
        }

        .btn-generate {
            width: 100%;
            padding: 10px;
            background: #5a4d5e;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
            transition: all 0.3s;
        }

        .btn-generate:hover {
            background: #94899c;
        }

        .error-message {
            background: #e74c3c;
            color: white;
            padding: 10px;
            border-radius: 8px;
            margin: 10px 0;
            display: none;
            font-size: 13px;
            text-align: center;
        }

        @media (max-width: 800px) {
            .container { flex-direction: column; }
            .right-area { min-width: auto; }
            .results-horizontal { flex-direction: column; }
        }
    </style>
</head>
<body>
<div class="container">
    <!-- Левая панель (toolbar) -->
    <div id="toolbar" class="toolbar">
        <div class="nav-buttons">
            <a href="/" class="nav-btn">Главный редактор</a>
            <a href="/floyd" class="nav-btn">Флойд-Уоршелл</a>
            <a href="/dijkstra" class="nav-btn" style="background: #94899c;">Дейкстра</a>
        </div>
        <h3>Алгоритм Дейкстры</h3>

        <div class="input-section">
            <h4>Входные данные</h4>
            <div class="inline-group">
                <label for="vertex-count">Количество вершин (2-8):</label>
                <input type="number" id="vertex-count" min="2" max="8" value="4" class="small-number-input" />
                <button class="btn-generate-inline" id="generate-matrix-btn">Создать матрицу и граф</button>
            </div>
            <div class="matrix-container" id="matrix-container" style="display: none;">
                <label style="display: block; margin: 10px 0 5px 0; font-weight: bold; color: #2c3e50;">Матрица весов (неориентированный граф):</label>
                <table class="matrix-table" id="weight-matrix"></table>
                <div style="font-size: 11px; margin-top: 8px; text-align: center; color: #2c3e50;"></div>
            </div>
        </div>

        <div class="start-vertex-section" id="start-vertex-section" style="display: none;">
            <h4>Стартовая вершина</h4>
            <select class="start-vertex-select" id="start-vertex-select">
                <option value="">Выберите стартовую вершину</option>
            </select>
            <button class="btn-generate" id="calculate-btn">Вычислить кратчайшие пути</button>
        </div>

        <div class="error-message" id="error-message"></div>
    </div>

    <!-- Правая область: канвас + результаты (горизонтальные) -->
    <div class="right-area">
        <div id="canvas" class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
        </div>

        <!-- НОВЫЙ БЛОК РЕЗУЛЬТАТОВ: таблица + пути в одну строку -->
        <div class="results-panel" id="results-panel">
            <h4>Результаты алгоритма Дейкстры</h4>
            <div class="results-horizontal">
                <div class="distances-col">
                    <label style="font-weight: bold; margin-bottom: 8px; display: block; color: #2c3e50;">Кратчайшие расстояния</label>
                    <table class="results-table" id="distances-table">
                        <thead><tr><th>Вершина</th><th>Расстояние от старта</th></tr></thead>
                        <tbody id="distances-tbody"></tbody>
                    </table>
                </div>
                <div class="paths-col">
                    <label style="font-weight: bold; margin-bottom: 8px; display: block; color: #2c3e50;">Кратчайшие пути</label>
                    <div class="path-list" id="path-list"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // ======================== ПОЛНОСТЬЮ ЛОКАЛЬНЫЙ ГРАФ (БЕЗ СЕРВЕРА) ========================
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

    // === Отрисовка всех линий и весов ===
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

    // === Обновить матрицу из графа (рёбер) ===
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

    // === Обновить граф из матрицы (создать/обновить рёбра) ===
    function updateGraphFromMatrix() {
        if (syncingFromCanvas) return;
        syncingFromMatrix = true;
        const newEdgesMap = new Map();
        for (let i = 1; i <= currentN; i++) {
            for (let j = i+1; j <= currentN; j++) {
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

    // === Создать вершины на канвасе (по кругу) ===
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

    // === Построить матрицу весов ===
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
                input.addEventListener('input', function() {
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

    // === Инициализация графа и матрицы ===
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
        const mat = [];
        for (let i = 1; i <= currentN; i++) {
            mat[i] = [];
            for (let j = 1; j <= currentN; j++) {
                const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
                mat[i][j] = inp ? parseFloat(inp.value) : 0;
            }
        }
        return mat;
    }

    function dijkstra(matrix, start) {
        const n = matrix.length - 1;
        const dist = new Array(n+1).fill(Infinity);
        const visited = new Array(n+1).fill(false);
        const prev = new Array(n+1).fill(null);
        dist[start] = 0;
        for (let count = 0; count < n; count++) {
            let minDist = Infinity, u = -1;
            for (let v = 1; v <= n; v++) {
                if (!visited[v] && dist[v] < minDist) { minDist = dist[v]; u = v; }
            }
            if (u === -1) break;
            visited[u] = true;
            for (let v = 1; v <= n; v++) {
                if (!visited[v] && matrix[u][v] > 0 && dist[u] !== Infinity) {
                    const nd = dist[u] + matrix[u][v];
                    if (nd < dist[v]) { dist[v] = nd; prev[v] = u; }
                }
            }
        }
        return { dist, prev };
    }

    function getPath(prev, start, end) {
        if (prev[end] === null && start !== end) return null;
        const path = [];
        let cur = end;
        while (cur !== null) {
            path.unshift(cur);
            if (cur === start) break;
            cur = prev[cur];
        }
        return path;
    }

    function displayResults(start, dist, prev) {
        if (!resultsPanel) return;
        const n = dist.length - 1;
        const tbody = document.getElementById('distances-tbody');
        const pathDiv = document.getElementById('path-list');
        tbody.innerHTML = '';
        pathDiv.innerHTML = '';

        for (let i = 1; i <= n; i++) {
            const row = document.createElement('tr');
            const tdV = document.createElement('td');
            const tdD = document.createElement('td');
            tdV.textContent = i;
            if (dist[i] === Infinity) {
                tdD.textContent = '∞ (недостижима)';
                tdD.classList.add('unreachable');
            } else {
                tdD.textContent = dist[i];
            }
            row.appendChild(tdV); row.appendChild(tdD);
            tbody.appendChild(row);
        }
        for (let i = 1; i <= n; i++) {
            const item = document.createElement('div');
            item.className = 'path-item';
            if (i === start) {
                item.textContent = `Путь до вершины ${i}: ${i} (стартовая), длина = 0`;
            } else if (dist[i] === Infinity) {
                item.innerHTML = `<span class="unreachable">Вершина ${i} недостижима из стартовой ${start}</span>`;
            } else {
                const path = getPath(prev, start, i);
                item.textContent = `Путь до ${i}: ${path.join(' → ')}  (длина = ${dist[i]})`;
            }
            pathDiv.appendChild(item);
        }
        resultsPanel.style.display = 'block';
    }

    // Обработчики событий
    document.getElementById('generate-matrix-btn').addEventListener('click', () => {
        initGraphAndMatrix();
    });

    document.getElementById('calculate-btn').addEventListener('click', () => {
        const err = validateMatrix();
        if (err) { showError(err); return; }
        const startVal = parseInt(document.getElementById('start-vertex-select').value);
        if (!startVal) { showError('Выберите стартовую вершину'); return; }
        const matrix = getWeightMatrixFromDOM();
        const { dist, prev } = dijkstra(matrix, startVal);
        displayResults(startVal, dist, prev);
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
</script>
</body>
</html>