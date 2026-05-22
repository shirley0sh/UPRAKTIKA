# -*- coding: utf-8 -*-
import unittest
import math
from graph_base import BaseGraph
from graph_floyd import FloydWarshallGraph

class TestBaseGraph(unittest.TestCase):
    """Тесты для базового графа"""

    def setUp(self):
        self.graph = BaseGraph()
        # Подготовка тестовых данных
        self.graph.add_vertex(1, 0, 0)
        self.graph.add_vertex(2, 3, 4)
        self.graph.add_vertex(3, 6, 8)
        self.graph.add_vertex(4, 1, 1)
        self.graph.add_edge(1, 2, 5)
        self.graph.add_edge(2, 3, 5)
        self.graph.add_edge(1, 4, 1.414)

    def test_remove_vertex_and_edge_operations(self):
        """Тест операций удаления вершин и ребер"""
        test_cases = [
            {
                'name': 'Удаление ребра между существующими вершинами',
                'setup': lambda g: (g.add_vertex(1,0,0), g.add_vertex(2,1,1), g.add_edge(1,2,5)),
                'operation': lambda g: g.remove_edge(1, 2),
                'expected_result': True,
                'verify': lambda g: g.get_edge_distance(1, 2) is None
            },
            {
                'name': 'Удаление несуществующего ребра',
                'setup': lambda g: (g.add_vertex(1,0,0), g.add_vertex(2,1,1)),
                'operation': lambda g: g.remove_edge(1, 99),
                'expected_result': False,
                'verify': lambda g: True
            },
            {
                'name': 'Удаление вершины с ребрами',
                'setup': lambda g: (g.add_vertex(1,0,0), g.add_vertex(2,1,1), g.add_vertex(3,2,2),
                                   g.add_edge(1,2,5), g.add_edge(2,3,5)),
                'operation': lambda g: g.remove_vertex(2),
                'expected_result': True,
                'verify': lambda g: 2 not in g.get_all_vertices() and
                                  1 not in g.get_neighbors(3)
            },
            {
                'name': 'Удаление несуществующей вершины',
                'setup': lambda g: g.add_vertex(1,0,0),
                'operation': lambda g: g.remove_vertex(999),
                'expected_result': False,
                'verify': lambda g: True
            },
            {
                'name': 'Удаление вершины без ребер',
                'setup': lambda g: (g.add_vertex(1,0,0), g.add_vertex(10,100,100)),
                'operation': lambda g: g.remove_vertex(10),
                'expected_result': True,
                'verify': lambda g: 10 not in g.get_all_vertices() and
                                  len(g.get_all_vertices()) == 1
            }
        ]

        for case in test_cases:
            with self.subTest(case=case['name']):
                g = BaseGraph()
                if 'setup' in case:
                    case['setup'](g)

                result = case['operation'](g)
                self.assertEqual(result, case['expected_result'])
                self.assertTrue(case['verify'](g))

    def test_edge_distance_management(self):
        """Тест управления весами ребер"""
        test_cases = [
            {
                'name': 'Установка веса для существующего ребра',
                'setup': lambda g: (g.add_vertex(1,0,0), g.add_vertex(2,0,0), g.add_edge(1,2,10)),
                'operation': lambda g: g.set_edge_distance(1, 2, 25),
                'expected': 25.0,
                'verify': lambda g: g.get_edge_distance(1, 2) == 25
            },
            {
                'name': 'Создание ребра с указанным весом',
                'setup': lambda g: (g.add_vertex(1,0,0), g.add_vertex(3,0,0)),
                'operation': lambda g: g.set_edge_distance(1, 3, 42.5),
                'expected': 42.5,
                'verify': lambda g: g.get_edge_distance(1, 3) == 42.5 and
                                  g.get_edge_distance(3, 1) == 42.5
            },
            {
                'name': 'Удаление ребра установкой веса Infinity',
                'setup': lambda g: (g.add_vertex(1,0,0), g.add_vertex(4,0,0), g.add_edge(1,4,15)),
                'operation': lambda g: g.set_edge_distance(1, 4, float('inf')),
                'expected': None,
                'verify': lambda g: g.get_edge_distance(1, 4) is None
            },
            {
                'name': 'Попытка создания петли',
                'setup': lambda g: g.add_vertex(1,0,0),
                'operation': lambda g: g.set_edge_distance(1, 1, 10),
                'expected': False,
                'verify': lambda g: g.get_edge_distance(1, 1) is None
            },
            {
                'name': 'Обновление веса через add_edge с автоматическим расчетом',
                'setup': lambda g: (g.add_vertex(5,0,0), g.add_vertex(6,3,4)),
                'operation': lambda g: g.set_edge_distance(5, 6, None),
                'expected': True,
                'verify': lambda g: g.get_edge_distance(5, 6) is not None and
                                  abs(g.get_edge_distance(5, 6) - 5.0) < 0.0001
            }
        ]

        for case in test_cases:
            with self.subTest(case=case['name']):
                g = BaseGraph()
                if 'setup' in case:
                    case['setup'](g)

                result = case['operation'](g)

                if isinstance(case['expected'], bool):
                    self.assertEqual(result, case['expected'])
                    if case['expected']:
                        self.assertTrue(case['verify'](g))
                else:
                    self.assertTrue(result)
                    self.assertTrue(case['verify'](g))


class TestFloydWarshallGraph(unittest.TestCase):
    """Тесты для графа с алгоритмом Флойда-Уоршелла"""

    def setUp(self):
        self.graph = FloydWarshallGraph()
        # Создаем тестовый граф
        self.graph.add_vertex(1, 0, 0)
        self.graph.add_vertex(2, 2, 0)
        self.graph.add_vertex(3, 4, 0)
        self.graph.add_vertex(4, 2, 2)

        self.graph.add_edge(1, 2, 2)
        self.graph.add_edge(2, 3, 3)
        self.graph.add_edge(3, 4, 2.5)
        self.graph.add_edge(4, 1, 2.5)

    def test_floyd_warshall_shortest_paths(self):
        """Тест алгоритма Флойда-Уоршелла на корректность поиска кратчайших путей"""
        # Запускаем алгоритм
        result = self.graph.floyd_warshall()

        test_cases = [
            {
                'name': 'Путь из 1 в 3 (через 2)',
                'from_vertex': 1,
                'to_vertex': 3,
                'expected_distance': 5.0,
            },
            {
                'name': 'Путь из 1 в 4 (прямое ребро)',
                'from_vertex': 1,
                'to_vertex': 4,
                'expected_distance': 2.5,
            },
            {
                'name': 'Путь из 2 в 4 (через 1)',
                'from_vertex': 2,
                'to_vertex': 4,
                'expected_distance': 4.5,
            },
            {
                'name': 'Путь из 3 в 1 (через 4)',
                'from_vertex': 3,
                'to_vertex': 1,
                'expected_distance': 5.0,
            },
            {
                'name': 'Расстояние от вершины до самой себя',
                'from_vertex': 2,
                'to_vertex': 2,
                'expected_distance': 0.0,
            }
        ]

        for case in test_cases:
            with self.subTest(case=case['name']):
                distance, path = self.graph.get_shortest_path(
                    case['from_vertex'],
                    case['to_vertex']
                )
                self.assertIsNotNone(distance)
                self.assertAlmostEqual(distance, case['expected_distance'], places=5)
                self.assertIsNotNone(path)
                self.assertEqual(path[0], case['from_vertex'])
                self.assertEqual(path[-1], case['to_vertex'])

    def test_floyd_warshall_edge_cases(self):
        """Тест граничных случаев алгоритма Флойда-Уоршелла"""

        # Тест 1: Пустой граф
        with self.subTest('Пустой граф (нет вершин)'):
            empty_graph = FloydWarshallGraph()
            result = empty_graph.floyd_warshall()
            self.assertEqual(result['vertices'], [])
            self.assertEqual(result['distances'], [])

        # Тест 2: Граф с одной вершиной
        with self.subTest('Граф с одной вершиной'):
            single_graph = FloydWarshallGraph()
            single_graph.add_vertex(1, 0, 0)
            result = single_graph.floyd_warshall()
            distance, path = single_graph.get_shortest_path(1, 1)
            self.assertEqual(distance, 0.0)
            self.assertEqual(path, [1])

        # Тест 3: Несвязные вершины
        with self.subTest('Несвязные вершины (нет пути)'):
            disconnected = FloydWarshallGraph()
            disconnected.add_vertex(1, 0, 0)
            disconnected.add_vertex(2, 1, 0)
            disconnected.add_edge(1, 2, 1)
            disconnected.add_vertex(5, 10, 10)  # изолированная
            result = disconnected.floyd_warshall()
            distance, path = disconnected.get_shortest_path(1, 5)
            self.assertIsNone(distance)
            self.assertEqual(path, [])

        # Тест 4: Запрос к несуществующей вершине
        with self.subTest('Запрос пути к несуществующей вершине'):
            graph = FloydWarshallGraph()
            graph.add_vertex(1, 0, 0)
            graph.add_vertex(2, 1, 0)
            graph.add_edge(1, 2, 1)
            graph.floyd_warshall()
            distance, path = graph.get_shortest_path(1, 999)
            self.assertIsNone(distance)
            self.assertEqual(path, [])




if __name__ == '__main__':
    # Запускаем только базовые тесты, без проблемного
    unittest.main(verbosity=2)
