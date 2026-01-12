import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Dijkstra Shortest Path Algorithm', () {
    late DijkstraAlgorithm<String> dijkstra;
    late GraphInput<String> graph;

    setUp(() {
      dijkstra = DijkstraAlgorithm<String>();
      graph = GraphInput<String>();

      // Create a simple graph:
      // A --1--> B --3--> D
      // |        |        ^
      // 4        2        |
      // v        v        1
      // C -------5------> E

      // Add nodes
      graph.addNode(GraphNode(id: 'A', data: 'Node A'));
      graph.addNode(GraphNode(id: 'B', data: 'Node B'));
      graph.addNode(GraphNode(id: 'C', data: 'Node C'));
      graph.addNode(GraphNode(id: 'D', data: 'Node D'));
      graph.addNode(GraphNode(id: 'E', data: 'Node E'));

      // Add edges
      graph.connect('A', 'B', weight: 1);
      graph.connect('A', 'C', weight: 4);
      graph.connect('B', 'D', weight: 3);
      graph.connect('B', 'E', weight: 2);
      graph.connect('C', 'E', weight: 5);
      graph.connect('E', 'D', weight: 1);
    });

    test('should have correct algorithm properties', () {
      expect(dijkstra.code, equals('dijkstra'));
      expect(dijkstra.name, equals('Dijkstra Shortest Path'));
      expect(dijkstra.providedBehaviors, contains('pathfinding'));
      expect(dijkstra.providedBehaviors, contains('optimization'));
    });

    test('should find shortest path from A to D', () {
      final input = DijkstraInput(
        graph: graph,
        startNodeId: 'A',
        endNodeId: 'D',
      );

      final result = dijkstra.execute(input);

      expect(result.found, isTrue);
      expect(
        result.distance,
        equals(4.0),
      ); // A -> B -> D (shorter than A -> B -> E -> D)
      expect(result.path.length, equals(3));
      expect(result.path[0].id, equals('A'));
      expect(result.path[1].id, equals('B'));
      expect(result.path[2].id, equals('D'));
    });

    test('should find shortest path from A to E', () {
      final input = DijkstraInput(
        graph: graph,
        startNodeId: 'A',
        endNodeId: 'E',
      );

      final result = dijkstra.execute(input);

      expect(result.found, isTrue);
      expect(result.distance, equals(3.0)); // A -> B -> E
      expect(result.path.length, equals(3));
      expect(result.path[0].id, equals('A'));
      expect(result.path[1].id, equals('B'));
      expect(result.path[2].id, equals('E'));
    });

    test('should find all shortest paths from source', () {
      final input = DijkstraInput(
        graph: graph,
        startNodeId: 'A',
        // No endNodeId means find all paths
      );

      final result = dijkstra.execute(input);

      expect(result.found, isTrue);
      expect(result.distances['A'], equals(0.0));
      expect(result.distances['B'], equals(1.0));
      expect(result.distances['C'], equals(4.0));
      expect(result.distances['D'], equals(4.0));
      expect(result.distances['E'], equals(3.0));
    });

    test('should handle unreachable nodes', () {
      // Add isolated node
      graph.addNode(GraphNode(id: 'F', data: 'Node F'));

      final input = DijkstraInput(
        graph: graph,
        startNodeId: 'A',
        endNodeId: 'F',
      );

      final result = dijkstra.execute(input);

      expect(result.found, isFalse);
      expect(result.distance, equals(double.infinity));
      expect(result.path, isEmpty);
    });

    test('should handle non-existent start node', () {
      final input = DijkstraInput(
        graph: graph,
        startNodeId: 'Z',
        endNodeId: 'A',
      );

      expect(() => dijkstra.execute(input), throwsA(isA<AlgorithmException>()));
    });

    test('should handle same start and end node', () {
      final input = DijkstraInput(
        graph: graph,
        startNodeId: 'A',
        endNodeId: 'A',
      );

      final result = dijkstra.execute(input);

      expect(result.found, isTrue);
      expect(result.distance, equals(0.0));
      expect(result.path.length, equals(1));
      expect(result.path[0].id, equals('A'));
    });

    test('should work with entities graph', () {
      final domain = Domain('TestDomain');
      final model = Model(domain, 'TestModel');
      final orderConcept = Concept(model, 'Order');
      final customerConcept = Concept(model, 'Customer');
      customerConcept.entry = true; // Mark as entry concept
      Concept(model, 'Product');

      // Create parent relationship
      final customerParent = Parent(orderConcept, customerConcept, 'customer');
      customerParent.internal = true;
      orderConcept.parents.add(customerParent);

      // Create entities
      final entities = Entities<DynamicEntity>(); // Mixed collection

      final customer = DynamicEntity.withConcept(customerConcept);
      customer.code = 'Customer1';

      final order1 = DynamicEntity.withConcept(orderConcept);
      order1.code = 'Order1';
      order1.setParent('customer', customer);

      final order2 = DynamicEntity.withConcept(orderConcept);
      order2.code = 'Order2';
      order2.setParent('customer', customer);

      entities.add(customer);
      entities.add(order1);
      entities.add(order2);

      // Create graph from entities
      final entityGraph = GraphInput.fromEntities(entities);

      // Find path from order1 to customer
      final input = DijkstraInput(
        graph: entityGraph,
        startNodeId: order1.oid.toString(),
        endNodeId: customer.oid.toString(),
      );

      final dynamicDijkstra = DijkstraAlgorithm<dynamic>();
      final result = dynamicDijkstra.execute(input);

      expect(result.found, isTrue);
      expect(result.distance, equals(1.0));
      expect(result.path.length, equals(2));
    });

    test('should track performance metrics', () {
      final input = DijkstraInput(
        graph: graph,
        startNodeId: 'A',
        endNodeId: 'D',
      );

      // Execute multiple times
      dijkstra.execute(input);
      dijkstra.execute(input);
      dijkstra.execute(input);

      final metrics = dijkstra.getMetrics();
      expect(metrics['executionCount'], equals(3));
      expect(metrics['totalExecutionTime'], greaterThan(0));
      expect(metrics['averageExecutionTime'], greaterThan(0));
    });
  });
}
