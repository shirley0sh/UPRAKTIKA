import json
import sys

def dijkstra(matrix, start):
    """
    Реализация алгоритма Дейкстры
    
    Args:
        matrix: список списков, матрица весов (1-индексация)
        start: int, стартовая вершина
    
    Returns:
        dict: {'dist': [список расстояний], 'prev': [список предыдущих вершин]}
    """
    n = len(matrix) - 1  # размерность матрицы (1-индексация)
    dist = [float('inf')] * (n + 1)
    visited = [False] * (n + 1)
    prev = [None] * (n + 1)
    
    dist[start] = 0
    
    for _ in range(n):
        # Находим непосещенную вершину с минимальным расстоянием
        min_dist = float('inf')
        u = -1
        for v in range(1, n + 1):
            if not visited[v] and dist[v] < min_dist:
                min_dist = dist[v]
                u = v
        
        if u == -1:  # Все оставшиеся вершины недостижимы
            break
        
        visited[u] = True
        
        # Релаксируем ребра из вершины u
        for v in range(1, n + 1):
            if not visited[v] and matrix[u][v] > 0 and dist[u] != float('inf'):
                new_dist = dist[u] + matrix[u][v]
                if new_dist < dist[v]:
                    dist[v] = new_dist
                    prev[v] = u
    
    return {
        'dist': dist,
        'prev': prev
    }


def get_path(prev, start, end):
    """
    Восстановление пути из prev
    
    Args:
        prev: список предыдущих вершин
        start: int, стартовая вершина
        end: int, конечная вершина
    
    Returns:
        list: путь от start до end или None если пути нет
    """
    if prev[end] is None and start != end:
        return None
    
    path = []
    cur = end
    while cur is not None:
        path.insert(0, cur)
        if cur == start:
            break
        cur = prev[cur]
    
    return path


if __name__ == "__main__":
    # Получаем данные из stdin
    data = json.loads(sys.stdin.read())
    matrix = data['matrix']
    start = data['start']
    
    # Запускаем алгоритм
    result = dijkstra(matrix, start)
    
    # Формируем пути для всех вершин
    paths = {}
    n = len(matrix) - 1
    for v in range(1, n + 1):
        path = get_path(result['prev'], start, v)
        paths[v] = path
    
    # Выводим результат
    output = {
        'dist': result['dist'][1:],  # убираем 0-й индекс
        'prev': result['prev'][1:],
        'paths': paths
    }
    print(json.dumps(output))
