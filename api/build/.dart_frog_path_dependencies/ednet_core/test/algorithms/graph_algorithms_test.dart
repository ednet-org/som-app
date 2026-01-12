import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Graph Infrastructure TDD Tests', () {
    group('🔗 GraphNode', () {
      test(
        'GIVEN: Node creation WHEN: Creating with data THEN: Properties set correctly',
        () {
          // Red: Test for basic node creation
          final node = GraphNode<String>(
            id: 'node1',
            data: 'test data',
            properties: {'type': 'test'},
          );

          expect(node.id, equals('node1'));
          expect(node.data, equals('test data'));
          expect(node.properties['type'], equals('test'));
        },
      );

      test(
        'GIVEN: Two nodes with same ID WHEN: Comparing THEN: Should be equal',
        () {
          final node1 = GraphNode<String>(id: 'same', data: 'data1');
          final node2 = GraphNode<String>(id: 'same', data: 'data2');

          expect(node1, equals(node2));
          expect(node1.hashCode, equals(node2.hashCode));
        },
      );

      test(
        'GIVEN: Nodes with different IDs WHEN: Comparing THEN: Should not be equal',
        () {
          final node1 = GraphNode<String>(id: 'different1', data: 'data');
          final node2 = GraphNode<String>(id: 'different2', data: 'data');

          expect(node1, isNot(equals(node2)));
        },
      );
    });

    group('🔗 GraphEdge', () {
      late GraphNode<String> source;
      late GraphNode<String> target;

      setUp(() {
        source = GraphNode<String>(id: 'source', data: 'source data');
        target = GraphNode<String>(id: 'target', data: 'target data');
      });

      test(
        'GIVEN: Edge creation WHEN: Creating with nodes THEN: Properties set correctly',
        () {
          final edge = GraphEdge<String>(
            source: source,
            target: target,
            weight: 2.5,
            type: 'test-edge',
            properties: {'category': 'test'},
          );

          expect(edge.source, equals(source));
          expect(edge.target, equals(target));
          expect(edge.weight, equals(2.5));
          expect(edge.type, equals('test-edge'));
          expect(edge.properties['category'], equals('test'));
        },
      );

      test(
        'GIVEN: Edge creation WHEN: No weight specified THEN: Default weight is 1.0',
        () {
          final edge = GraphEdge<String>(source: source, target: target);

          expect(edge.weight, equals(1.0));
        },
      );
    });

    group('📊 GraphInput', () {
      late GraphInput<String> graph;
      late GraphNode<String> node1, node2, node3;

      setUp(() {
        graph = GraphInput<String>();
        node1 = GraphNode<String>(id: 'node1', data: 'data1');
        node2 = GraphNode<String>(id: 'node2', data: 'data2');
        node3 = GraphNode<String>(id: 'node3', data: 'data3');
      });

      test(
        'GIVEN: Empty graph WHEN: Adding nodes THEN: Nodes are accessible',
        () {
          graph.addNode(node1);
          graph.addNode(node2);

          expect(graph.hasNode('node1'), isTrue);
          expect(graph.hasNode('node2'), isTrue);
          expect(graph.hasNode('nonexistent'), isFalse);
          expect(graph.nodeCount, equals(2));
          expect(graph.getNode('node1'), equals(node1));
        },
      );

      test(
        'GIVEN: Graph with nodes WHEN: Adding edges THEN: Edges are created correctly',
        () {
          graph.addNode(node1);
          graph.addNode(node2);

          final edge = GraphEdge<String>(
            source: node1,
            target: node2,
            weight: 3.0,
          );
          graph.addEdge(edge);

          expect(graph.edgeCount, equals(1));
          expect(graph.hasEdge('node1', 'node2'), isTrue);
          expect(graph.hasEdge('node2', 'node1'), isFalse);

          final neighbors = graph.getNeighbors('node1');
          expect(neighbors, contains(node2));
          expect(neighbors.length, equals(1));
        },
      );

      test(
        'GIVEN: Graph WHEN: Connecting nodes by ID THEN: Creates edges correctly',
        () {
          graph.addNode(node1);
          graph.addNode(node2);

          graph.connect('node1', 'node2', weight: 2.0, type: 'relationship');

          expect(graph.hasEdge('node1', 'node2'), isTrue);
          final edges = graph.getEdgesFrom('node1');
          expect(edges.length, equals(1));
          expect(edges.first.weight, equals(2.0));
          expect(edges.first.type, equals('relationship'));
        },
      );

      test('GIVEN: Nonexistent nodes WHEN: Connecting THEN: Throws error', () {
        graph.addNode(node1);

        expect(
          () => graph.connect('node1', 'nonexistent'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test(
        'GIVEN: Complex graph WHEN: Getting neighbors THEN: Returns correct nodes',
        () {
          graph.addNode(node1);
          graph.addNode(node2);
          graph.addNode(node3);

          graph.connect('node1', 'node2');
          graph.connect('node1', 'node3');

          final neighbors = graph.getNeighbors('node1');
          expect(neighbors.length, equals(2));
          expect(neighbors, contains(node2));
          expect(neighbors, contains(node3));

          expect(graph.getNeighbors('node2'), isEmpty);
        },
      );
    });

    group('🚀 Algorithm Base Class', () {
      test(
        'GIVEN: Algorithm execution WHEN: Running THEN: Tracks metrics correctly',
        () {
          final algorithm = _TestAlgorithm();

          expect(algorithm.getMetrics()['executionCount'], equals(0));

          final result = algorithm.execute('test input');

          expect(result, equals('processed: test input'));
          expect(algorithm.getMetrics()['executionCount'], equals(1));
          expect(algorithm.getMetrics()['lastExecutionTime'], greaterThan(0));
        },
      );

      test(
        'GIVEN: Algorithm with concept restrictions WHEN: Checking applicability THEN: Validates correctly',
        () {
          final algorithm = _TestAlgorithm();

          // This would require a mock concept, for now we'll test the basic structure
          expect(algorithm.applicableToConcepts, contains('TestConcept'));
          expect(algorithm.providedBehaviors, contains('test-behavior'));
        },
      );

      test(
        'GIVEN: Algorithm failure WHEN: Executing THEN: Throws AlgorithmException',
        () {
          final algorithm = _FailingAlgorithm();

          expect(
            () => algorithm.execute('any input'),
            throwsA(isA<AlgorithmException>()),
          );
        },
      );
    });
  });

  group('Graph Algorithm Integration Tests', () {
    group('🗺️ Dijkstra Algorithm', () {
      late GraphInput<String> graph;
      late DijkstraAlgorithm<String> dijkstra;

      setUp(() {
        graph = GraphInput<String>();
        dijkstra = DijkstraAlgorithm<String>();

        // Create a simple graph: A -> B -> C
        //                      |    ^
        //                      v    |
        //                       -> D
        final nodeA = GraphNode<String>(id: 'A', data: 'Node A');
        final nodeB = GraphNode<String>(id: 'B', data: 'Node B');
        final nodeC = GraphNode<String>(id: 'C', data: 'Node C');
        final nodeD = GraphNode<String>(id: 'D', data: 'Node D');

        graph.addNode(nodeA);
        graph.addNode(nodeB);
        graph.addNode(nodeC);
        graph.addNode(nodeD);

        graph.connect('A', 'B', weight: 1.0);
        graph.connect('B', 'C', weight: 2.0);
        graph.connect('A', 'D', weight: 4.0);
        graph.connect('D', 'B', weight: 1.0);
      });

      test(
        'GIVEN: Graph with weighted edges WHEN: Finding shortest path THEN: Returns optimal route',
        () {
          final input = DijkstraInput<String>(
            graph: graph,
            startNodeId: 'A',
            endNodeId: 'C',
          );

          final result = dijkstra.execute(input);

          expect(result.found, isTrue);
          expect(result.distance, equals(3.0)); // A -> B -> C = 1 + 2 = 3
          expect(result.path.length, equals(3));
          expect(result.path.first.id, equals('A'));
          expect(result.path.last.id, equals('C'));
        },
      );

      test(
        'GIVEN: Nonexistent start node WHEN: Running algorithm THEN: Throws exception',
        () {
          final input = DijkstraInput<String>(
            graph: graph,
            startNodeId: 'NONEXISTENT',
            endNodeId: 'C',
          );

          expect(
            () => dijkstra.execute(input),
            throwsA(isA<AlgorithmException>()),
          );
        },
      );

      test(
        'GIVEN: Unreachable target WHEN: Finding path THEN: Returns not found',
        () {
          // Add isolated node
          final isolatedNode = GraphNode<String>(
            id: 'ISOLATED',
            data: 'Isolated',
          );
          graph.addNode(isolatedNode);

          final input = DijkstraInput<String>(
            graph: graph,
            startNodeId: 'A',
            endNodeId: 'ISOLATED',
          );

          final result = dijkstra.execute(input);

          expect(result.found, isFalse);
          expect(result.distance, equals(double.infinity));
          expect(result.path, isEmpty);
        },
      );
    });

    group('🔍 BFS Algorithm', () {
      late GraphInput<String> graph;
      late BreadthFirstSearchAlgorithm<String> bfs;

      setUp(() {
        graph = GraphInput<String>();
        bfs = BreadthFirstSearchAlgorithm<String>();

        // Create tree structure
        final nodes = [
          'root',
          'child1',
          'child2',
          'grandchild1',
          'grandchild2',
        ];
        for (final nodeId in nodes) {
          graph.addNode(
            GraphNode<String>(id: nodeId, data: 'Data for $nodeId'),
          );
        }

        graph.connect('root', 'child1');
        graph.connect('root', 'child2');
        graph.connect('child1', 'grandchild1');
        graph.connect('child2', 'grandchild2');
      });

      test(
        'GIVEN: Tree structure WHEN: BFS from root THEN: Visits in breadth-first order',
        () {
          final input = BFSInput<String>(graph: graph, startNodeId: 'root');

          final result = bfs.execute(input);

          expect(result.visitedNodes.length, equals(5));
          expect(result.visitedNodes.first.id, equals('root'));

          // Check that children come before grandchildren
          final visitedIds = result.visitedNodes.map((n) => n.id).toList();
          final child1Index = visitedIds.indexOf('child1');
          final child2Index = visitedIds.indexOf('child2');
          final grandchild1Index = visitedIds.indexOf('grandchild1');
          final grandchild2Index = visitedIds.indexOf('grandchild2');

          expect(child1Index, lessThan(grandchild1Index));
          expect(child2Index, lessThan(grandchild2Index));
        },
      );

      test(
        'GIVEN: Target node specified WHEN: BFS to target THEN: Finds shortest path',
        () {
          final input = BFSInput<String>(
            graph: graph,
            startNodeId: 'root',
            targetNodeId: 'grandchild1',
          );

          final result = bfs.execute(input);

          expect(result.pathToTarget, isNotNull);
          expect(
            result.pathToTarget!.length,
            equals(3),
          ); // root -> child1 -> grandchild1
          expect(result.pathToTarget!.first.id, equals('root'));
          expect(result.pathToTarget!.last.id, equals('grandchild1'));
        },
      );
    });
  });
}

/// Test algorithm implementation for testing base functionality
class _TestAlgorithm extends Algorithm<String, String> {
  _TestAlgorithm()
    : super(
        code: 'test-algorithm',
        name: 'Test Algorithm',
        description: 'Algorithm for testing purposes',
        applicableToConcepts: ['TestConcept'],
        providedBehaviors: ['test-behavior'],
      );

  @override
  String performExecution(String input) {
    return 'processed: $input';
  }
}

/// Test algorithm that always fails for testing error handling
class _FailingAlgorithm extends Algorithm<String, String> {
  _FailingAlgorithm()
    : super(
        code: 'failing-algorithm',
        name: 'Failing Algorithm',
        description: 'Algorithm that always fails',
      );

  @override
  String performExecution(String input) {
    throw Exception('Intentional failure for testing');
  }
}
