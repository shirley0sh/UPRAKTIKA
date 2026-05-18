<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Floyd-Warshall</title>
    <link rel="stylesheet" href="/static/style.css">
    <style>
        /* Переопределение отступов в тулбаре */
        .toolbar {
            display: flex;
            flex-direction: column;
            gap: 12px;
            padding: 20px;
        }

        /* Шапка тулбара */
        .toolbar-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 0;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
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
            transition: all 0.2s ease;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-2px);
        }

        /* Стиль для заголовка-ссылки на теорию */
        .floyd-title-link {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            font-weight: 600;
            margin: 0;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 8px;
            border-radius: 8px;
        }

        .floyd-title-link:hover {
            background: rgba(155, 89, 182, 0.3);
            transform: translateX(2px);
        }

        /* Круглая кнопка добавления вершины */
        .vertex-creator {
            text-align: center;
            margin-bottom: 5px;
        }

        .draggable-point {
            width: 60px;
            height: 60px;
            background: #5a4d5e;
            border: 2px solid rgba(255, 255, 255, 0.6);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: bold;
            color: white;
            cursor: grab;
            margin: 0 auto 8px auto;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }

        .draggable-point:hover {
            transform: scale(1.05);
            background: #6e5d73;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
        }

        .draggable-point:active {
            cursor: grabbing;
            transform: scale(0.98);
        }

        .drag-hint {
            text-align: center;
            font-size: 13px;
            color: rgba(255, 255, 255, 0.7);
            margin-top: -5px;
            margin-bottom: 10px;
        }

        /* Панель генерации случайных расстояний */
        .random-panel {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            padding: 12px;
            margin-bottom: 5px;
        }

        .random-title {
            font-weight: bold;
            margin-bottom: 10px;
            font-size: 13px;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .input-group {
            margin-bottom: 8px;
        }

        .input-group label {
            display: block;
            font-size: 11px;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 4px;
        }

        .random-input {
            width: 100%;
            padding: 8px 10px;
            background: rgba(255, 255, 255, 0.9);
            border: none;
            border-radius: 6px;
            font-size: 13px;
            box-sizing: border-box;
        }

        .random-input:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(155, 89, 182, 0.5);
        }

        .input-row {
            display: flex;
            gap: 10px;
        }

        .input-row .input-group {
            flex: 1;
        }

        /* Кнопки управления - единый цвет */
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 8px;
            margin: 5px 0;
        }

        .btn {
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            text-align: center;
            background: #5a4d5e;
            color: white;
        }

        .btn:hover {
            background: #6e5d73;
            transform: translateY(-1px);
        }

        .btn-primary {
            background: #5a4d5e;
        }

        .btn-primary:hover {
            background: #6e5d73;
        }

        .btn-secondary {
            background: #5a4d5e;
        }

        .btn-secondary:hover {
            background: #6e5d73;
        }

        .btn-danger {
            background: #5a4d5e;
        }

        .btn-danger:hover {
            background: #6e5d73;
        }

        /* Информационный блок */
        .info-panel {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 10px;
            padding: 12px;
            margin-top: 10px;
        }

        .info-panel h4 {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .info-panel p {
            font-size: 11px;
            color: rgba(255, 255, 255, 0.6);
            line-height: 1.4;
            margin-bottom: 5px;
        }

        .info-panel .shortcut {
            display: inline-block;
            background: rgba(255, 255, 255, 0.1);
            padding: 2px 6px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div id="toolbar" class="toolbar">
            <div class="toolbar-header">
                <a href="/" class="back-btn" title="На главную">←</a>
                <a href="/" onclick="localStorage.setItem('activeTab', 'floyd');" class="floyd-title-link" title="Перейти к теоретическому описанию алгоритма Флойда">
                    Алгоритм Флойда–Уоршелла
                </a>
            </div>

            <!-- Создание вершины -->
            <div class="vertex-creator">
                <div id="point-drag" class="draggable-point" draggable="true" title="Перетащите на холст">+</div>
                <div class="drag-hint">📌 Перетащите на холст</div>
            </div>

            <!-- Генерация случайных расстояний -->
            <div class="random-panel">
                <div class="random-title">🎲 Случайные веса рёбер</div>
                <div class="input-row">
                    <div class="input-group">
                        <label>Мин.</label>
                        <input type="number" id="random-min" class="random-input" value="50" step="1">
                    </div>
                    <div class="input-group">
                        <label>Макс.</label>
                        <input type="number" id="random-max" class="random-input" value="500" step="1">
                    </div>
                </div>
                <button id="random-btn" class="btn btn-secondary" style="width: 100%; margin-top: 5px;">Сгенерировать</button>
            </div>

            <!-- Кнопки действий -->
            <div class="action-buttons">
                <button id="floyd-btn" class="btn btn-primary">🔍 Вычислить кратчайшие пути</button>
                <button id="clear-graph-btn" class="btn btn-danger">🗑 Очистить граф</button>
            </div>

            <!-- Информационный блок -->
            <div class="info-panel">
                <h4>ℹ️ О алгоритме</h4>
                <p>Флойда–Уоршелла находит кратчайшие пути между всеми парами вершин.</p>
                <p><strong>Сложность:</strong> O(n³)</p>
                <p><span class="shortcut">💡 Совет:</span> Дважды кликните по ребру, чтобы задать вес</p>
            </div>
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
