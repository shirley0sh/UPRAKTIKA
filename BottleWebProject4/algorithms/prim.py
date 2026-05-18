# prim.py
# Чистая реализация алгоритма Прима

def find_minimum_spanning_tree(vertices, edges, start_vertex):
    # Проверки
    if not vertices:
        return {
            'success': False,
            'error': 'Net vershin v grafe'
        }

    # Преобразуем ключи vertices в int
    vertices = {
        int(k): v for k, v in vertices.items()
    }

    start_vertex = int(start_vertex)

    if start_vertex not in vertices:
        return {
            'success': False,
            'error': f'Vershina {start_vertex} ne naidena'
        }
    
    # Строим список смежности
    adj = {v: [] for v in vertices.keys()}
    for edge in edges:
        frm = int(edge['from'])
        to = int(edge['to'])
        w = edge['weight']
        adj[frm].append((to, w))
        adj[to].append((frm, w))
    
    # Алгоритм Прима
    in_mst = {start_vertex}
    mst_edges = []
    total_weight = 0
    
    while len(in_mst) < len(vertices):
        min_edge = None
        min_w = float('inf')
        
        # Ищем минимальное ребро
        for u in in_mst:
            for v, w in adj[u]:
                if v not in in_mst and w < min_w:
                    min_w = w
                    min_edge = {'from': u, 'to': v, 'weight': w}
        
        # Если не нашли - граф несвязный
        if min_edge is None:
            return {'success': False, 'error': 'Graf nesvyazniy'}
        
        mst_edges.append(min_edge)
        total_weight += min_w
        in_mst.add(min_edge['to'])
    
    return {
        'success': True,
        'edges': mst_edges,
        'total_weight': round(total_weight, 2)
    }

def get_weight_matrix(vertices, edges):
    try:
        if not vertices:
            return {'success': True, 'matrix': {}}
        
        # Получаем все ID вершин
        vertex_ids = []
        if isinstance(vertices, dict):
            vertex_ids = sorted([int(v) for v in vertices.keys()])
        elif isinstance(vertices, list):
            vertex_ids = sorted([int(v.get('id', v)) for v in vertices])
        else:
            vertex_ids = []
        
        if not vertex_ids:
            return {'success': True, 'matrix': {}}
        
        # Создаем матрицу
        matrix = {}
        for v in vertex_ids:
            matrix[v] = {}
            for v2 in vertex_ids:
                if v == v2:
                    matrix[v][v2] = 0
                else:
                    matrix[v][v2] = None
        
        # Заполняем веса ребер
        for edge in edges:
            frm = int(edge['from'])
            to = int(edge['to'])
            weight = edge.get('weight', edge.get('distance', 100))
            
            if frm in matrix and to in matrix[frm]:
                matrix[frm][to] = weight
                matrix[to][frm] = weight
        
        return {
            'success': True,
            'matrix': matrix,
            'vertices': vertex_ids
        }
    except Exception as e:
        print(f"Error in get_weight_matrix: {str(e)}")
        return {'success': False, 'error': str(e)}