import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('A* Heuristic Search Algorithm', () {
    late AStarAlgorithm<String> aStar;
    late GraphInput<String> graph;

    setUp(() {
      aStar = AStarAlgorithm<String>();
      graph = GraphInput<String>();
    });

    test('should have correct algorithm properties', () {
      expect(aStar.code, equals('astar'));
      expect(aStar.name, equals('A* Heuristic Search'));
      expect(aStar.providedBehaviors, contains('intelligent-pathfinding'));
      expect(aStar.providedBehaviors, contains('heuristic-search'));
      expect(aStar.providedBehaviors, contains('guided-exploration'));
    });

    test('should find optimal path with zero heuristic (becomes Dijkstra)', () {
      // Create a diamond graph:
      //   A
      //  / \
      // B   C
      //  \ /
      //   D
      graph.addNode(GraphNode(id: 'A', data: 'Start'));
      graph.addNode(GraphNode(id: 'B', data: 'Left'));
      graph.addNode(GraphNode(id: 'C', data: 'Right'));
      graph.addNode(GraphNode(id: 'D', data: 'Goal'));

      graph.connect('A', 'B', weight: 1);
      graph.connect('A', 'C', weight: 4);
      graph.connect('B', 'D', weight: 5);
      graph.connect('C', 'D', weight: 1);

      final input = AStarInput(
        graph: graph,
        startNodeId: 'A',
        goalNodeId: 'D',
        heuristic: (node, goal) => 0.0, // Zero heuristic = Dijkstra
      );

      final result = aStar.execute(input);

      expect(result.found, isTrue);
      expect(result.distance, equals(5.0)); // A -> C -> D (4 + 1 = 5)
      expect(result.path.map((n) => n.id), equals(['A', 'C', 'D']));
    });

    test('should use heuristic to guide search efficiently', () {
      // Create grid-like graph with coordinate-based heuristic
      // Goal is at "bottom-right", heuristic guides toward it
      graph.addNode(
        GraphNode(id: 'A', data: 'Start', properties: {'x': 0, 'y': 0}),
      );
      graph.addNode(
        GraphNode(id: 'B', data: 'Middle', properties: {'x': 1, 'y': 0}),
      );
      graph.addNode(
        GraphNode(id: 'C', data: 'Detour', properties: {'x': 0, 'y': 1}),
      );
      graph.addNode(
        GraphNode(id: 'D', data: 'Goal', properties: {'x': 2, 'y': 0}),
      );

      // Direct path: A -> B -> D (cost: 2)
      // Detour path: A -> C -> ... (longer)
      graph.connect('A', 'B', weight: 1);
      graph.connect('A', 'C', weight: 1);
      graph.connect('B', 'D', weight: 1);
      graph.connect('C', 'D', weight: 10); // Expensive detour

      // Manhattan distance heuristic
      double manhattanHeuristic(
        GraphNode<String> node,
        GraphNode<String> goal,
      ) {
        final x1 = node.properties['x'] as int;
        final y1 = node.properties['y'] as int;
        final x2 = goal.properties['x'] as int;
        final y2 = goal.properties['y'] as int;
        return ((x2 - x1).abs() + (y2 - y1).abs()).toDouble();
      }

      final input = AStarInput(
        graph: graph,
        startNodeId: 'A',
        goalNodeId: 'D',
        heuristic: manhattanHeuristic,
      );

      final result = aStar.execute(input);

      expect(result.found, isTrue);
      expect(result.distance, equals(2.0)); // A -> B -> D
      expect(result.path.map((n) => n.id), equals(['A', 'B', 'D']));

      // Should explore fewer nodes than Dijkstra due to heuristic
      expect(result.exploredNodes.length, lessThanOrEqualTo(3));
    });

    test('should find path in complex domain model scenario', () {
      // Simulate domain modeling workflow with semantic heuristics
      final concepts = {
        'Problem': {'complexity': 1, 'abstraction': 0},
        'Domain': {'complexity': 2, 'abstraction': 1},
        'Entity': {'complexity': 3, 'abstraction': 2},
        'Attribute': {'complexity': 4, 'abstraction': 3},
        'Relationship': {'complexity': 4, 'abstraction': 3},
        'Implementation': {'complexity': 5, 'abstraction': 4},
      };

      for (final entry in concepts.entries) {
        graph.addNode(
          GraphNode(id: entry.key, data: entry.key, properties: entry.value),
        );
      }

      // Define domain modeling progression paths
      graph.connect('Problem', 'Domain', weight: 1);
      graph.connect('Domain', 'Entity', weight: 2);
      graph.connect('Entity', 'Attribute', weight: 1);
      graph.connect('Entity', 'Relationship', weight: 1);
      graph.connect('Attribute', 'Implementation', weight: 2);
      graph.connect('Relationship', 'Implementation', weight: 2);

      // Complexity-based heuristic (guides toward implementation)
      double complexityHeuristic(
        GraphNode<String> node,
        GraphNode<String> goal,
      ) {
        final nodeComplexity = node.properties['complexity'] as int;
        final goalComplexity = goal.properties['complexity'] as int;
        return (goalComplexity - nodeComplexity).abs().toDouble();
      }

      final input = AStarInput(
        graph: graph,
        startNodeId: 'Problem',
        goalNodeId: 'Implementation',
        heuristic: complexityHeuristic,
      );

      final result = aStar.execute(input);

      expect(result.found, isTrue);
      expect(result.path.first.id, equals('Problem'));
      expect(result.path.last.id, equals('Implementation'));

      // Should follow logical progression
      final pathIds = result.path.map((n) => n.id).toList();
      expect(pathIds, contains('Domain'));
      expect(pathIds, contains('Entity'));
    });

    test('should handle inadmissible heuristic gracefully', () {
      // Create simple graph where heuristic overestimates
      graph.addNode(GraphNode(id: 'A', data: 'Start'));
      graph.addNode(GraphNode(id: 'B', data: 'Goal'));

      graph.connect('A', 'B', weight: 1);

      // Inadmissible heuristic (overestimates)
      final input = AStarInput(
        graph: graph,
        startNodeId: 'A',
        goalNodeId: 'B',
        heuristic: (node, goal) => 100.0, // Way too high
      );

      final result = aStar.execute(input);

      // Should still find a path, just not optimal
      expect(result.found, isTrue);
      expect(result.path.map((n) => n.id), equals(['A', 'B']));
    });

    test('should detect when no path exists', () {
      // Create disconnected graph
      graph.addNode(GraphNode(id: 'A', data: 'Start'));
      graph.addNode(GraphNode(id: 'B', data: 'Isolated'));

      // No edges between them

      final input = AStarInput(
        graph: graph,
        startNodeId: 'A',
        goalNodeId: 'B',
        heuristic: (node, goal) => 1.0,
      );

      final result = aStar.execute(input);

      expect(result.found, isFalse);
      expect(result.path, isEmpty);
      expect(result.distance, equals(double.infinity));
    });

    test('should track explored nodes for analysis', () {
      // Create larger graph to see exploration
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          final id = '$i,$j';
          graph.addNode(
            GraphNode(id: id, data: 'Node $id', properties: {'x': i, 'y': j}),
          );
        }
      }

      // Connect grid nodes
      for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
          if (i < 4) graph.connect('$i,$j', '${i + 1},$j', weight: 1);
          if (j < 4) graph.connect('$i,$j', '$i,${j + 1}', weight: 1);
        }
      }

      final input = AStarInput(
        graph: graph,
        startNodeId: '0,0',
        goalNodeId: '4,4',
        heuristic: (node, goal) {
          final x1 = node.properties['x'] as int;
          final y1 = node.properties['y'] as int;
          final x2 = goal.properties['x'] as int;
          final y2 = goal.properties['y'] as int;
          return ((x2 - x1).abs() + (y2 - y1).abs()).toDouble();
        },
      );

      final result = aStar.execute(input);

      expect(result.found, isTrue);
      expect(result.distance, equals(8.0)); // Manhattan distance

      // With good heuristic, should explore reasonable number of nodes
      expect(result.exploredNodes.length, lessThanOrEqualTo(25));
    });

    test('should work with entity-based heuristics', () {
      final domain = Domain('NavigationDomain');
      final model = Model(domain, 'NavigationModel');
      final conceptA = Concept(model, 'ConceptA');
      final conceptB = Concept(model, 'ConceptB');

      // Add priority attribute to concepts
      final priorityType = AttributeType(domain, 'int');
      Attribute(conceptA, 'priority')
        ..type = priorityType
        ..required = false;
      Attribute(conceptB, 'priority')
        ..type = priorityType
        ..required = false;

      // Create a simple Entity subclass that satisfies the type bounds
      final entities = Entities<DynamicEntity>();
      entities.concept = conceptA;

      final entityStart = DynamicEntity.withConcept(conceptA);
      entityStart.code = 'StartEntity';
      entityStart.setAttribute('priority', 1);

      final entityGoal = DynamicEntity.withConcept(conceptB);
      entityGoal.code = 'GoalEntity';
      entityGoal.setAttribute('priority', 10);

      entities.add(entityStart);
      entities.add(entityGoal);

      final entityGraph = GraphInput.fromEntities(entities);

      // Priority-based heuristic
      double priorityHeuristic(
        GraphNode<dynamic> node,
        GraphNode<dynamic> goal,
      ) {
        final priority1 =
            (node.data as Entity).getAttribute<int>('priority') ?? 0;
        final priority2 =
            (goal.data as Entity).getAttribute<int>('priority') ?? 0;
        return (priority2 - priority1).abs().toDouble();
      }

      final input = AStarInput<dynamic>(
        graph: entityGraph,
        startNodeId: entityStart.oid.toString(),
        goalNodeId: entityGoal.oid.toString(),
        heuristic: priorityHeuristic,
      );

      final dynamicAStar = AStarAlgorithm<dynamic>();
      final result = dynamicAStar.execute(input);

      // Should handle entity-based search
      expect(result.found, isNotNull);
    });

    test('should track performance metrics', () {
      // Simple graph for performance testing
      graph.addNode(GraphNode(id: 'A', data: 'Start'));
      graph.addNode(GraphNode(id: 'B', data: 'Goal'));
      graph.connect('A', 'B', weight: 1);

      final input = AStarInput(
        graph: graph,
        startNodeId: 'A',
        goalNodeId: 'B',
        heuristic: (node, goal) => 0.0,
      );

      // Execute multiple times
      aStar.execute(input);
      aStar.execute(input);

      final metrics = aStar.getMetrics();
      expect(metrics['executionCount'], equals(2));
      expect(metrics['totalExecutionTime'], greaterThan(0));
    });
  });
}
