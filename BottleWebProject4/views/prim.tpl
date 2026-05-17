<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Редактор графа - Алгоритм Прима</title>
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
            background: #9b59b6;
        }
        .algorithm-btn:hover {
            background: #8e44ad;
        }
        .random-panel {
            background: #e8d7cf;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        .random-title {
            font-weight: bold;
            margin-bottom: 10px;
            color: #5a4d5e;
        }
        .random-label {
            font-size: 12px;
            display: block;
            margin-bottom: 5px;
            color: #666;
        }
        .random-input {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border-radius: 4px;
            border: 1px solid #bdc2ce;
        }
        .btn-generate {
            background-color: #5a4d5e;
            color: white;
            padding: 10px;
            width: 100%;
            border-radius: 5px;
            border: none;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-generate:hover {
            background-color: #94899c;
        }
        .btn-warning {
            background-color: #bdc2ce;
            color: #5a4d5e;
        }
        .btn-warning:hover {
            background-color: #9b8ea2;
            color: white;
        }
        .btn-primary {
            background-color: #5a4d5e;
            color: white;
        }
        .btn-primary:hover {
            background-color: #94899c;
            transform: translateY(-2px);
        }
        .start-vertex-panel {
            background: #e8d7cf;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        .start-vertex-select {
            width: 100%;
            padding: 8px;
            margin: 10px 0;
            border-radius: 4px;
            border: 1px solid #bdc2ce;
            background: white;
        }
        .mst-result {
            margin-top: 15px;
            padding: 12px;
            background: #f0f4f8;
            border-radius: 8px;
            display: none;
        }
        .mst-result.show {
            display: block;
        }
        .mst-edge {
            padding: 5px;
            margin: 3px 0;
            background: white;
            border-radius: 4px;
            font-size: 12px;
        }
        .mst-total {
            font-weight: bold;
            color: #2e7d32;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 2px solid #e8d7cf;
        }
    </style>
</head>
<body>
    <div class="container">
        <div id="toolbar" class="toolbar">
            <div class="nav-buttons">
                <a href="/" class="nav-btn">← Вернуться на главную</a>
            </div>
            <h3>Алгоритм прима - поиск кратчайшего остова</h3>

            <div id="point-drag" class="draggable-point" draggable="true">+ Добавить вершину</div>

            <!-- Панель выбора стартовой вершины -->
            <div class="start-vertex-panel">
                <div class="random-title">Стартовая вершина</div>
                <label class="random-label">Выберите стартовую вершину</label>
                <select id="start-vertex-select" class="start-vertex-select">
                </select>
                <div style="font-size: 11px; color: #666; margin-top: 5px;">
                    ℹ️ Алгоритм прима выберет вершину
                </div>
            </div>

            <!-- Панель генерации случайных расстояний -->
            <div class="random-panel">
                <div class="random-title">Генератор случайных расстояний</div>
                <label class="random-label">Min value:</label>
                <input type="number" id="random-min" class="random-input" value="50" step="1">
                <label class="random-label">Max value:</label>
                <input type="number" id="random-max" class="random-input" value="500" step="1">
                <button id="random-btn" class="btn-generate">Сгенерировать случайные расстояния</button>
            </div>

            <!-- Кнопки управления -->
            <button id="clear-graph-btn" class="btn btn-warning">Очистить граф</button>
            <button id="prim-btn" class="btn btn-primary" style="margin-top: 10px;">Найти кратчайший остов</button>

            <!-- Результаты MST -->
            <div id="mst-result" class="mst-result">
                <div class="random-title">Результат</div>
                <div id="mst-edges-list"></div>
                <div id="mst-total" class="mst-total"></div>
            </div>
        </div>

        <div id="canvas" class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
        </div>
    </div>

    <script src="/static/script.js"></script>
    <script src="/static/prim.js"></script>
</body>
</html>