import 'dart:convert';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test aggregate for enhanced aggregate root testing
class TestOrderAggregate extends EnhancedAggregateRoot<TestOrderAggregate> {
  String? customerId;
  List<String> items = [];
  String status = 'Draft';
  double total = 0.0;
  DateTime? orderDate;

  TestOrderAggregate() {
    concept = TestOrderConcept();
  }

  /// Command: Place the order
  CommandResult placeOrder(String customerId, List<String> items) {
    if (status != 'Draft') {
      return CommandResult.failure('Order already placed');
    }

    if (customerId.isEmpty) {
      return CommandResult.failure('Customer ID is required');
    }

    if (items.isEmpty) {
      return CommandResult.failure('Order must have at least one item');
    }

    // Calculate total for the event
    final orderTotal = items.length * 10.0; // Simple pricing

    // Record domain event (state will be updated in applyEvent)
    recordEventLegacy(
      'OrderPlaced',
      'Order was placed by customer',
      ['OrderFulfillmentHandler', 'NotificationHandler'],
      data: {
        'customerId': customerId,
        'items': items,
        'total': orderTotal,
        'orderDate': DateTime.now().toIso8601String(),
      },
    );

    return CommandResult.success(
      data: {'orderId': oid.toString(), 'total': orderTotal},
    );
  }

  /// Command: Ship the order
  CommandResult shipOrder(String trackingNumber) {
    if (status != 'Placed') {
      return CommandResult.failure('Can only ship placed orders');
    }

    recordEventLegacy(
      'OrderShipped',
      'Order was shipped to customer',
      ['NotificationHandler', 'TrackingHandler'],
      data: {
        'trackingNumber': trackingNumber,
        'shippedDate': DateTime.now().toIso8601String(),
      },
    );

    return CommandResult.success(
      data: {'orderId': oid.toString(), 'trackingNumber': trackingNumber},
    );
  }

  /// Command: Cancel the order
  CommandResult cancelOrder(String reason) {
    if (status == 'Shipped' || status == 'Delivered') {
      return CommandResult.failure('Cannot cancel shipped or delivered order');
    }

    recordEventLegacy(
      'OrderCancelled',
      'Order was cancelled',
      ['NotificationHandler'],
      data: {
        'reason': reason,
        'cancelledDate': DateTime.now().toIso8601String(),
      },
    );

    return CommandResult.success();
  }

  @override
  void applyEvent(dynamic event) {
    switch (event.name) {
      case 'OrderPlaced':
        status = 'Placed';
        customerId = event.data['customerId'];
        items = List<String>.from(event.data['items']);
        total = (event.data['total'] ?? 0.0).toDouble();
        orderDate = DateTime.parse(event.data['orderDate']);
        break;
      case 'OrderShipped':
        status = 'Shipped';
        break;
      case 'OrderCancelled':
        status = 'Cancelled';
        break;
    }
  }

  @override
  void resetDomainState() {
    // Reset aggregate-specific state
    customerId = null;
    items.clear();
    status = 'Draft';
    total = 0.0;
    orderDate = null;
  }

  @override
  String toJson() {
    final data = {
      'oid': oid.toString(),
      'customerId': customerId,
      'items': items,
      'status': status,
      'total': total,
      'orderDate': orderDate?.toIso8601String(),
    };
    return jsonEncode(data);
  }

  @override
  void fromJson<K extends Entity<K>>(String entityJson) {
    final data = jsonDecode(entityJson) as Map<String, dynamic>;
    customerId = data['customerId'];
    items = List<String>.from(data['items'] ?? []);
    status = data['status'] ?? 'Draft';
    total = (data['total'] ?? 0.0).toDouble();
    if (data['orderDate'] != null) {
      orderDate = DateTime.parse(data['orderDate']);
    }
  }

  // Add the fromSnapshot method that tests are expecting
  void fromSnapshot(AggregateSnapshot<TestOrderAggregate> snapshot) {
    // Use the proper method from EnhancedAggregateRoot
    restoreFromSnapshot(snapshot);
  }
}

/// Test concept for aggregate
class TestOrderConcept extends Concept {
  TestOrderConcept()
    : super(Model(Domain('TestDomain'), 'TestModel'), 'TestOrder') {
    entry = true; // Mark as aggregate root
  }

  String get name => 'TestOrder';
}

/// Test command for command integration testing
class TestPlaceOrderCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final List<String> items;

  TestPlaceOrderCommand({required this.customerId, required this.items});

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'items': items,
  };
}

void main() {
  group('Enhanced Aggregate Root Tests', () {
    late TestOrderAggregate order;

    setUp(() {
      order = TestOrderAggregate();
    });

    group('Event Sourcing Basics', () {
      test('should record events when executing commands', () {
        // Act
        final result = order.placeOrder('CUST-123', ['item1', 'item2']);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(order.pendingEvents.length, equals(1));
        expect(order.hasUncommittedEvents, isTrue);
        expect(order.uncommittedEventCount, equals(1));

        final event = order.pendingEvents.first;
        expect(event.name, equals('OrderPlaced'));
        expect(event.aggregateId, equals(order.oid.toString()));
        expect(event.aggregateVersion, equals(1));
      });

      test('should apply events to update state immediately', () {
        // Act
        final result = order.placeOrder('CUST-123', ['item1', 'item2']);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(order.status, equals('Placed'));
        expect(order.customerId, equals('CUST-123'));
        expect(order.items, equals(['item1', 'item2']));
        expect(order.total, equals(20.0));
        expect(order.orderDate, isNotNull);
      });

      test('should increment version with each event', () {
        // Initial state
        expect(order.version, equals(0));

        // Place order
        order.placeOrder('CUST-123', ['item1']);
        expect(order.version, equals(1));

        // Ship order
        order.shipOrder('TRACK-123');
        expect(order.version, equals(2));

        // Cancel order (should fail since shipped)
        final result = order.cancelOrder('Customer request');
        expect(result.isFailure, isTrue);
        expect(
          order.version,
          equals(2),
        ); // Version doesn't increment on failed commands
      });

      test('should handle multiple events in sequence', () {
        // Act
        order.placeOrder('CUST-123', ['item1']);
        order.shipOrder('TRACK-123');

        // Assert
        expect(order.pendingEvents.length, equals(2));
        expect(order.version, equals(2));
        expect(order.status, equals('Shipped'));

        final events = order.pendingEvents;
        expect(events[0].name, equals('OrderPlaced'));
        expect(events[1].name, equals('OrderShipped'));
      });
    });

    group('State Reconstruction', () {
      test('should rebuild state from event history', () {
        // Arrange - create some events
        order.placeOrder('CUST-123', ['item1', 'item2']);
        order.shipOrder('TRACK-123');

        final eventHistory = List.from(order.pendingEvents);
        final originalStatus = order.status;
        final originalVersion = order.version;

        // Create new aggregate and rebuild from history
        final newOrder = TestOrderAggregate();

        // Act
        newOrder.rehydrateFromEventHistory(eventHistory);

        // Assert
        expect(newOrder.status, equals(originalStatus));
        expect(newOrder.version, equals(originalVersion));
        expect(newOrder.customerId, equals('CUST-123'));
        expect(newOrder.items, equals(['item1', 'item2']));
        expect(newOrder.total, equals(20.0));
        expect(
          newOrder.pendingEvents.length,
          equals(0),
        ); // Cleared after rehydration
      });

      test('should handle empty event history', () {
        // Act
        order.rehydrateFromEventHistory([]);

        // Assert
        expect(order.version, equals(0));
        expect(order.status, equals('Draft'));
        expect(order.customerId, isNull);
        expect(order.items.length, equals(0));
      });

      test('should reset state before rehydration', () {
        // Arrange - modify order first
        order.placeOrder('CUST-123', ['item1']);
        expect(order.status, equals('Placed'));

        // Create different event history
        final anotherOrder = TestOrderAggregate();
        anotherOrder.placeOrder('CUST-456', ['item2', 'item3']);
        anotherOrder.shipOrder('TRACK-456');

        final eventHistory = List.from(anotherOrder.pendingEvents);

        // Act
        order.rehydrateFromEventHistory(eventHistory);

        // Assert
        expect(order.customerId, equals('CUST-456'));
        expect(order.items, equals(['item2', 'item3']));
        expect(order.status, equals('Shipped'));
      });
    });

    group('Snapshot Support', () {
      test('should create snapshot of current state', () {
        // Arrange
        order.placeOrder('CUST-123', ['item1', 'item2']);
        order.shipOrder('TRACK-123');

        // Act
        final snapshot = order.createSnapshot();

        // Assert
        expect(snapshot.aggregateId, equals(order.oid.toString()));
        expect(snapshot.aggregateType, equals('TestOrderAggregate'));
        expect(snapshot.version, equals(order.version));
        expect(snapshot.stateData, isNotNull);
        final stateData =
            jsonDecode(snapshot.stateData) as Map<String, dynamic>;
        expect(stateData['status'], equals('Shipped'));
        expect(stateData['customerId'], equals('CUST-123'));
      });

      test('should restore from snapshot', () {
        // Arrange - create and snapshot an order
        order.placeOrder('CUST-123', ['item1', 'item2']);
        order.shipOrder('TRACK-123');
        final snapshot = order.createSnapshot();

        // Create new order and restore from snapshot
        final newOrder = TestOrderAggregate();

        // Act
        newOrder.fromSnapshot(snapshot);

        // Assert
        expect(newOrder.status, equals('Shipped'));
        expect(newOrder.customerId, equals('CUST-123'));
        expect(newOrder.items, equals(['item1', 'item2']));
        expect(newOrder.total, equals(20.0));
      });

      test('should rehydrate from snapshot plus events', () {
        // Arrange - create initial state and snapshot
        order.placeOrder('CUST-123', ['item1', 'item2']);
        final snapshot = order.createSnapshot();

        // Add more events after snapshot
        order.shipOrder('TRACK-123');
        order.cancelOrder('Customer request'); // Will fail but that's ok

        final eventsAfterSnapshot = order.pendingEvents
            .skip(1)
            .toList(); // Skip the OrderPlaced event

        // Create new order
        final newOrder = TestOrderAggregate();

        // Act
        newOrder.rehydrateFromSnapshot(snapshot, eventsAfterSnapshot);

        // Assert
        expect(newOrder.status, equals('Shipped')); // From the ship event
        expect(newOrder.customerId, equals('CUST-123')); // From snapshot
        expect(
          newOrder.version,
          equals(order.version),
        ); // Should match current version
      });
    });

    group('Concurrency Control', () {
      test('should track expected version', () {
        // Initial state
        expect(order.expectedVersion, equals(0));

        // After events
        order.placeOrder('CUST-123', ['item1']);
        expect(order.expectedVersion, equals(1));

        order.shipOrder('TRACK-123');
        expect(order.expectedVersion, equals(2));
      });

      test('should validate version for concurrency control', () {
        // Arrange
        order.placeOrder('CUST-123', ['item1']);
        expect(order.version, equals(1));

        // Act & Assert - correct version should pass
        expect(() => order.validateVersion(1), returnsNormally);

        // Wrong version should throw
        expect(
          () => order.validateVersion(0),
          throwsA(isA<ConcurrencyException>()),
        );
        expect(
          () => order.validateVersion(2),
          throwsA(isA<ConcurrencyException>()),
        );
      });

      test('should include version info in concurrency exception', () {
        // Arrange
        order.placeOrder('CUST-123', ['item1']);

        // Act & Assert
        try {
          order.validateVersion(0);
          fail('Should have thrown ConcurrencyException');
        } catch (e) {
          expect(e, isA<ConcurrencyException>());
          expect(e.toString(), contains('expected 0, actual 1'));
          expect(e.toString(), contains('Another user may have modified'));
        }
      });
    });

    group('Command Integration', () {
      test('should execute command with event sourcing integration', () {
        // Create a mock command that calls placeOrder
        final mockCommand = MockCommand(() {
          return order.placeOrder('CUST-123', ['item1']);
        });

        // Act
        final result = order.executeCommandWithEventSourcing(mockCommand);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data!['aggregateId'], equals(order.oid.toString()));
        expect(result.data!['aggregateType'], equals('TestOrderAggregate'));
        expect(result.data!['version'], equals(1));
        expect(result.data!['eventsGenerated'], equals(1));
      });

      test('should handle command validation failures', () {
        // Create a command that will fail validation
        final mockCommand = MockCommand(() {
          return order.placeOrder('', []); // Invalid parameters
        });

        // Act
        final result = order.executeCommandWithEventSourcing(mockCommand);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Customer ID is required'));
        expect(order.version, equals(0)); // Version not incremented on failure
      });

      test('should handle command exceptions', () {
        // Create a command that throws an exception
        final mockCommand = MockCommand(() {
          throw Exception('Command processing error');
        });

        // Act
        final result = order.executeCommandWithEventSourcing(mockCommand);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Command processing error'));
      });
    });

    group('Event Publishing Integration', () {
      test('should create proper domain events', () {
        // Act
        order.placeOrder('CUST-123', ['item1', 'item2']);

        // Assert
        final event = order.pendingEvents.first;
        expect(event, isA<EnhancedDomainEventImpl>());

        final domainEvent = event as EnhancedDomainEventImpl;
        expect(domainEvent.id, isNotNull);
        expect(domainEvent.name, equals('OrderPlaced'));
        expect(domainEvent.aggregateId, equals(order.oid.toString()));
        expect(domainEvent.aggregateType, equals('TestOrderAggregate'));
        expect(domainEvent.aggregateVersion, equals(1));
        expect(domainEvent.timestamp, isNotNull);
        expect(domainEvent.data['customerId'], equals('CUST-123'));
        expect(domainEvent.data['items'], equals(['item1', 'item2']));
      });

      test('should convert to base event', () {
        // Act
        order.placeOrder('CUST-123', ['item1']);

        // Assert
        final domainEvent =
            order.pendingEvents.first as EnhancedDomainEventImpl;
        final baseEvent = domainEvent.toBaseEvent();

        expect(baseEvent.name, equals('OrderPlaced'));
        expect(baseEvent.entity, equals(order));
        expect(baseEvent.data['customerId'], equals('CUST-123'));
      });

      test('should support JSON serialization', () {
        // Act
        order.placeOrder('CUST-123', ['item1']);

        // Assert
        final domainEvent =
            order.pendingEvents.first as EnhancedDomainEventImpl;
        final json = domainEvent.toJson();

        expect(json['id'], isNotNull);
        expect(json['name'], equals('OrderPlaced'));
        expect(json['aggregateId'], equals(order.oid.toString()));
        expect(json['aggregateType'], equals('TestOrderAggregate'));
        expect(json['aggregateVersion'], equals(1));
        expect(json['timestamp'], isNotNull);
        expect(json['data']['customerId'], equals('CUST-123'));
      });
    });

    group('Enhanced Graph Representation', () {
      test('should include event sourcing metadata in graph', () {
        // Arrange
        order.placeOrder('CUST-123', ['item1']);

        // Act
        final graph = order.toGraph();

        // Assert
        expect(graph['eventSourcingEnabled'], isTrue);
        expect(graph['version'], equals(1));
        expect(graph['pendingEventCount'], equals(1));
        expect(graph['hasUncommittedEvents'], isTrue);
        expect(graph['canCreateSnapshot'], isTrue);

        expect(graph['eventSourcing'], isNotNull);
        final eventSourcingInfo =
            graph['eventSourcing'] as Map<String, dynamic>;
        expect(eventSourcingInfo['currentVersion'], equals(1));
        expect(eventSourcingInfo['uncommittedEvents'], equals(1));
        expect(eventSourcingInfo['lastEventTimestamp'], isNotNull);
      });

      test('should handle empty state in graph', () {
        // Act
        final graph = order.toGraph();

        // Assert
        expect(graph['eventSourcingEnabled'], isTrue);
        expect(graph['version'], equals(0));
        expect(graph['pendingEventCount'], equals(0));
        expect(graph['hasUncommittedEvents'], isFalse);
        expect(graph['canCreateSnapshot'], isFalse);

        final eventSourcingInfo =
            graph['eventSourcing'] as Map<String, dynamic>;
        expect(eventSourcingInfo['currentVersion'], equals(0));
        expect(eventSourcingInfo['uncommittedEvents'], equals(0));
        expect(eventSourcingInfo['lastEventTimestamp'], isNull);
      });
    });

    group('Event Processing After Persistence', () {
      test('should clear pending events after marking as processed', () {
        // Arrange
        order.placeOrder('CUST-123', ['item1']);
        order.shipOrder('TRACK-123');
        expect(order.pendingEvents.length, equals(2));

        // Act
        order.markEventsAsProcessed();

        // Assert
        expect(order.pendingEvents.length, equals(0));
        expect(order.hasUncommittedEvents, isFalse);
        expect(order.uncommittedEventCount, equals(0));

        // Version should remain the same
        expect(order.version, equals(2));
      });
    });
  });
}

/// Mock command for testing
class MockCommand {
  final Function _action;
  dynamic _lastResult;

  MockCommand(this._action);

  bool doIt() {
    try {
      _lastResult = _action();
      // If the action returns a CommandResult, use its success status
      if (_lastResult != null && _lastResult.isSuccess != null) {
        return _lastResult.isSuccess;
      }
      // If the action returns something else, assume success
      return true;
    } catch (e) {
      // Re-throw the exception so it can be caught by executeCommandWithEventSourcing
      rethrow;
    }
  }

  // Method to get the last result for error message extraction
  dynamic get lastResult => _lastResult;

  // Mock other command interface methods
  bool get executed => true;
  dynamic undo() {}
  List<dynamic> getEvents() => [];
}
