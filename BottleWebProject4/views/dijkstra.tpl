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
</body>
</html>
