# -*- coding: utf-8 -*-
from typing import Dict, List, Tuple, Optional
from graph_base import BaseGraph


class PrimaGraph(BaseGraph):

    def __init__(self):
        super().__init__()
        self._mst_edges = None      # Рёбра минимального остовного дерева
        self._total_weight = None   # Общий вес MST
        self._start_vertex = None   # Начальная вершина




    

    def prim_mst(self, start_vertex: int) -> Dict:
        
        # Получаем все вершины
        vertices = self.get_all_vertices()
        
        # Проверки
        if not vertices:
            return {
                'success': False,
                'error': 'Graf ne soderzhit vershin',
                'edges': [],
                'total_weight': 0,
                'vertex_count': 0,
                'edge_count': 0,
                'start_vertex': start_vertex
            }
        
        if start_vertex not in vertices:
            return {
                'success': False,
                'error': f'Vershina {start_vertex} ne naidena v grafe',
                'edges': [],
                'total_weight': 0,
                'vertex_count': len(vertices),
                'edge_count': 0,
                'start_vertex': start_vertex
            }
        
        # Строим список смежности из self.adjacency
        adj = self._build_adjacency_list()
        
        # Алгоритм Прима
        in_mst = {start_vertex}
        mst_edges = []
        total_weight = 0.0
        
        while len(in_mst) < len(vertices):
            min_edge = None
            min_weight = float('inf')
            
            # Ищем минимальное ребро из MST во внешнюю вершину
            for u in in_mst:
                for v, weight in adj.get(u, []):
                    if v not in in_mst and weight < min_weight:
                        min_weight = weight
                        min_edge = {
                            'from': u,
                            'to': v,
                            'weight': weight
                        }
            
            # Если не нашли ребро - граф несвязный
            if min_edge is None:
                return {
                    'success': False,
                    'error': 'Graf ne yavlyaetsya svyznim. Nevozmozhno postroit ostovnoe derevo.',
                    'edges': [],
                    'total_weight': 0,
                    'vertex_count': len(vertices),
                    'edge_count': 0,
                    'start_vertex': start_vertex
                }
            
            mst_edges.append(min_edge)
            total_weight += min_weight
            in_mst.add(min_edge['to'])
        
        # Сохраняем результаты
        self._mst_edges = mst_edges
        self._total_weight = round(total_weight, 2)
        self._start_vertex = start_vertex
        
        return {
            'success': True,
            'error': None,
            'edges': mst_edges,
            'total_weight': round(total_weight, 2),
            'vertex_count': len(vertices),
            'edge_count': len(mst_edges),
            'start_vertex': start_vertex
        }
    
    def _build_adjacency_list(self) -> Dict[int, List[Tuple[int, float]]]:
        
        adj = {v: [] for v in self.get_all_vertices()}
        
        for v1 in self.adjacency:
            for v2, weight in self.adjacency[v1].items():
                adj[v1].append((v2, weight))
                # Граф неориентированный, добавляем в обе стороны
                if v2 not in adj:
                    adj[v2] = []
                # Но self.adjacency уже содержит обе стороны?
                # Добавим проверку чтобы не дублировать
                # В BaseGraph обычно adjacency неориентированный
        
        # Убираем дубликаты (если есть)
        for v in adj:
            adj[v] = list(set(adj[v]))
        
        return adj
    
    def get_mst(self) -> Tuple[Optional[List[Dict]], Optional[float]]:
        
        return self._mst_edges, self._total_weight
    
    def get_mst_edges_list(self) -> List[Dict]:
        
        return self._mst_edges if self._mst_edges else []
    
    def get_total_weight(self) -> Optional[float]:
        
        return self._total_weight
    
    def is_connected(self) -> bool:
        
        vertices = self.get_all_vertices()
        if not vertices:
            return True
        
        # Обход в глубину
        visited = set()
        start = next(iter(vertices))
        self._dfs(start, visited)
        
        return len(visited) == len(vertices)
    
    def _dfs(self, vertex: int, visited: set) -> None:
        
        visited.add(vertex)
        
        for neighbor in self.adjacency.get(vertex, {}):
            if neighbor not in visited:
                self._dfs(neighbor, visited)
    
    def get_statistics(self) -> Dict:
        
        vertices = self.get_all_vertices()
        edges = self.get_all_edges()
        
        if edges:
            weights = [edge['weight'] for edge in edges]
            min_weight = min(weights)
            max_weight = max(weights)
            avg_weight = sum(weights) / len(weights)
        else:
            min_weight = max_weight = avg_weight = 0
        
        return {
            'vertex_count': len(vertices),
            'edge_count': len(edges),
            'min_weight': round(min_weight, 2) if min_weight else 0,
            'max_weight': round(max_weight, 2) if max_weight else 0,
            'avg_weight': round(avg_weight, 2) if avg_weight else 0,
            'is_connected': self.is_connected()
        }



# Функция для удобного вызова (как в твоём prim.py)
def find_minimum_spanning_tree(vertices, edges, start_vertex):
    
    # Строим список смежности
    if isinstance(vertices, dict):
        vertex_list = list(vertices.keys())
    else:
        vertex_list = list(vertices)
    
    adj = {v: [] for v in vertex_list}
    for edge in edges:
        frm, to, w = edge['from'], edge['to'], edge['weight']
        adj[frm].append((to, w))
        adj[to].append((frm, w))
    
    # Алгоритм Прима
    if start_vertex not in adj:
        return {
            'success': False,
            'error': f'Vershina {start_vertex} ne naidena',
            'edges': [],
            'total_weight': 0
        }
    
    in_mst = {start_vertex}
    mst_edges = []
    total_weight = 0
    
    while len(in_mst) < len(vertex_list):
        min_edge = None
        min_w = float('inf')
        
        for u in in_mst:
            for v, w in adj.get(u, []):
                if v not in in_mst and w < min_w:
                    min_w = w
                    min_edge = {'from': u, 'to': v, 'weight': w}
        
        if min_edge is None:
            return {
                'success': False,
                'error': 'Graf ne yavlyaetsya svyaznim',
                'edges': [],
                'total_weight': 0
            }
        
        mst_edges.append(min_edge)
        total_weight += min_w
        in_mst.add(min_edge['to'])
    
    return {
        'success': True,
        'edges': mst_edges,
        'total_weight': round(total_weight, 2)
    }