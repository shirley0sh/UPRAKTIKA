import unittest
from algorithms.dijkstra import dijkstra, get_all_paths, calculate_paths

class TestDijkstraAlgorithm(unittest.TestCase):

    def setUp(self):
        # Простой граф: 1--2 (вес 3), 1--3 (вес 1), 2--3 (вес 1)
        self.simple_matrix = [
            [],
            [0, 0, 3, 1],
            [0, 3, 0, 1],
            [0, 1, 1, 0] 
        ]

        # Граф с изолированной вершиной
        self.disconnected_matrix = [
            [],
            [0, 0, 2, 0],
            [0, 2, 0, 0],
            [0, 0, 0, 0]
        ]

        # Линейный граф: 1--2--3--4 (все веса = 1)
        self.linear_matrix = [
            [],
            [0, 0, 1, 0, 0],
            [0, 1, 0, 1, 0],
            [0, 0, 1, 0, 1],
            [0, 0, 0, 1, 0]
        ]

    def test_dijkstra_simple_graph(self):
        result = dijkstra(self.simple_matrix, start=1)

        # Ожидаемые расстояния: до 1=0, до 2=2 (1→3→2), до 3=1 (1→3)
        expected_dist = [float('inf'), 0, 2, 1]
        self.assertEqual(result['dist'], expected_dist)

        # Проверка prev:
        self.assertIn(3, result['prev'][2])
        self.assertIn(1, result['prev'][3])

    def test_dijkstra_disconnected_vertex(self):
        result = dijkstra(self.disconnected_matrix, start=1)

        self.assertEqual(result['dist'][3], float('inf'))
        
        self.assertEqual(result['dist'][2], 2)


    def test_dijkstra_start_equals_end(self):
        result = dijkstra(self.simple_matrix, start=2)
        
        self.assertEqual(result['dist'][2], 0)


    def test_get_all_paths_direct_connection(self):
        
        result = dijkstra(self.simple_matrix, start=1)
        paths = get_all_paths(result['prev'], start=1, end=3)
        self.assertEqual(paths, [[1, 3]])


    def test_get_all_paths_multiple_paths(self):
       
        matrix = [
            [],
            [0, 0, 1, 1, 0],
            [0, 1, 0, 0, 1],
            [0, 1, 0, 0, 1],
            [0, 0, 1, 1, 0]
        ]
        result = dijkstra(matrix, start=1)
        paths = get_all_paths(result['prev'], start=1, end=4)

        expected = [[1, 2, 4], [1, 3, 4]]
        self.assertEqual(sorted(paths), sorted(expected))

    def test_get_all_paths_unreachable(self):
        result = dijkstra(self.disconnected_matrix, start=1)
        paths = get_all_paths(result['prev'], start=1, end=3)
        
        self.assertEqual(paths, [])


    def test_get_all_paths_start_equals_end(self):
        paths = get_all_paths([[]], start=1, end=1)
        self.assertEqual(paths, [[1]])


    def test_calculate_paths_disconnected(self):
        result = calculate_paths(self.disconnected_matrix, start=1)

        # Проверяем расстояния
        self.assertEqual(result['dist'][0], 0)
        self.assertEqual(result['dist'][1], 2)
        self.assertEqual(result['dist'][2], float('inf'))

        # Проверяем пути
        self.assertIn([1], result['paths'][1])
        self.assertIn([1, 2], result['paths'][2])
        self.assertEqual(result['paths'][3], []) 

    

    def test_calculate_paths_linear_graph(self):
        result = calculate_paths(self.linear_matrix, start=1)

        self.assertEqual(result['dist'], [0, 1, 2, 3])
        self.assertEqual(result['paths'][4], [[1, 2, 3, 4]])



    def test_calculate_paths_disconnected(self):
        result = calculate_paths(self.disconnected_matrix, start=1)

        self.assertEqual(result['dist'][0], 0)
        self.assertEqual(result['dist'][1], 2)
        self.assertEqual(result['dist'][2], float('inf'))

        
        self.assertIn([1], result['paths'][1])
        self.assertIn([1, 2], result['paths'][2])
        self.assertEqual(result['paths'][3], [])


    def test_dijkstra_custom(self):
        custom_matrix = [
            [],
            [0, 0, 3, 1],
            [0, 3, 0, 1],
            [0, 1, 1, 0] 
        ]

        expected_dist = [0, 2, 1]

        expected_paths = {
            1: [[1]],
            2: [[1, 3, 2]],
            3: [[1, 3]]
        }

        result = calculate_paths(custom_matrix, start=1)

        self.assertEqual(result['dist'], expected_dist)

        for vertex, paths in expected_paths.items():
            for path in paths:
                self.assertIn(path, result['paths'][vertex])




if __name__ == '__main__':
    unittest.main()

