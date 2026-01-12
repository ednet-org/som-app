import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Topological Sort Algorithm', () {
    late TopologicalSortAlgorithm<String> topoSort;
    late GraphInput<String> graph;

    setUp(() {
      topoSort = TopologicalSortAlgorithm<String>();
      graph = GraphInput<String>();
    });

    test('should have correct algorithm properties', () {
      expect(topoSort.code, equals('topological_sort'));
      expect(topoSort.name, equals('Topological Sort'));
      expect(topoSort.providedBehaviors, contains('dependency-resolution'));
      expect(topoSort.providedBehaviors, contains('task-ordering'));
      expect(topoSort.providedBehaviors, contains('workflow-planning'));
    });

    test('should sort simple linear dependency chain', () {
      // Create: A -> B -> C -> D
      graph.addNode(GraphNode(id: 'A', data: 'Task A'));
      graph.addNode(GraphNode(id: 'B', data: 'Task B'));
      graph.addNode(GraphNode(id: 'C', data: 'Task C'));
      graph.addNode(GraphNode(id: 'D', data: 'Task D'));

      graph.connect('A', 'B');
      graph.connect('B', 'C');
      graph.connect('C', 'D');

      final input = TopologicalSortInput(graph: graph);
      final result = topoSort.execute(input);

      expect(result.hasCycle, isFalse);
      expect(result.sortedNodes.length, equals(4));

      // Verify order: A should come before B, B before C, C before D
      final ids = result.sortedNodes.map((n) => n.id).toList();
      expect(ids.indexOf('A'), lessThan(ids.indexOf('B')));
      expect(ids.indexOf('B'), lessThan(ids.indexOf('C')));
      expect(ids.indexOf('C'), lessThan(ids.indexOf('D')));
    });

    test('should sort complex workflow dependencies', () {
      // Create workflow:
      //   A -> C -> E
      //   B -> C -> F
      //   D -> F
      graph.addNode(GraphNode(id: 'A', data: 'Init System'));
      graph.addNode(GraphNode(id: 'B', data: 'Load Config'));
      graph.addNode(GraphNode(id: 'C', data: 'Setup Database'));
      graph.addNode(GraphNode(id: 'D', data: 'Start Logging'));
      graph.addNode(GraphNode(id: 'E', data: 'Launch Web Server'));
      graph.addNode(GraphNode(id: 'F', data: 'Start Background Jobs'));

      graph.connect('A', 'C');
      graph.connect('B', 'C');
      graph.connect('C', 'E');
      graph.connect('C', 'F');
      graph.connect('D', 'F');

      final input = TopologicalSortInput(graph: graph);
      final result = topoSort.execute(input);

      expect(result.hasCycle, isFalse);
      expect(result.sortedNodes.length, equals(6));

      final ids = result.sortedNodes.map((n) => n.id).toList();

      // A and B must come before C
      expect(ids.indexOf('A'), lessThan(ids.indexOf('C')));
      expect(ids.indexOf('B'), lessThan(ids.indexOf('C')));

      // C must come before E and F
      expect(ids.indexOf('C'), lessThan(ids.indexOf('E')));
      expect(ids.indexOf('C'), lessThan(ids.indexOf('F')));

      // D must come before F
      expect(ids.indexOf('D'), lessThan(ids.indexOf('F')));
    });

    test('should detect cycles in workflow', () {
      // Create cycle: A -> B -> C -> A
      graph.addNode(GraphNode(id: 'A', data: 'Task A'));
      graph.addNode(GraphNode(id: 'B', data: 'Task B'));
      graph.addNode(GraphNode(id: 'C', data: 'Task C'));

      graph.connect('A', 'B');
      graph.connect('B', 'C');
      graph.connect('C', 'A'); // Creates cycle

      final input = TopologicalSortInput(graph: graph);
      final result = topoSort.execute(input);

      expect(result.hasCycle, isTrue);
      expect(result.sortedNodes, isEmpty);
      expect(result.cycleNodes, isNotEmpty);

      // Should identify the cycle nodes
      final cycleIds = result.cycleNodes!.map((n) => n.id).toSet();
      expect(cycleIds, containsAll(['A', 'B', 'C']));
    });

    test('should handle disconnected components', () {
      // Two separate chains: A -> B and C -> D
      graph.addNode(GraphNode(id: 'A', data: 'Task A'));
      graph.addNode(GraphNode(id: 'B', data: 'Task B'));
      graph.addNode(GraphNode(id: 'C', data: 'Task C'));
      graph.addNode(GraphNode(id: 'D', data: 'Task D'));

      graph.connect('A', 'B');
      graph.connect('C', 'D');

      final input = TopologicalSortInput(graph: graph);
      final result = topoSort.execute(input);

      expect(result.hasCycle, isFalse);
      expect(result.sortedNodes.length, equals(4));

      final ids = result.sortedNodes.map((n) => n.id).toList();
      expect(ids.indexOf('A'), lessThan(ids.indexOf('B')));
      expect(ids.indexOf('C'), lessThan(ids.indexOf('D')));
    });

    test('should work with entity workflow', () {
      final domain = Domain('WorkflowDomain');
      final model = Model(domain, 'WorkflowModel');
      final taskConcept = Concept(model, 'Task');
      taskConcept.entry = true; // Mark as entry concept

      // Create dependency relationship
      final dependsOnParent = Parent(taskConcept, taskConcept, 'dependsOn');
      dependsOnParent.required = false; // Not all tasks need dependencies

      final tasks = Entities<DynamicEntity>();
      tasks.concept = taskConcept;

      final taskA = DynamicEntity.withConcept(taskConcept);
      taskA.code = 'Build';

      final taskB = DynamicEntity.withConcept(taskConcept);
      taskB.code = 'Test';
      taskB.setParent('dependsOn', taskA); // Test depends on Build

      final taskC = DynamicEntity.withConcept(taskConcept);
      taskC.code = 'Deploy';
      taskC.setParent('dependsOn', taskB); // Deploy depends on Test

      tasks.add(taskA);
      tasks.add(taskB);
      tasks.add(taskC);

      final entityGraph = GraphInput.fromEntities(tasks);
      final input = TopologicalSortInput(graph: entityGraph);
      final dynamicTopoSort = TopologicalSortAlgorithm<dynamic>();
      final result = dynamicTopoSort.execute(input);

      expect(result.hasCycle, isFalse);
      expect(result.sortedNodes.length, equals(3));
    });

    test('should provide execution order with priorities', () {
      // Test with priority-based sorting
      graph.addNode(
        GraphNode(id: 'A', data: 'High Priority', properties: {'priority': 1}),
      );
      graph.addNode(
        GraphNode(
          id: 'B',
          data: 'Medium Priority',
          properties: {'priority': 2},
        ),
      );
      graph.addNode(
        GraphNode(id: 'C', data: 'Low Priority', properties: {'priority': 3}),
      );

      // No dependencies, should sort by priority
      final input = TopologicalSortInput(
        graph: graph,
        priorityComparator: (a, b) {
          final priorityA = a.properties['priority'] as int? ?? 999;
          final priorityB = b.properties['priority'] as int? ?? 999;
          return priorityA.compareTo(priorityB);
        },
      );

      final result = topoSort.execute(input);

      expect(result.hasCycle, isFalse);
      final ids = result.sortedNodes.map((n) => n.id).toList();
      expect(ids, equals(['A', 'B', 'C'])); // Sorted by priority
    });

    test('should handle empty graph', () {
      final input = TopologicalSortInput(graph: graph);
      final result = topoSort.execute(input);

      expect(result.hasCycle, isFalse);
      expect(result.sortedNodes, isEmpty);
    });

    test('should track algorithm performance', () {
      // Add some nodes for meaningful execution
      for (int i = 0; i < 10; i++) {
        graph.addNode(GraphNode(id: 'Node$i', data: 'Data $i'));
        if (i > 0) {
          graph.connect('Node${i - 1}', 'Node$i');
        }
      }

      final input = TopologicalSortInput(graph: graph);

      // Execute multiple times
      topoSort.execute(input);
      topoSort.execute(input);

      final metrics = topoSort.getMetrics();
      expect(metrics['executionCount'], equals(2));
      expect(metrics['totalExecutionTime'], greaterThan(0));
    });
  });
}
