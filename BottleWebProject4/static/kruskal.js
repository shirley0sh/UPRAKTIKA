class DisjointSetUnion {
    constructor(n) {
        this.parent = new Array(n);
        this.rank = new Array(n);
        
        for (let i = 0; i < n; i++) {
            this.parent[i] = i;
            this.rank[i] = 0;
        }
    }
    
    /**
     * Находит корень множества с компрессией пути
     */
    find(x) {
        if (this.parent[x] !== x) {
            this.parent[x] = this.find(this.parent[x]);
        }
        return this.parent[x];
    }
    
    union(x, y) {
        const rootX = this.find(x);
        const rootY = this.find(y);
        
        if (rootX === rootY) return false;
        
        // Ранговая эвристика
        if (this.rank[rootX] < this.rank[rootY]) {
            this.parent[rootX] = rootY;
        } else if (this.rank[rootX] > this.rank[rootY]) {
            this.parent[rootY] = rootX;
        } else {
            this.parent[rootY] = rootX;
            this.rank[rootX]++;
        }
        return true;
    }
    
    isConnected(x, y) {
        return this.find(x) === this.find(y);
    }
}

class KruskalAlgorithm {
    constructor(matrix) {
        this.matrix = matrix;
        this.n = matrix.length;
        this.edges = [];
        this.mstEdges = [];
        this.totalWeight = 0;
        this.steps = []; // Для пошагового режима
        this.dsu = null;
    }
    

    collectEdges() {
        this.edges = [];
        for (let i = 0; i < this.n; i++) {
            for (let j = i + 1; j < this.n; j++) {
                const weight = this.matrix[i][j];
                // Игнорируем нулевые веса (отсутствие ребра)
                if (weight !== null && weight !== undefined && weight !== 0 && weight !== Infinity) {
                    this.edges.push({
                        u: i,
                        v: j,
                        weight: parseInt(weight)
                    });
                }
            }
        }
    }
    
    sortEdges() {
        this.edges.sort((a, b) => a.weight - b.weight);
    }
    

    run() {
        // Шаг 1: Сбор всех рёбер
        this.collectEdges();
        
        // Шаг 2: Сортировка рёбер
        this.sortEdges();
        
        // Шаг 3: Инициализация DSU
        this.dsu = new DisjointSetUnion(this.n);
        
        // Шаг 4: Очистка результатов
        this.mstEdges = [];
        this.totalWeight = 0;
        this.steps = [];
        
        // Шаг 5: Основной цикл
        for (const edge of this.edges) {
            // Запоминаем шаг для пошагового режима
            this.steps.push({
                type: 'check',
                edge: edge,
                uComp: this.dsu.find(edge.u),
                vComp: this.dsu.find(edge.v)
            });
            
            // Если вершины в разных компонентах
            if (!this.dsu.isConnected(edge.u, edge.v)) {
                // Добавляем ребро в остов
                this.dsu.union(edge.u, edge.v);
                this.mstEdges.push({
                    u: edge.u,
                    v: edge.v,
                    weight: edge.weight
                });
                this.totalWeight += edge.weight;
                
                // Запоминаем шаг добавления
                this.steps.push({
                    type: 'add',
                    edge: edge,
                    mstCount: this.mstEdges.length
                });
            } else {
                // Запоминаем шаг пропуска
                this.steps.push({
                    type: 'skip',
                    edge: edge
                });
            }
            
            // Ранний выход: если остов готов
            if (this.mstEdges.length === this.n - 1) {
                break;
            }
        }
        
        // Формирование результата
        const success = this.mstEdges.length === this.n - 1;
        
        return {
            success: success,
            edges: this.mstEdges.map(e => ({
                u: e.u + 1,
                v: e.v + 1,
                weight: e.weight
            })),
            totalWeight: this.totalWeight,
            message: success 
                ? `Минимальное остовное дерево построено. Суммарный вес: ${this.totalWeight}`
                : "Граф несвязен. Невозможно построить остовное дерево",
            steps: this.steps,
            edgeCount: this.mstEdges.length,
            vertexCount: this.n
        };
    }
    
    
    // Проверка связности графа (через DFS)
     
    isGraphConnected() {
        if (this.n === 0) return true;
        
        const visited = new Array(this.n).fill(false);
        
        const dfs = (v) => {
            visited[v] = true;
            for (let u = 0; u < this.n; u++) {
                const weight = this.matrix[v][u];
                if (weight && weight !== 0 && weight !== Infinity && !visited[u]) {
                    dfs(u);
                }
            }
        };
        
        dfs(0);
        return visited.every(v => v === true);
    }
}

// Валидация входных данных

const GraphValidator = {
    
     // Проверка количества вершин
     
    validateVertexCount(n) {
        if (n < 2) {
            return { valid: false, message: "Количество вершин должно быть не менее 2" };
        }
        if (n > 10) {
            return { valid: false, message: "Количество вершин должно быть не более 10" };
        }
        return { valid: true, message: "" };
    },
   
     // Проверка матрицы на заполненность
     
    validateMatrixFilled(matrix, n) {
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < n; j++) {
                if (matrix[i][j] === null || matrix[i][j] === undefined || matrix[i][j] === "") {
                    return { valid: false, message: `Незаполненная ячейка [${i+1}][${j+1}]` };
                }
            }
        }
        return { valid: true, message: "" };
    },
    
     // Проверка главной диагонали
     
    validateDiagonal(matrix, n) {
        for (let i = 0; i < n; i++) {
            if (matrix[i][i] != 0) {
                return { valid: false, message: `Элемент на главной диагонали [${i+1}][${i+1}] должен быть равен 0` };
            }
        }
        return { valid: true, message: "" };
    },
    
     // Проверка симметричности матрицы
     
    validateSymmetry(matrix, n) {
        for (let i = 0; i < n; i++) {
            for (let j = i + 1; j < n; j++) {
                if (matrix[i][j] != matrix[j][i]) {
                    return { valid: false, message: `Матрица несимметрична: [${i+1}][${j+1}] ≠ [${j+1}][${i+1}]` };
                }
            }
        }
        return { valid: true, message: "" };
    },
    
     // Проверка отрицательных весов
     
    validateNoNegatives(matrix, n) {
        for (let i = 0; i < n; i++) {
            for (let j = 0; j < n; j++) {
                if (matrix[i][j] < 0) {
                    return { valid: false, message: `Отрицательный вес в ячейке [${i+1}][${j+1}]: ${matrix[i][j]}` };
                }
            }
        }
        return { valid: true, message: "" };
    },
   
    // Полная валидация графа
     
    validateAll(matrix, n) {
        const checks = [
            this.validateVertexCount(n),
            this.validateMatrixFilled(matrix, n),
            this.validateDiagonal(matrix, n),
            this.validateSymmetry(matrix, n),
            this.validateNoNegatives(matrix, n)
        ];
        
        for (const check of checks) {
            if (!check.valid) return check;
        }
        
        return { valid: true, message: "Данные корректны" };
    }
};

// Вспомогательные функции


function parseMatrixFromTable(tableId) {
    const table = document.getElementById(tableId);
    if (!table) return null;
    
    const rows = table.querySelectorAll('tbody tr');
    const n = rows.length;
    const matrix = Array(n).fill().map(() => Array(n).fill(0));
    
    for (let i = 0; i < rows.length; i++) {
        const cells = rows[i].querySelectorAll('td input');
        for (let j = 0; j < cells.length; j++) {
            const value = cells[j].value;
            if (value === "") {
                matrix[i][j] = null;
            } else {
                matrix[i][j] = parseInt(value);
            }
        }
    }
    
    return matrix;
}

function renderMatrixTable(containerId, n, testData = null) {
    const container = document.getElementById(containerId);
    if (!container) return;
    
    let html = '<table class="matrix-table" id="matrix-table">';
    html += '<thead><tr><th></th>';
    for (let j = 1; j <= n; j++) html += `<th>${j}</th>`;
    html += '</tr></thead><tbody>';
    
    for (let i = 1; i <= n; i++) {
        html += `<tr><th>${i}</th>`;
        for (let j = 1; j <= n; j++) {
            let value = '';
            if (testData && testData[i-1] && testData[i-1][j-1] !== undefined) {
                value = testData[i-1][j-1];
            } else if (i === j) {
                value = 0;
            }
            html += `<td><input type="number" name="cell_${i-1}_${j-1}" value="${value}"></td>`;
        }
        html += '</tr>';
    }
    html += '</tbody></table>';
    
    container.innerHTML = html;
}

// Экспорт

if (typeof module !== 'undefined' && module.exports) {
    module.exports = { KruskalAlgorithm, DisjointSetUnion, GraphValidator, parseMatrixFromTable, renderMatrixTable };
}