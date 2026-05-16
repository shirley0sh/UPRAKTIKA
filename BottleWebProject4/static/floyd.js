// Функция генерации случайных расстояний для страницы Флойда
async function generateRandomDistancesFloyd() {
    const minInput = document.getElementById('random-min');
    const maxInput = document.getElementById('random-max');

    if (!minInput || !maxInput) {
        console.error('Input elements not found');
        alert('Error: Input elements not found');
        return;
    }

    let min = parseInt(minInput.value);
    let max = parseInt(maxInput.value);

    if (isNaN(min)) {
        alert('Please enter a valid minimum value');
        minInput.focus();
        return;
    }
    if (isNaN(max)) {
        alert('Please enter a valid maximum value');
        maxInput.focus();
        return;
    }
    if (min >= max) {
        alert('Minimum must be less than maximum');
        minInput.focus();
        return;
    }
    if (min < 0 || max < 0) {
        alert('Values cannot be negative');
        return;
    }

    try {
        const response = await fetch('/api/graph/random-distances', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ min: min, max: max })
        });

        const data = await response.json();

        if (data.success) {
            // Обновляем локальные данные
            const graphResponse = await fetch('/api/graph');
            const graphData = await graphResponse.json();

            if (graphData.edges) {
                window.lineConnections = graphData.edges;
                redrawLines();
            }

            alert(`Random distances assigned to ${data.count} line(s)!`);
        }

    } catch (error) {
        console.error('Error generating random distances:', error);
        alert('Error generating random distances');
    }
}

// Функция очистки графа для страницы Флойда
async function clearGraphFloyd() {
    if (!confirm('Clear all points and lines?')) return;

    points.forEach(p => {
        if (p.element) p.element.remove();
    });
        points = [];
        window.lineConnections = [];
        selectedPointId = null;
        selectedLine = null;

        await fetch('/api/graph/update', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ vertices: {}, edges: [] })
        });

        redrawAll();
}

// Инициализация редактора Флойда
function initFloydEditor() {
    console.log('Initializing Floyd editor...');

    // Используем стандартные ID (как в script.js)
    pointsLayer = document.getElementById('points-layer');
    linesSvg = document.getElementById('lines-layer');
    draggable = document.getElementById('point-drag');

    // Переопределяем глобальные переменные
    window.pointsLayer = pointsLayer;
    window.linesSvg = linesSvg;
    window.draggable = draggable;

    // Настройка Drag & Drop
    if (draggable) {
        draggable.addEventListener('dragstart', (e) => {
            e.dataTransfer.setData('text/plain', 'point');
        });
    }

    if (pointsLayer) {
        pointsLayer.addEventListener('dragover', (e) => e.preventDefault());

        pointsLayer.addEventListener('drop', (e) => {
            e.preventDefault();
            const rect = pointsLayer.getBoundingClientRect();
            addPoint(e.clientX - rect.left, e.clientY - rect.top);
        });

        pointsLayer.addEventListener('dblclick', (e) => {
            const target = e.target;
            if (target.classList && target.classList.contains('point')) {
                removePoint(parseInt(target.dataset.id));
            }
        });

        pointsLayer.addEventListener('click', () => {
            clearSelectedPoints();
            if (selectedLine) {
                selectedLine.style.stroke = '#bdc2ce';
                selectedLine = null;
            }
        });
    }

    // Загружаем граф
    loadGraph();

    // Назначаем обработчики кнопок (стандартные ID из floyd.tpl)
    const randomBtn = document.getElementById('random-btn');
    if (randomBtn) {
        randomBtn.onclick = generateRandomDistancesFloyd;
        console.log('Random button handler assigned');
    } else {
        console.error('random-btn not found');
    }

    const clearBtn = document.getElementById('clear-graph-btn');
    if (clearBtn) {
        clearBtn.onclick = clearGraphFloyd;
    }

    const computeBtn = document.getElementById('floyd-btn');
    if (computeBtn) {
        computeBtn.onclick = showFloydWarshall;
    }
}

// Показать результаты Флойда-Уоршелла
async function showFloydWarshall() {
    try {
        const response = await fetch('/api/floyd/shortest-paths');
        const data = await response.json();

        if (!data.vertices || data.vertices.length === 0) {
            alert('No vertices in graph. Add some points first.');
            return;
        }

        const modal = document.createElement('div');
        modal.style.position = 'fixed';
        modal.style.top = '0';
        modal.style.left = '0';
        modal.style.width = '100%';
        modal.style.height = '100%';
        modal.style.backgroundColor = 'rgba(0,0,0,0.8)';
        modal.style.zIndex = '2000';
        modal.style.display = 'flex';
        modal.style.justifyContent = 'center';
        modal.style.alignItems = 'center';

        const content = document.createElement('div');
        content.style.backgroundColor = 'white';
        content.style.padding = '20px';
        content.style.borderRadius = '12px';
        content.style.maxWidth = '95%';
        content.style.maxHeight = '85%';
        content.style.overflow = 'auto';
        content.style.boxShadow = '0 10px 40px rgba(0,0,0,0.3)';

        const title = document.createElement('h2');
        title.textContent = 'Floyd-Warshall Algorithm Results';
        title.style.textAlign = 'center';
        title.style.marginBottom = '20px';
        title.style.color = '#5a4d5e';
        content.appendChild(title);

        const tabContainer = document.createElement('div');
        tabContainer.style.display = 'flex';
        tabContainer.style.borderBottom = '2px solid #e8d7cf';
        tabContainer.style.marginBottom = '20px';

        const distTab = document.createElement('button');
        distTab.textContent = 'Distance Matrix';
        distTab.style.padding = '10px 20px';
        distTab.style.backgroundColor = '#5a4d5e';
        distTab.style.color = 'white';
        distTab.style.border = 'none';
        distTab.style.cursor = 'pointer';
        distTab.style.borderRadius = '8px 8px 0 0';
        distTab.style.fontWeight = 'bold';

        const pathTab = document.createElement('button');
        pathTab.textContent = 'Path Matrix';
        pathTab.style.padding = '10px 20px';
        pathTab.style.backgroundColor = '#e8d7cf';
        pathTab.style.color = '#5a4d5e';
        pathTab.style.border = 'none';
        pathTab.style.cursor = 'pointer';
        pathTab.style.borderRadius = '8px 8px 0 0';
        pathTab.style.fontWeight = 'bold';

        tabContainer.appendChild(distTab);
        tabContainer.appendChild(pathTab);
        content.appendChild(tabContainer);

        const tableContainer = document.createElement('div');
        content.appendChild(tableContainer);

        function showDistanceMatrix() {
            tableContainer.innerHTML = '';

            const vertices = data.vertices;
            const n = vertices.length;
            const distances = data.distances;

            const table = document.createElement('table');
            table.style.borderCollapse = 'collapse';
            table.style.width = '100%';
            table.style.marginTop = '10px';
            table.style.fontSize = '13px';

            const thead = document.createElement('thead');
            const headerRow = document.createElement('tr');

            const cornerTh = document.createElement('th');
            cornerTh.textContent = 'From\\To';
            cornerTh.style.border = '1px solid #e8d7cf';
            cornerTh.style.padding = '10px';
            cornerTh.style.backgroundColor = '#e8d7cf';
            cornerTh.style.fontWeight = 'bold';
            headerRow.appendChild(cornerTh);

            for (let v of vertices) {
                const th = document.createElement('th');
                th.textContent = v;
                th.style.border = '1px solid #e8d7cf';
                th.style.padding = '10px';
                th.style.backgroundColor = '#e8d7cf';
                th.style.fontWeight = 'bold';
                headerRow.appendChild(th);
            }
            thead.appendChild(headerRow);
            table.appendChild(thead);

            const tbody = document.createElement('tbody');
            for (let i = 0; i < n; i++) {
                const row = document.createElement('tr');

                const rowTh = document.createElement('th');
                rowTh.textContent = vertices[i];
                rowTh.style.border = '1px solid #e8d7cf';
                rowTh.style.padding = '10px';
                rowTh.style.backgroundColor = '#e8d7cf';
                rowTh.style.fontWeight = 'bold';
                row.appendChild(rowTh);

                for (let j = 0; j < n; j++) {
                    const cell = document.createElement('td');
                    cell.style.border = '1px solid #e8d7cf';
                    cell.style.padding = '10px';
                    cell.style.textAlign = 'center';

                    const val = distances[i][j];
                    if (i === j) {
                        cell.textContent = '0';
                        cell.style.backgroundColor = '#f5f5f5';
                    } else if (val === null || val === Infinity) {
                        cell.textContent = '∞';
                        cell.style.color = '#999';
                    } else {
                        cell.textContent = val.toFixed(2);
                        if (val < 100) {
                            cell.style.backgroundColor = '#e8f5e9';
                            cell.style.color = '#2e7d32';
                            cell.style.fontWeight = 'bold';
                        } else if (val < 500) {
                            cell.style.backgroundColor = '#fff3e0';
                            cell.style.color = '#e65100';
                        } else {
                            cell.style.backgroundColor = '#ffebee';
                            cell.style.color = '#c62828';
                        }
                    }
                    row.appendChild(cell);
                }
                tbody.appendChild(row);
            }
            table.appendChild(tbody);
            tableContainer.appendChild(table);

            const legend = document.createElement('div');
            legend.style.marginTop = '15px';
            legend.style.padding = '10px';
            legend.style.backgroundColor = '#f9f9f9';
            legend.style.borderRadius = '8px';
            legend.style.fontSize = '12px';
            legend.innerHTML = `
            <strong>Legend:</strong><br>
            🟢 Green: Short distance (< 100)<br>
            🟠 Orange: Medium distance (100-500)<br>
            🔴 Red: Long distance (> 500)<br>
            ∞: No path exists
            `;
            tableContainer.appendChild(legend);
        }

        function showPathMatrix() {
            tableContainer.innerHTML = '';

            const vertices = data.vertices;
            const n = vertices.length;
            const paths = data.paths;
            const distances = data.distances;

            const table = document.createElement('table');
            table.style.borderCollapse = 'collapse';
            table.style.width = '100%';
            table.style.marginTop = '10px';
            table.style.fontSize = '12px';

            const thead = document.createElement('thead');
            const headerRow = document.createElement('tr');

            const cornerTh = document.createElement('th');
            cornerTh.textContent = 'From\\To';
            cornerTh.style.border = '1px solid #e8d7cf';
            cornerTh.style.padding = '10px';
            cornerTh.style.backgroundColor = '#e8d7cf';
            cornerTh.style.fontWeight = 'bold';
            headerRow.appendChild(cornerTh);

            for (let v of vertices) {
                const th = document.createElement('th');
                th.textContent = v;
                th.style.border = '1px solid #e8d7cf';
                th.style.padding = '10px';
                th.style.backgroundColor = '#e8d7cf';
                th.style.fontWeight = 'bold';
                headerRow.appendChild(th);
            }
            thead.appendChild(headerRow);
            table.appendChild(thead);

            const tbody = document.createElement('tbody');
            for (let i = 0; i < n; i++) {
                const row = document.createElement('tr');

                const rowTh = document.createElement('th');
                rowTh.textContent = vertices[i];
                rowTh.style.border = '1px solid #e8d7cf';
                rowTh.style.padding = '10px';
                rowTh.style.backgroundColor = '#e8d7cf';
                rowTh.style.fontWeight = 'bold';
                row.appendChild(rowTh);

                for (let j = 0; j < n; j++) {
                    const cell = document.createElement('td');
                    cell.style.border = '1px solid #e8d7cf';
                    cell.style.padding = '10px';
                    cell.style.textAlign = 'center';
                    cell.style.fontSize = '11px';

                    const path = paths[i][j];
                    const dist = distances[i][j];

                    if (i === j) {
                        cell.textContent = '-';
                        cell.style.backgroundColor = '#f5f5f5';
                    } else if (dist === null || dist === Infinity || !path || path.length === 0) {
                        cell.textContent = 'No path';
                        cell.style.color = '#999';
                        cell.style.backgroundColor = '#f9f9f9';
                    } else {
                        cell.textContent = path.join(' → ');
                        cell.style.backgroundColor = '#e3f2fd';
                        cell.style.color = '#1565c0';
                        cell.style.cursor = 'pointer';
                        cell.style.fontWeight = '500';
                        cell.title = `Distance: ${dist.toFixed(2)}`;
                        cell.onclick = () => {
                            alert(`Shortest path from ${vertices[i]} to ${vertices[j]}:\n\n${path.join(' → ')}\n\nTotal distance: ${dist.toFixed(2)}`);
                        };
                    }
                    row.appendChild(cell);
                }
                tbody.appendChild(row);
            }
            table.appendChild(tbody);
            tableContainer.appendChild(table);

            const info = document.createElement('div');
            info.style.marginTop = '15px';
            info.style.padding = '10px';
            info.style.backgroundColor = '#e3f2fd';
            info.style.borderRadius = '8px';
            info.style.fontSize = '12px';
            info.innerHTML = '💡 <strong>Tip:</strong> Click on any path to see detailed information.';
            tableContainer.appendChild(info);
        }

        showDistanceMatrix();

        distTab.onclick = () => {
            distTab.style.backgroundColor = '#5a4d5e';
            distTab.style.color = 'white';
            pathTab.style.backgroundColor = '#e8d7cf';
            pathTab.style.color = '#5a4d5e';
            showDistanceMatrix();
        };

        pathTab.onclick = () => {
            pathTab.style.backgroundColor = '#5a4d5e';
            pathTab.style.color = 'white';
            distTab.style.backgroundColor = '#e8d7cf';
            distTab.style.color = '#5a4d5e';
            showPathMatrix();
        };

        const closeBtn = document.createElement('button');
        closeBtn.textContent = 'Close';
        closeBtn.style.marginTop = '20px';
        closeBtn.style.padding = '12px 20px';
        closeBtn.style.backgroundColor = '#5a4d5e';
        closeBtn.style.color = 'white';
        closeBtn.style.border = 'none';
        closeBtn.style.borderRadius = '8px';
        closeBtn.style.cursor = 'pointer';
        closeBtn.style.fontSize = '14px';
        closeBtn.style.fontWeight = 'bold';
        closeBtn.style.width = '100%';
        closeBtn.onclick = () => document.body.removeChild(modal);
        content.appendChild(closeBtn);

        modal.appendChild(content);
        document.body.appendChild(modal);

    } catch (error) {
        console.error('Error:', error);
        alert('Error computing shortest paths');
    }
}

// Автоматический запуск инициализации при загрузке страницы
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initFloydEditor);
} else {
    initFloydEditor();
}
