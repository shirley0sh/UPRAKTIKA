# -*- coding: utf-8 -*-
import json

def dijkstra(matrix, start):
    n = len(matrix) - 1
    dist = [float('inf')] * (n + 1)
    visited = [False] * (n + 1)
    prev = [[] for _ in range(n + 1)]
    
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
                    prev[v] = [u] 
                elif new_dist == dist[v]:
                    prev[v].append(u) 
                    
    return {'dist': dist, 'prev': prev}


def get_all_paths(prev, start, end):
    """Возвращает список всех кратчайших путей от start до end"""
    if start == end:
        return [[start]]
    if not prev[end]:
        return []
        
    all_paths = []
    for p in prev[end]:
        for sub_path in get_all_paths(prev, start, p):
            all_paths.append(sub_path + [end])
    return all_paths


def calculate_paths(matrix, start):
    result = dijkstra(matrix, start)
    paths = {}
    n = len(matrix) - 1
    for v in range(1, n + 1):
        paths[v] = get_all_paths(result['prev'], start, v)
        
    return {
        'dist': result['dist'][1:],
        'prev': result['prev'][1:],
        'paths': paths
    }

