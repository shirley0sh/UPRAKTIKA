<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Floyd-Warshall</title>
    <link rel="stylesheet" href="/static/style.css">
    <style>
        /* Стили для шапки тулбара */
        .toolbar-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            padding-bottom: 0;
            border-bottom: none;
        }

        .toolbar h3 {
            border-bottom: none;
            padding-bottom: 0;
            margin-bottom: 0;
            color: #fff; /* Исправил цвет на белый для контраста с темным тулбаром */
            font-size: 20px;
            font-weight: 600;
        }

        /* Кнопка назад (<) */
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

        /* --- ОБНОВЛЕННЫЕ СТИЛИ ДЛЯ КНОПКИ ДОБАВЛЕНИЯ ТОЧКИ --- */
        .draggable-point {
            background: rgba(187, 195, 208, 0.9); /* Цвет как у точки на холсте */
            border: 2px solid rgba(255, 255, 255, 0.8);
            color: #2c2c2c;
            width: 60px;       /* Фиксированная ширина */
            height: 60px;      /* Фиксированная высота */
            border-radius: 50%; /* Делает её круглой */
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;   /* Крупный плюс */
            font-weight: bold;
            cursor: grab;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            transition: all 0.2s ease;
            margin: 0 auto 20px auto; /* Центрируем кнопку в тулбаре */
            padding: 0;        /* Убираем лишние отступы */
            text-align: center;
            line-height: 1;
        }

        .draggable-point:hover {
            background: #ffffff;
            transform: scale(1.1); /* Увеличение при наведении */
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }

        .draggable-point:active {
            cursor: grabbing;
            transform: scale(0.95);
        }

        /* Панель генерации (оставил как было, но привел к общему стилю) */
        .random-panel {
            background: rgba(0, 0, 0, 0.15);
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
        }

        .random-title {
            font-weight: bold;
            margin-bottom: 12px;
            font-size: 14px;
            color: #fff;
        }

        .random-label {
            font-size: 12px;
            display: block;
            margin-bottom: 5px;
            color: #fff;
        }

        .random-input {
            width: 100%;
            padding: 8px 10px;
            margin-bottom: 12px;
            box-sizing: border-box;
            border-radius: 4px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.8);
        }

        .btn-generate {
            background-color: #5a4d5e;
            color: white;
            padding: 10px;
            width: 100%;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            font-weight: bold;
            margin-top: 5px;
        }

        .btn-generate:hover {
            background-color: #6e5d73;
        }

        /* Стили для остальных кнопок, чтобы они не конфликтовали */
        .btn {
            padding: 12px;
            width: 100%;
            cursor: pointer;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            font-weight: 700;
            transition: all 0.3s ease;
            font-family: 'Segoe UI', sans-serif;
            margin-bottom: 10px;
            background-color: #5a4d5e;
            color: white;
        }
        .btn:hover {
            background-color: #6e5d73;
            transform: translateY(-1px);
        }
    </style>
</head>
<body>
    <div class="container">
        <div id="toolbar" class="toolbar">

            <!-- Шапка с кнопкой < и заголовком -->
            <div class="toolbar-header">
                <a href="/" class="back-btn" title="Back to Home"><</a>
                <h3>Floyd-Warshall Algorithm</h3>
            </div>

            <!-- Круглая кнопка добавления точки (теперь выглядит как вершина) -->
            <div id="point-drag" class="draggable-point" draggable="true" title="Перетащите на холст, чтобы создать вершину">+</div>

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
            <button id="clear-graph-btn" class="btn">Clear Graph</button>
            <button id="floyd-btn" class="btn">Compute Shortest Paths</button>
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
