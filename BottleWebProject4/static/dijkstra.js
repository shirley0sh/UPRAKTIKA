// Обновление списка вершин в селекте
function updateVertexSelect() {
    const select = document.getElementById('source-select');
    if (!select) return;

    select.innerHTML = '<option value="">Select source vertex</option>';
    points.forEach(point => {
        const option = document.createElement('option');
        option.value = point.id;
        option.textContent = `Vertex ${point.id}`;
        select.appendChild(option);
    });
}

// Вычисление кратчайших путей алгоритмом Дейкстры
async function computeDijkstra() {
    const select = document.getElementById('source-select');
    const source = parseInt(select.value);

    if (isNaN(source)) {
        alert('Please select a source vertex');
        return;
    }

    try {
        const response = await fetch('/api/dijkstra/calculate', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ source: source })
        });

        const data = await response.json();

        if (data.error) {
            alert(data.error);
            return;
        }

        // Отображаем результаты
        const resultsDiv = document.getElementById('results');
        resultsDiv.innerHTML = '<h4 style="margin-bottom: 10px; color: #5a4d5e;">Shortest Paths from Vertex ' + source + ':</h4>';

        const resultsList = document.createElement('div');
        resultsList.style.maxHeight = '250px';
        resultsList.style.overflowY = 'auto';

        for (const item of data.results) {
            if (item.vertex === source) continue;

            const itemDiv = document.createElement('div');
            itemDiv.style.padding = '8px';
            itemDiv.style.marginBottom = '5px';
            itemDiv.style.backgroundColor = '#f5f5f5';
            itemDiv.style.borderRadius = '5px';
            itemDiv.style.cursor = 'pointer';

            if (item.distance === null) {
                itemDiv.innerHTML = `<strong>→ Vertex ${item.vertex}</strong>: No path`;
                itemDiv.style.color = '#999';
            } else {
                itemDiv.innerHTML = `<strong>→ Vertex ${item.vertex}</strong>: ${item.distance.toFixed(2)}<br>
                <span style="font-size: 11px; color: #666;">Path: ${item.path.join(' → ')}</span>`;
                itemDiv.style.borderLeft = '3px solid #5a4d5e';
            }

            itemDiv.onclick = () => {
                if (item.distance !== null) {
                    alert(`Path from ${source} to ${item.vertex}:\n\n${item.path.join(' → ')}\n\nTotal distance: ${item.distance.toFixed(2)}`);
                }
            };

            resultsList.appendChild(itemDiv);
        }

        resultsDiv.appendChild(resultsList);

    } catch (error) {
        console.error('Error:', error);
        alert('Error computing shortest paths');
    }
}

// Переопределяем redrawPoints для обновления селекта
const originalRedrawPoints = redrawPoints;
redrawPoints = function() {
    originalRedrawPoints();
    updateVertexSelect();
};

// Добавляем обработчик для кнопки Дейкстры
const dijkstraBtn = document.getElementById('dijkstra-btn');
if (dijkstraBtn) {
    dijkstraBtn.onclick = computeDijkstra;
}

// Инициализация селекта после загрузки
setTimeout(updateVertexSelect, 500);
