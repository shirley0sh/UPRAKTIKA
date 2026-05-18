<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Редактор графов - Алгоритм Краскала</title>
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
            color: #fff;
            font-size: 20px;
            font-weight: 600;
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

        .draggable-point {
            background: rgba(187, 195, 208, 0.9);
            border: 2px solid rgba(255, 255, 255, 0.8);
            color: #2c2c2c;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: bold;
            cursor: grab;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            transition: all 0.2s ease;
            margin: 0 auto 20px auto;
            padding: 0;
            text-align: center;
            line-height: 1;
        }

        .draggable-point:hover {
            background: #ffffff;
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.3);
        }

        .draggable-point:active {
            cursor: grabbing;
            transform: scale(0.95);
        }

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

        /* Единый стиль для всех кнопок */
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
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .btn-generate {
            background-color: #5a4d5e;
            color: white;
            padding: 10px;
            width: 100%;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 700;
            border: none;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 5px;
        }

        .btn-generate:hover {
            background-color: #6e5d73;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        /* Панель информации о MST */
        .info-panel {
            background: rgba(0, 0, 0, 0.3);
            border-radius: 6px;
            padding: 12px;
            margin-top: 15px;
            text-align: center;
        }

        .info-panel .mst-weight {
            font-size: 18px;
            font-weight: bold;
            color: #2ecc71;
        }

        .info-panel .mst-edges {
            font-size: 12px;
            color: #ccc;
            margin-top: 5px;
        }

        /* Анимация для пошагового режима */
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }

        .step-active {
            animation: pulse 1s ease-in-out infinite;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Левая панель инструментов -->
        <div id="toolbar" class="toolbar">
            <!-- Шапка с кнопкой назад -->
            <div class="toolbar-header">
                <a href="/" class="back-btn" title="На главную"><</a>
                <h3>Алгоритм Краскала (MST)</h3>
            </div>

            <!-- Круглая кнопка добавления точки -->
            <div id="point-drag" class="draggable-point" draggable="true" title="Перетащите на холст, чтобы создать вершину">+</div>

            <!-- Панель генерации случайных расстояний -->
            <div class="random-panel">
                <div class="random-title">🎲 Генератор случайных расстояний</div>
                <label class="random-label">Минимальное значение:</label>
                <input type="number" id="random-min" class="random-input" value="50" step="1">
                <label class="random-label">Максимальное значение:</label>
                <input type="number" id="random-max" class="random-input" value="500" step="1">
                <button id="random-btn" class="btn-generate">Сгенерировать случайные расстояния</button>
            </div>

            <!-- Кнопки управления -->
            <button id="clear-graph-btn" class="btn">🗑 Очистить граф</button>
            <button id="kruskal-btn" class="btn">🌲 Вычислить MST (Краскал)</button>
            <button id="step-btn" class="btn">▶ Пошаговый режим</button>

            <!-- Панель информации -->
            <div class="info-panel" id="mst-info">
                <div style="font-size: 12px; color: #aaa;">Минимальное остовное дерево</div>
                <div class="mst-weight" id="mst-weight">—</div>
                <div class="mst-edges" id="mst-edges-count">Рёбер: —</div>
            </div>

            <!-- Краткая справка -->
            <div class="random-panel" style="margin-top: 10px;">
                <div class="random-title">📖 Как пользоваться</div>
                <div style="font-size: 11px; color: #ddd; line-height: 1.5;">
                    • Перетащите <strong>+</strong> на холст → создать вершину<br>
                    • Клик по вершине → выделить<br>
                    • Клик по двум вершинам → создать ребро<br>
                    • Двойной клик по ребру → задать вес<br>
                    • Нажмите Delete → удалить выделенное ребро<br>
                    • Двойной клик по вершине → удалить вершину
                </div>
            </div>
        </div>

        <!-- Правая область - холст -->
        <div id="canvas" class="canvas">
            <svg id="lines-layer" class="lines-layer"></svg>
            <div id="points-layer" class="points-layer"></div>
        </div>
    </div>

    <!-- Подключение скриптов -->
    <script src="/static/script.js"></script>
    <script src="/static/kruskal.js"></script>
</body>
</html>