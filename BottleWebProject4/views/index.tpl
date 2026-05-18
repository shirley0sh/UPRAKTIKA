<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Graphix - Graph Theory</title>
    <!-- Подключение внешнего CSS-файла -->
    <link rel="stylesheet" href="/static/style.css">
</head>
<body>
    <!-- Шапка с табами -->
    <header class="header">
        <div class="header-content">
            <div class="logo">Graphix</div>
            <nav class="tabs">
                <button class="tab-button active" data-tab="home">Home</button>
                <button class="tab-button" data-tab="floyd">Флойда</button>
                <button class="tab-button" data-tab="dijkstra">Dijkstra</button>
                <button class="tab-button" data-tab="prim">Алгоритм Прима</button>
                <button class="tab-button" data-tab="kruskal">Kruskal</button>
                <button class="tab-button" data-tab="about">About</button>
                <button class="tab-button" data-tab="contacts">Contacts</button>
                <button class="tab-button" data-tab="feedback">Feedback</button>
            </nav>
        </div>
    </header>

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

        <!-- Вкладка Floyd-Warshall -->
        <div id="floyd" class="tab-content">
            <div class="content-text">
                <div class="section-header">
                    <h1 class="section-title">Алгоритм Флойда–Уоршелла</h1>
                    <a href="/floyd" class="forward-btn" title="Открыть редактор">></a>
                </div>

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
        </div>

        <!-- Вкладка Dijkstra -->
        <div id="dijkstra" class="tab-content">
            <div class="content-text">
                <div class="section-header">
                    <h1 class="section-title">Алгоритм Дейкстры</h1>
                    <a href="/dijkstra" class="forward-btn" title="Открыть редактор">></a>
                </div>

                <div class="intro">
                    <strong>Алгоритм Дейкстры</strong> — алгоритм нахождения кратчайших путей от одной вершины до всех остальных во взвешенном графе с неотрицательными весами рёбер.
                    <br><br>
                    <strong>Сложность:</strong>
                    Время — <span class="complexity">O(|E|·log|V|)</span> (с двоичной кучей),
                    Память — <span class="complexity">O(|V| + |E|)</span>.
                    <br>Разработан в 1959 году Эдсгером Дейкстрой.
                </div>

                <h2>Описание алгоритма</h2>
                <p>Алгоритм работает следующим образом:</p>
                <ul>
                    <li>Начальной вершине присваивается расстояние 0, всем остальным — бесконечность</li>
                    <li>На каждом шаге выбирается непосещённая вершина с наименьшим расстоянием</li>
                    <li>Для выбранной вершины рассматриваются все соседние вершины и обновляются расстояния до них</li>
                    <li>Алгоритм завершается, когда все вершины посещены</li>
                </ul>

                <pre><code><span class="function">func</span> <span class="function">dijkstra</span>(graph, start):
    distances = [∞] * n
    distances[start] = 0
    visited = [False] * n

    <span class="keyword">for</span> _ <span class="keyword">in</span> range(n):
        u = <span class="function">find_min_unvisited</span>(distances, visited)
        visited[u] = True

        <span class="keyword">for</span> v, weight <span class="keyword">in</span> graph[u]:
            <span class="keyword">if</span> <span class="keyword">not</span> visited[v]:
                new_dist = distances[u] + weight
                <span class="keyword">if</span> new_dist < distances[v]:
                    distances[v] = new_dist

    <span class="keyword">return</span> distances</code></pre>

                <h2>Применение</h2>
                <ul>
                    <li>Навигационные системы (GPS)</li>
                    <li>Маршрутизация в компьютерных сетях (OSPF)</li>
                    <li>Поиск оптимальных путей в транспортных сетях</li>
                </ul>

                <div class="note">
                    <strong>Важно:</strong> Алгоритм Дейкстры не работает с рёбрами отрицательного веса. Для таких случаев используется алгоритм Беллмана-Форда.
                </div>
            </div>
        </div>

        <!-- Вкладка Prim -->
        <div id="prim" class="tab-content">
            <div class="content-text">
                <div class="section-header">
                    <h1 class="section-title">Алгоритм Прима</h1>
                    <a href="/prim" class="forward-btn" title="Открыть редактор">></a>
                </div>

                <div class="intro">
                    <strong>Алгоритм Прима</strong> — алгоритм построения минимального остовного дерева (Minimum Spanning Tree, MST) для связного взвешенного неориентированного графа.
                    Он находит подграф, который соединяет все вершины графа, не содержит циклов и имеет минимально возможную сумму весов рёбер.
                    <br><br>
                    <strong>Сложность:</strong>
                    Время — <span class="complexity">O(|E|·log|V|)</span> (с бинарной кучей),
                    Память — <span class="complexity">O(|V| + |E|)</span>.
                    <br>Разработан в 1957 году Робертом Примом.
                </div>

                <h2>Описание алгоритма</h2>
                <p>Алгоритм Прима относится к классу <strong>жадных алгоритмов</strong>. На каждом шаге он добавляет к текущему дереву ребро минимального веса, соединяющее дерево с новой вершиной.</p>

                <p><strong>Основная идея:</strong></p>
                <ul>
                    <li>Выбрать произвольную стартовую вершину <code>s</code> и включить её в дерево <code>T</code>.</li>
                    <li>Поддерживать множество вершин <code>U</code>, уже включённых в дерево.</li>
                    <li>На каждом шаге выбирать ребро <code>(u, v)</code> минимального веса, где <code>u ∈ U</code>, <code>v ∉ U</code>.</li>
                    <li>Добавлять вершину <code>v</code> в <code>U</code>, а ребро <code>(u, v)</code> — в <code>T</code>.</li>
                    <li>Повторять, пока <code>U ≠ V</code>.</li>
                </ul>

                <pre><code><span class="function">func</span> <span class="function">prim</span>(graph, n):
    visited = [False] * n
    key = [∞] * n
    parent = [-1] * n
    key[0] = 0

    <span class="keyword">for</span> _ <span class="keyword">in</span> range(n):
        u = <span class="function">find_min_key</span>(key, visited)
        visited[u] = True

        <span class="keyword">for</span> v <span class="keyword">in</span> range(n):
            <span class="keyword">if</span> graph[u][v] != 0 <span class="keyword">and</span> <span class="keyword">not</span> visited[v] <span class="keyword">and</span> graph[u][v] < key[v]:
                key[v] = graph[u][v]
                parent[v] = u

    <span class="keyword">return</span> parent, sum(key)</code></pre>

                <h2>Сравнение с алгоритмом Краскала</h2>
                <table class="comparison-table">
                    <thead>
                        <tr>
                            <th>Характеристика</th>
                            <th>Алгоритм Прима</th>
                            <th>Алгоритм Краскала</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Подход</td>
                            <td>"Растущее дерево" — добавляет вершины</td>
                            <td>"Лес" — добавляет рёбра, объединяя деревья</td>
                        </tr>
                        <tr>
                            <td>Структура данных</td>
                            <td>Куча (приоритетная очередь)</td>
                            <td>Система непересекающихся множеств (DSU)</td>
                        </tr>
                        <tr>
                            <td>Сложность</td>
                            <td>O(|E|·log|V|)</td>
                            <td>O(|E|·log|E|)</td>
                        </tr>
                        <tr>
                            <td>Когда лучше</td>
                            <td>Плотные графы (|E| ≈ |V|²)</td>
                            <td>Разреженные графы (|E| ≈ |V|)</td>
                        </tr>
                    </tbody>
                </table>

                <h2>Области применения</h2>
                <ul>
                    <li><strong>Телекоммуникации:</strong> проектирование минимальных сетей связи</li>
                    <li><strong>Транспорт:</strong> прокладка дорог, железнодорожных путей</li>
                    <li><strong>Электроэнергетика:</strong> построение электрических сетей минимальной стоимости</li>
                    <li><strong>Компьютерные сети:</strong> протокол STP (Spanning Tree Protocol)</li>
                </ul>
            </div>
        </div>

        <!-- Вкладка Kruskal -->
        <div id="kruskal" class="tab-content">
            <div class="content-text">
                <div class="section-header">
                    <h1 class="section-title">Алгоритм Краскала</h1>
                    <button class="forward-btn" disabled style="opacity:0.5; cursor:not-allowed;">></button>
                </div>

                <div class="intro">
                    <strong>Алгоритм Краскала</strong> — алгоритм построения минимального остовного дерева (MST) для связного взвешенного неориентированного графа.
                    В отличие от алгоритма Прима, он работает с рёбрами, сортируя их по весу и добавляя в MST, если они не создают цикл.
                    <br><br>
                    <strong>Сложность:</strong>
                    Время — <span class="complexity">O(|E|·log|E|)</span> (сортировка рёбер),
                    Память — <span class="complexity">O(|V| + |E|)</span>.
                    <br>Разработан в 1956 году Джозефом Краскалом.
                </div>

                <div class="note" style="text-align: center; background: rgba(155, 142, 162, 0.5);">
                    <strong>🚧 В разработке 🚧</strong><br>
                    Редактор с визуализацией алгоритма Краскала появится в следующем обновлении!
                </div>

                <h2>Описание алгоритма</h2>
                <p>Алгоритм Краскала следует жадной стратегии:</p>
                <ul>
                    <li>Отсортировать все рёбра графа по возрастанию веса</li>
                    <li>Инициализировать лес, где каждая вершина — отдельное дерево</li>
                    <li>Проходить по рёбрам в отсортированном порядке</li>
                    <li>Если ребро соединяет вершины из разных деревьев — добавить его в MST</li>
                    <li>Если вершины уже в одном дереве — пропустить ребро (иначе образуется цикл)</li>
                    <li>Повторять, пока в MST не будет (|V|-1) рёбер</li>
                </ul>

                <pre><code><span class="function">func</span> <span class="function">kruskal</span>(edges, n):
    <span class="comment">// Сортировка рёбер по весу</span>
    sort(edges, key=<span class="keyword">lambda</span> e: e.weight)

    dsu = <span class="function">DisjointSet</span>(n)  <span class="comment">// Система непересекающихся множеств</span>
    mst = []
    total_weight = 0

    <span class="keyword">for</span> edge <span class="keyword">in</span> edges:
        <span class="keyword">if</span> dsu.<span class="function">find</span>(edge.u) != dsu.<span class="function">find</span>(edge.v):
            dsu.<span class="function">union</span>(edge.u, edge.v)
            mst.append(edge)
            total_weight += edge.weight

            <span class="keyword">if</span> len(mst) == n - 1:
                <span class="keyword">break</span>

    <span class="keyword">return</span> mst, total_weight</code></pre>

                <h2>Применение</h2>
                <ul>
                    <li>Проектирование сетей связи и электропередач</li>
                    <li>Кластеризация данных</li>
                    <li>Приближённое решение задачи коммивояжёра</li>
                </ul>
            </div>
        </div>

        <!-- Вкладка About -->
        <div id="about" class="tab-content">
            <div class="content-text">
                <h2>About Graphix</h2>
                <p>Educational graph theory visualization tool.</p>
                <h3>Technologies:</h3>
                <ul>
                    <li>Backend: Python + Bottle</li>
                    <li>Frontend: HTML5, CSS3, Vanilla JS, SVG</li>
                </ul>
                <h3>Features:</h3>
                <ul>
                    <li>Interactive graph editor with drag & drop</li>
                    <li>Real-time visualization of algorithms</li>
                    <li>Step-by-step execution mode</li>
                    <li>Random graph generation</li>
                </ul>
            </div>
        </div>

        <!-- Вкладка Contacts -->
        <div id="contacts" class="tab-content">
            <div class="content-text">
                <h2>Contacts</h2>
                <p>Email: support@graphix.com</p>
                <p>GitHub: github.com/graphix</p>
                <p>Telegram: @graphix_support</p>
                <p>Discord: discord.gg/graphix</p>
                <p>Twitter: @graphix_app</p>
            </div>
        </div>

        <!-- Вкладка Feedback -->
        <div id="feedback" class="tab-content">
            <div class="content-text">
                <h2>Feedback Form</h2>
                <form action="/feedback" method="POST">
                    <div class="form-group">
                        <label for="email">Your Email:</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    <div class="form-group">
                        <label for="question">Your Question / Feedback:</label>
                        <textarea id="question" name="question" required placeholder="Tell us what you think..."></textarea>
                    </div>
                    <button type="submit">Send Feedback</button>
                </form>
            </div>
        </div>

    </div>

    <!-- Скрипт переключения табов - ПЛАВНАЯ АНИМАЦИЯ -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const tabButtons = document.querySelectorAll('.tab-button');
            const tabContents = document.querySelectorAll('.tab-content');

            const tabOrder = Array.from(tabButtons).map(btn => btn.dataset.tab);
            let currentTabId = 'home';
            let isAnimating = false;

            function getDirection(fromTab, toTab) {
                const fromIndex = tabOrder.indexOf(fromTab);
                const toIndex = tabOrder.indexOf(toTab);
                if (fromIndex === -1 || toIndex === -1) return 'right';
                return toIndex > fromIndex ? 'right' : 'left';
            }

            function activateTab(targetTabId) {
                if (isAnimating) return;
                if (targetTabId === currentTabId) return;

                const currentContent = document.getElementById(currentTabId);
                const targetContent = document.getElementById(targetTabId);

                if (!currentContent || !targetContent) return;

                const direction = getDirection(currentTabId, targetTabId);
                isAnimating = true;

                tabButtons.forEach(btn => {
                    btn.classList.toggle('active', btn.dataset.tab === targetTabId);
                });

                const exitClass = direction === 'right' ? 'animate-out-left' : 'animate-out-right';
                currentContent.classList.add(exitClass);

                setTimeout(() => {
                    currentContent.classList.remove('active', exitClass);
                    currentContent.style.display = 'none';

                    targetContent.style.display = 'block';

                    const enterClass = direction === 'right' ? 'animate-in-right' : 'animate-in-left';
                    targetContent.classList.add(enterClass);

                    setTimeout(() => {
                        targetContent.classList.add('active');
                        setTimeout(() => {
                            targetContent.classList.remove(enterClass);
                            isAnimating = false;
                        }, 350);
                    }, 10);

                    currentTabId = targetTabId;
                }, 350);
            }

            tabButtons.forEach(btn => {
                btn.addEventListener('click', (e) => {
                    e.preventDefault();
                    const tabId = btn.dataset.tab;
                    if (tabId && !isAnimating) {
                        activateTab(tabId);
                    }
                });
            });

            tabContents.forEach(content => {
                if (!content.classList.contains('active')) {
                    content.style.display = 'none';
                } else {
                    currentTabId = content.id;
                }
            });
        });
    </script>
</body>
</html>
