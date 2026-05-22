# -*- coding: utf-8 -*-
from bottle import Bottle, run, static_file, template, request, response
import json
import math
import random
import traceback
from graph_floyd import FloydWarshallGraph
from graph_dijkstra import DijkstraGraph

app = Bottle()

# Создаем экземпляры графов
graph = FloydWarshallGraph()
dijkstra_graph = DijkstraGraph()

@app.route('/')
def index():
    return template('index')


@app.route('/floyd')
def floyd_page():
    return template('floyd')

@app.route('/dijkstra')
def dijkstra_page():
    return template('dijkstra')

@app.route('/feedback', method='POST')
def handle_feedback():
    email = request.forms.get('email', '').strip()
    question = request.forms.get('question', '').strip()

    if not email or not question:
        return template('message',
                       title='Error',
                       message='Please fill in both fields.')

    with open('feedback.txt', 'a', encoding='utf-8') as f:
        f.write(f"Email: {email}\nQuestion: {question}\n{'='*50}\n")

    return template('message',
                   title='Thank you!',
                   message=f'Your message has been sent. We will reply to {email}')

@app.route('/static/<filename:path>')
def send_static(filename):
    return static_file(filename, root='./static')

# ============ API ДЛЯ ГРАФА ============



@app.route('/api/graph/update', method='POST')
def update_graph():
    try:
        data = request.json
        graph.from_dict(data)
        dijkstra_graph.from_dict(data)
        response.content_type = 'application/json'
        return json.dumps({'success': True})
    except Exception as e:
        print(f"ERROR in update_graph: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph', method='GET')
def get_graph():
    try:
        response.content_type = 'application/json'
        return json.dumps(graph.to_dict())
    except Exception as e:
        print(f"ERROR in get_graph: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph/vertex', method='POST')
def add_vertex():
    try:
        data = request.json
        vid = graph.next_id
        graph.add_vertex(vid, data['x'], data['y'])
        dijkstra_graph.add_vertex(vid, data['x'], data['y'])
        response.content_type = 'application/json'
        return json.dumps({'id': vid, 'x': data['x'], 'y': data['y']})
    except Exception as e:
        print(f"ERROR in add_vertex: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph/vertex/<vid>', method='DELETE')
def remove_vertex(vid):
    try:
        graph.remove_vertex(int(vid))
        dijkstra_graph.remove_vertex(int(vid))
        response.content_type = 'application/json'
        return json.dumps({'success': True})
    except Exception as e:
        print(f"ERROR in remove_vertex: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph/vertex/<vid>/position', method='PUT')
def update_vertex_position(vid):
    try:
        data = request.json
        graph.update_vertex_position(int(vid), data['x'], data['y'])
        dijkstra_graph.update_vertex_position(int(vid), data['x'], data['y'])
        response.content_type = 'application/json'
        return json.dumps({'success': True})
    except Exception as e:
        print(f"ERROR in update_vertex_position: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph/edge', method='POST')
def add_edge():
    try:
        data = request.json
        success = graph.add_edge(data['v1'], data['v2'], data.get('distance'))
        if success:
            dijkstra_graph.add_edge(data['v1'], data['v2'], data.get('distance'))
        response.content_type = 'application/json'
        return json.dumps({'success': success})
    except Exception as e:
        print(f"ERROR in add_edge: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph/edge', method='DELETE')
def remove_edge():
    try:
        data = request.json
        success = graph.remove_edge(data['v1'], data['v2'])
        if success:
            dijkstra_graph.remove_edge(data['v1'], data['v2'])
        response.content_type = 'application/json'
        return json.dumps({'success': success})
    except Exception as e:
        print(f"ERROR in remove_edge: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph/edge/distance', method='PUT')
def set_edge_distance():
    try:
        data = request.json
        success = graph.set_edge_distance(data['v1'], data['v2'], data['distance'])
        if success:
            dijkstra_graph.set_edge_distance(data['v1'], data['v2'], data['distance'])
        response.content_type = 'application/json'
        return json.dumps({'success': success, 'distance': data['distance']})
    except Exception as e:
        print(f"ERROR in set_edge_distance: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/graph/random-distances', method='POST')
def random_distances():
    try:
        data = request.json
        min_val = float(data.get('min', 50))
        max_val = float(data.get('max', 500))

        edges = graph.get_edges()
        for edge in edges:
            random_dist = min_val + random.random() * (max_val - min_val)
            graph.set_edge_distance(edge['from'], edge['to'], random_dist)
            dijkstra_graph.set_edge_distance(edge['from'], edge['to'], random_dist)

        response.content_type = 'application/json'
        return json.dumps({'success': True, 'count': len(edges)})
    except Exception as e:
        print(f"ERROR in random_distances: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

# ============ API ДЛЯ АЛГОРИТМА ФЛОЙДА ============

@app.route('/api/floyd/paths-matrix', method='GET')
def get_matrix():
    """Возвращает матрицу смежности для редактирования"""
    try:
        print("DEBUG: Getting matrix...")

        # Получаем все вершины из графа
        vertices_list = graph.get_all_vertices()
        print(f"DEBUG: Raw vertices from get_all_vertices: {vertices_list}")

        if not vertices_list:
            print("DEBUG: No vertices found, returning empty matrix")
            response.content_type = 'application/json'
            return json.dumps({
                'vertices': [],
                'distances': []
            })

        # Сортируем вершины для консистентности
        vertices_list = sorted(vertices_list)
        print(f"DEBUG: Sorted vertices: {vertices_list}")

        n = len(vertices_list)

        # Создаем матрицу расстояний
        distances = [[None] * n for _ in range(n)]

        for i, v1 in enumerate(vertices_list):
            for j, v2 in enumerate(vertices_list):
                if i == j:
                    distances[i][j] = 0
                else:
                    try:
                        dist = graph.get_edge_distance(v1, v2)
                        if dist is None:
                            distances[i][j] = float('inf')
                        else:
                            distances[i][j] = dist
                    except Exception as e:
                        print(f"ERROR getting distance between {v1} and {v2}: {e}")
                        distances[i][j] = float('inf')

        # Конвертируем Infinity в None для JSON (чтобы не было проблем с сериализацией)
        distances_json = []
        for row in distances:
            json_row = []
            for val in row:
                if val == float('inf') or val is None:
                    json_row.append(None)
                else:
                    json_row.append(val)
            distances_json.append(json_row)

        result = {
            'vertices': vertices_list,
            'distances': distances_json
        }

        print(f"DEBUG: Returning result with {len(vertices_list)} vertices")
        response.content_type = 'application/json'
        return json.dumps(result)

    except Exception as e:
        print(f"ERROR in get_matrix: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

@app.route('/api/floyd/shortest-paths', method='GET')
def floyd_shortest_paths():
    """Возвращает результаты алгоритма Флойда-Уоршелла"""
    try:
        result = graph.floyd_warshall()
        response.content_type = 'application/json'
        return json.dumps(result)
    except Exception as e:
        print(f"ERROR in floyd_shortest_paths: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

# ============ МАРШРУТ ДЛЯ ПАКЕТНОГО ОБНОВЛЕНИЯ ============
@app.route('/api/graph/edge/distance/batch', method='POST')
def batch_set_edge_distance():
    """
    Принимает JSON-объект вида: {"A-B": 100, "C-D": Infinity, ...}
    и применяет все изменения.
    """
    try:
        data = request.json

        if not data:
            response.status = 400
            response.content_type = 'application/json'
            return json.dumps({'error': 'No data provided'})

        print(f"DEBUG: Batch update received: {data}")

        changes_applied = 0

        # Применяем каждое изменение по очереди
        for key, distance in data.items():
            # Разбиваем ключ "A-B" на вершины v1="A", v2="B"
            parts = key.split('-')
            if len(parts) != 2:
                continue

            # Конвертируем в int, так как вершины хранятся как числа
            try:
                v1 = int(parts[0])
                v2 = int(parts[1])
            except ValueError:
                print(f"WARNING: Could not convert {parts[0]} or {parts[1]} to int")
                continue

            # Обработка Infinity
            if distance == "Infinity" or distance == "∞" or distance == "inf" or distance is None or distance == "":
                distance = float('inf')
            else:
                try:
                    distance = float(distance)
                except (ValueError, TypeError):
                    print(f"WARNING: Invalid distance value for {key}: {distance}")
                    continue

            print(f"DEBUG: Setting distance between {v1} and {v2} to {distance}")

            # Устанавливаем расстояние
            success = graph.set_edge_distance(v1, v2, distance)

            # Обновляем и граф для Дейкстры
            if success:
                dijkstra_graph.set_edge_distance(v1, v2, distance)
                changes_applied += 1
                print(f"DEBUG: Successfully updated {v1}-{v2}")
            else:
                print(f"WARNING: Failed to update {v1}-{v2}")

        response.content_type = 'application/json'
        return json.dumps({'success': True, 'count': changes_applied})

    except Exception as e:
        print(f"ERROR in batch_set_edge_distance: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

# ============ API ДЛЯ АЛГОРИТМА ДЕЙКСТРЫ ============

@app.route('/api/dijkstra/calculate', method='POST')
def dijkstra_calculate():
    try:
        data = request.json
        source = data.get('source')
        if source is None:
            response.status = 400
            response.content_type = 'application/json'
            return json.dumps({'error': 'Source vertex required'})

        result = dijkstra_graph.dijkstra(source)
        response.content_type = 'application/json'
        return json.dumps(result)
    except Exception as e:
        print(f"ERROR in dijkstra_calculate: {e}")
        traceback.print_exc()
        response.status = 500
        response.content_type = 'application/json'
        return json.dumps({'error': str(e)})

if __name__ == '__main__':
    print("=" * 50)
    print("Graphix - Graph Theory Visualization")
    print("=" * 50)
    print("Main page: http://localhost:8080")
    print("Floyd-Warshall: http://localhost:8080/floyd")
    print("Dijkstra: http://localhost:8080/dijkstra")
    print("=" * 50)
    run(app, host='localhost', port=8080, debug=True, reloader=True)
