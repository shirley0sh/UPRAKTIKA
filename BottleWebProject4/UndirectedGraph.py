# -*- coding: utf-8 -*-
import math
from typing import Dict, List, Tuple, Optional, Any

class UndirectedGraph:
    def __init__(self):
        # Structure: { vertex1: { vertex2: distance, vertex3: distance }, vertex2: {...} }
        self.adjacency: Dict[int, Dict[int, float]] = {}

    def add_vertex(self, vertex: int) -> None:
        """Add vertex to graph if not exists"""
        if vertex not in self.adjacency:
            self.adjacency[vertex] = {}

    def remove_vertex(self, vertex: int) -> None:
        """Remove vertex and all its edges"""
        if vertex in self.adjacency:
            # Remove all edges where this vertex is connected
            for neighbor in list(self.adjacency[vertex].keys()):
                if neighbor in self.adjacency:
                    del self.adjacency[neighbor][vertex]
            # Remove the vertex itself
            del self.adjacency[vertex]

    def add_edge(self, vertex1: int, vertex2: int, distance: float) -> bool:
        """
        Add edge between vertices with specified distance
        Returns True if edge added, False if already exists
        """
        if vertex1 == vertex2:
            return False

        # Add vertices if they don't exist
        self.add_vertex(vertex1)
        self.add_vertex(vertex2)

        # Check if edge already exists
        if vertex2 in self.adjacency[vertex1]:
            return False

        # Add edge in both directions (undirected graph)
        self.adjacency[vertex1][vertex2] = distance
        self.adjacency[vertex2][vertex1] = distance
        return True

    def remove_edge(self, vertex1: int, vertex2: int) -> bool:
        """Remove edge between vertices. Returns True if edge existed"""
        if vertex1 in self.adjacency and vertex2 in self.adjacency[vertex1]:
            del self.adjacency[vertex1][vertex2]
            del self.adjacency[vertex2][vertex1]
            return True
        return False

    def get_edge_distance(self, vertex1: int, vertex2: int) -> Optional[float]:
        """Return distance between vertices or None if edge doesn't exist"""
        if vertex1 in self.adjacency and vertex2 in self.adjacency[vertex1]:
            return self.adjacency[vertex1][vertex2]
        return None

    def get_neighbors(self, vertex: int) -> Dict[int, float]:
        """Return dictionary of vertex neighbors {vertex: distance}"""
        return self.adjacency.get(vertex, {}).copy()

    def get_all_vertices(self) -> List[int]:
        """Return list of all vertices in graph"""
        return list(self.adjacency.keys())

    def get_edges(self) -> List[Tuple[int, int, float]]:
        """
        Return list of all edges in format (vertex1, vertex2, distance)
        Each edge is returned only once
        """
        edges = []
        seen = set()

        for v1 in self.adjacency:
            for v2, dist in self.adjacency[v1].items():
                edge_key = tuple(sorted([v1, v2]))
                if edge_key not in seen:
                    seen.add(edge_key)
                    edges.append((v1, v2, dist))
        return edges

    def get_vertex_count(self) -> int:
        """Return number of vertices in graph"""
        return len(self.adjacency)

    def get_edge_count(self) -> int:
        """Return number of edges in graph"""
        return len(self.get_edges())

    def compute_euclidean_distance(self, point1: Tuple[float, float], point2: Tuple[float, float]) -> float:
        """Calculate Euclidean distance between two points"""
        return math.sqrt((point1[0] - point2[0])**2 + (point1[1] - point2[1])**2)

    def clear(self) -> None:
        """Clear the graph"""
        self.adjacency.clear()

    def floyd_warshall(self) -> Tuple[Dict[Tuple[int, int], float], Dict[Tuple[int, int], List[int]]]:
        """
        Floyd-Warshall algorithm for finding shortest paths between all pairs of vertices.

        Returns:
            distances: Dictionary mapping (from, to) -> shortest distance
            paths: Dictionary mapping (from, to) -> list of vertices in the shortest path
        """
        vertices = sorted(self.get_all_vertices())
        n = len(vertices)
        vertex_to_idx = {v: i for i, v in enumerate(vertices)}
        idx_to_vertex = {i: v for i, v in enumerate(vertices)}

        # Initialize distance matrix with infinity
        INF = float('inf')
        dist = [[INF] * n for _ in range(n)]

        # Initialize next matrix for path reconstruction
        next_vertex = [[None] * n for _ in range(n)]

        # Set distance to self as 0
        for i in range(n):
            dist[i][i] = 0

        # Fill known edges
        for v1, neighbors in self.adjacency.items():
            i = vertex_to_idx[v1]
            for v2, distance in neighbors.items():
                j = vertex_to_idx[v2]
                if distance < dist[i][j]:
                    dist[i][j] = distance
                    next_vertex[i][j] = v2

        # Floyd-Warshall algorithm
        for k in range(n):
            for i in range(n):
                for j in range(n):
                    if dist[i][k] + dist[k][j] < dist[i][j]:
                        dist[i][j] = dist[i][k] + dist[k][j]
                        next_vertex[i][j] = next_vertex[i][k]

        # Convert matrices to dictionaries
        distances = {}
        paths = {}

        for i in range(n):
            for j in range(n):
                from_vertex = idx_to_vertex[i]
                to_vertex = idx_to_vertex[j]
                distances[(from_vertex, to_vertex)] = dist[i][j]

                # Reconstruct path
                if i == j:
                    paths[(from_vertex, to_vertex)] = [from_vertex]
                elif dist[i][j] == INF:
                    paths[(from_vertex, to_vertex)] = []
                else:
                    path = self._reconstruct_path(vertex_to_idx, idx_to_vertex, next_vertex, i, j)
                    paths[(from_vertex, to_vertex)] = path

        return distances, paths

    def _reconstruct_path(self, vertex_to_idx, idx_to_vertex, next_vertex, start_idx, end_idx):
        """Reconstruct path using next_vertex matrix"""
        if next_vertex[start_idx][end_idx] is None:
            return []

        path = [idx_to_vertex[start_idx]]
        while start_idx != end_idx:
            start_vertex = path[-1]
            next_vertex_id = next_vertex[vertex_to_idx[start_vertex]][end_idx]
            if next_vertex_id is None:
                return []
            path.append(next_vertex_id)
            start_idx = vertex_to_idx[next_vertex_id]

        return path

    def get_shortest_path(self, from_vertex: int, to_vertex: int) -> Tuple[float, List[int]]:
        """
        Get shortest path between two vertices using Floyd-Warshall.

        Returns:
            (distance, path) tuple where path is list of vertices from start to end
        """
        distances, paths = self.floyd_warshall()
        return distances.get((from_vertex, to_vertex), float('inf')), paths.get((from_vertex, to_vertex), [])

    def get_distance_matrix(self) -> Dict[str, Any]:
        """
        Get complete distance matrix with vertex labels.

        Returns:
            Dictionary with vertices, matrix, and path information
        """
        vertices = sorted(self.get_all_vertices())
        distances, paths = self.floyd_warshall()

        n = len(vertices)
        matrix = [[float('inf')] * n for _ in range(n)]
        path_matrix = [[None] * n for _ in range(n)]

        for i, v1 in enumerate(vertices):
            for j, v2 in enumerate(vertices):
                dist = distances.get((v1, v2), float('inf'))
                matrix[i][j] = dist
                path_matrix[i][j] = paths.get((v1, v2), [])

        return {
            'vertices': vertices,
            'matrix': matrix,
            'path_matrix': path_matrix,
            'has_paths': len(vertices) > 0
        }

    def __str__(self) -> str:
        """String representation of graph"""
        result = f"Graph with {self.get_vertex_count()} vertices and {self.get_edge_count()} edges:\n"
        for vertex in sorted(self.adjacency.keys()):
            neighbors = self.adjacency[vertex]
            if neighbors:
                neighbor_str = ", ".join([f"{n}({d:.2f})" for n, d in sorted(neighbors.items())])
                result += f"  {vertex} -> {neighbor_str}\n"
            else:
                result += f"  {vertex} -> (no connections)\n"
        return result

    def to_dict(self) -> Dict:
        """Convert graph to dictionary for saving"""
        return {
            'adjacency': {
                str(v): {str(n): d for n, d in neighbors.items()}
                for v, neighbors in self.adjacency.items()
            }
        }

    @classmethod
    def from_dict(cls, data: Dict) -> 'UndirectedGraph':
        """Restore graph from dictionary"""
        graph = cls()
        if 'adjacency' in data:
            for v_str, neighbors in data['adjacency'].items():
                v = int(v_str)
                graph.add_vertex(v)
                for n_str, dist in neighbors.items():
                    n = int(n_str)
                    graph.add_edge(v, n, dist)
        return graph
