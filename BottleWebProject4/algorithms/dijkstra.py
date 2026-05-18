# -*- coding: utf-8 -*-
import json

def dijkstra(matrix, start):
    """
    Реализация алгоритма Дейкстры
    
    Args:
        matrix: список списков, матрица весов (1-индексация)
        start: int, стартовая вершина
    
    Returns:
        dict: {'dist': [список расстояний], 'prev': [список предыдущих вершин]}
    """
    n = len(matrix) - 1
    dist = [float('inf')] * (n + 1)
    visited = [False] * (n + 1)
    prev = [None] * (n + 1)
    
    dist[start] = 0
    
    for _ in range(n):
        min_dist = float('inf')
        u = -1
        for v in range(1, n + 1):
            if not visited[v] and dist[v] < min_dist:
                min_dist = dist[v]
                u = v
        
        if u == -1:
            break
        
        visited[u] = True
        
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
    """Восстановление пути из prev"""
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


def calculate_paths(matrix, start):
    """Вычисление всех кратчайших путей"""
    result = dijkstra(matrix, start)
    paths = {}
    n = len(matrix) - 1
    for v in range(1, n + 1):
        path = get_path(result['prev'], start, v)
        paths[v] = path
    output = {
        'dist': result['dist'][1:],
        'prev': result['prev'][1:],
        'paths': paths
    }
    return output