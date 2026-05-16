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
                <h2>Welcome to Graphix</h2>
                <p>Graphix is a powerful graph theory visualization tool that allows you to create, edit, and analyze graphs using various algorithms.</p>

                <h3>Available Algorithms:</h3>
                <ul>
                    <li><strong>Floyd-Warshall</strong> - Finds shortest paths between all pairs of vertices</li>
                    <li><strong>Dijkstra</strong> - Finds shortest paths from a single source vertex</li>
                    <li><strong>Алгоритм Прима</strong> - Используется для нахождения кратчайшего остова</li>
                    <li><strong>Kruskal</strong> - Finds Minimum Spanning Tree (Coming Soon)</li>
                </ul>

                <h3>How to use the Graph Editor:</h3>
                <ul>
                    <li>Go to any algorithm tab to access the interactive graph editor</li>
                    <li>Drag "Add Point" button to canvas to create vertices</li>
                    <li>Click on a vertex, then click on another to create an edge</li>
                    <li>Double-click on an edge to set custom distance</li>
                    <li>Drag vertices to move them</li>
                    <li>Click on an edge and press Delete to remove it</li>
                    <li>Double-click on a vertex to delete it</li>
                    <li>Use Random Distance Generator to assign random weights to all edges</li>
                </ul>

                <h3>Features:</h3>
                <ul>
                    <li>Interactive graph editor with drag-and-drop interface</li>
                    <li>Real-time visualization</li>
                    <li>Random distance generation</li>
                    <li>Shortest path visualization</li>
                </ul>
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

        <!-- Вкладка Алгоритм Прима -->
        <div id="prim" class="tab-content">
            <div class="content-text">
                <h2>Алгоритм Прима</h2>
                <div class="algorithm-description">
    <div class="description-header">
        
        <h3>Принцип работы алгоритма Прима</h3>
    </div>
    
    <p><strong>Алгоритм Прима</strong> – метод построения минимального остовного дерева (Minimum Spanning Tree) для связного взвешенного неориентированного графа. Остовное дерево соединяет все вершины графа без циклов и обладает минимальной суммой весов рёбер.</p>
    
    <div class="description-section">
        <h4>Алгоритм пошагово</h4>
        <ol>
            <li>Выбрать произвольную начальную вершину и включить её в остовное дерево.</li>
            <li>Из всех рёбер, соединяющих вершины дерева с вершинами вне дерева, выбрать ребро с минимальным весом.</li>
            <li>Добавить выбранное ребро и новую вершину в дерево.</li>
            <li>Повторять шаги 2-3, пока все вершины не окажутся в деревеd.</li>
        </ol>
    </div>

    <div class="description-section">
        <h4>Область применения</h4>
        <p>Проектирование сетей связи, прокладка дорог, создание электрических сетей, построение маршрутов в логистике – везде, где требуется связать все узлы с минимальными затратами.</p>
    </div>

    <div class="description-note">
        <strong>Важно:</strong> алгоритм работает только для связных графов и всегда находит глобально оптимальное решение.
    </div>
</div>
                <button disabled style="margin-top: 15px; opacity: 0.5;">Coming Soon</button>
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
