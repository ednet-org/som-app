import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Breadth-First Search Algorithm', () {
    late BreadthFirstSearchAlgorithm<String> bfs;
    late GraphInput<String> graph;

    setUp(() {
      bfs = BreadthFirstSearchAlgorithm<String>();
      graph = GraphInput<String>();

      // Create a test graph:
      //     A
      //    / \
      //   B   C
      //  / \   \
      // D   E   F
      //      \ /
      //       G

      // Add nodes
      graph.addNode(GraphNode(id: 'A', data: 'Node A'));
      graph.addNode(GraphNode(id: 'B', data: 'Node B'));
      graph.addNode(GraphNode(id: 'C', data: 'Node C'));
      graph.addNode(GraphNode(id: 'D', data: 'Node D'));
      graph.addNode(GraphNode(id: 'E', data: 'Node E'));
      graph.addNode(GraphNode(id: 'F', data: 'Node F'));
      graph.addNode(GraphNode(id: 'G', data: 'Node G'));

      // Add edges
      graph.connect('A', 'B');
      graph.connect('A', 'C');
      graph.connect('B', 'D');
      graph.connect('B', 'E');
      graph.connect('C', 'F');
      graph.connect('E', 'G');
      graph.connect('F', 'G');
    });

    test('should have correct algorithm properties', () {
      expect(bfs.code, equals('bfs'));
      expect(bfs.name, equals('Breadth-First Search'));
      expect(bfs.providedBehaviors, contains('traversal'));
      expect(bfs.providedBehaviors, contains('exploration'));
      expect(bfs.providedBehaviors, contains('level-order'));
    });

    test('should traverse graph in breadth-first order', () {
      final input = BFSInput(graph: graph, startNodeId: 'A');

      final result = bfs.execute(input);

      expect(result.visitedNodes.length, equals(7));

      // Check BFS order - level by level
      expect(result.visitedNodes[0].id, equals('A')); // Level 0
      expect(['B', 'C'], contains(result.visitedNodes[1].id)); // Level 1
      expect(['B', 'C'], contains(result.visitedNodes[2].id)); // Level 1

      // Level 2 nodes should come after all Level 1 nodes
      const level2Start = 3;
      final level2Nodes = result.visitedNodes
          .sublist(level2Start, level2Start + 3)
          .map((n) => n.id)
          .toList();
      expect(level2Nodes, containsAll(['D', 'E', 'F']));
    });

    test('should calculate correct levels for each node', () {
      final input = BFSInput(graph: graph, startNodeId: 'A');

      final result = bfs.execute(input);

      expect(result.levels['A'], equals(0));
      expect(result.levels['B'], equals(1));
      expect(result.levels['C'], equals(1));
      expect(result.levels['D'], equals(2));
      expect(result.levels['E'], equals(2));
      expect(result.levels['F'], equals(2));
      expect(result.levels['G'], equals(3));
    });

    test('should find path to target node', () {
      final input = BFSInput(graph: graph, startNodeId: 'A', targetNodeId: 'G');

      final result = bfs.execute(input);

      expect(result.found, isTrue);
      expect(result.pathToTarget, isNotNull);
      expect(result.pathToTarget!.length, equals(4)); // A -> B -> E -> G
      expect(result.pathToTarget![0].id, equals('A'));
      expect(result.pathToTarget![1].id, equals('B'));
      expect(result.pathToTarget![2].id, equals('E'));
      expect(result.pathToTarget![3].id, equals('G'));
    });

    test('should handle disconnected components', () {
      // Add isolated node
      graph.addNode(GraphNode(id: 'H', data: 'Node H'));

      final input = BFSInput(graph: graph, startNodeId: 'A');

      final result = bfs.execute(input);

      // Should only visit connected component
      expect(result.visitedNodes.length, equals(7));
      expect(result.visitedNodes.map((n) => n.id), isNot(contains('H')));
    });

    test('should apply visitor function if provided', () {
      final visitedInOrder = <String>[];

      final input = BFSInput(
        graph: graph,
        startNodeId: 'A',
        visitor: (node, level) {
          visitedInOrder.add('${node.id}:$level');
        },
      );

      bfs.execute(input);

      expect(visitedInOrder, contains('A:0'));
      expect(visitedInOrder, contains('B:1'));
      expect(visitedInOrder, contains('C:1'));
      expect(visitedInOrder, contains('G:3'));
    });

    test('should handle non-existent start node', () {
      final input = BFSInput(graph: graph, startNodeId: 'Z');

      expect(() => bfs.execute(input), throwsA(isA<AlgorithmException>()));
    });

    test('should work with cyclic graphs', () {
      // Add cycle
      graph.connect('G', 'B');

      final input = BFSInput(graph: graph, startNodeId: 'A');

      final result = bfs.execute(input);

      // Should still visit each node only once
      expect(result.visitedNodes.length, equals(7));
      expect(result.visitedNodes.map((n) => n.id).toSet().length, equals(7));
    });

    test('should work with entities graph', () {
      final domain = Domain('TestDomain');
      final model = Model(domain, 'TestModel');
      final departmentConcept = Concept(model, 'Department');
      final employeeConcept = Concept(model, 'Employee');

      // Create child relationship
      Child(departmentConcept, employeeConcept, 'employees');

      // Create entities
      final company = Entities<DynamicEntity>();
      company.concept = departmentConcept;

      final dept1 = DynamicEntity.withConcept(departmentConcept);
      dept1.code = 'Engineering';

      final dept2 = DynamicEntity.withConcept(departmentConcept);
      dept2.code = 'Sales';

      final emp1 = DynamicEntity.withConcept(employeeConcept);
      emp1.code = 'John';

      final emp2 = DynamicEntity.withConcept(employeeConcept);
      emp2.code = 'Jane';

      company.add(dept1);
      company.add(dept2);
      company.add(emp1);
      company.add(emp2);

      // Create graph from entities
      final entityGraph = GraphInput.fromEntities(company);

      // BFS from dept1
      final input = BFSInput(
        graph: entityGraph,
        startNodeId: dept1.oid.toString(),
      );

      final dynamicBFS = BreadthFirstSearchAlgorithm<dynamic>();
      final result = dynamicBFS.execute(input);

      expect(result.visitedNodes, isNotEmpty);
      expect(result.levels[dept1.oid.toString()], equals(0));
    });

    test('should stop early when max depth is specified', () {
      final input = BFSInput(graph: graph, startNodeId: 'A', maxDepth: 2);

      final result = bfs.execute(input);

      // Should only visit nodes up to level 2
      expect(result.visitedNodes.length, equals(6)); // A, B, C, D, E, F
      expect(result.levels.values.every((level) => level <= 2), isTrue);
      expect(result.levels.containsKey('G'), isFalse); // G is at level 3
    });
  });
}
