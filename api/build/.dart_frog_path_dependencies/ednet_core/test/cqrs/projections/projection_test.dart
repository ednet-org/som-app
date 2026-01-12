import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test projection for order summaries - implements the book Chapter 6 pattern
class OrderSummaryProjection extends Projection {
  final IReadModelRepository<OrderSummaryReadModel> _repository;
  final List<IDomainEvent> _processedEvents = [];

  OrderSummaryProjection(this._repository);

  @override
  String get name => 'OrderSummaryProjection';

  @override
  bool canHandle(IDomainEvent event) {
    return event.name == 'OrderPlaced' ||
        event.name == 'OrderShipped' ||
        event.name == 'OrderCancelled';
  }

  @override
  Future<void> handle(IDomainEvent event) async {
    _processedEvents.add(event);

    switch (event.name) {
      case 'OrderPlaced':
        await _handleOrderPlaced(event);
        break;
      case 'OrderShipped':
        await _handleOrderShipped(event);
        break;
      case 'OrderCancelled':
        await _handleOrderCancelled(event);
        break;
    }
  }

  Future<void> _handleOrderPlaced(IDomainEvent event) async {
    final readModel = OrderSummaryReadModel(
      orderId: event.aggregateId,
      customerName: event.data['customerName'] ?? 'Unknown',
      totalAmount: (event.data['totalAmount'] ?? 0.0).toDouble(),
      status: 'Placed',
      orderDate: DateTime.parse(
        event.data['orderDate'] ?? DateTime.now().toIso8601String(),
      ),
    );

    await _repository.save(readModel);
  }

  Future<void> _handleOrderShipped(IDomainEvent event) async {
    final existing = await _repository.getById(event.aggregateId);
    if (existing != null) {
      final updated = existing.copyWith(status: 'Shipped');
      await _repository.save(updated);
    }
  }

  Future<void> _handleOrderCancelled(IDomainEvent event) async {
    final existing = await _repository.getById(event.aggregateId);
    if (existing != null) {
      final updated = existing.copyWith(status: 'Cancelled');
      await _repository.save(updated);
    }
  }

  @override
  Future<void> rebuild() async {
    await _repository.clear();
    _processedEvents.clear();
    // In a real implementation, this would replay all events from the event store
  }

  // Test helper methods
  List<IDomainEvent> get processedEvents => List.unmodifiable(_processedEvents);
  int get processedEventCount => _processedEvents.length;
}

/// Test read model for order summaries used in projection tests
class OrderSummaryReadModel extends ReadModel {
  final String orderId;
  final String customerName;
  final double totalAmount;
  final String status;
  final DateTime orderDate;

  OrderSummaryReadModel({
    required this.orderId,
    required this.customerName,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    DateTime? lastUpdated,
  }) : super(id: orderId, lastUpdated: lastUpdated ?? DateTime.now());

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'customerName': customerName,
    'totalAmount': totalAmount,
    'status': status,
    'orderDate': orderDate.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  OrderSummaryReadModel copyWith({
    String? customerName,
    double? totalAmount,
    String? status,
    DateTime? orderDate,
  }) {
    return OrderSummaryReadModel(
      orderId: orderId,
      customerName: customerName ?? this.customerName,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      lastUpdated: DateTime.now(),
    );
  }
}

/// Test projection for customer profiles
class CustomerProfileProjection extends Projection {
  final IReadModelRepository<CustomerProfileReadModel> _repository;
  final List<IDomainEvent> _processedEvents = [];

  CustomerProfileProjection(this._repository);

  @override
  String get name => 'CustomerProfileProjection';

  @override
  bool canHandle(IDomainEvent event) {
    return event.name == 'CustomerRegistered' || event.name == 'OrderPlaced';
  }

  @override
  Future<void> handle(IDomainEvent event) async {
    _processedEvents.add(event);

    switch (event.name) {
      case 'CustomerRegistered':
        await _handleCustomerRegistered(event);
        break;
      case 'OrderPlaced':
        await _handleCustomerOrderPlaced(event);
        break;
    }
  }

  Future<void> _handleCustomerRegistered(IDomainEvent event) async {
    final readModel = CustomerProfileReadModel(
      customerId: event.aggregateId,
      name: event.data['name'] ?? 'Unknown',
      email: event.data['email'] ?? '',
      totalOrders: 0,
      totalSpent: 0.0,
      customerTier: 'Bronze',
    );

    await _repository.save(readModel);
  }

  Future<void> _handleCustomerOrderPlaced(IDomainEvent event) async {
    final customerId = event.data['customerId'];
    if (customerId != null) {
      final existing = await _repository.getById(customerId);
      if (existing != null) {
        final orderAmount = (event.data['totalAmount'] ?? 0.0).toDouble();
        final newTotalOrders = existing.totalOrders + 1;
        final newTotalSpent = existing.totalSpent + orderAmount;

        // Determine new tier
        String newTier = 'Bronze';
        if (newTotalSpent >= 1000)
          newTier = 'Gold';
        else if (newTotalSpent >= 500)
          newTier = 'Silver';

        final updated = CustomerProfileReadModel(
          customerId: existing.customerId,
          name: existing.name,
          email: existing.email,
          totalOrders: newTotalOrders,
          totalSpent: newTotalSpent,
          customerTier: newTier,
        );

        await _repository.save(updated);
      }
    }
  }

  @override
  Future<void> rebuild() async {
    await _repository.clear();
    _processedEvents.clear();
  }

  // Test helper methods
  List<IDomainEvent> get processedEvents => List.unmodifiable(_processedEvents);
}

/// Test read model for customer profiles used in projection tests
class CustomerProfileReadModel extends ReadModel {
  final String customerId;
  final String name;
  final String email;
  final int totalOrders;
  final double totalSpent;
  final String customerTier;

  CustomerProfileReadModel({
    required this.customerId,
    required this.name,
    required this.email,
    required this.totalOrders,
    required this.totalSpent,
    required this.customerTier,
    DateTime? lastUpdated,
  }) : super(id: customerId, lastUpdated: lastUpdated ?? DateTime.now());

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'name': name,
    'email': email,
    'totalOrders': totalOrders,
    'totalSpent': totalSpent,
    'customerTier': customerTier,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}

/// Mock domain event for testing
class MockDomainEvent implements IDomainEvent {
  @override
  final String id = 'test-event-id';

  @override
  final String name;

  @override
  String aggregateId;

  @override
  final DateTime timestamp;

  final Map<String, dynamic> data;

  @override
  String aggregateType = 'TestAggregate';

  @override
  int aggregateVersion = 1;

  MockDomainEvent({
    required this.name,
    required this.aggregateId,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  Entity? get entity => null;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'timestamp': timestamp.toIso8601String(),
    'data': data,
  };

  @override
  Map<String, dynamic> get eventData => data;

  @override
  Event toBaseEvent() {
    return Event(name, 'Test event: $name', [], null, data);
  }
}

void main() {
  group('CQRS Projection Tests', () {
    group('Projection Base Class', () {
      late InMemoryReadModelRepository<OrderSummaryReadModel> repository;
      late OrderSummaryProjection projection;

      setUp(() {
        repository = InMemoryReadModelRepository<OrderSummaryReadModel>();
        projection = OrderSummaryProjection(repository);
      });

      test('should have required properties', () {
        // Assert
        expect(projection.name, equals('OrderSummaryProjection'));
        expect(projection.canHandle, isA<Function>());
        expect(projection.handle, isA<Function>());
        expect(projection.rebuild, isA<Function>());
      });

      test('should identify handleable events correctly', () {
        // Arrange
        final orderPlacedEvent = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-123',
          data: {},
        );

        final orderShippedEvent = MockDomainEvent(
          name: 'OrderShipped',
          aggregateId: 'order-123',
          data: {},
        );

        final unrelatedEvent = MockDomainEvent(
          name: 'ProductCreated',
          aggregateId: 'product-456',
          data: {},
        );

        // Act & Assert
        expect(projection.canHandle(orderPlacedEvent), isTrue);
        expect(projection.canHandle(orderShippedEvent), isTrue);
        expect(projection.canHandle(unrelatedEvent), isFalse);
      });

      test('should handle OrderPlaced event and create read model', () async {
        // Arrange
        final event = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-123',
          data: {
            'customerName': 'John Doe',
            'totalAmount': 150.75,
            'orderDate': '2024-12-01T10:30:00.000Z',
          },
        );

        // Act
        await projection.handle(event);

        // Assert
        expect(projection.processedEventCount, equals(1));
        expect(projection.processedEvents.first.name, equals('OrderPlaced'));

        final readModel = await repository.getById('order-123');
        expect(readModel, isNotNull);
        expect(readModel!.orderId, equals('order-123'));
        expect(readModel.customerName, equals('John Doe'));
        expect(readModel.totalAmount, equals(150.75));
        expect(readModel.status, equals('Placed'));
      });

      test(
        'should handle OrderShipped event and update existing read model',
        () async {
          // Arrange - first create an order
          final orderPlacedEvent = MockDomainEvent(
            name: 'OrderPlaced',
            aggregateId: 'order-123',
            data: {
              'customerName': 'John Doe',
              'totalAmount': 150.75,
              'orderDate': '2024-12-01T10:30:00.000Z',
            },
          );
          await projection.handle(orderPlacedEvent);

          final orderShippedEvent = MockDomainEvent(
            name: 'OrderShipped',
            aggregateId: 'order-123',
            data: {},
          );

          // Act
          await projection.handle(orderShippedEvent);

          // Assert
          expect(projection.processedEventCount, equals(2));

          final readModel = await repository.getById('order-123');
          expect(readModel, isNotNull);
          expect(readModel!.status, equals('Shipped'));
          expect(
            readModel.customerName,
            equals('John Doe'),
          ); // Other properties unchanged
          expect(readModel.totalAmount, equals(150.75));
        },
      );

      test('should handle OrderCancelled event and update status', () async {
        // Arrange - first create an order
        final orderPlacedEvent = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-456',
          data: {
            'customerName': 'Jane Smith',
            'totalAmount': 99.99,
            'orderDate': '2024-12-01T11:00:00.000Z',
          },
        );
        await projection.handle(orderPlacedEvent);

        final orderCancelledEvent = MockDomainEvent(
          name: 'OrderCancelled',
          aggregateId: 'order-456',
          data: {},
        );

        // Act
        await projection.handle(orderCancelledEvent);

        // Assert
        final readModel = await repository.getById('order-456');
        expect(readModel, isNotNull);
        expect(readModel!.status, equals('Cancelled'));
        expect(readModel.customerName, equals('Jane Smith'));
      });

      test(
        'should rebuild projection by clearing repository and state',
        () async {
          // Arrange - process some events first
          final event1 = MockDomainEvent(
            name: 'OrderPlaced',
            aggregateId: 'order-123',
            data: {
              'customerName': 'John',
              'totalAmount': 100.0,
              'orderDate': DateTime.now().toIso8601String(),
            },
          );
          final event2 = MockDomainEvent(
            name: 'OrderPlaced',
            aggregateId: 'order-456',
            data: {
              'customerName': 'Jane',
              'totalAmount': 200.0,
              'orderDate': DateTime.now().toIso8601String(),
            },
          );

          await projection.handle(event1);
          await projection.handle(event2);
          expect(projection.processedEventCount, equals(2));
          expect(await repository.count(), equals(2));

          // Act
          await projection.rebuild();

          // Assert
          expect(projection.processedEventCount, equals(0));
          expect(await repository.count(), equals(0));
        },
      );
    });

    group('Customer Profile Projection', () {
      late InMemoryReadModelRepository<CustomerProfileReadModel> repository;
      late CustomerProfileProjection projection;

      setUp(() {
        repository = InMemoryReadModelRepository<CustomerProfileReadModel>();
        projection = CustomerProfileProjection(repository);
      });

      test('should handle CustomerRegistered event', () async {
        // Arrange
        final event = MockDomainEvent(
          name: 'CustomerRegistered',
          aggregateId: 'customer-123',
          data: {'name': 'Alice Johnson', 'email': 'alice@example.com'},
        );

        // Act
        await projection.handle(event);

        // Assert
        final readModel = await repository.getById('customer-123');
        expect(readModel, isNotNull);
        expect(readModel!.customerId, equals('customer-123'));
        expect(readModel.name, equals('Alice Johnson'));
        expect(readModel.email, equals('alice@example.com'));
        expect(readModel.totalOrders, equals(0));
        expect(readModel.totalSpent, equals(0.0));
        expect(readModel.customerTier, equals('Bronze'));
      });

      test('should update customer profile when order is placed', () async {
        // Arrange - first register the customer
        final customerRegisteredEvent = MockDomainEvent(
          name: 'CustomerRegistered',
          aggregateId: 'customer-123',
          data: {'name': 'Alice Johnson', 'email': 'alice@example.com'},
        );
        await projection.handle(customerRegisteredEvent);

        final orderPlacedEvent = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-789',
          data: {'customerId': 'customer-123', 'totalAmount': 300.0},
        );

        // Act
        await projection.handle(orderPlacedEvent);

        // Assert
        final readModel = await repository.getById('customer-123');
        expect(readModel, isNotNull);
        expect(readModel!.totalOrders, equals(1));
        expect(readModel.totalSpent, equals(300.0));
        expect(readModel.customerTier, equals('Bronze')); // < 500
      });

      test('should upgrade customer tier based on total spent', () async {
        // Arrange - register customer
        final customerRegisteredEvent = MockDomainEvent(
          name: 'CustomerRegistered',
          aggregateId: 'customer-123',
          data: {'name': 'Alice Johnson', 'email': 'alice@example.com'},
        );
        await projection.handle(customerRegisteredEvent);

        // First order - should be Silver tier
        final orderEvent1 = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-1',
          data: {'customerId': 'customer-123', 'totalAmount': 600.0},
        );

        // Act
        await projection.handle(orderEvent1);

        // Assert Silver tier
        var readModel = await repository.getById('customer-123');
        expect(readModel!.totalSpent, equals(600.0));
        expect(readModel.customerTier, equals('Silver'));

        // Second order - should upgrade to Gold tier
        final orderEvent2 = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-2',
          data: {'customerId': 'customer-123', 'totalAmount': 500.0},
        );

        await projection.handle(orderEvent2);

        // Assert Gold tier
        readModel = await repository.getById('customer-123');
        expect(readModel!.totalOrders, equals(2));
        expect(readModel.totalSpent, equals(1100.0));
        expect(readModel.customerTier, equals('Gold'));
      });
    });

    group('Projection Error Handling', () {
      late InMemoryReadModelRepository<OrderSummaryReadModel> repository;
      late OrderSummaryProjection projection;

      setUp(() {
        repository = InMemoryReadModelRepository<OrderSummaryReadModel>();
        projection = OrderSummaryProjection(repository);
      });

      test('should handle missing data gracefully', () async {
        // Arrange - event with minimal data
        final event = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-123',
          data: {}, // Missing all optional data
        );

        // Act
        await projection.handle(event);

        // Assert - should still create read model with defaults
        final readModel = await repository.getById('order-123');
        expect(readModel, isNotNull);
        expect(readModel!.customerName, equals('Unknown'));
        expect(readModel.totalAmount, equals(0.0));
        expect(readModel.status, equals('Placed'));
      });

      test(
        'should handle update events for non-existent read models gracefully',
        () async {
          // Arrange - try to ship an order that was never placed
          final orderShippedEvent = MockDomainEvent(
            name: 'OrderShipped',
            aggregateId: 'non-existent-order',
            data: {},
          );

          // Act - should not throw
          await projection.handle(orderShippedEvent);

          // Assert - should track the event but not create a read model
          expect(projection.processedEventCount, equals(1));
          final readModel = await repository.getById('non-existent-order');
          expect(readModel, isNull);
        },
      );
    });
  });

  group('ProjectionEventData Extension - TDD Fix for Hardcoded MockDomainEvent', () {
    test(
      'GIVEN: MockDomainEvent WHEN: accessing data property THEN: returns event data without hardcoded string checks',
      () {
        // Arrange - Create a mock event with test data
        final testData = {'customerName': 'John Doe', 'totalAmount': 99.99};
        final mockEvent = MockDomainEvent(
          name: 'OrderPlaced',
          aggregateId: 'order-123',
          data: testData,
        );

        // Act - Access data through the extension (this should work without hardcoded checks)
        final eventData = mockEvent.data;

        // Assert - Should return the test data
        expect(eventData, equals(testData));
        expect(eventData['customerName'], equals('John Doe'));
        expect(eventData['totalAmount'], equals(99.99));
      },
    );

    test(
      'GIVEN: DomainEvent with JSON data WHEN: accessing data property THEN: extracts data from JSON representation',
      () {
        // Arrange - Create a domain event with data
        final domain = Domain('TestDomain');
        final model = Model(domain, 'TestModel');
        final concept = Concept(model, 'TestConcept');

        // Add attribute to concept first
        final testAttribute = Attribute(concept, 'testField');
        testAttribute.type = domain.getType('String');

        final entity = DynamicEntity.withConcept(concept);
        entity.setAttribute('testField', 'testValue');

        final domainEvent = DomainEvent(
          id: 'test-event-id',
          name: 'TestEvent',
          timestamp: DateTime.now(),
          entity: entity,
          aggregateId: 'test-aggregate',
          aggregateType: 'TestAggregate',
          aggregateVersion: 1,
        );

        // Act - Access data through extension
        final eventData = domainEvent.data;

        // Assert - Should extract data from the event
        expect(eventData, isA<Map<String, dynamic>>());
        expect(eventData.containsKey('id'), isFalse); // Should remove metadata
        expect(eventData.containsKey('timestamp'), isFalse);
        expect(eventData.containsKey('name'), isFalse);
        expect(eventData.containsKey('aggregateId'), isFalse);
      },
    );

    test(
      'GIVEN: Event without data WHEN: accessing data property THEN: returns empty map',
      () {
        // Arrange - Create a minimal event
        final mockEvent = MockDomainEvent(
          name: 'EmptyEvent',
          aggregateId: 'empty-123',
          data: {},
        );

        // Act
        final eventData = mockEvent.data;

        // Assert
        expect(eventData, isA<Map<String, dynamic>>());
        expect(eventData.isEmpty, isTrue);
      },
    );
  });
}
