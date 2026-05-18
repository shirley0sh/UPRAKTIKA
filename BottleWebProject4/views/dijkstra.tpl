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

    <!-- Правая область: канвас + результаты -->
    <div class="right-area">
        <div id="canvas" class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
        </div>

        <!-- таблица + пути -->
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

<script src="/static/dijkstra.js"></script>
</body>
</html>