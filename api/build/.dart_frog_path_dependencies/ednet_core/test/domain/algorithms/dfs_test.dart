import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Depth-First Search Algorithm', () {
    late DepthFirstSearchAlgorithm<String> dfs;
    late GraphInput<String> graph;

    setUp(() {
      dfs = DepthFirstSearchAlgorithm<String>();
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
      expect(dfs.code, equals('dfs'));
      expect(dfs.name, equals('Depth-First Search'));
      expect(dfs.providedBehaviors, contains('traversal'));
      expect(dfs.providedBehaviors, contains('exploration'));
      expect(dfs.providedBehaviors, contains('cycle-detection'));
    });

    test('should traverse graph in depth-first order', () {
      final input = DFSInput(graph: graph, startNodeId: 'A');

      final result = dfs.execute(input);

      expect(result.visitedNodes.length, equals(7));

      // Check DFS order - goes deep before backtracking
      expect(result.visitedNodes[0].id, equals('A')); // Start

      // Should go deep into one branch before exploring siblings
      final visitedIds = result.visitedNodes.map((n) => n.id).toList();
      final bIndex = visitedIds.indexOf('B');
      final cIndex = visitedIds.indexOf('C');
      final dIndex = visitedIds.indexOf('D');
      final eIndex = visitedIds.indexOf('E');

      // If we visit B before C, then D and E should come before C
      if (bIndex < cIndex) {
        expect(dIndex, lessThan(cIndex));
        expect(eIndex, lessThan(cIndex));
      }
    });

    test('should track discovery and finish times', () {
      final input = DFSInput(graph: graph, startNodeId: 'A');

      final result = dfs.execute(input);

      // Check discovery times are set
      expect(result.discoveryTimes.length, equals(7));
      expect(result.finishTimes.length, equals(7));

      // Discovery time should be less than finish time for each node
      for (final nodeId in result.discoveryTimes.keys) {
        expect(
          result.discoveryTimes[nodeId]!,
          lessThan(result.finishTimes[nodeId]!),
        );
      }

      // Start node should have discovery time 0
      expect(result.discoveryTimes['A'], equals(0));
    });

    test('should classify edges', () {
      // Add back edge to create cycle
      graph.connect('G', 'A');

      final input = DFSInput(graph: graph, startNodeId: 'A');

      final result = dfs.execute(input);

      // Should have classified edges
      expect(result.treeEdges, isNotEmpty);
      expect(result.backEdges, isNotEmpty); // Due to cycle

      // Back edge should be G -> A
      expect(
        result.backEdges.any((e) => e.source.id == 'G' && e.target.id == 'A'),
        isTrue,
      );
    });

    test('should detect cycles', () {
      // Graph without cycle
      var input = DFSInput(graph: graph, startNodeId: 'A');

      var result = dfs.execute(input);
      expect(result.hasCycle, isFalse);

      // Add cycle
      graph.connect('G', 'B');

      input = DFSInput(graph: graph, startNodeId: 'A');

      result = dfs.execute(input);
      expect(result.hasCycle, isTrue);
    });

    test('should apply visitor functions', () {
      final visitOrder = <String>[];

      final input = DFSInput(
        graph: graph,
        startNodeId: 'A',
        onDiscovery: (node) => visitOrder.add('discover:${node.id}'),
        onFinish: (node) => visitOrder.add('finish:${node.id}'),
      );

      dfs.execute(input);

      // Check visitor was called
      expect(visitOrder, contains('discover:A'));
      expect(visitOrder, contains('finish:A'));

      // Discovery should come before finish for each node
      final aDiscoverIndex = visitOrder.indexOf('discover:A');
      final aFinishIndex = visitOrder.indexOf('finish:A');
      expect(aDiscoverIndex, lessThan(aFinishIndex));
    });

    test('should handle disconnected components', () {
      // Add isolated node
      graph.addNode(GraphNode(id: 'H', data: 'Node H'));
      graph.addNode(GraphNode(id: 'I', data: 'Node I'));
      graph.connect('H', 'I');

      final input = DFSInput(
        graph: graph,
        startNodeId: 'A',
        exploreAllComponents: true,
      );

      final result = dfs.execute(input);

      // Should visit all nodes including disconnected component
      expect(result.visitedNodes.length, equals(9));
      expect(result.visitedNodes.map((n) => n.id), contains('H'));
      expect(result.visitedNodes.map((n) => n.id), contains('I'));
    });

    test('should find strongly connected components in directed graph', () {
      // Create a directed graph with SCCs
      final directedGraph = GraphInput<String>();

      // SCC 1: A, B, C form a cycle
      directedGraph.addNode(GraphNode(id: 'A', data: 'Node A'));
      directedGraph.addNode(GraphNode(id: 'B', data: 'Node B'));
      directedGraph.addNode(GraphNode(id: 'C', data: 'Node C'));
      directedGraph.connect('A', 'B');
      directedGraph.connect('B', 'C');
      directedGraph.connect('C', 'A');

      // SCC 2: D, E form a cycle
      directedGraph.addNode(GraphNode(id: 'D', data: 'Node D'));
      directedGraph.addNode(GraphNode(id: 'E', data: 'Node E'));
      directedGraph.connect('D', 'E');
      directedGraph.connect('E', 'D');

      // Connection between SCCs
      directedGraph.connect('C', 'D');

      final input = DFSInput(
        graph: directedGraph,
        startNodeId: 'A',
        findStronglyConnectedComponents: true,
      );

      final result = dfs.execute(input);

      // Should identify 2 SCCs
      expect(result.stronglyConnectedComponents?.length, equals(2));

      // Check SCC contents
      final sccs = result.stronglyConnectedComponents!;
      expect(
        sccs.any(
          (scc) =>
              scc.length == 3 &&
              scc.map((n) => n.id).toSet().containsAll(['A', 'B', 'C']),
        ),
        isTrue,
      );
      expect(
        sccs.any(
          (scc) =>
              scc.length == 2 &&
              scc.map((n) => n.id).toSet().containsAll(['D', 'E']),
        ),
        isTrue,
      );
    });

    test('should handle non-existent start node', () {
      final input = DFSInput(graph: graph, startNodeId: 'Z');

      expect(() => dfs.execute(input), throwsA(isA<AlgorithmException>()));
    });
  });
}
