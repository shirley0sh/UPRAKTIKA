<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Graphix - Graph Theory</title>
    <!-- Подключаем внешний CSS -->
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <!-- Шапка с табами -->
    <header class="header">
        <div class="header-content">
            <div class="logo">Graphix</div>
            <nav class="tabs">
                <button class="tab-button active" data-tab="home">Home</button>
                <button class="tab-button" data-tab="floyd">Floyd-Warshall</button>
                <button class="tab-button" data-tab="dijkstra">Dijkstra</button>
                <button class="tab-button" data-tab="bellman">Bellman-Ford</button>
                <button class="tab-button" data-tab="kruskal">Kruskal</button>
                <button class="tab-button" data-tab="about">About</button>
                <button class="tab-button" data-tab="contacts">Contacts</button>
                <button class="tab-button" data-tab="feedback">Feedback</button>
            </nav>
        </div>
    </header>

    <!-- Основной контент -->
    <main class="main-content">
        <!-- Вкладка Home -->
        <section id="home" class="tab-content active">
            <div class="content-text">
                <h2>Welcome to Graphix</h2>
                <p>Graphix is a powerful graph theory visualization tool that allows you to create, edit, and analyze graphs using various algorithms.</p>

                <h3>Available Algorithms:</h3>
                <ul>
                    <li><strong>Floyd-Warshall</strong> - Finds shortest paths between all pairs of vertices</li>
                    <li><strong>Dijkstra</strong> - Finds shortest paths from a single source vertex</li>
                    <li><strong>Bellman-Ford</strong> - Finds shortest paths with negative weights (Coming Soon)</li>
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
        </section>

        <!-- Вкладка Floyd-Warshall -->
        <section id="floyd" class="tab-content">
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

                <h2 id="example">5. Пример работы</h2>
                <p>Исходная матрица весов (<code>∞</code> — нет ребра):</p>
                <div class="matrix">
                [ ×   ∞   ∞   ∞ ]<br>
                [ 1   ×   ∞   ∞ ]<br>
                [ 6   4   ×   1 ]<br>
                [ ∞   1   ∞   × ]
                </div>

                <h2 id="path-reconstruction">6. Восстановление кратчайшего пути</h2>
                <pre><code><span class="function">func</span> <span class="function">get_path</span>(u, v, next):
    <span class="keyword">if</span> d[u][v] == ∞:
        <span class="keyword">return</span> <span class="string">"No path"</span>
    path = [u]
    <span class="keyword">while</span> u != v:
        u = next[u][v]
        <span class="keyword">if</span> u <span class="keyword">is</span> None: <span class="keyword">return</span> <span class="string">"No path"</span>
        path.append(u)
    <span class="keyword">return</span> path</code></pre>

                <hr>
                <div class="intro">
                    <strong>Источники:</strong>
                    <ul style="margin: 10px 0 0 0; padding-left: 20px;">
                        <li>Cormen T., Leiserson C., Rivest R. — "Алгоритмы: построение и анализ"</li>
                        <li>Floyd R.W. (1962). "Algorithm 97: Shortest Path". Communications of the ACM</li>
                    </ul>
                </div>
            </div>
        </section>

        <!-- Вкладка Dijkstra -->
        <section id="dijkstra" class="tab-content">
            <div class="content-text">
                <h2>Dijkstra's Algorithm</h2>
                <p>Finds shortest paths from a single source vertex to all other vertices.</p>
                <button onclick="window.location.href='/dijkstra-editor'" class="editor-btn">Open Dijkstra Editor</button>
            </div>
        </section>

        <!-- Вкладка Bellman-Ford -->
        <section id="bellman" class="tab-content">
            <div class="content-text">
                <h2>Bellman-Ford Algorithm</h2>
                <p>Coming soon! Handles negative edge weights.</p>
                <button disabled class="editor-btn" style="opacity:0.5;cursor:not-allowed;">Coming Soon</button>
            </div>
        </section>

        <!-- Вкладка Kruskal -->
        <section id="kruskal" class="tab-content">
            <div class="content-text">
                <h2>Kruskal's Algorithm</h2>
                <p>Coming soon! Finds Minimum Spanning Tree (MST).</p>
                <button disabled class="editor-btn" style="opacity:0.5;cursor:not-allowed;">Coming Soon</button>
            </div>
        </section>

        <!-- Вкладка About -->
        <section id="about" class="tab-content">
            <div class="content-text">
                <h2>About Graphix</h2>
                <p>Educational graph theory visualization tool.</p>
                <h3>Technologies:</h3>
                <ul>
                    <li>Backend: Python + Bottle</li>
                    <li>Frontend: HTML5, CSS3, Vanilla JS, SVG</li>
                </ul>
            </div>
        </section>

        <!-- Вкладка Contacts -->
        <section id="contacts" class="tab-content">
            <div class="content-text">
                <h2>Contacts</h2>
                <p>Email: support@graphix.com</p>
                <p>GitHub: github.com/graphix</p>
                <p>Telegram: @graphix_support</p>
            </div>
        </section>

        <!-- Вкладка Feedback -->
        <section id="feedback" class="tab-content">
            <div class="content-text">
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
        </section>
    </main>

    <!-- Скрипт переключения табов -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const tabButtons = document.querySelectorAll('.tab-button');
            const tabContents = document.querySelectorAll('.tab-content');

            function activateTab(tabId) {
                // Скрываем все вкладки
                tabContents.forEach(content => content.classList.remove('active'));
                // Убираем активный класс у всех кнопок
                tabButtons.forEach(btn => btn.classList.remove('active'));

                // Показываем нужную вкладку
                const targetContent = document.getElementById(tabId);
                if (targetContent) {
                    targetContent.classList.add('active');
                }

                // Делаем кнопку активной
                const targetBtn = document.querySelector(`.tab-button[data-tab="${tabId}"]`);
                if (targetBtn) {
                    targetBtn.classList.add('active');
                }
            }

            // Навешиваем обработчики
            tabButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const tabId = this.getAttribute('data-tab');
                    activateTab(tabId);
                });
            });
        });
    </script>
</body>
</html>
