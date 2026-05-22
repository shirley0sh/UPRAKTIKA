import unittest
from algorithms.prim import find_minimum_spanning_tree

class TestPrimMST(unittest.TestCase):
    
    def test_empty_graph(self):
        """Empty graph"""
        result = find_minimum_spanning_tree({}, [], 1)
        self.assertFalse(result['success'])
        self.assertEqual(result['error'], 'Net vershin v grafe')
    
    def test_start_vertex_not_found(self):
        """No start verticle"""
        vertices = {1: {}, 2: {}}
        edges = [{'from': 1, 'to': 2, 'weight': 10}]
        result = find_minimum_spanning_tree(vertices, edges, 3)
        self.assertFalse(result['success'])
        self.assertIn('Vershina 3 ne naidena', result['error'])
    
    def test_disconnected_graph(self):
        """Nesvyazniy graph"""
        vertices = {1: {}, 2: {}, 3: {}}
        edges = [{'from': 1, 'to': 2, 'weight': 10}] 
        result = find_minimum_spanning_tree(vertices, edges, 1)
        self.assertFalse(result['success'])
        self.assertEqual(result['error'], 'Graf nesvyazniy')
    
    def test_single_vertex(self):
        """One vertice"""
        vertices = {1: {}}
        edges = []
        result = find_minimum_spanning_tree(vertices, edges, 1)
        self.assertTrue(result['success'])
        self.assertEqual(len(result['edges']), 0)
        self.assertEqual(result['total_weight'], 0)
    
    def test_simple_triangle(self):
        """Simple triangle all edges same lenght"""
        vertices = {1: {}, 2: {}, 3: {}}
        edges = [
            {'from': 1, 'to': 2, 'weight': 5},
            {'from': 2, 'to': 3, 'weight': 5},
            {'from': 3, 'to': 1, 'weight': 5}
        ]
        result = find_minimum_spanning_tree(vertices, edges, 1)
        self.assertTrue(result['success'])
        self.assertEqual(len(result['edges']), 2)
        self.assertEqual(result['total_weight'], 10)
    
    def test_different_weights(self):
        """Graph with different edges"""
        vertices = {1: {}, 2: {}, 3: {}, 4: {}}
        edges = [
            {'from': 1, 'to': 2, 'weight': 1},
            {'from': 1, 'to': 3, 'weight': 4},
            {'from': 1, 'to': 4, 'weight': 3},
            {'from': 2, 'to': 3, 'weight': 2},
            {'from': 3, 'to': 4, 'weight': 5}
        ]
        result = find_minimum_spanning_tree(vertices, edges, 1)
        self.assertTrue(result['success'])
        self.assertEqual(len(result['edges']), 3)
        self.assertEqual(result['total_weight'], 6)  # 1 + 2 + 3
    
    
    def test_float_weights(self):
        """Graph with double type edges"""
        vertices = {1: {}, 2: {}, 3: {}}
        edges = [
            {'from': 1, 'to': 2, 'weight': 1.5},
            {'from': 2, 'to': 3, 'weight': 2.3},
            {'from': 3, 'to': 1, 'weight': 3.7}
        ]
        result = find_minimum_spanning_tree(vertices, edges, 1)
        self.assertTrue(result['success'])
        self.assertEqual(len(result['edges']), 2)
        self.assertAlmostEqual(result['total_weight'], 3.8, places=2)  # 1.5 + 2.3
    
    def test_string_vertices(self):
        """Vertices with string input"""
        vertices = {'1': {}, '2': {}, '3': {}}
        edges = [
            {'from': '1', 'to': '2', 'weight': 10},
            {'from': '2', 'to': '3', 'weight': 20},
            {'from': '3', 'to': '1', 'weight': 30}
        ]
        result = find_minimum_spanning_tree(vertices, edges, '1')
        self.assertTrue(result['success'])
        self.assertEqual(len(result['edges']), 2)
        self.assertEqual(result['total_weight'], 30)  # 10 + 20
    
    def test_large_graph(self):
        """Big graph to find powerfull"""
        vertices = {i: {} for i in range(1, 6)}
        edges = []
        for i in range(1, 6):
            for j in range(i + 1, 6):
                edges.append({'from': i, 'to': j, 'weight': (i + j) % 10 + 1})
        result = find_minimum_spanning_tree(vertices, edges, 1)
        self.assertTrue(result['success'])
        self.assertEqual(len(result['edges']), 4)

    def test_10(self):
        vertices = {1: {}, 2: {}, 3: {}, 4: {}, 5: {}}
        edges = [
            {'from': 1, 'to': 2, 'weight': 10},
            {'from': 1, 'to': 3, 'weight': 5},
            {'from': 1, 'to': 4, 'weight': 3},

            {'from': 2, 'to': 3, 'weight': 1},
            {'from': 2, 'to': 4, 'weight': 3},

            {'from': 3, 'to': 4, 'weight': 2},
            {'from': 3, 'to': 5, 'weight': 4},

            {'from': 4, 'to': 5, 'weight': 7}
        ]
        result = find_minimum_spanning_tree(vertices, edges, 1)
        self.assertTrue(result['success'])
        self.assertEqual(len(result['edges']), 4)
        self.assertEqual(result['total_weight'], 10)


if __name__ == '__main__':
    unittest.main()
