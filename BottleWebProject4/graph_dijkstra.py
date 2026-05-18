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

    def get_vertex_label(self, vid: int) -> int:
        """Получение метки вершины (для отображения)"""
        # Если есть метка в данных вершины, возвращаем её
        if hasattr(self, '_vertices') and vid in self._vertices:
            vertex_data = self._vertices[vid]
            if isinstance(vertex_data, dict) and 'label_index' in vertex_data:
                return vertex_data['label_index']
        # Иначе возвращаем сам id
        return vid

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
        for v in sorted(vertices, key=lambda x: self.get_vertex_label(x)):
            label = self.get_vertex_label(v)
            result.append({
                'vertex': label,
                'distance': distances[v] if distances[v] != INF else None,
                'path': self.get_path_to(v, previous)
            })

        return {
            'source': self.get_vertex_label(source),
            'vertices': sorted([self.get_vertex_label(v) for v in vertices]),
            'results': result,
            'distances': {self.get_vertex_label(k): v for k, v in distances.items() if v != INF},
            'previous': {self.get_vertex_label(k): self.get_vertex_label(v) if v else None 
                        for k, v in previous.items()}
        }

    def get_path_to(self, target: int, previous: Dict = None) -> List[int]:
        """Получение пути до целевой вершины (возвращает метки вершин)"""
        if previous is None:
            previous = self._previous

        if previous is None or target not in previous:
            return []

        path = []
        current = target
        while current is not None:
            path.insert(0, self.get_vertex_label(current))
            current = previous.get(current)

        # Возвращаем путь только если он не состоит из одной вершины
        return path if len(path) > 1 else path

    def get_shortest_path(self, target: int) -> Tuple[Optional[float], List[int]]:
        """Получение кратчайшего пути до целевой вершины""" 
        if self._distances is None:
            return (None, [])

        distance = self._distances.get(target)
        if distance is None or distance == float('inf'):
            return (None, [])

        path = self.get_path_to(target)
        return (distance, path)