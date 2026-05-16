# -*- coding: utf-8 -*-
from typing import Dict, List, Tuple, Optional
from graph_base import BaseGraph

class DijkstraGraph(BaseGraph):
    """Класс графа с алгоритмом Дейкстры"""

    def __init__(self):
        super().__init__()
        self._distances = None
        self._previous = None
        self._source = None

    def dijkstra(self, source: int) -> Dict:
        """Алгоритм Дейкстры для поиска кратчайших путей от источника"""
        if source not in self.get_all_vertices():
            return {'error': f'Vertex {source} not found', 'vertices': []}

        self._source = source
        vertices = self.get_all_vertices()

        INF = float('inf')
        distances = {v: INF for v in vertices}
        distances[source] = 0
        previous = {v: None for v in vertices}

        unvisited = set(vertices)

        while unvisited:
            current = min(unvisited, key=lambda v: distances[v])

            if distances[current] == INF:
                break

            unvisited.remove(current)

            for neighbor, weight in self.get_neighbors(current).items():
                if neighbor in unvisited:
                    new_distance = distances[current] + weight
                    if new_distance < distances[neighbor]:
                        distances[neighbor] = new_distance
                        previous[neighbor] = current

        self._distances = distances
        self._previous = previous

        # Преобразуем для JSON
        result = []
        for v in sorted(vertices):
            result.append({
                'vertex': v,
                'distance': distances[v] if distances[v] != INF else None,
                'path': self.get_path_to(v, previous)
            })

        return {
            'source': source,
            'vertices': sorted(vertices),
            'results': result,
            'distances': distances,
            'previous': previous
        }

    def get_path_to(self, target: int, previous: Dict = None) -> List[int]:
        """Получение пути до целевой вершины"""
        if previous is None:
            previous = self._previous

        if previous is None or target not in previous:
            return []

        path = []
        current = target
        while current is not None:
            path.insert(0, current)
            current = previous.get(current)

        return path if len(path) > 1 else []

    def get_shortest_path(self, target: int) -> Tuple[Optional[float], List[int]]:
        """Получение кратчайшего пути до целевой вершины"""
        if self._distances is None:
            return (None, [])

        distance = self._distances.get(target)
        if distance is None or distance == float('inf'):
            return (None, [])

        path = self.get_path_to(target)
        return (distance, path)
