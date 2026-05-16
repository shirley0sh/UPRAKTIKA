<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Graphix - Graph Theory</title>
    <style>
        * {
            margin: 1;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 0;
            margin: 0;
            background-image: url('/static/background.png');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            background-repeat: no-repeat;
        }

        /* Фиксированная шапка */
        .header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            background: rgba(0, 0, 0, 0.85);
            backdrop-filter: blur(10px);
            z-index: 1000;
            padding: 15px 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.3);
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .logo {
            font-size: 28px;
            font-weight: bold;
            color: #fff;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
            font-family: 'Arial Black', sans-serif;
            letter-spacing: 2px;
            white-space: nowrap;
        }

        .tabs {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .tab-button {
            padding: 10px 20px;
            background: none;
            border: none;
            border-bottom: 2px solid transparent;
            cursor: pointer;
            font-size: 15px;
            color: #fff;
            transition: all 0.2s;
            white-space: nowrap;
        }

        .tab-button:hover {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px;
        }

        .tab-button.active {
            border-bottom-color: #fff;
            font-weight: bold;
            color: #fff;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 4px 4px 0 0;
        }

        /* Основной контент с отступом для фиксированной шапки */
        .main-content {
            padding-top: 90px;
            padding-left: 20px;
            padding-right: 20px;
            padding-bottom: 40px;
            max-width: 1400px;
            margin: 0 auto;
        }

        .tab-content {
            display: none;
            width: 100%;
            background: rgba(155, 142, 162, 0.95);
            border-radius: 8px;
            padding: 30px;
            color: #fff;
            min-height: 500px;
        }

        .tab-content.active {
            display: block;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #fff;
        }

        input, textarea {
            width: 100%;
            max-width: 500px;
            padding: 8px;
            border: 1px solid #ccc;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 4px;
        }

        textarea {
            min-height: 120px;
        }

        button {
            padding: 8px 20px;
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid #fff;
            cursor: pointer;
            color: #fff;
            border-radius: 4px;
            transition: all 0.3s;
        }

        button:hover {
            background: rgba(255, 255, 255, 0.3);
        }

        .tab-content h2, .tab-content p, .tab-content ul, .tab-content li {
            color: #fff;
        }

        .tab-content a {
            color: #fff;
            text-decoration: underline;
        }

        .content-text {
            line-height: 1.6;
            font-size: 16px;
        }

        .content-text h2 {
            margin-bottom: 15px;
            font-size: 28px;
            color: #fff;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }

        .content-text h3 {
            margin-bottom: 10px;
            margin-top: 20px;
            font-size: 22px;
            color: #fff;
        }

        .content-text p {
            margin-bottom: 15px;
        }

        .content-text ul {
            margin-left: 20px;
            margin-bottom: 15px;
        }

        .content-text li {
            margin-bottom: 8px;
        }

        /* Стили для теории */
        .intro {
            background: rgba(248, 249, 250, 0.2);
            padding: 15px;
            border-left: 4px solid #3498db;
            border-radius: 0 4px 4px 0;
            margin: 20px 0;
        }

        .complexity {
            display: inline-block;
            background: rgba(232, 244, 248, 0.3);
            padding: 2px 8px;
            border-radius: 3px;
            font-family: monospace;
            font-weight: bold;
        }

        pre {
            background: #2d2d2d;
            color: #f8f8f2;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 0.9em;
            margin: 15px 0;
        }

        code {
            font-family: 'Consolas', 'Monaco', monospace;
            background: rgba(241, 241, 241, 0.2);
            padding: 2px 6px;
            border-radius: 3px;
        }

        pre code {
            background: none;
            padding: 0;
        }

        .formula {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(221, 221, 221, 0.3);
            padding: 10px 15px;
            margin: 10px 0;
            border-radius: 4px;
            font-family: 'Times New Roman', serif;
            font-style: italic;
            text-align: center;
        }

        .matrix {
            font-family: monospace;
            white-space: pre;
            text-align: center;
            margin: 10px 0;
            background: rgba(248, 249, 250, 0.1);
            padding: 10px;
            border-radius: 4px;
        }

        .note {
            background: rgba(255, 243, 205, 0.2);
            border: 1px solid rgba(255, 234, 167, 0.3);
            padding: 10px 15px;
            border-radius: 4px;
            margin: 10px 0;
        }

        .proof {
            border-left: 3px solid #9b59b6;
            padding-left: 15px;
            margin: 15px 0;
            font-style: italic;
        }

        ul.toc {
            list-style: none;
            padding-left: 0;
            background: rgba(248, 249, 250, 0.1);
            padding: 15px;
            border-radius: 5px;
        }
        ul.toc li { margin: 5px 0; }
        ul.toc a {
            color: #87ceeb;
            text-decoration: none;
        }
        ul.toc a:hover { text-decoration: underline; }

        .keyword { color: #f92672; font-weight: bold; }
        .function { color: #66d9ef; }
        .comment { color: #75715e; font-style: italic; }
        .string { color: #a6e22e; }

        .editor-btn {
            background: #9b59b6;
            padding: 12px 24px;
            font-size: 16px;
            margin-top: 20px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
            color: white;
            font-weight: bold;
        }
        .editor-btn:hover {
            background: #8e44ad;
        }

        /* Адаптация для мобильных */
        @media (max-width: 768px) {
            .header-content {
                flex-direction: column;
                align-items: center;
            }
            .logo {
                white-space: normal;
                text-align: center;
            }
            .tabs {
                justify-content: center;
            }
            .tab-button {
                padding: 8px 12px;
                font-size: 12px;
            }
            .main-content {
                padding-top: 130px;
            }
        }
    </style>
</head>
<body>
    <!-- Фиксированная шапка с логотипом и табами -->
    <div class="header">
        <div class="header-content">
            <div class="logo">Graphix</div>
            <div class="tabs">
                <button class="tab-button active" data-tab="home">Home</button>
                <button class="tab-button" data-tab="floyd">Floyd-Warshall</button>
                <button class="tab-button" data-tab="dijkstra">Dijkstra</button>
                <button class="tab-button" data-tab="prim">Алгоритм Прима</button>
                <button class="tab-button" data-tab="kruskal">Kruskal</button>
                <button class="tab-button" data-tab="about">About</button>
                <button class="tab-button" data-tab="contacts">Contacts</button>
                <button class="tab-button" data-tab="feedback">Feedback</button>
            </div>
        </div>
    </div>

    <!-- Основной контент -->
<div class="main-content">
    <!-- Вкладка Home -->
    <div id="home" class="tab-content active">
        <div class="content-text">
            <h2>Добро пожаловать в Graphix</h2>
            <p>Graphix — это мощный инструмент визуализации теории графов, который позволяет создавать, редактировать и анализировать графы с помощью различных алгоритмов.</p>

            <h3>Доступные алгоритмы:</h3>
            <ul>
                <li><strong>Флойд–Уоршелл</strong> — находит кратчайшие пути между всеми парами вершин</li>
                <li><strong>Дейкстра</strong> — находит кратчайшие пути от одной исходной вершины</li>
                <li><strong>Алгоритм Прима</strong> — используется для нахождения минимального остовного дерева</li>
                <li><strong>Краскал</strong> — находит минимальное остовное дерево (скоро)</li>
            </ul>

            <h3>Как использовать редактор графов:</h3>
            <ul>
                <li>Перейдите на вкладку любого алгоритма, чтобы открыть интерактивный редактор графов</li>
                <li>Перетащите кнопку «Добавить точку» на холст, чтобы создать вершины</li>
                <li>Нажмите на одну вершину, затем на другую, чтобы создать ребро</li>
                <li>Дважды нажмите на ребро, чтобы задать пользовательское расстояние</li>
                <li>Перетаскивайте вершины, чтобы перемещать их</li>
                <li>Нажмите на ребро и затем на клавишу Delete, чтобы удалить его</li>
                <li>Дважды нажмите на вершину, чтобы удалить её</li>
                <li>Используйте генератор случайных расстояний, чтобы назначить случайные веса всем рёбрам</li>
            </ul>

            <h3>Возможности:</h3>
            <ul>
                <li>Интерактивный редактор графов с интерфейсом перетаскивания</li>
                <li>Визуализация в реальном времени</li>
                <li>Генерация случайных расстояний</li>
                <li>Визуализация кратчайшего пути</li>
            </ul>
        </div>
    </div>
</div>

        <!-- Вкладка Floyd-Warshall с теорией -->
        <div id="floyd" class="tab-content">
            <div class="content-text">
                <button onclick="window.location.href='/floyd'" class="editor-btn">Open Floyd-Warshall Editor</button>

                <h1>Алгоритм Флойда–Уоршелла</h1>

                <div class="intro">
                    <strong>Алгоритм Флойда</strong> (алгоритм Флойда–Уоршелла) — алгоритм нахождения длин кратчайших путей между всеми парами вершин во взвешенном ориентированном графе.
                    Работает корректно, если в графе нет циклов отрицательной величины, а в случае, когда такой цикл есть, позволяет найти хотя бы один такой цикл.
                    <br><br>
                    <strong>Сложность:</strong>
                    Время — <span class="complexity">Θ(n³)</span>,
                    Память — <span class="complexity">Θ(n²)</span>.
                    <br>Разработан в 1962 году.
                </div>

                <nav>
                    <h3>Содержание</h3>
                    <ul class="toc">
                        <li><a href="#problem">1. Постановка задачи</a></li>
                        <li><a href="#description">2. Описание алгоритма</a></li>
                        <li><a href="#code-basic">3. Код (базовая версия)</a></li>
                        <li><a href="#code-optimal">4. Код (оптимизированный)</a></li>
                        <li><a href="#example">5. Пример работы</a></li>
                        <li><a href="#path-reconstruction">6. Восстановление пути</a></li>
                        <li><a href="#negative-cycle">7. Поиск отрицательного цикла</a></li>
                        <li><a href="#transitive-closure">8. Транзитивное замыкание</a></li>
                    </ul>
                </nav>

                <h2 id="problem">1. Постановка задачи</h2>
                <p>Дан взвешенный ориентированный граф <code>G(V, E)</code>, в котором вершины пронумерованы от <code>1</code> до <code>n</code>.</p>

                <div class="formula">
                    ω<sub>uv</sub> = { weight(u→v), если (u→v) ∈ E; +∞, если (u→v) ∉ E }
                </div>

                <p><strong>Требуется:</strong> найти матрицу кратчайших расстояний <code>d</code>, где элемент <code>d<sub>ij</sub></code> равен:</p>
                <ul>
                    <li>длине кратчайшего пути из <code>i</code> в <code>j</code>, или</li>
                    <li><code>+∞</code>, если вершина <code>j</code> не достижима из <code>i</code></li>
                </ul>

                <h2 id="description">2. Описание алгоритма</h2>
                <p>Обозначим длину кратчайшего пути между вершинами <code>u</code> и <code>v</code>, содержащего только вершины из множества <code>{1..i}</code> как <code>d<sup>(i)</sup><sub>uv</sub></code>, где <code>d<sup>(0)</sup><sub>uv</sub> = ω<sub>uv</sub></code>.</p>

                <p><strong>Рекуррентное соотношение:</strong></p>
                <div class="formula">
                    d<sup>(i)</sup><sub>uv</sub> = min( d<sup>(i-1)</sup><sub>uv</sub>, d<sup>(i-1)</sup><sub>ui</sub> + d<sup>(i-1)</sup><sub>iv</sub> )
                </div>

                <p><strong>Логика:</strong></p>
                <ul>
                    <li>Если кратчайший путь из <code>u</code> в <code>v</code> проходит через вершину <code>i</code> → объединяем пути <code>u→i</code> и <code>i→v</code></li>
                    <li>Если не проходит → берём значение с предыдущей итерации</li>
                </ul>

                <h2 id="code-basic">3. Код (базовая версия)</h2>
                <pre><code><span class="comment">// Инициализация</span>
<span class="keyword">for</span> u <span class="keyword">in</span> V:
    <span class="keyword">for</span> v <span class="keyword">in</span> V:
        d[0][u][v] = ω[u][v]

<span class="comment">// Основной цикл</span>
<span class="keyword">for</span> i <span class="keyword">in</span> V:
    <span class="keyword">for</span> u <span class="keyword">in</span> V:
        <span class="keyword">for</span> v <span class="keyword">in</span> V:
            d[i][u][v] = min(
                d[i-1][u][v],
                d[i-1][u][i] + d[i-1][i][v]
            )</code></pre>

                <div class="note">
                    Эта реализация использует <span class="complexity">Θ(n³)</span> памяти из-за хранения всех слоёв <code>d<sup>(i)</sup></code>.
                </div>

                <h2 id="code-optimal">4. Код (оптимизированный)</h2>
                <p>Можно использовать <strong>двумерный массив</strong>, обновляя значения "на месте":</p>

                <pre><code><span class="function">func</span> <span class="function">floyd</span>(ω):
    <span class="comment">// Инициализация: d = ω</span>
    d = copy(ω)

    <span class="comment">// Три вложенных цикла</span>
    <span class="keyword">for</span> k <span class="keyword">in</span> <span class="function">range</span>(n):          <span class="comment">// промежуточная вершина</span>
        <span class="keyword">for</span> i <span class="keyword">in</span> <span class="function">range</span>(n):          <span class="comment">// начальная вершина</span>
            <span class="keyword">for</span> j <span class="keyword">in</span> <span class="function">range</span>(n):      <span class="comment">// конечная вершина</span>
                <span class="keyword">if</span> d[i][k] + d[k][j] < d[i][j]:
                    d[i][j] = d[i][k] + d[k][j]

    <span class="keyword">return</span> d</code></pre>

                <p><strong>Сложность:</strong> <span class="complexity">Θ(n³)</span> времени, <span class="complexity">Θ(n²)</span> памяти.</p>

                <h2 id="example">5. Пример работы</h2>
                <p>Исходная матрица весов (<code>∞</code> — нет ребра):</p>
                <div class="matrix">
                [ ×   ∞   ∞   ∞ ]<br>
                [ 1   ×   ∞   ∞ ]<br>
                [ 6   4   ×   1 ]<br>
                [ ∞   1   ∞   × ]
                </div>

                <p><strong>После итераций:</strong></p>
                <div class="matrix">
                k=0 → k=1 → k=2 → k=3<br><br>
                [ ×  ∞  ∞  ∞ ]   [ ×  ∞  ∞  ∞ ]   [ ×  ∞  ∞  ∞ ]   [ ×  ∞  ∞  ∞ ]<br>
                [ 1  ×  ∞  ∞ ] → [ 1  ×  ∞  ∞ ] → [ 1  ×  ∞  ∞ ] → [ 1  ×  ∞  ∞ ]<br>
                [ 6  4  ×  1 ]   [ 5  4  ×  1 ]   [ 5  4  ×  1 ]   [ 3  2  ×  1 ]<br>
                [ ∞  1  ∞  × ]   [ 2  1  ∞  × ]   [ 2  1  ∞  × ]   [ 2  1  ∞  × ]
                </div>

                <h2 id="path-reconstruction">6. Восстановление кратчайшего пути</h2>
                <p>Добавим массив <code>next[u][v]</code> — следующая вершина на пути из <code>u</code> в <code>v</code>.</p>

                <pre><code><span class="function">func</span> <span class="function">floyd_with_path</span>(ω):
    d = copy(ω)
    next = [[None]*n <span class="keyword">for</span> _ <span class="keyword">in</span> <span class="function">range</span>(n)]

    <span class="comment">// Инициализация next</span>
    <span class="keyword">for</span> i <span class="keyword">in</span> <span class="function">range</span>(n):
        <span class="keyword">for</span> j <span class="keyword">in</span> <span class="function">range</span>(n):
            <span class="keyword">if</span> ω[i][j] < ∞ <span class="keyword">and</span> i != j:
                next[i][j] = j

    <span class="comment">// Основной алгоритм</span>
    <span class="keyword">for</span> k <span class="keyword">in</span> <span class="function">range</span>(n):
        <span class="keyword">for</span> i <span class="keyword">in</span> <span class="function">range</span>(n):
            <span class="keyword">for</span> j <span class="keyword">in</span> <span class="function">range</span>(n):
                <span class="keyword">if</span> d[i][k] + d[k][j] < d[i][j]:
                    d[i][j] = d[i][k] + d[k][j]
                    next[i][j] = next[i][k]

    <span class="keyword">return</span> d, next

<span class="function">func</span> <span class="function">get_path</span>(u, v, next):
    <span class="keyword">if</span> d[u][v] == ∞:
        <span class="keyword">return</span> <span class="string">"No path"</span>

    path = [u]
    <span class="keyword">while</span> u != v:
        u = next[u][v]
        <span class="keyword">if</span> u <span class="keyword">is</span> None: <span class="keyword">return</span> <span class="string">"No path"</span>
        path.append(u)
    <span class="keyword">return</span> path</code></pre>

                <h2 id="negative-cycle">7. Поиск отрицательного цикла</h2>
                <div class="proof">
                    <strong>Утверждение:</strong> При наличии цикла отрицательного веса на главной диагонали матрицы <code>d</code> появятся отрицательные числа: <code>d[i][i] &lt; 0</code>.
                </div>

                <pre><code><span class="comment">// После выполнения алгоритма Флойда:</span>
<span class="keyword">for</span> i <span class="keyword">in</span> <span class="function">range</span>(n):
    <span class="keyword">if</span> d[i][i] < 0:
        print(<span class="string">f"Отрицательный цикл через вершину {i}"</span>)</code></pre>

                <div class="note">
                    <strong>Важно:</strong> При наличии отрицательных циклов расстояния могут уменьшаться неограниченно. Рекомендуется ограничивать вычисления снизу значением <code>-INF</code>.
                </div>

                <h2 id="transitive-closure">8. Построение транзитивного замыкания</h2>
                <p>Задача: найти все пары вершин <code>(x, y)</code>, между которыми существует путь.</p>

                <h3>Псевдокод</h3>
                <pre><code><span class="comment">// W[i][j] = 1, если есть ребро (i→j), иначе 0</span>
<span class="keyword">for</span> k <span class="keyword">in</span> <span class="function">range</span>(n):
    <span class="keyword">for</span> i <span class="keyword">in</span> <span class="function">range</span>(n):
        <span class="keyword">for</span> j <span class="keyword">in</span> <span class="function">range</span>(n):
            W[i][j] = W[i][j] <span class="keyword">or</span> (W[i][k] <span class="keyword">and</span> W[k][j])</code></pre>

                <hr>

                <div class="intro">
                    <strong>Источники:</strong>
                    <ul style="margin: 10px 0 0 0; padding-left: 20px;">
                        <li>Cormen T., Leiserson C., Rivest R. — "Алгоритмы: построение и анализ"</li>
                        <li>Floyd R.W. (1962). "Algorithm 97: Shortest Path". Communications of the ACM</li>
                        <li>Warshall S. (1962). "A theorem on Boolean matrices". Journal of the ACM</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Вкладка Dijkstra -->
        <div id="dijkstra" class="tab-content">
            <div class="content-text">
                <h2>Dijkstra's Algorithm</h2>
                <p>Click the button below to open the interactive graph editor with Dijkstra's algorithm.</p>
                <p>Dijkstra's algorithm finds the shortest paths from a single source vertex to all other vertices.</p>
                <button onclick="window.location.href='/dijkstra'" style="margin-top: 15px;">Open Dijkstra Editor →</button>
            </div>
        </div>

        <!-- Вкладка Prim с теорией -->
<div id="prim" class="tab-content">
    <div class="content-text">
        <button onclick="window.location.href='/prim'" class="editor-btn">Решить задачу с помощью алгоритма Прима</button>

        <h1>Алгоритм Прима</h1>

        <div class="intro">
            <strong>Алгоритм Прима</strong> — алгоритм построения минимального остовного дерева (Minimum Spanning Tree, MST) для связного взвешенного неориентированного графа.
            Он находит подграф, который соединяет все вершины графа, не содержит циклов и имеет минимально возможную сумму весов рёбер.
            <br><br>
            <strong>Сложность:</strong>
            Время — <span class="complexity">O(|E|·log|V|)</span> (с бинарной кучей),
            Память — <span class="complexity">O(|V| + |E|)</span>.
            <br>Разработан в 1957 году Робертом Примом (также открыт Ярником в 1930 и Дейкстрой в 1959).
        </div>

        <nav>
            <h3>Содержание</h3>
            <ul class="toc">
                <li><a href="#problem">1. Постановка задачи</a></li>
                <li><a href="#description">2. Описание алгоритма</a></li>
                <li><a href="#code-basic">3. Код (базовая версия)</a></li>
                <li><a href="#code-optimal">4. Код (оптимизированный с кучей)</a></li>
                <li><a href="#example">5. Пример работы</a></li>
                <li><a href="#comparison">6. Сравнение с алгоритмом Краскала</a></li>
                <li><a href="#applications">7. Области применения</a></li>
            </ul>
        </nav>

        <h2 id="problem">1. Постановка задачи</h2>
        <p>Дан связный взвешенный неориентированный граф <code>G(V, E)</code>, где <code>V</code> — множество вершин, <code>E</code> — множество рёбер, каждому ребру приписан вес <code>w(u, v) > 0</code>.</p>

        <div class="formula">
            G = (V, E), w: E → ℝ<sup>+</sup>
        </div>

        <p><strong>Требуется:</strong> найти остовное дерево <code>T ⊆ E</code>, такое что:</p>
        <ul>
            <li><code>T</code> связывает все вершины из <code>V</code>;</li>
            <li><code>T</code> не содержит циклов;</li>
            <li>сумма весов рёбер <code>∑<sub>e∈T</sub> w(e)</code> минимальна.</li>
        </ul>

        <h2 id="description">2. Описание алгоритма</h2>
        <p>Алгоритм Прима относится к классу <strong>жадных алгоритмов</strong>. На каждом шаге он добавляет к текущему дереву ребро минимального веса, соединяющее дерево с новой вершиной.</p>

        <p><strong>Основная идея:</strong></p>
        <ul>
            <li>Выбрать произвольную стартовую вершину <code>s</code> и включить её в дерево <code>T</code>.</li>
            <li>Поддерживать множество вершин <code>U</code>, уже включённых в дерево.</li>
            <li>На каждом шаге выбирать ребро <code>(u, v)</code> минимального веса, где <code>u ∈ U</code>, <code>v ∉ U</code>.</li>
            <li>Добавлять вершину <code>v</code> в <code>U</code>, а ребро <code>(u, v)</code> — в <code>T</code>.</li>
            <li>Повторять, пока <code>U ≠ V</code>.</li>
        </ul>

        <div class="proof">
            <strong>Корректность:</strong> Алгоритм всегда находит глобально оптимальное решение благодаря свойству жадного выбора: минимальное ребро, соединяющее дерево с внешней вершиной, принадлежит некоторому MST.
        </div>

        <h2 id="code-basic">3. Код (базовая версия)</h2>
        <p>Реализация с матрицей смежности и массивом <code>key</code> для хранения минимальных весов рёбер до каждой вершины:</p>

        <pre><code><span class="function">func</span> <span class="function">prim_basic</span>(graph, n):
    <span class="comment">// Инициализация</span>
    visited = [False] * n
    key = [∞] * n          <span class="comment">// минимальный вес ребра до вершины</span>
    parent = [-1] * n      <span class="comment">// родитель в MST</span>
    
    key[0] = 0             <span class="comment">// начинаем с вершины 0</span>
    
    <span class="keyword">for</span> _ <span class="keyword">in</span> <span class="function">range</span>(n):
        <span class="comment">// Выбираем вершину с минимальным key среди непосещённых</span>
        u = -1
        <span class="keyword">for</span> i <span class="keyword">in</span> <span class="function">range</span>(n):
            <span class="keyword">if</span> <span class="keyword">not</span> visited[i] <span class="keyword">and</span> (u == -1 <span class="keyword">or</span> key[i] < key[u]):
                u = i
        
        visited[u] = True
        
        <span class="comment">// Обновляем ключи соседей</span>
        <span class="keyword">for</span> v <span class="keyword">in</span> <span class="function">range</span>(n):
            <span class="keyword">if</span> graph[u][v] != 0 <span class="keyword">and</span> <span class="keyword">not</span> visited[v] <span class="keyword">and</span> graph[u][v] < key[v]:
                key[v] = graph[u][v]
                parent[v] = u
    
    <span class="keyword">return</span> parent, sum(key)  <span class="comment">// родители и вес MST</span></code></pre>

        <div class="note">
            <strong>Сложность базовой версии:</strong> <span class="complexity">O(|V|²)</span> — хорошо для плотных графов (где |E| близко к |V|²).
        </div>

        <h2 id="code-optimal">4. Код (оптимизированный с кучей)</h2>
        <p>Для разреженных графов эффективнее использовать <strong>бинарную кучу</strong> или <strong>кучу Фибоначчи</strong>:</p>

        <pre><code><span class="keyword">import</span> heapq

<span class="function">func</span> <span class="function">prim_heap</span>(graph, n):
    visited = [False] * n
    key = [∞] * n
    parent = [-1] * n
    key[0] = 0
    
    <span class="comment">// Куча: (вес, вершина)</span>
    heap = [(0, 0)]
    
    total_weight = 0
    
    <span class="keyword">while</span> heap:
        weight, u = heapq.heappop(heap)
        
        <span class="keyword">if</span> visited[u]:
            <span class="keyword">continue</span>
            
        visited[u] = True
        total_weight += weight
        
        <span class="comment">// Для каждого соседа v</span>
        <span class="keyword">for</span> v, w <span class="keyword">in</span> graph[u]:
            <span class="keyword">if</span> <span class="keyword">not</span> visited[v] <span class="keyword">and</span> w < key[v]:
                key[v] = w
                parent[v] = u
                heapq.heappush(heap, (w, v))
    
    <span class="keyword">return</span> parent, total_weight</code></pre>

        <p><strong>Сложность:</strong> <span class="complexity">O(|E|·log|V|)</span> — оптимально для разреженных графов.</p>

        <h2 id="example">5. Пример работы</h2>
        <p>Рассмотрим граф из 5 вершин:</p>

        <div class="matrix">
        Рёбра:<br>
        (0-1): 2, (0-3): 6<br>
        (1-2): 3, (1-3): 8, (1-4): 5<br>
        (2-4): 7<br>
        (3-4): 9
        </div>

        <p><strong>Пошаговое построение MST (начиная с вершины 0):</strong></p>
        <ul>
            <li><strong>Шаг 1:</strong> U = {0}, рассматриваем рёбра: (0-1):2, (0-3):6 → выбираем (0-1):2, добавляем вершину 1</li>
            <li><strong>Шаг 2:</strong> U = {0,1}, рёбра: (0-3):6, (1-2):3, (1-3):8, (1-4):5 → выбираем (1-2):3, добавляем вершину 2</li>
            <li><strong>Шаг 3:</strong> U = {0,1,2}, рёбра: (0-3):6, (1-3):8, (1-4):5, (2-4):7 → выбираем (1-4):5, добавляем вершину 4</li>
            <li><strong>Шаг 4:</strong> U = {0,1,2,4}, рёбра: (0-3):6, (1-3):8, (3-4):9 → выбираем (0-3):6, добавляем вершину 3</li>
        </ul>

        <div class="formula">
            <strong>Результат (MST):</strong> рёбра (0-1):2, (1-2):3, (1-4):5, (0-3):6<br>
            <strong>Общий вес:</strong> 2 + 3 + 5 + 6 = 16
        </div>

        <h2 id="comparison">6. Сравнение с алгоритмом Краскала</h2>
        
        <table style="width: 100%; border-collapse: collapse; margin: 20px 0;">
            <tr style="background: #96748a;">
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Характеристика</th>
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Алгоритм Прима</th>
                <th style="padding: 12px; text-align: left; border: 1px solid #ddd;">Алгоритм Краскала</th>
            </tr>
            <tr>
                <td style="padding: 10px; border: 1px solid #ddd;">Подход</td>
                <td style="padding: 10px; border: 1px solid #ddd;">"Растущее дерево" — добавляет вершины</td>
                <td style="padding: 10px; border: 1px solid #ddd;">"Лес" — добавляет рёбра, объединяя деревья</td>
            </tr>
            <tr style="background: #96748a;">
                <td style="padding: 10px; border: 1px solid #ddd;">Структура данных</td>
                <td style="padding: 10px; border: 1px solid #ddd;">Куча (приоритетная очередь)</td>
                <td style="padding: 10px; border: 1px solid #ddd;">Система непересекающихся множеств (DSU)</td>
            </tr>
            <tr>
                <td style="padding: 10px; border: 1px solid #ddd;">Сложность</td>
                <td style="padding: 10px; border: 1px solid #ddd;">O(|E|·log|V|)</td>
                <td style="padding: 10px; border: 1px solid #ddd;">O(|E|·log|E|)</td>
            </tr>
            <tr style="background: #96748a;">
                <td style="padding: 10px; border: 1px solid #ddd;">Когда лучше</td>
                <td style="padding: 10px; border: 1px solid #ddd;">Плотные графы (|E| ≈ |V|²)</td>
                <td style="padding: 10px; border: 1px solid #ddd;">Разреженные графы (|E| ≈ |V|)</td>
            </tr>
        </table>

        <h2 id="applications">7. Области применения</h2>
        <ul>
            <li><strong>Телекоммуникации:</strong> проектирование минимальных сетей связи (оптоволокно, вышки сотовой связи)</li>
            <li><strong>Транспорт:</strong> прокладка дорог, железнодорожных путей, трубопроводов</li>
            <li><strong>Электроэнергетика:</strong> построение электрических сетей минимальной стоимости</li>
            <li><strong>Компьютерные сети:</strong> построение остовных деревьев в протоколах STP (Spanning Tree Protocol)</li>
            <li><strong>Кластеризация:</strong> выделение связных компонент с минимальными расстояниями</li>
            <li><strong>Оптимизация:</strong> решение задач, сводящихся к MST (например, задача коммивояжёра с метрическими ограничениями)</li>
        </ul>

        <hr>

        <div class="intro">
            <strong>Источники:</strong>
            <ul style="margin: 10px 0 0 0; padding-left: 20px;">
                <li>Prim R.C. (1957). "Shortest connection networks and some generalizations". Bell System Technical Journal</li>
                <li>Cormen T., Leiserson C., Rivest R., Stein C. — "Алгоритмы: построение и анализ" (глава 23)</li>
                <li>Jarník V. (1930). "O jistém problému minimálním". Práce Moravské Přírodovědecké Společnosti</li>
            </ul>
        </div>
    </div>
</div>

        <!-- Вкладка Kruskal -->
        <div id="kruskal" class="tab-content">
            <div class="content-text">
                <h2>Kruskal's Algorithm</h2>
                <p>Coming soon!</p>
                <p>Kruskal's algorithm finds the Minimum Spanning Tree (MST) of a graph.</p>
                <button disabled style="margin-top: 15px; opacity: 0.5;">Coming Soon</button>
            </div>
        </div>

        <!-- Вкладка About -->
        <div id="about" class="tab-content">
            <div class="content-text">
                <h2>About Graphix</h2>
                <p>Graphix is a graph theory visualization tool developed for educational purposes.</p>

                <h3>Features:</h3>
                <ul>
                    <li>Interactive graph editor with drag-and-drop</li>
                    <li>Floyd-Warshall algorithm (all-pairs shortest paths)</li>
                    <li>Dijkstra algorithm (single-source shortest paths)</li>
                    <li>Random distance generation</li>
                    <li>Real-time visualization with SVG</li>
                </ul>

                <h3>Technologies:</h3>
                <ul>
                    <li>Backend: Python with Bottle framework</li>
                    <li>Frontend: HTML5, CSS3, JavaScript, SVG</li>
                </ul>
            </div>
        </div>

        <!-- Вкладка Contacts -->
        <div id="contacts" class="tab-content">
            <div class="content-text">
                <h2>Contacts</h2>
                <p>Email: support@graphix.com</p>
                <p>GitHub: github.com/graphix</p>
                <p>Documentation: docs.graphix.com</p>
                <p>Telegram: @graphix_support</p>
            </div>
        </div>

        <!-- Вкладка Feedback -->
        <div id="feedback" class="tab-content">
            <h2>Feedback Form</h2>
            <form action="/feedback" method="POST">
                <div class="form-group">
                    <label for="email">Your Email:</label>
                    <input type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label for="question">Your Question / Feedback:</label>
                    <textarea id="question" name="question" required></textarea>
                </div>

                <button type="submit">Send</button>
            </form>
        </div>
    </div>

    <script>
        var buttons = document.querySelectorAll('.tab-button');
        var contents = document.querySelectorAll('.tab-content');

        function switchTab(tabId) {
            for(var i = 0; i < contents.length; i++) {
                contents[i].classList.remove('active');
            }

            var activeContent = document.getElementById(tabId);
            if(activeContent) {
                activeContent.classList.add('active');
            }

            for(var i = 0; i < buttons.length; i++) {
                buttons[i].classList.remove('active');
                if(buttons[i].getAttribute('data-tab') === tabId) {
                    buttons[i].classList.add('active');
                }
            }
        }

        for(var i = 0; i < buttons.length; i++) {
            buttons[i].addEventListener('click', function() {
                var tabId = this.getAttribute('data-tab');
                switchTab(tabId);
            });
        }
    </script>
</body>
</html>
