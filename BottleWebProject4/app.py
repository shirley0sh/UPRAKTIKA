# -*- coding: utf-8 -*-
from bottle import Bottle, run, static_file, template, request, response
import json
import math
import random
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

@app.route('/kruskal')
def kruskal_page():
    return template('kruskal')

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

@app.route('/api/graph', method='GET')
def get_graph():
    response.content_type = 'application/json'
    return json.dumps(graph.to_dict())

@app.route('/api/graph/update', method='POST')
def update_graph():
    data = request.json
    graph.from_dict(data)
    dijkstra_graph.from_dict(data)
    response.content_type = 'application/json'
    return json.dumps({'success': True})

@app.route('/api/graph/vertex', method='POST')
def add_vertex():
    data = request.json
    vid = graph.next_id
    graph.add_vertex(vid, data['x'], data['y'])
    dijkstra_graph.add_vertex(vid, data['x'], data['y'])
    response.content_type = 'application/json'
    return json.dumps({'id': vid, 'x': data['x'], 'y': data['y']})

@app.route('/api/graph/vertex/<vid>', method='DELETE')
def remove_vertex(vid):
    graph.remove_vertex(int(vid))
    dijkstra_graph.remove_vertex(int(vid))
    response.content_type = 'application/json'
    return json.dumps({'success': True})

@app.route('/api/graph/vertex/<vid>/position', method='PUT')
def update_vertex_position(vid):
    data = request.json
    graph.update_vertex_position(int(vid), data['x'], data['y'])
    dijkstra_graph.update_vertex_position(int(vid), data['x'], data['y'])
    response.content_type = 'application/json'
    return json.dumps({'success': True})

@app.route('/api/graph/edge', method='POST')
def add_edge():
    data = request.json
    success = graph.add_edge(data['v1'], data['v2'], data.get('distance'))
    if success:
        dijkstra_graph.add_edge(data['v1'], data['v2'], data.get('distance'))
    response.content_type = 'application/json'
    return json.dumps({'success': success})

@app.route('/api/graph/edge', method='DELETE')
def remove_edge():
    data = request.json
    success = graph.remove_edge(data['v1'], data['v2'])
    if success:
        dijkstra_graph.remove_edge(data['v1'], data['v2'])
    response.content_type = 'application/json'
    return json.dumps({'success': success})

@app.route('/api/graph/edge/distance', method='PUT')
def set_edge_distance():
    data = request.json
    success = graph.set_edge_distance(data['v1'], data['v2'], data['distance'])
    if success:
        dijkstra_graph.set_edge_distance(data['v1'], data['v2'], data['distance'])
    response.content_type = 'application/json'
    return json.dumps({'success': success, 'distance': data['distance']})

@app.route('/api/graph/random-distances', method='POST')
def random_distances():
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

# ============ API ДЛЯ АЛГОРИТМА ФЛОЙДА ============

@app.route('/api/floyd/shortest-paths', method='GET')
def floyd_shortest_paths():
    result = graph.floyd_warshall()
    response.content_type = 'application/json'
    return json.dumps(result)

# ============ API ДЛЯ АЛГОРИТМА ДЕЙКСТРЫ ============

@app.route('/api/dijkstra/calculate', method='POST')
def dijkstra_calculate():
    data = request.json
    source = data.get('source')
    if source is None:
        response.status = 400
        return json.dumps({'error': 'Source vertex required'})

    result = dijkstra_graph.dijkstra(source)
    response.content_type = 'application/json'
    return json.dumps(result)

if __name__ == '__main__':
    print("=" * 50)
    print("Graphix - Graph Theory Visualization")
    print("=" * 50)
    print("Main page: http://localhost:8080")
    print("Floyd-Warshall: http://localhost:8080/floyd")
    print("Dijkstra: http://localhost:8080/dijkstra")
    print("=" * 50)
    run(app, host='localhost', port=8080, debug=True, reloader=True)
