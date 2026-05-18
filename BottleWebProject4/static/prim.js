// prim.js - ПОЛНОСТЬЮ РАБОЧАЯ ВЕРСИЯ С МАТРИЦЕЙ ВЕСОВ
let points = [];
let selectedPointId = null;
let edgeStartVertex = null;
let pointsLayer = null;
let linesSvg = null;
let draggedPoint = null;
let isDragging = false;
let offsetX = 0;
let offsetY = 0;

// ============ ЗАГРУЗКА ГРАФА ============
async function loadGraph() {
    try {
        const response = await fetch('/api/graph');
        const data = await response.json();

        console.log('Graph loaded:', data);

        // Очищаем
        if (pointsLayer) pointsLayer.innerHTML = '';
        if (linesSvg) linesSvg.innerHTML = '';
        points = [];

        // Добавляем вершины
        if (data.vertices) {
            console.log('Vertices:', data.vertices);

            if (Array.isArray(data.vertices)) {
                data.vertices.forEach(vertex => {
                    addPointToDOM(
                        parseInt(vertex.id),
                        vertex.x,
                        vertex.y
                    );
                });
            } else {
                for (const [id, coords] of Object.entries(data.vertices)) {
                    addPointToDOM(
                        parseInt(id),
                        coords.x,
                        coords.y
                    );
                }
            }
        }

        // Добавляем рёбра
        if (data.edges) {
            drawEdges(data.edges);
        }

        // ОБНОВЛЯЕМ ВЫПАДАЮЩИЙ СПИСОК
        updateVertexSelect();

        // ОБНОВЛЯЕМ МАТРИЦУ ВЕСОВ
        await updateWeightMatrix();

        console.log('Points array:', points);

    } catch (error) {
        console.error('Error loading graph:', error);
    }
}

// ============ ОБНОВЛЕНИЕ МАТРИЦЫ ВЕСОВ ============
// Обновленная функция updateWeightMatrix в prim.js
async function updateWeightMatrix() {
    try {
        const response = await fetch('/api/graph/matrix');
        const data = await response.json();

        const matrixContainer = document.getElementById('weight-matrix');
        if (!matrixContainer) {
            console.error('Matrix container not found');
            return;
        }

        if (!data.success || points.length === 0) {
            matrixContainer.innerHTML = '<div class="matrix-placeholder">📊 Нет вершин для отображения матрицы<br><small>Добавьте вершины на поле</small></div>';
            return;
        }

        // Сортируем вершины по id
        const sortedVertices = [...points].sort((a, b) => a.id - b.id);

        // Создаем таблицу
        let html = '<table class="weight-matrix-table">';

        // Заголовок
        html += '<thead>';
        html += '<tr>';
        html += '<th>Верш\\Верш</th>';

        for (let v of sortedVertices) {
            html += `<th>${v.id}</th>`;
        }
        html += '</tr>';
        html += '</thead>';

        // Тело таблицы
        html += '<tbody>';

        for (let i of sortedVertices) {
            html += '<tr>';
            html += `<td class="diagonal"><strong>${i.id}</strong></td>`;

            for (let j of sortedVertices) {
                if (i.id === j.id) {
                    // Диагональ
                    html += '<td class="diagonal">0</td>';
                } else {
                    // Получаем вес ребра
                    let weight = null;
                    if (data.matrix[i.id] && data.matrix[i.id][j.id] !== undefined) {
                        weight = data.matrix[i.id][j.id];
                    }

                    if (weight !== null && weight !== undefined && weight !== Infinity) {
                        // Есть ребро
                        html += `<td class="has-edge">
                            <input type="number" 
                                class="matrix-weight-input" 
                                data-from="${i.id}" 
                                data-to="${j.id}" 
                                value="${weight}" 
                                step="1" 
                                min="1" 
                                max="9999"
                                placeholder="вес">
                        </td>`;
                    } else {
                        // Нет ребра
                        html += '<td class="no-edge">—</td>';
                    }
                }
            }
            html += '</tr>';
        }

        html += '</tbody>';
        html += '</table>';

        matrixContainer.innerHTML = html;

        // Добавляем обработчики для input полей
        const inputs = matrixContainer.querySelectorAll('.matrix-weight-input');
        console.log(`Found ${inputs.length} weight inputs`);

        inputs.forEach(input => {
            input.addEventListener('change', async (e) => {
                const from = parseInt(input.dataset.from);
                const to = parseInt(input.dataset.to);
                let weight = parseFloat(input.value);

                if (isNaN(weight) || weight <= 0) {
                    alert('Введите корректный вес (число > 0)');
                    await updateWeightMatrix(); // Обновляем для отображения старого значения
                    return;
                }

                // Округляем
                weight = Math.round(weight * 1000) / 1000;

                try {
                    const response = await fetch('/api/graph/edge/distance', {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            v1: from,
                            v2: to,
                            distance: weight
                        })
                    });

                    const result = await response.json();

                    if (result.success) {
                        console.log(`Updated edge ${from}-${to} to ${weight}`);
                        await loadGraph(); // Перезагружаем граф
                        clearMSTResult();
                    } else {
                        alert('Не удалось изменить вес ребра');
                        await updateWeightMatrix();
                    }
                } catch (error) {
                    console.error('Error updating weight:', error);
                    alert('Ошибка при обновлении веса');
                    await updateWeightMatrix();
                }
            });
        });

    } catch (error) {
        console.error('Error loading matrix:', error);
        const matrixContainer = document.getElementById('weight-matrix');
        if (matrixContainer) {
            matrixContainer.innerHTML = '<div class="matrix-placeholder">❌ Ошибка загрузки матрицы</div>';
        }
    }
}

// ============ ДОБАВЛЕНИЕ ВЕРШИНЫ В DOM ============
function addPointToDOM(id, x, y) {
    if (!pointsLayer) return;

    const point = document.createElement('div');
    point.className = 'point';
    point.style.left = x + 'px';
    point.style.top = y + 'px';
    point.dataset.id = id;
    point.innerHTML = `<span class="point-id">${id}</span>`;

    // КЛИК
    point.onclick = async (e) => {
        e.stopPropagation();
        if (isDragging) return;
        await selectPoint(id);
    };

    // УДАЛЕНИЕ
    point.ondblclick = async (e) => {
        e.stopPropagation();
        await deleteVertex(id);
    };

    // НАЧАЛО ПЕРЕТАСКИВАНИЯ
    point.onmousedown = (e) => {
        isDragging = false;
        draggedPoint = {
            id: id,
            element: point
        };
        const rect = point.getBoundingClientRect();
        offsetX = e.clientX - rect.left;
        offsetY = e.clientY - rect.top;
    };

    pointsLayer.appendChild(point);
    points.push({
        id: id,
        x: x,
        y: y,
        element: point
    });
}

// ============ ОБНОВЛЕНИЕ ВЫПАДАЮЩЕГО СПИСКА ============
function updateVertexSelect() {
    const select = document.getElementById('start-vertex-select');
    if (!select) {
        console.error('Select element not found!');
        return;
    }

    select.innerHTML = '';

    if (points.length === 0) {
        const option = document.createElement('option');
        option.value = '';
        option.textContent = 'Нет вершин';
        select.appendChild(option);
        return;
    }

    console.log('Updating select, points count:', points.length);

    points.forEach(point => {
        const option = document.createElement('option');
        option.value = point.id;
        option.textContent = `Вершина ${point.id}`;
        select.appendChild(option);
    });
}

// ============ ВЫБОР ВЕРШИНЫ ============
async function selectPoint(id) {
    const point = points.find(p => p.id === id);
    if (!point) return;

    if (edgeStartVertex === null) {
        edgeStartVertex = id;
        points.forEach(p => {
            p.element.classList.remove('selected');
        });
        point.element.classList.add('selected');
        return;
    }

    if (edgeStartVertex === id) {
        edgeStartVertex = null;
        point.element.classList.remove('selected');
        return;
    }

    try {
        const response = await fetch('/api/graph/edge', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                v1: edgeStartVertex,
                v2: id,
                distance: 100
            })
        });

        const data = await response.json();

        if (data.success) {
            console.log('Edge created');
            edgeStartVertex = null;
            await loadGraph();
        } else {
            alert('Не удалось создать ребро');
        }
    } catch (error) {
        console.error('Error creating edge:', error);
    }

    points.forEach(p => {
        p.element.classList.remove('selected');
    });
    edgeStartVertex = null;
}

// ============ УДАЛЕНИЕ ВЕРШИНЫ ============
async function deleteVertex(id) {
    if (!confirm(`Удалить вершину ${id} и все связанные рёбра?`)) return;

    try {
        await fetch(`/api/graph/vertex/${id}`, { method: 'DELETE' });
        await loadGraph();
    } catch (error) {
        console.error('Error:', error);
    }
}


// ============ ОТРИСОВКА РЁБЕР ============
function drawEdges(edges) {
    if (!linesSvg) return;
    linesSvg.innerHTML = '';

    edges.forEach(edge => {
        edge.weight = edge.weight || edge.distance || 100;
        const fromPoint = points.find(p => p.id === edge.from);
        const toPoint = points.find(p => p.id === edge.to);

        if (fromPoint && toPoint) {
            const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
            line.setAttribute('x1', fromPoint.x);
            line.setAttribute('y1', fromPoint.y);
            line.setAttribute('x2', toPoint.x);
            line.setAttribute('y2', toPoint.y);
            line.setAttribute('stroke', '#bdc2ce');
            line.setAttribute('stroke-width', '3'); // Увеличил толщину для лучшего клика
            line.setAttribute('data-from', edge.from);
            line.setAttribute('data-to', edge.to);
            line.style.cursor = 'pointer';
            line.style.pointerEvents = 'stroke'; // Только линия кликабельная

            // ПКМ для удаления ребра
            line.addEventListener('contextmenu', async (e) => {
                e.preventDefault();
                e.stopPropagation();
                if (confirm('Удалить ребро?')) {
                    try {
                        const response = await fetch('/api/graph/edge', {
                            method: 'DELETE',
                            headers: { 'Content-Type': 'application/json' },
                            body: JSON.stringify({
                                v1: parseInt(edge.from),
                                v2: parseInt(edge.to)
                            })
                        });
                        const data = await response.json();
                        if (data.success) {
                            await loadGraph();
                            clearMSTResult();
                        }
                    } catch (error) {
                        console.error('Error deleting edge:', error);
                    }
                }
            });

            // ЛКМ по линии для редактирования веса
            line.addEventListener('click', async (e) => {
                e.stopPropagation();
                const currentWeight = edge.weight || edge.distance || 100;

                const newWeight = prompt(
                    `Редактирование веса ребра (${edge.from} → ${edge.to})\nТекущий вес: ${currentWeight}\nВведите новый вес:`,
                    currentWeight
                );

                if (newWeight === null) return;

                let weight = parseFloat(newWeight);
                if (isNaN(weight) || weight <= 0) {
                    alert('Введите корректное число (больше 0)');
                    return;
                }

                weight = Math.round(weight * 10) / 10;

                try {
                    const response = await fetch('/api/graph/edge/distance', {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            v1: parseInt(edge.from),
                            v2: parseInt(edge.to),
                            distance: weight
                        })
                    });

                    const data = await response.json();

                    if (data.success) {
                        console.log(`Вес ребра ${edge.from}-${edge.to} изменен на ${weight}`);
                        await loadGraph();
                        clearMSTResult();
                    } else {
                        alert('Не удалось изменить вес ребра');
                    }
                } catch (error) {
                    console.error('Error updating weight:', error);
                    alert('Ошибка при изменении веса');
                }
            });

            // Вычисляем позицию для текста
            const midX = (fromPoint.x + toPoint.x) / 2;
            const midY = (fromPoint.y + toPoint.y) / 2;

            const weightValue = edge.weight || edge.distance || 100;
            const weightText = Number(weightValue).toFixed(1);

            // Создаем группу для текста с увеличенной зоной клика
            const textGroup = document.createElementNS('http://www.w3.org/2000/svg', 'g');
            textGroup.style.cursor = 'pointer';
            textGroup.style.pointerEvents = 'bounding-box'; // Вся группа кликабельная

            // Создаем невидимую область для клика (увеличиваем зону)
            const hitArea = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            hitArea.setAttribute('x', midX - 30);
            hitArea.setAttribute('y', midY - 15);
            hitArea.setAttribute('width', '60');
            hitArea.setAttribute('height', '30');
            hitArea.setAttribute('fill', 'rgba(0,0,0,0)'); // Прозрачный
            hitArea.setAttribute('stroke', 'none');

            // Фон для текста
            const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
            const bbox = { width: weightText.length * 7 }; // Примерная ширина
            rect.setAttribute('x', midX - bbox.width / 2 - 5);
            rect.setAttribute('y', midY - 10);
            rect.setAttribute('width', bbox.width + 10);
            rect.setAttribute('height', 20);
            rect.setAttribute('fill', 'white');
            rect.setAttribute('stroke', '#5a4d5e');
            rect.setAttribute('stroke-width', '1.5');
            rect.setAttribute('rx', '4');

            // Текст
            const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
            text.setAttribute('x', midX);
            text.setAttribute('y', midY);
            text.setAttribute('fill', '#5a4d5e');
            text.setAttribute('font-size', '13');
            text.setAttribute('font-weight', 'bold');
            text.setAttribute('text-anchor', 'middle');
            text.setAttribute('dominant-baseline', 'middle');
            text.textContent = weightText;
            text.style.pointerEvents = 'none'; // Текст не перехватывает клики

            // Добавляем обработчик клика на группу
            textGroup.addEventListener('click', async (e) => {
                e.stopPropagation();
                console.log('Clicked on edge weight text');
                const currentWeight = edge.weight || edge.distance || 100;

                const newWeight = prompt(
                    `Редактирование веса ребра (${edge.from} → ${edge.to})\nТекущий вес: ${currentWeight}\nВведите новый вес:`,
                    currentWeight
                );

                if (newWeight === null) return;

                let weight = parseFloat(newWeight);
                if (isNaN(weight) || weight <= 0) {
                    alert('Введите корректное число (больше 0)');
                    return;
                }

                weight = Math.round(weight * 10) / 10;

                try {
                    const response = await fetch('/api/graph/edge/distance', {
                        method: 'PUT',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            v1: parseInt(edge.from),
                            v2: parseInt(edge.to),
                            distance: weight
                        })
                    });

                    const data = await response.json();

                    if (data.success) {
                        console.log(`Вес ребра ${edge.from}-${edge.to} изменен на ${weight}`);
                        await loadGraph();
                        clearMSTResult();
                    } else {
                        alert('Не удалось изменить вес ребра');
                    }
                } catch (error) {
                    console.error('Error updating weight:', error);
                    alert('Ошибка при изменении веса');
                }
            });

            // Эффекты при наведении
            textGroup.addEventListener('mouseenter', () => {
                text.setAttribute('fill', '#e74c3c');
                text.setAttribute('font-size', '14');
                rect.setAttribute('stroke', '#e74c3c');
                rect.setAttribute('stroke-width', '2');
                rect.setAttribute('fill', '#fff9e6');
                hitArea.setAttribute('fill', 'rgba(231, 76, 60, 0.1)');
            });

            textGroup.addEventListener('mouseleave', () => {
                text.setAttribute('fill', '#5a4d5e');
                text.setAttribute('font-size', '13');
                rect.setAttribute('stroke', '#5a4d5e');
                rect.setAttribute('stroke-width', '1.5');
                rect.setAttribute('fill', 'white');
                hitArea.setAttribute('fill', 'rgba(0,0,0,0)');
            });

            textGroup.appendChild(hitArea);
            textGroup.appendChild(rect);
            textGroup.appendChild(text);

            linesSvg.appendChild(line);
            linesSvg.appendChild(textGroup);

            // Добавляем подсказку при наведении на линию
            line.addEventListener('mouseenter', () => {
                line.setAttribute('stroke', '#e74c3c');
                line.setAttribute('stroke-width', '4');
            });

            line.addEventListener('mouseleave', () => {
                line.setAttribute('stroke', '#bdc2ce');
                line.setAttribute('stroke-width', '3');
            });
        }
    });
}


// ============ ГЕНЕРАЦИЯ СЛУЧАЙНЫХ ВЕСОВ ============
async function generateRandomDistances() {
    const min = parseInt(document.getElementById('random-min').value);
    const max = parseInt(document.getElementById('random-max').value);

    if (min >= max) {
        alert('Min должен быть меньше Max');
        return;
    }

    try {
        await fetch('/api/graph/random-distances', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ min: min, max: max })
        });
        await loadGraph();
        clearMSTResult();
        alert('Случайные веса сгенерированы!');
    } catch (error) {
        console.error('Error:', error);
    }
}

// ============ ОЧИСТКА ГРАФА ============
async function clearGraph() {
    if (!confirm('Очистить всё?')) return;

    try {
        await fetch('/api/graph/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ vertices: {}, edges: [] })
        });
        await loadGraph();
        clearMSTResult();
    } catch (error) {
        console.error('Error:', error);
    }
}

// ============ ОЧИСТКА РЕЗУЛЬТАТОВ ============
function clearMSTResult() {
    const resultDiv = document.getElementById('mst-result');
    const edgesList = document.getElementById('mst-edges-list');
    const totalDiv = document.getElementById('mst-total');

    if (resultDiv) resultDiv.classList.remove('show');
    if (edgesList) edgesList.innerHTML = '';
    if (totalDiv) totalDiv.innerHTML = '';

    if (linesSvg) {
        const lines = linesSvg.querySelectorAll('line');
        lines.forEach(line => {
            line.setAttribute('stroke', '#bdc2ce');
            line.setAttribute('stroke-width', '2');
        });
    }
}

// ============ ПОДСВЕТКА MST ============
function highlightMST(mstEdges) {
    if (!linesSvg) return;

    const lines = linesSvg.querySelectorAll('line');
    lines.forEach(line => {
        line.setAttribute('stroke', '#bdc2ce');
        line.setAttribute('stroke-width', '2');
    });

    mstEdges.forEach(edge => {
        const targets = linesSvg.querySelectorAll(`line[data-from="${edge.from}"][data-to="${edge.to}"], line[data-from="${edge.to}"][data-to="${edge.from}"]`);
        targets.forEach(line => {
            line.setAttribute('stroke', '#4caf50');
            line.setAttribute('stroke-width', '4');
        });
    });
}

// ============ ОТОБРАЖЕНИЕ РЕЗУЛЬТАТОВ ============
function displayMSTResult(data) {
    const resultDiv = document.getElementById('mst-result');
    const edgesList = document.getElementById('mst-edges-list');
    const totalDiv = document.getElementById('mst-total');

    if (!data.success) {
        edgesList.innerHTML = `<div style="color: red;">Ошибка: ${data.error}</div>`;
        resultDiv.classList.add('show');
        return;
    }

    edgesList.innerHTML = '';
    let total = 0;

    data.edges.forEach((edge, i) => {
        edgesList.innerHTML += `<div class="mst-edge">${i + 1}. ${edge.from} → ${edge.to} : <strong>${edge.weight}</strong></div>`;
        total += edge.weight;
    });

    totalDiv.innerHTML = `Общий вес: <strong>${total.toFixed(2)}</strong>`;
    resultDiv.classList.add('show');
    highlightMST(data.edges);
}

// ============ АЛГОРИТМ ПРИМА ============
async function computePrimMST() {
    const select = document.getElementById('start-vertex-select');
    const startVertex = select.value;

    if (!startVertex) {
        alert('Выберите начальную вершину!');
        return;
    }

    if (points.length === 0) {
        alert('Нет вершин в графе!');
        return;
    }

    try {
        const response = await fetch('/api/prim/calculate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ start_vertex: parseInt(startVertex) })
        });

        const data = await response.json();
        console.log('Prim result:', data);

        if (data.success) {
            displayMSTResult(data);
        } else {
            alert(data.error || 'Ошибка');
        }
    } catch (error) {
        alert('Ошибка: ' + error.message);
    }
}

// ============ ПЕРЕТАСКИВАНИЕ ВЕРШИН ============
function setupVertexDragging() {
    document.addEventListener('mousemove', async (e) => {
        if (!draggedPoint) return;
        isDragging = true;

        const rect = pointsLayer.getBoundingClientRect();
        const x = e.clientX - rect.left - offsetX;
        const y = e.clientY - rect.top - offsetY;

        draggedPoint.element.style.left = x + 'px';
        draggedPoint.element.style.top = y + 'px';

        const pointObj = points.find(p => p.id === draggedPoint.id);
        if (pointObj) {
            pointObj.x = x;
            pointObj.y = y;
        }

        const response = await fetch('/api/graph');
        const data = await response.json();
        if (data.edges) {
            drawEdges(data.edges);
        }
    });

    document.addEventListener('mouseup', async () => {
        if (!draggedPoint) return;
        const pointObj = points.find(p => p.id === draggedPoint.id);
        if (pointObj) {
            try {
                await fetch(`/api/graph/vertex/${draggedPoint.id}/position`, {
                    method: 'PUT',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ x: pointObj.x, y: pointObj.y })
                });
            } catch (error) {
                console.error('Error updating position:', error);
            }
        }
        setTimeout(() => {
            isDragging = false;
        }, 50);
        draggedPoint = null;
    });
}

// ============ ДОБАВЛЕНИЕ ВЕРШИНЫ ЧЕРЕЗ DRAG & DROP ============
function setupDragAndDrop() {
    const draggable = document.getElementById('point-drag');
    if (draggable) {
        draggable.addEventListener('dragstart', (e) => {
            e.dataTransfer.setData('text/plain', 'point');
        });
    }

    if (pointsLayer) {
        pointsLayer.addEventListener('dragover', (e) => e.preventDefault());

        pointsLayer.addEventListener('drop', async (e) => {
            e.preventDefault();
            const rect = pointsLayer.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;

            try {
                const response = await fetch('/api/graph/vertex', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ x: x, y: y })
                });
                const data = await response.json();
                console.log('Vertex added:', data);
                await loadGraph();
            } catch (error) {
                console.error('Error:', error);
            }
        });
    }
}
// Добавьте эту функцию в конец prim.js
async function saveMatrixToJSON() {
    try {
        const response = await fetch('/api/graph/matrix');
        const data = await response.json();

        if (data.success) {
            const jsonString = JSON.stringify(data.matrix, null, 2);
            const blob = new Blob([jsonString], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `matrix_${new Date().toISOString().slice(0, 19)}.json`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
            alert('Матрица сохранена!');
        } else {
            alert('Ошибка при сохранении матрицы: ' + (data.error || 'Неизвестная ошибка'));
        }
    } catch (error) {
        console.error('Error saving matrix:', error);
        alert('Ошибка при сохранении: ' + error.message);
    }
}
// ============ ИНИЦИАЛИЗАЦИЯ ============
async function init() {
    console.log('Initializing Prim editor...');

    pointsLayer = document.getElementById('points-layer');
    linesSvg = document.getElementById('lines-layer');


    setupDragAndDrop();
    setupVertexDragging();
    await loadGraph();

    document.getElementById('random-btn')?.addEventListener('click', generateRandomDistances);
    document.getElementById('clear-graph-btn')?.addEventListener('click', clearGraph);
    document.getElementById('prim-btn')?.addEventListener('click', computePrimMST);
    document.getElementById('save-matrix-btn')?.addEventListener('click', saveMatrixToJSON);
    console.log('Initialized, points:', points.length);
}

// ЗАПУСК
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}