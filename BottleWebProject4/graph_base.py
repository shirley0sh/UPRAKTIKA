# -*- coding: utf-8 -*-
import math
from typing import Dict, List, Tuple, Optional

class BaseGraph:
    def __init__(self):
        self.adjacency: Dict[int, Dict[int, float]] = {}
        self.points: Dict[int, Dict[str, float]] = {}
        self.next_id: int = 1

    def add_vertex(self, vertex_id: int, x: float, y: float) -> bool:
        """Добавление вершины"""
        if vertex_id not in self.adjacency and vertex_id not in self.points:
            self.adjacency[vertex_id] = {}
            self.points[vertex_id] = {'x': x, 'y': y}
            if vertex_id >= self.next_id:
                self.next_id = vertex_id + 1
            return True
        return False

    def update_vertex_position(self, vertex_id: int, x: float, y: float) -> bool:
        """Обновление позиции вершины"""
        if vertex_id in self.points:
            self.points[vertex_id] = {'x': x, 'y': y}
            return True
        return False

    def remove_vertex(self, vertex_id: int) -> bool:
        """Удаление вершины"""
        if vertex_id in self.adjacency:
            for neighbor in list(self.adjacency[vertex_id].keys()):
                if neighbor in self.adjacency:
                    del self.adjacency[neighbor][vertex_id]
            del self.adjacency[vertex_id]
            if vertex_id in self.points:
                del self.points[vertex_id]
            return True
        return False

    def add_edge(self, v1: int, v2: int, distance: float = None) -> bool:
        """Добавление ребра"""
        if v1 == v2:
            return False

        if v1 not in self.adjacency:
            self.adjacency[v1] = {}
        if v2 not in self.adjacency:
            self.adjacency[v2] = {}

        if distance is None:
            if v1 in self.points and v2 in self.points:
                p1 = self.points[v1]
                p2 = self.points[v2]
                distance = math.sqrt((p1['x'] - p2['x'])**2 + (p1['y'] - p2['y'])**2)
            else:
                distance = 0

        if v2 in self.adjacency[v1]:
            return False

        self.adjacency[v1][v2] = distance
        self.adjacency[v2][v1] = distance
        return True

    def remove_edge(self, v1: int, v2: int) -> bool:
        """Удаление ребра"""
        if v1 in self.adjacency and v2 in self.adjacency[v1]:
            del self.adjacency[v1][v2]
            del self.adjacency[v2][v1]
            return True
        return False

    def set_edge_distance(self, v1, v2, distance):
        """
        Устанавливает вес ребра. Если ребра нет и вес не бесконечность, создает его.
        """
        # Если это петля (v1 == v2), игнорируем
        if v1 == v2:
            return False

        # Если вес Infinity, мы хотим удалить ребро, если оно есть
        if distance == float('inf'):
            return self.remove_edge(v1, v2)

        # Пробуем обновить существующий вес
        if v1 in self.adjacency and v2 in self.adjacency[v1]:
            self.adjacency[v1][v2] = distance
            return True

        # Если ребра не было и вес - число, создаем новое ребро
        else:
            # Используем существующий метод add_edge
            return self.add_edge(v1, v2, distance)

    def get_edge_distance(self, v1: int, v2: int) -> Optional[float]:
        """Получение расстояния между вершинами"""
        if v1 in self.adjacency and v2 in self.adjacency[v1]:
            return self.adjacency[v1][v2]
        return None

    def get_neighbors(self, vertex_id: int) -> Dict[int, float]:
        """Получение соседей вершины"""
        return self.adjacency.get(vertex_id, {}).copy()

    def get_all_vertices(self) -> List[int]:
        """Получение всех вершин"""
        return list(self.adjacency.keys())

    def get_edges(self) -> List[Dict]:
        """Получение всех ребер"""
        edges = []
        seen = set()
        for v1 in self.adjacency:
            for v2, dist in self.adjacency[v1].items():
                key = tuple(sorted([v1, v2]))
                if key not in seen:
                    seen.add(key)
                    edges.append({'from': v1, 'to': v2, 'distance': dist})
        return edges

    def get_vertex_count(self) -> int:
        """Количество вершин"""
        return len(self.adjacency)

    def get_edge_count(self) -> int:
        """Количество ребер"""
        return len(self.get_edges())

    def clear(self) -> None:
        """Очистка графа"""
        self.adjacency.clear()
        self.points.clear()
        self.next_id = 1

    def to_dict(self) -> Dict:
        """Преобразование в словарь"""
        return {
            'vertices': {str(v): self.points[v] for v in self.adjacency.keys()},
            'edges': self.get_edges(),
            'next_id': self.next_id
        }

    def from_dict(self, data: Dict) -> None:
        """Загрузка из словаря"""
        self.clear()
        if 'vertices' in data:
            for v_str, point in data['vertices'].items():
                v = int(v_str)
                self.adjacency[v] = {}
                self.points[v] = {'x': point['x'], 'y': point['y']}
                if v >= self.next_id:
                    self.next_id = v + 1

        if 'edges' in data:
            for edge in data['edges']:
                self.add_edge(edge['from'], edge['to'], edge.get('distance'))
