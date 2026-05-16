<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Floyd-Warshall</title>
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <div class="container">
        <div class="toolbar">
            <div class="nav-buttons">
                <a href="/" class="nav-btn">← Back to Home</a>
            </div>
            <h3>Floyd-Warshall Algorithm</h3>

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
