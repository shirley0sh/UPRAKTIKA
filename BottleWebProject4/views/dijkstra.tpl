<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Dijkstra</title>
    <link rel="stylesheet" href="/static/style.css">
    <style>
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

            <!-- Секция ввода данных -->
            <div class="input-section">
                <h4>Input Data</h4>
                <div class="form-group">
                    <label for="vertex-count">Number of vertices (2-10):</label>
                    <input type="number" id="vertex-count" min="2" max="10" value="3" />
                </div>
                <button class="btn-generate" id="generate-matrix-btn">Generate Matrix</button>

                <div class="matrix-container" id="matrix-container" style="display: none;">
                    <label style="display: block; margin: 10px 0 5px 0; font-weight: bold; color: #34495e;">Weight Matrix:</label>
                    <table class="matrix-table" id="weight-matrix">
                        <!-- Таблица будет генерироваться динамически -->
                    </table>
                </div>
            </div>

            <!-- Секция выбора стартовой вершины -->
            <div class="start-vertex-section" id="start-vertex-section" style="display: none;">
                <h4>Start Vertex</h4>
                <select class="start-vertex-select" id="start-vertex-select">
                    <option value="">Select start vertex</option>
                </select>
                <button class="btn-generate" id="calculate-btn">Calculate Shortest Paths</button>
            </div>

            <!-- Сообщение об ошибке -->
            <div class="error-message" id="error-message"></div>

            <!-- Секция результатов -->
            <div class="results-section" id="results-section">
                <h4>Results</h4>
                <label style="display: block; margin: 10px 0 5px 0; font-weight: bold; color: #34495e;">Shortest Distances:</label>
                <table class="results-table" id="distances-table">
                    <thead>
                        <tr>
                            <th>Vertex</th>
                            <th>Distance from Start</th>
                        </tr>
                    </thead>
                    <tbody id="distances-tbody">
                        <!-- Результаты будут добавлены динамически -->
                    </tbody>
                </table>

                <label style="display: block; margin: 15px 0 5px 0; font-weight: bold; color: #34495e;">Shortest Paths:</label>
                <div class="path-list" id="path-list">
                    <!-- Пути будут добавлены динамически -->
                </div>
            </div>

            <div id="point-drag" class="draggable-point" draggable="true">Add Point</div>
            <div id="buttons-container"></div>
            <select id="source-select" class="source-select">
                <option value="">Select source vertex</option>
            </select>
            <button id="dijkstra-btn" class="btn algorithm-btn">Compute Shortest Paths</button>
            <div id="results" style="margin-top: 15px; max-height: 300px; overflow-y: auto;"></div>
        </div>
        <div id="canvas" class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
        </div>
    </div>
    <script src="/static/script.js"></script>
    <script src="/static/dijkstra.js"></script>
    <script>
        // Генерация матрицы весов
        document.getElementById('generate-matrix-btn').addEventListener('click', function() {
            const n = parseInt(document.getElementById('vertex-count').value);

            if (isNaN(n) || n < 2 || n > 10) {
                alert('Please enter a valid number of vertices (2-10)');
                return;
            }

            const matrixContainer = document.getElementById('matrix-container');
            const table = document.getElementById('weight-matrix');

            // Очистка таблицы
            table.innerHTML = '';

            // Создание заголовка
            const thead = document.createElement('thead');
            const headerRow = document.createElement('tr');
            headerRow.appendChild(document.createElement('th')); // Пустая ячейка в углу

            for (let i = 1; i <= n; i++) {
                const th = document.createElement('th');
                th.textContent = i;
                headerRow.appendChild(th);
            }
            thead.appendChild(headerRow);
            table.appendChild(thead);

            // Создание тела таблицы
            const tbody = document.createElement('tbody');
            for (let i = 1; i <= n; i++) {
                const row = document.createElement('tr');

                // Заголовок строки
                const th = document.createElement('th');
                th.textContent = i;
                row.appendChild(th);

                // Ячейки для ввода весов
                for (let j = 1; j <= n; j++) {
                    const td = document.createElement('td');
                    const input = document.createElement('input');
                    input.type = 'number';
                    input.min = '0';
                    input.value = i === j ? '0' : '0';
                    input.dataset.row = i;
                    input.dataset.col = j;

                    // Диагональные элементы заблокированы и равны 0
                    if (i === j) {
                        input.disabled = true;
                        input.style.background = '#e8e8e8';
                    }

                    // Автоматическая симметрия для неориентированного графа
                    input.addEventListener('input', function() {
                        const row = parseInt(this.dataset.row);
                        const col = parseInt(this.dataset.col);
                        const value = this.value;

                        // Найти симметричную ячейку и обновить её
                        const symmetricInput = document.querySelector(`input[data-row="${col}"][data-col="${row}"]`);
                        if (symmetricInput) {
                            symmetricInput.value = value;
                        }
                    });

                    td.appendChild(input);
                    row.appendChild(td);
                }

                tbody.appendChild(row);
            }
            table.appendChild(tbody);

            // Показать контейнер с матрицей
            matrixContainer.style.display = 'block';

            // Обновить выпадающий список стартовых вершин
            updateStartVertexSelect(n);
        });

        // Обновление выпадающего списка стартовых вершин
        function updateStartVertexSelect(n) {
            const select = document.getElementById('start-vertex-select');
            select.innerHTML = '<option value="">Select start vertex</option>';

            for (let i = 1; i <= n; i++) {
                const option = document.createElement('option');
                option.value = i;
                option.textContent = `Vertex ${i}`;
                select.appendChild(option);
            }

            // Показать секцию выбора стартовой вершины
            document.getElementById('start-vertex-section').style.display = 'block';
        }

        // Валидация матрицы
        function validateMatrix() {
            const inputs = document.querySelectorAll('#weight-matrix input:not([disabled])');
            const n = parseInt(document.getElementById('vertex-count').value);

            // Проверка: все поля заполнены
            for (let input of inputs) {
                if (input.value === '' || isNaN(parseFloat(input.value))) {
                    return 'All matrix cells must be filled with numbers';
                }
            }

            // Проверка: нет отрицательных весов
            for (let input of inputs) {
                if (parseFloat(input.value) < 0) {
                    return 'Dijkstra algorithm does not allow negative weights';
                }
            }

            // Проверка: диагональ равна нулю (уже обеспечено блокировкой)
            // Проверка: симметричность (уже обеспечено автоматически)

            return null; // Нет ошибок
        }

        // Показать сообщение об ошибке
        function showError(message) {
            const errorDiv = document.getElementById('error-message');
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
            setTimeout(() => {
                errorDiv.style.display = 'none';
            }, 5000);
        }

        // Получить матрицу весов
        function getWeightMatrix() {
            const n = parseInt(document.getElementById('vertex-count').value);
            const matrix = [];

            for (let i = 1; i <= n; i++) {
                matrix[i] = [];
                for (let j = 1; j <= n; j++) {
                    const input = document.querySelector(`input[data-row="${i}"][data-col="${j}"]`);
                    matrix[i][j] = parseFloat(input.value);
                }
            }

            return matrix;
        }

        // Алгоритм Дейкстры
        function dijkstra(matrix, start) {
            const n = matrix.length - 1;
            const dist = new Array(n + 1).fill(Infinity);
            const visited = new Array(n + 1).fill(false);
            const prev = new Array(n + 1).fill(null);

            dist[start] = 0;

            for (let count = 0; count < n; count++) {
                // Найти непосещённую вершину с минимальным расстоянием
                let minDist = Infinity;
                let u = -1;

                for (let v = 1; v <= n; v++) {
                    if (!visited[v] && dist[v] < minDist) {
                        minDist = dist[v];
                        u = v;
                    }
                }

                if (u === -1) break; // Все достижимые вершины посещены

                visited[u] = true;

                // Релаксация рёбер
                for (let v = 1; v <= n; v++) {
                    if (!visited[v] && matrix[u][v] > 0 && dist[u] !== Infinity) {
                        const newDist = dist[u] + matrix[u][v];
                        if (newDist < dist[v]) {
                            dist[v] = newDist;
                            prev[v] = u;
                        }
                    }
                }
            }

            return { dist, prev };
        }

        // Восстановление пути
        function getPath(prev, start, end) {
            if (prev[end] === null && start !== end) {
                return null; // Путь не существует
            }

            const path = [];
            let current = end;

            while (current !== null) {
                path.unshift(current);
                if (current === start) break;
                current = prev[current];
            }

            return path;
        }

        // Отображение результатов
        function displayResults(start, dist, prev) {
            const n = dist.length - 1;
            const tbody = document.getElementById('distances-tbody');
            const pathList = document.getElementById('path-list');

            tbody.innerHTML = '';
            pathList.innerHTML = '';

            // Таблица расстояний
            for (let i = 1; i <= n; i++) {
                const row = document.createElement('tr');
                const vertexCell = document.createElement('td');
                const distCell = document.createElement('td');

                vertexCell.textContent = i;

                if (dist[i] === Infinity) {
                    distCell.textContent = '∞ (unreachable)';
                    distCell.classList.add('unreachable');
                } else {
                    distCell.textContent = dist[i];
                }

                row.appendChild(vertexCell);
                row.appendChild(distCell);
                tbody.appendChild(row);
            }

            // Список путей
            for (let i = 1; i <= n; i++) {
                const pathItem = document.createElement('div');
                pathItem.classList.add('path-item');

                if (i === start) {
                    pathItem.textContent = `Path to vertex ${i}: ${i} (start vertex), length = 0`;
                } else if (dist[i] === Infinity) {
                    pathItem.innerHTML = `<span class="unreachable">Vertex ${i} is unreachable from start vertex ${start}</span>`;
                } else {
                    const path = getPath(prev, start, i);
                    pathItem.textContent = `Path to vertex ${i}: ${path.join(' → ')}, length = ${dist[i]}`;
                }

                pathList.appendChild(pathItem);
            }

            // Показать секцию результатов
            document.getElementById('results-section').style.display = 'block';
        }

        // Обработчик кнопки расчёта
        document.getElementById('calculate-btn').addEventListener('click', function() {
            // Валидация
            const error = validateMatrix();
            if (error) {
                showError(error);
                return;
            }

            const startVertex = parseInt(document.getElementById('start-vertex-select').value);
            if (!startVertex) {
                showError('Please select a start vertex');
                return;
            }

            // Получить матрицу и выполнить алгоритм
            const matrix = getWeightMatrix();
            const { dist, prev } = dijkstra(matrix, startVertex);

            // Отобразить результаты
            displayResults(startVertex, dist, prev);
        });
    </script>
</body>
</html>
