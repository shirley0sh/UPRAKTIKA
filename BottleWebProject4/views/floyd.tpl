<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Graph Editor - Floyd-Warshall</title>
    <link rel="stylesheet" href="/static/style.css">
    <style>
        .toolbar {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Шапка тулбара */
        .toolbar-header {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 5px;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }

        .back-btn {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.4);
            color: #fff;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            font-size: 20px;
            font-weight: bold;
            transition: all 0.2s ease;
        }

        .back-btn:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: translateX(-2px);
        }

        .toolbar-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: #fff;
        }

        /* Круглая кнопка добавления вершины */
        .vertex-creator {
            text-align: center;
            margin-bottom: 10px;
        }

        .draggable-point {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #6e5d73 0%, #5a4d5e 100%);
            border: 2px solid rgba(255, 255, 255, 0.6);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            font-weight: bold;
            color: white;
            cursor: grab;
            margin: 0 auto 15px auto;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .draggable-point:hover {
            transform: scale(1.05);
            background: linear-gradient(135deg, #7d6d83 0%, #6e5d73 100%);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.3);
        }

        .draggable-point:active {
            cursor: grabbing;
            transform: scale(0.98);
        }

        .drag-hint {
            text-align: center;
            font-size: 16px;
            color: rgba(255, 255, 255, 0.6);
            margin-top: -10px;
            margin-bottom: 15px;
        }

        /* Панель генерации случайных расстояний */
        .random-panel {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 10px;
        }

        .random-title {
            font-weight: bold;
            margin-bottom: 12px;
            font-size: 14px;
            color: #fff;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .random-title::before {
            content: "";
            font-size: 16px;
        }

        .input-group {
            margin-bottom: 12px;
        }

        .input-group label {
            display: block;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 5px;
        }

        .random-input {
            width: 100%;
            padding: 10px 12px;
            background: rgba(255, 255, 255, 0.9);
            border: none;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .random-input:focus {
            outline: none;
            box-shadow: 0 0 0 2px rgba(155, 89, 182, 0.5);
        }

        .input-row {
            display: flex;
            gap: 12px;
        }

        .input-row .input-group {
            flex: 1;
        }

        /* Кнопки управления */
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin: 10px 0;
        }

        .btn {
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            text-align: center;
        }

        .btn-primary {
            background: linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(155, 89, 182, 0.4);
        }

        .btn-secondary {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
        }

        .btn-secondary:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-1px);
        }

        .btn-danger {
            background: rgba(231, 76, 60, 0.3);
            border: 1px solid rgba(231, 76, 60, 0.5);
            color: #e74c3c;
        }

        .btn-danger:hover {
            background: rgba(231, 76, 60, 0.5);
            color: white;
        }

        /* Информационный блок */
        .info-panel {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 12px;
            padding: 15px;
            margin-top: 15px;
        }

        .info-panel h4 {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.7);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .info-panel p {
            font-size: 12px;
            color: rgba(255, 255, 255, 0.6);
            line-height: 1.5;
            margin-bottom: 8px;
        }

        .info-panel .shortcut {
            display: inline-block;
            background: rgba(255, 255, 255, 0.1);
            padding: 2px 8px;
            border-radius: 4px;
            font-family: monospace;
            font-size: 11px;
        }

        .floyd-title {
            font-size: 22px;
            font-weight: 600;
            color: #fff;
            margin: 0;
            position: relative;
            padding-left: 16px;
        }
   /* Стиль для заголовка-ссылки на теорию */
        .floyd-title-link {
            color: #fff;
            text-decoration: none;
            font-size: 18px;
            font-weight: 600;
            margin: 0;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 4px 8px;
            border-radius: 8px;
        }

        .floyd-title-link:hover {
            background: rgba(155, 89, 182, 0.3);
            transform: translateX(2px);
        }


    </style>
</head>
<body>
    <div class="container">
        <div id="toolbar" class="toolbar">
                       <div class="toolbar-header">
                <a href="/" class="back-btn" title="На главную"><</a>
                <a href="/" onclick="localStorage.setItem('activeTab', 'floyd');" class="floyd-title-link" title="Перейти к теоретическому описанию алгоритма Флойда">
                    Алгоритм Флойда–Уоршелла
                </a>
            </div>

            <!-- Создание вершины -->
            <div class="vertex-creator">
                <div id="point-drag" class="draggable-point" draggable="true" title="Перетащите на холст">+</div>
                <div class="drag-hint">Перетащите на холст</div>
            </div>

            <!-- Генерация случайных расстояний -->
            <div class="random-panel">
                <div class="random-title">Случайные веса рёбер</div>
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
                <button id="floyd-btn" class="btn btn-primary">Вычислить кратчайшие пути</button>
                <button id="clear-graph-btn" class="btn btn-danger">Очистить граф</button>
            </div>

            <!-- Информационный блок -->
            <div class="info-panel">
                <h4>О алгоритме</h4>
                <p>Флойда–Уоршелла находит кратчайшие пути между всеми парами вершин.</p>
                <p><strong>Сложность:</strong> O(n³)</p>
                <p><span class="shortcut">Совет:</span> Дважды кликните по ребру, чтобы задать вес</p>
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
