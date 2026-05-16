<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Dijkstra | Интерактивный граф ↔ Матрица</title>
    <link rel="stylesheet" href="/static/style.css">
    <style>
        /* Сохранение всех исходных стилей */
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
        .source-select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #bdc2ce;
            font-size: 14px;
        }
        .input-section {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
        }
        .input-section h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 16px;
        }
        .form-group {
            margin-bottom: 12px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #34495e;
            font-size: 13px;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #bdc2ce;
            border-radius: 4px;
            font-size: 14px;
        }
        .matrix-container {
            margin-top: 10px;
            overflow-x: auto;
            max-height: 300px;
            overflow-y: auto;
        }
        .matrix-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            font-size: 12px;
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
        }
        .matrix-table input:disabled {
            background: #f0f0f0;
        }
        .btn-generate {
            width: 100%;
            padding: 10px;
            background: #5a4d5e;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
            transition: all 0.3s;
        }
        .btn-generate:hover {
            background: #94899c;
        }
        .start-vertex-section {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
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
            border-radius: 5px;
            border: 1px solid #bdc2ce;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .error-message {
            background: #e74c3c;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
            display: none;
            font-size: 13px;
        }
        .results-section {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            display: none;
        }
        .results-section h4 {
            margin: 0 0 10px 0;
            color: #2c3e50;
            font-size: 16px;
        }
        .results-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            font-size: 13px;
            margin: 10px 0;
        }
        .results-table th,
        .results-table td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        .results-table th {
            background: #5a4d5e;
            color: white;
            font-weight: bold;
        }
        .path-list {
            background: white;
            padding: 10px;
            border-radius: 5px;
            max-height: 200px;
            overflow-y: auto;
        }
        .path-item {
            padding: 8px;
            border-bottom: 1px solid #eee;
            font-size: 13px;
        }
        .path-item:last-child {
            border-bottom: none;
        }
        .unreachable {
            color: #e74c3c;
            font-style: italic;
        }
        /* Дополнительные стили для canvas и точек */
        .canvas {
            position: relative;
            background: #f8f9fc;
            border-radius: 12px;
            box-shadow: inset 0 0 0 1px rgba(0,0,0,0.05), 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-top: 20px;
            min-height: 450px;
            height: 500px;
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
        .container {
            display: flex;
            gap: 24px;
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
        }
        .toolbar {
            flex: 1.2;
            background: rgba(255,255,240,0.7);
            border-radius: 20px;
            padding: 20px;
            backdrop-filter: blur(2px);
        }
        .canvas {
            flex: 2;
        }
        @media (max-width: 800px) {
            .container { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div id="toolbar" class="toolbar">
            <div class="nav-buttons">
                <a href="/" class="nav-btn">Main Editor</a>
                <a href="/floyd" class="nav-btn">Floyd-Warshall</a>
                <a href="/dijkstra" class="nav-btn" style="background: #94899c;">Dijkstra</a>
            </div>
            <h3>Dijkstra Algorithm</h3>

            <div class="input-section">
                <h4>Input Data</h4>
                <div class="form-group">
                    <label for="vertex-count">Number of vertices (2-10):</label>
                    <input type="number" id="vertex-count" min="2" max="10" value="4" />
                </div>
                <button class="btn-generate" id="generate-matrix-btn">Generate Matrix & Graph</button>
                <div class="matrix-container" id="matrix-container" style="display: none;">
                    <label style="display: block; margin: 10px 0 5px 0; font-weight: bold; color: #34495e;">Weight Matrix (неориентированный граф):</label>
                    <table class="matrix-table" id="weight-matrix"></table>
                    <div style="font-size: 11px; margin-top: 6px; text-align: center;">Изменяйте ячейки → граф обновляется | Перетащите вершины → матрица меняется</div>
                </div>
            </div>

            <div class="start-vertex-section" id="start-vertex-section" style="display: none;">
                <h4>Start Vertex</h4>
                <select class="start-vertex-select" id="start-vertex-select">
                    <option value="">Select start vertex</option>
                </select>
                <button class="btn-generate" id="calculate-btn">Calculate Shortest Paths</button>
            </div>

            <div class="error-message" id="error-message"></div>

            <div class="results-section" id="results-section">
                <h4>Results</h4>
                <label style="display: block; margin: 10px 0 5px 0; font-weight: bold; color: #34495e;">Shortest Distances:</label>
                <table class="results-table" id="distances-table">
                    <thead><tr><th>Vertex</th><th>Distance from Start</th></tr></thead>
                    <tbody id="distances-tbody"></tbody>
                </table>
                <label style="display: block; margin: 15px 0 5px 0; font-weight: bold; color: #34495e;">Shortest Paths:</label>
                <div class="path-list" id="path-list"></div>
            </div>
        </div>
        <div id="canvas" class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
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

        // === Отрисовка всех линий и весов ===
        function redrawLinesAndLabels() {
            if (!linesSvg || !canvasDiv) return;
            const rect = canvasDiv.getBoundingClientRect();
            const width = rect.width || 800;
            const height = rect.height || 500;
            linesSvg.setAttribute('viewBox', `0 0 ${width} ${height}`);
            linesSvg.innerHTML = '';
            // удаляем старые лейблы весов
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

                // метка веса
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
            // Сбросить все недиагональные ячейки в 0
            for (let i = 1; i <= currentN; i++) {
                for (let j = 1; j <= currentN; j++) {
                    if (i !== j) {
                        const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
                        if (inp) inp.value = '0';
                    }
                }
            }
            // Заполняем весами из рёбер
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

            const newEdgesMap = new Map(); // ключ "minId-maxId"
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
            // перерисовка линий и весов
            redrawLinesAndLabels();
            syncingFromMatrix = false;
        }

        // === Создать вершины на канвасе (по кругу) ===
        function createVerticesOnCanvas(n) {
            pointsLayer.innerHTML = '';
            verticesData = [];
            edgesList = [];
            const rect = canvasDiv.getBoundingClientRect();
            const w = rect.width || 800;
            const h = rect.height || 500;
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
                pointDiv.setAttribute('data-label', idx);
                pointDiv.style.left = (x - 21) + 'px';
                pointDiv.style.top = (y - 21) + 'px';
                pointDiv.style.position = 'absolute';
                pointDiv.draggable = true;
                
                // Drag & Drop логика
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
                    // обновляем координаты в данных
                    const vertex = verticesData.find(v => v.id === pointId);
                    if (vertex) {
                        vertex.x = newX + 21;
                        vertex.y = newY + 21;
                    }
                    redrawLinesAndLabels();
                    // при перемещении вершин матрица НЕ меняется, только визуал
                });
                pointsLayer.appendChild(pointDiv);
                verticesData.push({
                    id: pointId,
                    labelIndex: idx,
                    x: x,
                    y: y,
                    dom: pointDiv
                });
            }
            // Обновляем позиции в dom после добавления
            verticesData.forEach(v => {
                v.dom.style.left = (v.x - 21) + 'px';
                v.dom.style.top = (v.y - 21) + 'px';
            });
            redrawLinesAndLabels();
        }

        // === Построить матрицу весов в DOM ===
        function buildMatrixTable(n) {
            weightMatrixTable.innerHTML = '';
            // Заголовок
            const thead = document.createElement('thead');
            const headerRow = document.createElement('tr');
            headerRow.appendChild(document.createElement('th')); // угол
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
                        input.value = '0';
                    }
                    // Обработчик изменения ячейки -> обновление графа
                    input.addEventListener('input', function(e) {
                        if (syncingFromCanvas) return;
                        let val = parseFloat(this.value);
                        if (isNaN(val)) val = 0;
                        if (val < 0) val = 0;
                        // Симметрия для неориентированного графа
                        const rowIdx = parseInt(this.dataset.row);
                        const colIdx = parseInt(this.dataset.col);
                        if (rowIdx !== colIdx) {
                            const symmetric = document.querySelector(`input[data-row='${colIdx}'][data-col='${rowIdx}']`);
                            if (symmetric && symmetric !== this) {
                                symmetric.value = val;
                            }
                        }
                        updateGraphFromMatrix();  // динамически обновляем рёбра
                    });
                    td.appendChild(input);
                    tr.appendChild(td);
                }
                tbody.appendChild(tr);
            }
            weightMatrixTable.appendChild(tbody);
        }

        // === Сбросить все веса и рёбра в матрице, синхронизировать ===
        function resetMatrixToZeros() {
            for (let i = 1; i <= currentN; i++) {
                for (let j = 1; j <= currentN; j++) {
                    if (i !== j) {
                        const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
                        if (inp) inp.value = '0';
                    }
                }
            }
            updateGraphFromMatrix();
        }

        // === Главная инициализация после нажатия кнопки "Generate Matrix" ===
        async function initGraphAndMatrix() {
            const nInput = document.getElementById('vertex-count');
            let n = parseInt(nInput.value);
            if (isNaN(n) || n < 2) n = 2;
            if (n > 10) n = 10;
            currentN = n;
            
            // Показать контейнер матрицы
            matrixContainer.style.display = 'block';
            // Построить таблицу
            buildMatrixTable(currentN);
            // Создать вершины на канвасе
            createVerticesOnCanvas(currentN);
            // Очистить список рёбер
            edgesList = [];
            // Обнулить матрицу (все 0)
            for (let i = 1; i <= currentN; i++) {
                for (let j = 1; j <= currentN; j++) {
                    if (i !== j) {
                        const inp = document.querySelector(`input[data-row='${i}'][data-col='${j}']`);
                        if (inp) inp.value = '0';
                    }
                }
            }
            updateGraphFromMatrix(); // синхронизация графа (рёбер нет)
            redrawLinesAndLabels();
            updateStartVertexSelect(currentN);
            
            // Дополнительно: если хотим пример, создадим пару демо-рёбер (можно убрать, но оставим без)
            // Чтобы показать работоспособность, добавим пару тестовых рёбер только при первом создании? необязательно.
            // Оставим всё пустым, пользователь сам заполнит.
        }

        // Обновление селекта стартовой вершины
        function updateStartVertexSelect(n) {
            const select = document.getElementById('start-vertex-select');
            select.innerHTML = '<option value="">Select start vertex</option>';
            for (let i = 1; i <= n; i++) {
                const opt = document.createElement('option');
                opt.value = i;
                opt.textContent = `Vertex ${i}`;
                select.appendChild(opt);
            }
            document.getElementById('start-vertex-section').style.display = 'block';
        }

        // Валидация матрицы
        function validateMatrix() {
            const inputs = document.querySelectorAll('#weight-matrix input:not([disabled])');
            for (let inp of inputs) {
                const val = parseFloat(inp.value);
                if (isNaN(val)) return 'All cells must contain numbers';
                if (val < 0) return 'Dijkstra does not allow negative weights';
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

        // Алгоритм Дейкстры
        function dijkstra(matrix, start) {
            const n = matrix.length - 1;
            const dist = new Array(n+1).fill(Infinity);
            const visited = new Array(n+1).fill(false);
            const prev = new Array(n+1).fill(null);
            dist[start] = 0;
            for (let count = 0; count < n; count++) {
                let minDist = Infinity, u = -1;
                for (let v = 1; v <= n; v++) {
                    if (!visited[v] && dist[v] < minDist) {
                        minDist = dist[v];
                        u = v;
                    }
                }
                if (u === -1) break;
                visited[u] = true;
                for (let v = 1; v <= n; v++) {
                    if (!visited[v] && matrix[u][v] > 0 && dist[u] !== Infinity) {
                        const nd = dist[u] + matrix[u][v];
                        if (nd < dist[v]) {
                            dist[v] = nd;
                            prev[v] = u;
                        }
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
                    tdD.textContent = '∞ (unreachable)';
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
                    item.textContent = `Path to vertex ${i}: ${i} (start), length = 0`;
                } else if (dist[i] === Infinity) {
                    item.innerHTML = `<span class="unreachable">Vertex ${i} is unreachable from ${start}</span>`;
                } else {
                    const path = getPath(prev, start, i);
                    item.textContent = `Path to ${i}: ${path.join(' → ')}, length = ${dist[i]}`;
                }
                pathDiv.appendChild(item);
            }
            document.getElementById('results-section').style.display = 'block';
        }

        // Обработчики событий
        document.getElementById('generate-matrix-btn').addEventListener('click', () => {
            initGraphAndMatrix();
        });

        document.getElementById('calculate-btn').addEventListener('click', () => {
            const err = validateMatrix();
            if (err) { showError(err); return; }
            const startVal = parseInt(document.getElementById('start-vertex-select').value);
            if (!startVal) { showError('Select start vertex'); return; }
            const matrix = getWeightMatrixFromDOM();
            const { dist, prev } = dijkstra(matrix, startVal);
            displayResults(startVal, dist, prev);
        });

        // Синхронизация при изменении размера окна (корректировка позиций)
        window.addEventListener('resize', () => {
            if (verticesData.length === currentN) {
                // не перемещаем вершины, просто перерисовываем линии
                redrawLinesAndLabels();
            }
        });

        // Периодическая синхронизация canvas -> matrix на случай внешних модификаций
        setInterval(() => {
            if (!syncingFromMatrix && matrixContainer.style.display !== 'none') {
                updateMatrixFromGraph();
            }
        }, 400);
        
        // Первоначальный вызов для демонстрации (по умолчанию создадим с n=4)
        setTimeout(() => {
            initGraphAndMatrix();
        }, 100);
    </script>
</body>
</html>