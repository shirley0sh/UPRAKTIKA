<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Floyd-Warshall</title>
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
    </style>
</head>
<body>
    <div class="container">
        <div id="toolbar" class="toolbar">
            <div class="nav-buttons">
                <a href="/" class="nav-btn">← Back to Home</a>
            </div>
            <h3>Floyd-Warshall Algorithm</h3>

            <!-- Кнопка добавления точки -->
            <div id="point-drag" class="draggable-point" draggable="true">+ Add Point</div>

            <!-- Панель генерации случайных расстояний -->
            <div class="random-panel">
                <div class="random-title">Random Distance Generator</div>
                <label class="random-label">Min value:</label>
                <input type="number" id="random-min" class="random-input" value="50" step="1">
                <label class="random-label">Max value:</label>
                <input type="number" id="random-max" class="random-input" value="500" step="1">
                <button id="random-btn" class="btn-generate">Generate Random Distances</button>
            </div>

            <!-- Кнопки управления -->
            <button id="clear-graph-btn" class="btn btn-warning">Clear Graph</button>
            <button id="floyd-btn" class="btn btn-primary" style="margin-top: 10px;">Compute Shortest Paths</button>
        </div>

        <div id="canvas" class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
        </div>
    </div>

    <script src="/static/script.js"></script>
    <script src="/static/floyd.js"></script>
</body>
</html>
