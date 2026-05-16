# -*- coding: utf-8 -*-
from typing import Dict, List, Tuple, Optional
from graph_base import BaseGraph

class FloydWarshallGraph(BaseGraph):
    """Класс графа с алгоритмом Флойда-Уоршелла"""

    def __init__(self):
        super().__init__()
        self._distances = None
        self._paths = None
        self._vertices = None

    def floyd_warshall(self) -> Dict:
        """Алгоритм Флойда-Уоршелла для поиска кратчайших путей"""
        vertices = sorted(self.get_all_vertices())
        n = len(vertices)

        if n == 0:
            return {
                'vertices': [],
                'distances': [],
                'paths': []
            }

        idx = {v: i for i, v in enumerate(vertices)}
        INF = float('inf')

        dist = [[INF] * n for _ in range(n)]
        next_v = [[None] * n for _ in range(n)]

        for i in range(n):
            dist[i][i] = 0

        for v1 in self.adjacency:
            for v2, d in self.adjacency[v1].items():
                i, j = idx[v1], idx[v2]
                if d < dist[i][j]:
                    dist[i][j] = d
                    next_v[i][j] = v2

        for k in range(n):
            for i in range(n):
                for j in range(n):
                    if dist[i][k] + dist[k][j] < dist[i][j]:
                        dist[i][j] = dist[i][k] + dist[k][j]
                        next_v[i][j] = next_v[i][k]

        paths = [[[] for _ in range(n)] for _ in range(n)]
        for i in range(n):
            for j in range(n):
                if i == j:
                    paths[i][j] = [vertices[i]]
                elif dist[i][j] != INF:
                    path = self._reconstruct_path(idx, next_v, i, j, vertices)
                    paths[i][j] = path

        self._vertices = vertices
        self._distances = dist
        self._paths = paths

        distances_json = []
        for i in range(len(dist)):
            row = []
            for j in range(len(dist[i])):
                if dist[i][j] == float('inf'):
                    row.append(None)
                else:
                    row.append(dist[i][j])
            distances_json.append(row)

        return {
            'vertices': vertices,
            'distances': distances_json,
            'paths': paths
        }

    def _reconstruct_path(self, idx, next_v, start, end, vertices):
        if next_v[start][end] is None:
            return []

        path = [vertices[start]]
        curr = start
        while curr != end:
            nxt = next_v[curr][end]
            if nxt is None:
                return []
            path.append(nxt)
            curr = idx[nxt]
        return path

    def get_shortest_path(self, from_vertex: int, to_vertex: int) -> Tuple[Optional[float], List[int]]:
        if self._vertices is None:
            self.floyd_warshall()

        try:
            i = self._vertices.index(from_vertex)
            j = self._vertices.index(to_vertex)
            distance = self._distances[i][j]
            path = self._paths[i][j]
            return (distance if distance != float('inf') else None, path)
        except ValueError:
            return (None, [])
