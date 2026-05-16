<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Floyd-Warshall</title>
    <link rel="stylesheet" href="/static/style.css">
    <style>
        /* Локальные стили для шапки редактора */
        .toolbar-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid rgba(255, 255, 255, 0.3);
        }
        .back-btn {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.4);
            color: #fff;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
            line-height: 1;
        }
        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-2px);
            border-color: #fff;
        }
        .toolbar-title {
            color: #2c2c2c;
            font-size: 20px;
            font-weight: 600;
            margin: 0;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="toolbar">
            <!-- Шапка с кнопкой назад и заголовком -->
            <div class="toolbar-header">
                <a href="/" class="back-btn" title="Back to Home"><</a>
                <h3 class="toolbar-title">Floyd-Warshall Algorithm</h3>
            </div>

            <div id="point-drag" class="draggable-point" draggable="true">+ Add Point</div>

            <div class="random-panel">
                <div class="random-title">Random Distance Generator</div>
                <label class="random-label">Min value:</label>
                <input type="number" id="random-min" class="random-input" value="50" step="1">
                <label class="random-label">Max value:</label>
                <input type="number" id="random-max" class="random-input" value="500" step="1">
                <button id="random-btn" class="btn-generate">Generate Random Distances</button>
            </div>

            <button id="clear-graph-btn" class="btn btn-warning">Clear Graph</button>
            <button id="floyd-btn" class="btn btn-primary" style="margin-top: 10px;">Compute Shortest Paths</button>
        </div>

        <div class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
        </div>
    </div>

    <script src="/static/script.js"></script>
    <script src="/static/floyd.js"></script>
</body>
</html>
