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

