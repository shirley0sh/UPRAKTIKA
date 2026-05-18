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
                <!-- Простой заголовок без кнопки перехода -->
                <div class="section-header">
                    <h1 class="section-title">Общая теория графов</h1>
                </div>

                <!-- Вступление в стиле intro как на странице Флойда -->
                <div class="intro">
                    <strong>Теория графов</strong> — раздел дискретной математики, изучающий графы, их свойства и приложения. 
                    Графы являются фундаментальной структурой для моделирования связей между объектами в информатике, логистике, биологии и социальных науках. 
                    На этой странице представлены базовые определения и концепции, необходимые для понимания работы алгоритмов, реализованных в Graphix.
                </div>

                <!-- Содержание в стиле .toc (как на странице Флойда) -->
                <nav>
                    <h3>Содержание</h3>
                    <ul class="toc">
                        <li><a href="#basic-concepts">1. Основные понятия и определения</a></li>
                        <li><a href="#adjacency">2. Смежность, инцидентность, степень вершины</a></li>
                        <li><a href="#walks">3. Маршруты, цепи, циклы</a></li>
                        <li><a href="#distance">4. Расстояние между вершинами. Диаметр графа</a></li>
                        <li><a href="#connectivity">5. Достижимость и связность</a></li>
                        <li><a href="#representations">6. Представление графов в компьютере</a></li>
                        <li><a href="#traversals">7. Обходы графов (DFS, BFS)</a></li>
                        <li><a href="#trees">8. Подграфы, деревья, остовы</a></li>
                        <li><a href="#isomorphism">9. Изоморфизм графов</a></li>
                        <li><a href="#algorithms-overview">10. Связь с алгоритмами Graphix</a></li>
                    </ul>
                </nav>

                <!-- Раздел 1 -->
                <h2 id="basic-concepts">1. Основные понятия и определения</h2>
                <p>Графом <var>G(V, E)</var> называется совокупность двух множеств – непустого множества <var>V</var> (вершин) и множества <var>E</var> (рёбер), представляющих собой двухэлементные подмножества множества <var>V</var>.</p>
                <p>Ориентированным графом (орграфом) называется граф, где рёбра являются упорядоченными парами вершин. Ориентированное ребро называется дугой. В общем случае графы могут содержать петли – рёбра, инцидентные только одной вершине.</p>
                <p>Граф изображается на плоскости в виде множества точек (вершин) и соединяющих их линий (рёбер). Для орграфов на рёбрах стрелками указывается направление.</p>
                
                <div class="note">
                    <strong>Примечание:</strong> В рамках нашего визуального редактора поддерживаются как неориентированные, так и ориентированные графы (для алгоритма Флойда и Дейкстры рёбра имеют направление и вес).
                </div>

                <!-- Раздел 2 -->
                <h2 id="adjacency">2. Смежность, инцидентность, степень вершины</h2>
                <ul>
                    <li>Две вершины называются <strong>смежными</strong>, если они соединены ребром.</li>
                    <li>Ребро <strong>инцидентно</strong> вершине, если оно соединяет эту вершину с другой (или является петлёй).</li>
                    <li><strong>Степенью вершины</strong> называется число рёбер, инцидентных данной вершине.</li>
                    <li>Для ориентированных графов определяются:
                        <ul>
                            <li><strong>полустепень исхода</strong> – число дуг, выходящих из вершины;</li>
                            <li><strong>полустепень захода</strong> – число дуг, входящих в вершину.</li>
                        </ul>
                    </li>
                </ul>
                <p>Вершина нулевой степени называется <strong>изолированной</strong>.</p>
                
                <div class="formula">
                    Σ<sub>v∈V</sub> deg(v) = 2·|E|   (лемма о рукопожатиях)
                </div>

                <!-- Раздел 3 -->
                <h2 id="walks">3. Маршруты, цепи, циклы</h2>
                <p><strong>Маршрутом</strong> в неориентированном графе называется последовательность вершин (<var>v₀, v₁, …, vₖ</var>), где каждые две соседние вершины смежны.</p>
                <ul>
                    <li>Длина маршрута – количество рёбер в нём (<var>k</var>).</li>
                    <li>Если рёбра в маршруте не повторяются, он называется <strong>цепью</strong>.</li>
                    <li>Если вершины в цепи не повторяются – это <strong>простая цепь</strong>.</li>
                    <li>Замкнутый маршрут – маршрут, у которого начало и конец совпадают.</li>
                    <li>Замкнутая цепь называется <strong>циклом</strong>, а замкнутая простая цепь – <strong>простым циклом</strong>.</li>
                </ul>
                <p>Для орграфов аналогично определяются ориентированный маршрут, ориентированная цепь, контур (простой ориентированный цикл).</p>

                <!-- Раздел 4 -->
                <h2 id="distance">4. Расстояние между вершинами. Диаметр графа</h2>
                <p>Длиной маршрута называется количество рёбер в нём.</p>
                <p><strong>Расстоянием</strong> между вершинами <var>u</var> и <var>v</var> (обозначается <var>d(u, v)</var>) называется длина кратчайшей цепи, соединяющей эти вершины. Кратчайшая цепь называется геодезической.</p>
                <p>Если между вершинами не существует цепи, то <var>d(u, v) = +∞</var>.</p>
                <p><strong>Диаметром графа</strong> <var>D(G)</var> называется длина длиннейшей геодезической цепи.</p>
                
                <div class="formula">
                    diam(G) = max{ d(u, v) | u, v ∈ V, u и v достижимы }
                </div>

                <!-- Раздел 5 -->
                <h2 id="connectivity">5. Достижимость и связность</h2>
                <p>Вершина <var>xⱼ</var> называется <strong>достижимой</strong> из вершины <var>xᵢ</var>, если существует путь от <var>xᵢ</var> к <var>xⱼ</var>.</p>
                <p><strong>Компонентой связности</strong> графа называется максимальный связный подграф. Множества вершин различных компонент связности попарно не пересекаются.</p>
                <p>Граф называется <strong>связным</strong>, если он состоит из одной компоненты связности.</p>
                
                <div class="intro">
                    <strong>Важно для алгоритмов:</strong> Алгоритмы Дейкстры, Флойда–Уоршелла и Прима обычно требуют связности графа или корректно обрабатывают недостижимые вершины (расстояние = ∞).
                </div>

                <!-- Раздел 6 -->
                <h2 id="representations">6. Представление графов в компьютере</h2>
                <p>Для хранения графов в памяти компьютера используются различные структуры данных. Выбор конкретного представления зависит от требуемой эффективности операций и объёма доступной памяти.</p>
                
                <h3>6.1. Матрица смежности</h3>
                <p>Квадратная булева матрица <var>M</var> размера <var>p × p</var>, где <var>p</var> – число вершин. Для неориентированных графов матрица смежности симметрична относительно главной диагонали.</p>
                
                <h3>6.2. Матрица инциденций</h3>
                <p>Прямоугольная матрица размера <var>p × q</var>, где <var>q</var> – число рёбер. Для неориентированного графа строится по правилу инцидентности вершин и рёбер.</p>
                
                <h3>6.3. Списки смежности</h3>
                <p>Массив указателей на списки вершин, смежных с данной. Экономит память при представлении разреженных графов.</p>
                
                <h3>6.4. Массив рёбер (дуг)</h3>
                <p>Массив структур, каждая из которых содержит пару смежных вершин. Удобен для алгоритмов, работающих с рёбрами (например, алгоритм Краскала).</p>

                <!-- Раздел 7 -->
                <h2 id="traversals">7. Обходы графов</h2>
                <p>Обход графа – систематическое перечисление его вершин и/или рёбер. Наиболее известны два типа обхода.</p>
                
                <h3>7.1. Поиск в глубину (Depth-First Search, DFS)</h3>
                <p>Использует стек (LIFO). Алгоритм: из текущей вершины переходим к первой непосещённой смежной вершине и повторяем. Если тупик – возвращаемся назад.</p>
                
                <h3>7.2. Поиск в ширину (Breadth-First Search, BFS)</h3>
                <p>Использует очередь (FIFO). Алгоритм: сначала посещаем все вершины, смежные с начальной, затем вершины, смежные с ними, и так далее.</p>
                <p>Оба алгоритма лежат в основе многих конкретных алгоритмов на графах.</p>
                
                <div class="note">
                    <strong>Сложность:</strong> O(|V| + |E|) при использовании списков смежности как для BFS, так и для DFS.
                </div>

                <!-- Раздел 8 -->
                <h2 id="trees">8. Подграфы, деревья, остовы</h2>
                <p><strong>Суграф</strong> – часть графа, определённая на всём множестве вершин исходного графа.</p>
                <p><strong>Подграф</strong> задаётся только подмножеством вершин, а рёбрами являются все рёбра исходного графа с обоими концами в этом подмножестве.</p>
                <p><strong>Дерево</strong> – связный ациклический граф.</p>
                <p><strong>Остовным деревом (остовом)</strong> графа <var>G</var> называется связный ациклический суграф, содержащий все вершины <var>G</var>. Для графа может существовать несколько остовов; минимальный по сумме весов рёбер называется минимальным остовным деревом.</p>
                
                <div class="formula">
                    MST (Minimum Spanning Tree) — задача, решаемая алгоритмами Прима и Краскала.
                </div>

                <!-- Раздел 9 -->
                <h2 id="isomorphism">9. Изоморфизм графов</h2>
                <p>Два графа <var>G₁(V₁, E₁)</var> и <var>G₂(V₂, E₂)</var> называются изоморфными, если существует биекция <var>φ: V₁ → V₂</var>, сохраняющая смежность (для орграфов – с учётом направления дуг). Изоморфные графы не различаются по своей структуре – достаточно перенумеровать вершины, чтобы они полностью совпали.</p>
                
                <div class="note">
                    Задача проверки изоморфизма графов — важная теоретическая проблема, для которой не известен полиномиальный алгоритм в общем случае (класс GI).
                </div>

                <!-- Раздел 10 -->
                <h2 id="algorithms-overview">10. Связь с алгоритмами Graphix</h2>
                <p>На платформе <strong>Graphix</strong> реализованы ключевые алгоритмы, основанные на описанной теории:</p>
                <ul>
                    <li><strong>Алгоритм Флойда–Уоршелла</strong> — находит кратчайшие расстояния между всеми парами вершин (динамическое программирование, <span class="complexity">O(n³)</span>). Полезен для плотных графов и анализа достижимости.</li>
                    <li><strong>Алгоритм Дейкстры</strong> — эффективно вычисляет кратчайшие пути от одной вершины до всех остальных (<span class="complexity">O(|E|·log|V|)</span> с приоритетной очередью). Работает только с неотрицательными весами.</li>
                    <li><strong>Алгоритм Прима</strong> — строит минимальное остовное дерево для взвешенного неориентированного графа, последовательно добавляя вершины.</li>
                    <li><strong>Алгоритм Краскала</strong> — альтернативный метод построения MST, основанный на добавлении рёбер минимального веса с использованием системы непересекающихся множеств (DSU).</li>
                </ul>
                <p>Понимание базовых понятий (смежность, степень, маршруты, циклы, связность) необходимо для корректного использования визуального редактора и интерпретации результатов.</p>

                <!-- Футер с источниками в стиле .intro (как на странице Флойда) -->
                <hr>
                <div class="intro">
                    <strong>📚 Источники для дальнейшего изучения:</strong>
                    <ul style="margin: 10px 0 0 0; padding-left: 20px;">
                        <li>Cormen T., Leiserson C., Rivest R., Stein C. — "Алгоритмы: построение и анализ" (главы 22–25).</li>
                        <li>Харари Ф. — "Теория графов".</li>
                        <li>Доступные онлайн-курсы: "Алгоритмы на графах" (Coursera, Stepik).</li>
                    </ul>
                </div>
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
	
	
<!-- Вкладка Краскала — только содержимое .tab-content -->
    <div id="kruskal" class="tab-content active">
    <div class="content-text">
        <!-- Заголовок с кнопкой перехода в редактор -->
        <div class="section-header">
            <h1 class="section-title">Алгоритм Краскала</h1>
            <a href="/kruskal" class="forward-btn" title="Открыть редактор">></a>
        </div>

        <!-- Вступление -->
        <div class="intro">
            <strong>Алгоритм Краскала</strong> (также алгоритм Крускала) — эффективный алгоритм построения минимального остовного дерева взвешенного связного неориентированного графа. Также применяется для нахождения некоторых приближённых решений задачи Штейнера.
            <br><br>
            Алгоритм был описан Джозефом Краскалом в 1956 году. Он практически не отличается от более раннего алгоритма Борувки, предложенного Отакаром Борувкой ещё в 1926 году.
            <br><br>
            <strong>Сложность:</strong>
            Время — <span class="complexity">O(|E|·log|E|)</span> (сортировка рёбер + DSU),
            Память — <span class="complexity">O(|V| + |E|)</span>.
        </div>

        <!-- Содержание -->
        <nav>
            <h3>Содержание</h3>
            <ul class="toc">
                <li><a href="#kruskal-formulation">1. Формулировка алгоритма</a></li>
                <li><a href="#kruskal-complexity">2. Оценка сложности</a></li>
                <li><a href="#kruskal-proof">3. Доказательство корректности</a></li>
                <li><a href="#kruskal-example">4. Пример работы</a></li>
                <li><a href="#kruskal-code">5. Реализация на псевдокоде</a></li>
                <li><a href="#kruskal-comparison">6. Сравнение с алгоритмом Прима</a></li>
                <li><a href="#kruskal-applications">7. Области применения</a></li>
            </ul>
        </nav>

        <!-- Раздел 1 - Формулировка (исправленные отступы) -->
        <h2 id="kruskal-formulation">1. Формулировка алгоритма</h2>
        <p>В начале работы текущее множество выбранных рёбер устанавливается пустым. Затем, пока это возможно, выполняется следующая операция:</p>
        <ol style="margin-left: 25px; margin-bottom: 15px;">
            <li style="margin-bottom: 8px;">Из всех рёбер, добавление которых к уже имеющемуся множеству <strong>не вызовет появления цикла</strong>, выбирается ребро с минимальным весом.</li>
            <li style="margin-bottom: 8px;">Выбранное ребро добавляется к текущему множеству.</li>
            <li style="margin-bottom: 8px;">Когда рёбер, удовлетворяющих условию, больше не остаётся, алгоритм завершается.</li>
        </ol>
        <p>Подграф исходного графа, содержащий все его вершины и найденное множество рёбер, является <strong>остовным деревом минимального веса</strong>.</p>
        
        <div class="note">
            <strong>Ключевая идея:</strong> жадно добавлять рёбра в порядке возрастания веса, пропуская те, которые создают циклы.
        </div>

        <!-- Раздел 2 -->
        <h2 id="kruskal-complexity">2. Оценка сложности</h2>
        <ul style="margin-left: 25px; margin-bottom: 15px;">
            <li style="margin-bottom: 8px;"><strong>Сортировка рёбер:</strong> перед началом работы рёбра необходимо отсортировать по весу. Это требует <var>O(E × log E)</var> времени.</li>
            <li style="margin-bottom: 8px;"><strong>Хранение компонент связности:</strong> удобно использовать систему непересекающихся множеств (DSU).</li>
            <li style="margin-bottom: 8px;"><strong>Обработка рёбер:</strong> все операции объединения и поиска займут <var>O(E × α(E, V))</var>, где <var>α</var> — функция, обратная функции Аккермана.</li>
            <li style="margin-bottom: 8px;">Поскольку для любых практических размеров графов <var>α(E, V) &lt; 5</var>, её можно считать константой.</li>
        </ul>
        <p>Таким образом, общее время работы алгоритма Краскала оценивается как <code>O(E × log E)</code>.</p>

        <div class="formula">
            T(Kruskal) = O(|E|·log|E|) + O(|E|·α(|V|)) ≈ O(|E|·log|E|)
        </div>

        <!-- Раздел 3 -->
        <h2 id="kruskal-proof">3. Доказательство корректности</h2>
        <p>Алгоритм Краскала действительно находит остовное дерево минимального веса, так как он является частным случаем <strong>алгоритма Радо — Эдмондса</strong> для графического матроида. В данном контексте независимыми множествами выступают ациклические множества рёбер.</p>
        <div class="proof">
            <strong>Краткое доказательство:</strong> Пусть алгоритм выбрал рёбра e₁, e₂, ..., e_{n-1} в порядке возрастания веса. Предположим, существует минимальное остовное дерево T*, отличное от построенного. Рассмотрим первое ребро eᵢ, которое есть в построенном дереве, но отсутствует в T*. Замена даст дерево не большего веса — противоречие.
        </div>

        <!-- Раздел 4 - Пример работы -->
        <h2 id="kruskal-example">4. Пример работы</h2>
        <p>Рассмотрим граф из 7 вершин (A, B, C, D, E, F, G):</p>
        
        <div class="note" style="margin-bottom: 12px;">
            <strong>Шаг 1.</strong> Рёбра <code>AD (5)</code> и <code>CE (5)</code> имеют минимальный вес. Выбираем <code>AD (5)</code>. Множество: <code>{A, D}</code>.
        </div>
        <div class="note" style="margin-bottom: 12px;">
            <strong>Шаг 2.</strong> Выбираем <code>CE (5)</code>. Множество: <code>{C, E}</code>.
        </div>
        <div class="note" style="margin-bottom: 12px;">
            <strong>Шаг 3.</strong> Выбираем <code>DF (6)</code>. Множество: <code>{A, D, F}</code>.
        </div>
        <div class="note" style="margin-bottom: 12px;">
            <strong>Шаг 4.</strong> Выбираем <code>AB (7)</code>. Множество: <code>{A, B, D, F}</code>.
        </div>
        <div class="note" style="margin-bottom: 12px;">
            <strong>Шаг 5.</strong> Выбираем <code>BE (7)</code>. Объединяем множества: <code>{A, B, C, D, E, F}</code>.
        </div>
        <div class="note" style="margin-bottom: 12px;">
            <strong>Шаг 6.</strong> Добавляем <code>EG (9)</code>. Минимальное остовное дерево построено.
        </div>

        <div class="intro">
            <strong>Примечание:</strong> Визуальное представление шагов будет доступно в интерактивном редакторе.
        </div>

        <!-- Раздел 5 - Реализация -->
        <h2 id="kruskal-code">5. Реализация на псевдокоде</h2>
        <pre><code><span class="keyword">function</span> <span class="function">kruskal</span>(graph):
    <span class="comment">// 1. Сортировка всех рёбер по весу</span>
    edges = sort(graph.edges, key=weight)
    
    <span class="comment">// 2. Инициализация DSU</span>
    dsu = DisjointSetUnion(graph.vertices)
    
    <span class="comment">// 3. Построение MST</span>
    mst = []
    total_weight = 0
    
    <span class="keyword">for</span> edge <span class="keyword">in</span> edges:
        <span class="keyword">if</span> dsu.find(edge.u) != dsu.find(edge.v):
            dsu.union(edge.u, edge.v)
            mst.append(edge)
            total_weight += edge.weight
            <span class="keyword">if</span> len(mst) == n - 1:
                <span class="keyword">break</span>
    
    <span class="keyword">return</span> mst, total_weight</code></pre>

        <!-- Раздел 6 - Сравнение -->
        <h2 id="kruskal-comparison">6. Сравнение с алгоритмом Прима</h2>
        <div class="matrix" style="text-align: left; white-space: normal; line-height: 1.8;">
            <strong>Алгоритм Краскала:</strong> "Лес" — добавляет рёбра, объединяя деревья. DSU. O(|E|·log|E|). Лучше для разреженных графов.<br><br>
            <strong>Алгоритм Прима:</strong> "Растущее дерево" — добавляет вершины. Куча. O(|E|·log|V|). Лучше для плотных графов.
        </div>

        <!-- Раздел 7 - Применения -->
        <h2 id="kruskal-applications">7. Области применения</h2>
        <ul style="margin-left: 25px; margin-bottom: 15px;">
            <li style="margin-bottom: 8px;"><strong>Телекоммуникации:</strong> проектирование минимальных сетей связи.</li>
            <li style="margin-bottom: 8px;"><strong>Транспорт:</strong> прокладка дорог, железнодорожных путей.</li>
            <li style="margin-bottom: 8px;"><strong>Электроэнергетика:</strong> построение электрических сетей.</li>
            <li style="margin-bottom: 8px;"><strong>Компьютерные сети:</strong> протоколы STP.</li>
            <li style="margin-bottom: 8px;"><strong>Кластеризация:</strong> выделение связных компонент.</li>
        </ul>

        <!-- Футер -->
        <hr>
        <div class="intro">
            <strong>Источники:</strong>
            <ul style="margin: 10px 0 0 0; padding-left: 20px;">
                <li>Kruskal J.B. (1956). "On the shortest spanning subtree of a graph"</li>
                <li>Cormen T. и др. — "Алгоритмы: построение и анализ" (глава 23)</li>
            </ul>
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
