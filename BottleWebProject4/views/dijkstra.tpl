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
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
        }
        .btn-generate:hover {
            background: #229954;
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
        });
    </script>
</body>
</html>
