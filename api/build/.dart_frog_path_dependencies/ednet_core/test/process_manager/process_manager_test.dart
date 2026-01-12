import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test events for saga workflow testing
class OrderRequestReceived implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'OrderRequestReceived';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'OrderRequest';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String customerId;
  final List<String> items;
  String? sagaId;

  OrderRequestReceived({
    required this.customerId,
    required this.items,
    this.sagaId,
  }) : aggregateId = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'customerId': customerId,
    'items': items,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  @override
  Event toBaseEvent() =>
      Event(name, 'Order request received', [], entity, toJson());
}

class OrderCreated implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'OrderCreated';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Order';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String orderId;
  final String customerId;
  String? sagaId;

  OrderCreated({required this.orderId, required this.customerId, this.sagaId})
    : aggregateId = orderId;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'orderId': orderId,
    'customerId': customerId,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  @override
  Event toBaseEvent() => Event(name, 'Order created', [], entity, toJson());
}

class InventoryReserved implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'InventoryReserved';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Inventory';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String orderId;
  final List<String> reservedItems;
  String? sagaId;

  InventoryReserved({
    required this.orderId,
    required this.reservedItems,
    this.sagaId,
  }) : aggregateId = orderId;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'orderId': orderId,
    'reservedItems': reservedItems,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  @override
  Event toBaseEvent() =>
      Event(name, 'Inventory reserved', [], entity, toJson());
}

class PaymentProcessed implements IDomainEvent {
  @override
  final String id = Oid().toString();
  @override
  final String name = 'PaymentProcessed';
  @override
  final DateTime timestamp = DateTime.now();
  @override
  String aggregateId;
  @override
  String aggregateType = 'Payment';
  @override
  int aggregateVersion = 1;
  @override
  Entity? entity;

  final String orderId;
  final String paymentId;
  final double amount;
  String? sagaId;

  PaymentProcessed({
    required this.orderId,
    required this.paymentId,
    required this.amount,
    this.sagaId,
  }) : aggregateId = paymentId;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'orderId': orderId,
    'paymentId': paymentId,
    'amount': amount,
    'sagaId': sagaId,
  };

  @override
  Map<String, dynamic> get eventData {
    final json = toJson();
    final data = Map<String, dynamic>.from(json);

    // Remove metadata fields to leave just the event data
    data.remove('id');
    data.remove('timestamp');
    data.remove('name');
    data.remove('aggregateId');
    data.remove('aggregateType');
    data.remove('aggregateVersion');

    return data;
  }

  @override
  Event toBaseEvent() => Event(name, 'Payment processed', [], entity, toJson());
}

/// Test commands for saga workflow testing
class CreateOrderCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String customerId;
  final List<String> items;

  CreateOrderCommand({required this.customerId, required this.items});

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'items': items,
  };
}

class ReserveInventoryCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String orderId;
  final List<String> items;

  ReserveInventoryCommand({required this.orderId, required this.items});

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'items': items,
  };
}

class ProcessPaymentCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String orderId;
  final double amount;

  ProcessPaymentCommand({required this.orderId, required this.amount});

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'orderId': orderId,
    'amount': amount,
  };
}

/// Compensation commands
class CancelOrderCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String orderId;

  CancelOrderCommand(this.orderId);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'orderId': orderId};
}

class ReleaseInventoryCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String orderId;

  ReleaseInventoryCommand(this.orderId);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'orderId': orderId};
}

class RefundPaymentCommand implements ICommandBusCommand {
  @override
  final String id = Oid().toString();
  final String paymentId;

  RefundPaymentCommand(this.paymentId);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'paymentId': paymentId};
}

/// Test saga state
class TestOrderProcessingState extends SagaState {
  String? customerId;
  String? orderId;
  String? paymentId;
  List<String> items = [];
  double amount = 0.0;

  TestOrderProcessingState({String? sagaId, DateTime? startedAt})
    : super(sagaId: sagaId, startedAt: startedAt);

  @override
  Map<String, dynamic> toJson() => {
    'sagaId': sagaId,
    'customerId': customerId,
    'orderId': orderId,
    'paymentId': paymentId,
    'items': items,
    'amount': amount,
    'startedAt': startedAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'currentStep': currentStep,
    'isCompleted': isCompleted,
    'hasFailed': hasFailed,
    'completedSteps': completedSteps.toList(),
    'retryAttempts': retryAttempts,
    'sentCommands': sentCommands,
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    orderId = json['orderId'];
    paymentId = json['paymentId'];
    items = List<String>.from(json['items'] ?? []);
    amount = (json['amount'] ?? 0.0).toDouble();
    currentStep = json['currentStep'];
    isCompleted = json['isCompleted'] ?? false;
    hasFailed = json['hasFailed'] ?? false;

    if (json['completedSteps'] != null) {
      completedSteps.addAll(List<String>.from(json['completedSteps']));
    }

    if (json['retryAttempts'] != null) {
      retryAttempts.addAll(Map<String, int>.from(json['retryAttempts']));
    }

    if (json['sentCommands'] != null) {
      sentCommands.addAll(
        List<Map<String, dynamic>>.from(json['sentCommands']),
      );
    }
  }
}

/// Test saga implementation
class TestOrderProcessingSaga extends ProcessManager<TestOrderProcessingState> {
  final List<String> executionLog = [];
  final List<String> compensationLog = [];
  final List<ICommandBusCommand> sentCommands = [];

  TestOrderProcessingSaga() : super('TestOrderProcessingSaga');

  @override
  TestOrderProcessingState createInitialState() => TestOrderProcessingState();

  @override
  void configureWorkflow() {
    step('CreateOrder')
        .whenEvent<OrderRequestReceived>()
        .then(createOrder)
        .compensateWith(cancelOrder)
        .asStartingStep();

    step('ReserveInventory')
        .whenEvent<OrderCreated>()
        .then(reserveInventory)
        .compensateWith(releaseInventory)
        .withTimeout(const Duration(seconds: 1))
        .withRetry(
          RetryPolicy(maxRetries: 2, delay: const Duration(milliseconds: 10)),
        );

    step('ProcessPayment')
        .whenEvent<InventoryReserved>()
        .then(processPayment)
        .compensateWith(refundPayment);

    step('CompleteOrder').whenEvent<PaymentProcessed>().then(completeOrder);
  }

  // Step implementations
  Future<void> createOrder(OrderRequestReceived event) async {
    executionLog.add('createOrder');
    state.customerId = event.customerId;
    state.items = List.from(event.items);
    state.orderId = Oid().toString();

    final command = CreateOrderCommand(
      customerId: event.customerId,
      items: event.items,
    );

    sentCommands.add(command);
    await sendCommand(command);
  }

  Future<void> reserveInventory(OrderCreated event) async {
    executionLog.add('reserveInventory');

    final command = ReserveInventoryCommand(
      orderId: event.orderId,
      items: state.items,
    );

    sentCommands.add(command);
    await sendCommand(command);
  }

  Future<void> processPayment(InventoryReserved event) async {
    executionLog.add('processPayment');
    state.amount = state.items.length * 10.0; // Simple pricing

    final command = ProcessPaymentCommand(
      orderId: event.orderId,
      amount: state.amount,
    );

    sentCommands.add(command);
    await sendCommand(command);
  }

  Future<void> completeOrder(PaymentProcessed event) async {
    executionLog.add('completeOrder');
    state.paymentId = event.paymentId;
  }

  // Compensation methods
  Future<void> cancelOrder(dynamic context) async {
    compensationLog.add('cancelOrder');
    if (state.orderId != null) {
      final command = CancelOrderCommand(state.orderId!);
      sentCommands.add(command);
      await sendCommand(command);
    }
  }

  Future<void> releaseInventory(dynamic context) async {
    compensationLog.add('releaseInventory');
    if (state.orderId != null) {
      final command = ReleaseInventoryCommand(state.orderId!);
      sentCommands.add(command);
      await sendCommand(command);
    }
  }

  Future<void> refundPayment(dynamic context) async {
    compensationLog.add('refundPayment');
    if (state.paymentId != null) {
      final command = RefundPaymentCommand(state.paymentId!);
      sentCommands.add(command);
      await sendCommand(command);
    }
  }

  @override
  Future<bool> correlateEvent(dynamic event) async {
    // Custom correlation logic
    if (event.sagaId != null) {
      return event.sagaId == sagaId;
    }

    // For starting events, accept if we're new
    if (event is OrderRequestReceived && state.isNew) {
      return true;
    }

    // For subsequent events, correlate by order ID
    if (state.orderId != null) {
      if (event is OrderCreated) return event.orderId == state.orderId;
      if (event is InventoryReserved) return event.orderId == state.orderId;
      if (event is PaymentProcessed) return event.orderId == state.orderId;
    }

    return false;
  }
}

/// Mock command bus for testing
class MockCommandBus extends CommandBus {
  final List<ICommandBusCommand> executedCommands = [];
  bool shouldFail = false;
  String? failureMessage;

  @override
  Future<CommandResult> execute(ICommandBusCommand command) async {
    executedCommands.add(command);

    if (shouldFail) {
      return CommandResult.failure(
        failureMessage ?? 'Command execution failed',
      );
    }

    return CommandResult.success(
      data: {
        'commandId': command.id,
        'commandType': command.runtimeType.toString(),
      },
    );
  }
}

/// Mock event bus for testing
class MockEventBus extends EventBus {
  final List<IDomainEvent> publishedEvents = [];

  @override
  Future<void> publish(IDomainEvent event) async {
    publishedEvents.add(event);
  }
}

void main() {
  group('Process Manager (Saga) Tests', () {
    late TestOrderProcessingSaga saga;
    late MockCommandBus commandBus;
    late MockEventBus eventBus;

    setUp(() {
      saga = TestOrderProcessingSaga();
      commandBus = MockCommandBus();
      eventBus = MockEventBus();

      saga.setCommandBus(commandBus);
      saga.setEventBus(eventBus);
    });

    tearDown(() {
      // Clear any static state between tests
      ObservabilityExtension.clearAllObservabilityHandlers();
    });

    group('Saga Initialization', () {
      test('should initialize with correct saga type and initial state', () {
        expect(saga.sagaType, equals('TestOrderProcessingSaga'));
        expect(saga.isCompleted, isFalse);
        expect(saga.hasFailed, isFalse);
        expect(saga.currentStep, isNull);
        expect(saga.state.isNew, isTrue);
      });

      test('should configure workflow steps correctly', () {
        // Steps should be auto-built during configuration
        expect(saga.steps.length, equals(4));
        expect(saga.steps.containsKey('CreateOrder'), isTrue);
        expect(saga.steps.containsKey('ReserveInventory'), isTrue);
        expect(saga.steps.containsKey('ProcessPayment'), isTrue);
        expect(saga.steps.containsKey('CompleteOrder'), isTrue);
      });

      test('should map events to steps correctly', () {
        expect(
          saga.eventStepMappings[OrderRequestReceived],
          equals('CreateOrder'),
        );
        expect(
          saga.eventStepMappings[OrderCreated],
          equals('ReserveInventory'),
        );
        expect(
          saga.eventStepMappings[InventoryReserved],
          equals('ProcessPayment'),
        );
        expect(
          saga.eventStepMappings[PaymentProcessed],
          equals('CompleteOrder'),
        );
      });
    });

    group('Event Handling', () {
      test('should handle starting event and execute first step', () async {
        // Arrange
        final event = OrderRequestReceived(
          customerId: 'CUST-123',
          items: ['item1', 'item2'],
        );

        // Act
        await saga.handleEvent(event);

        // Assert
        expect(saga.executionLog, contains('createOrder'));
        expect(saga.state.customerId, equals('CUST-123'));
        expect(saga.state.items, equals(['item1', 'item2']));
        expect(saga.state.orderId, isNotNull);
        expect(saga.currentStep, equals('CreateOrder'));
        expect(saga.state.completedSteps, contains('CreateOrder'));
        expect(commandBus.executedCommands.length, equals(1));
        expect(commandBus.executedCommands.first, isA<CreateOrderCommand>());
      });

      test('should handle subsequent events in workflow', () async {
        // Arrange - start the saga
        final startEvent = OrderRequestReceived(
          customerId: 'CUST-123',
          items: ['item1'],
        );
        await saga.handleEvent(startEvent);

        // Act - trigger next step
        final orderCreatedEvent = OrderCreated(
          orderId: saga.state.orderId!,
          customerId: 'CUST-123',
          sagaId: saga.sagaId,
        );
        await saga.handleEvent(orderCreatedEvent);

        // Assert
        expect(saga.executionLog, contains('reserveInventory'));
        expect(saga.currentStep, equals('ReserveInventory'));
        expect(saga.state.completedSteps, contains('ReserveInventory'));
        expect(commandBus.executedCommands.length, equals(2));
        expect(
          commandBus.executedCommands.last,
          isA<ReserveInventoryCommand>(),
        );
      });

      test('should complete entire workflow successfully', () async {
        // Execute complete workflow
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        await saga.handleEvent(
          OrderCreated(
            orderId: saga.state.orderId!,
            customerId: 'CUST-123',
            sagaId: saga.sagaId,
          ),
        );

        await saga.handleEvent(
          InventoryReserved(
            orderId: saga.state.orderId!,
            reservedItems: ['item1'],
            sagaId: saga.sagaId,
          ),
        );

        await saga.handleEvent(
          PaymentProcessed(
            orderId: saga.state.orderId!,
            paymentId: 'PAY-123',
            amount: 10.0,
            sagaId: saga.sagaId,
          ),
        );

        // Assert
        expect(
          saga.executionLog,
          equals([
            'createOrder',
            'reserveInventory',
            'processPayment',
            'completeOrder',
          ]),
        );
        expect(saga.isCompleted, isTrue);
        expect(saga.state.paymentId, equals('PAY-123'));
        expect(
          eventBus.publishedEvents.length,
          equals(1),
        ); // SagaCompletedEvent
        expect(eventBus.publishedEvents.first, isA<SagaCompletedEvent>());
      });

      test('should ignore events for wrong saga instance', () async {
        // Arrange - start a saga
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        // Act - send event for different order
        final wrongEvent = OrderCreated(
          orderId: 'different-order-id',
          customerId: 'CUST-456',
        );
        await saga.handleEvent(wrongEvent);

        // Assert - should not execute step
        expect(saga.executionLog.length, equals(1)); // Only createOrder
        expect(saga.currentStep, equals('CreateOrder'));
      });
    });

    group('Event Correlation', () {
      test('should correlate events by saga ID', () async {
        // Arrange
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        // Act - event with correct saga ID
        final event = OrderCreated(
          orderId: saga.state.orderId!,
          customerId: 'CUST-123',
          sagaId: saga.sagaId,
        );
        final shouldHandle = await saga.correlateEvent(event);

        // Assert
        expect(shouldHandle, isTrue);
      });

      test(
        'should correlate events by order ID when saga ID missing',
        () async {
          // Arrange
          await saga.handleEvent(
            OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
          );

          // Act - event without saga ID but correct order ID
          final event = OrderCreated(
            orderId: saga.state.orderId!,
            customerId: 'CUST-123',
          );
          final shouldHandle = await saga.correlateEvent(event);

          // Assert
          expect(shouldHandle, isTrue);
        },
      );

      test('should not correlate events with wrong identifiers', () async {
        // Arrange
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        // Act - event with wrong order ID
        final event = OrderCreated(
          orderId: 'wrong-order-id',
          customerId: 'CUST-123',
        );
        final shouldHandle = await saga.correlateEvent(event);

        // Assert
        expect(shouldHandle, isFalse);
      });
    });

    group('Compensation (Rollback)', () {
      test('should execute compensation when step fails', () async {
        // Arrange - start saga and execute first step
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        // Make command bus fail for next step
        commandBus.shouldFail = true;
        commandBus.failureMessage = 'Inventory service unavailable';

        // Act - trigger failing step
        final orderCreatedEvent = OrderCreated(
          orderId: saga.state.orderId!,
          customerId: 'CUST-123',
          sagaId: saga.sagaId,
        );
        await saga.handleEvent(orderCreatedEvent);

        // Assert
        expect(saga.hasFailed, isTrue);
        expect(saga.compensationLog, contains('cancelOrder'));
        expect(saga.sentCommands.last, isA<CancelOrderCommand>());
        expect(
          eventBus.publishedEvents.length,
          equals(1),
        ); // SagaCompensatedEvent
        expect(eventBus.publishedEvents.first, isA<SagaCompensatedEvent>());
      });

      test('should execute compensations in reverse order', () async {
        // Arrange - execute multiple steps
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        await saga.handleEvent(
          OrderCreated(
            orderId: saga.state.orderId!,
            customerId: 'CUST-123',
            sagaId: saga.sagaId,
          ),
        );

        // Make payment step fail
        commandBus.shouldFail = true;

        await saga.handleEvent(
          InventoryReserved(
            orderId: saga.state.orderId!,
            reservedItems: ['item1'],
            sagaId: saga.sagaId,
          ),
        );

        // Assert - compensations in reverse order
        expect(
          saga.compensationLog,
          equals(['releaseInventory', 'cancelOrder']),
        );
      });
    });

    group('State Management', () {
      test('should track completed steps', () async {
        // Execute first two steps
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        await saga.handleEvent(
          OrderCreated(
            orderId: saga.state.orderId!,
            customerId: 'CUST-123',
            sagaId: saga.sagaId,
          ),
        );

        // Assert
        expect(saga.state.completedSteps, contains('CreateOrder'));
        expect(saga.state.completedSteps, contains('ReserveInventory'));
        expect(saga.state.completedSteps.length, equals(2));
      });

      test('should track sent commands', () async {
        // Execute first step
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        // Assert
        expect(saga.state.sentCommands.length, equals(1));
        expect(
          saga.state.sentCommands.first['commandType'],
          equals('CreateOrderCommand'),
        );
        expect(saga.state.sentCommands.first['result'], equals('success'));
      });

      test('should serialize and deserialize state', () {
        // Arrange - modify state
        saga.state.customerId = 'CUST-123';
        saga.state.orderId = 'ORDER-456';
        saga.state.items = ['item1', 'item2'];
        saga.state.amount = 25.0;
        saga.state.currentStep = 'ProcessPayment';
        saga.state.completedSteps.addAll(['CreateOrder', 'ReserveInventory']);

        // Act - serialize and deserialize
        final json = saga.state.toJson();
        final newState = TestOrderProcessingState();
        newState.fromJson(json);

        // Assert
        expect(newState.customerId, equals('CUST-123'));
        expect(newState.orderId, equals('ORDER-456'));
        expect(newState.items, equals(['item1', 'item2']));
        expect(newState.amount, equals(25.0));
        expect(newState.currentStep, equals('ProcessPayment'));
        expect(newState.completedSteps, contains('CreateOrder'));
        expect(newState.completedSteps, contains('ReserveInventory'));
      });
    });

    group('Retry and Timeout Handling', () {
      test('should track retry attempts', () async {
        // Arrange - start saga
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        // Make command fail to trigger retry tracking
        commandBus.shouldFail = true;

        // Act - trigger step that has retry policy
        final orderCreatedEvent = OrderCreated(
          orderId: saga.state.orderId!,
          customerId: 'CUST-123',
          sagaId: saga.sagaId,
        );
        await saga.handleEvent(orderCreatedEvent);

        // Assert - retry attempts should be tracked
        expect(
          saga.state.retryAttempts.containsKey('ReserveInventory'),
          isTrue,
        );
      });

      test('should set step start times for timeout checking', () async {
        // Act
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        // Assert
        expect(saga.state.stepStartTimes.containsKey('CreateOrder'), isTrue);
        expect(saga.state.stepStartTimes['CreateOrder'], isA<DateTime>());
      });
    });

    group('Saga Events', () {
      test('should publish saga completed event with correct data', () async {
        // Execute complete workflow
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        await saga.handleEvent(
          OrderCreated(
            orderId: saga.state.orderId!,
            customerId: 'CUST-123',
            sagaId: saga.sagaId,
          ),
        );

        await saga.handleEvent(
          InventoryReserved(
            orderId: saga.state.orderId!,
            reservedItems: ['item1'],
            sagaId: saga.sagaId,
          ),
        );

        await saga.handleEvent(
          PaymentProcessed(
            orderId: saga.state.orderId!,
            paymentId: 'PAY-123',
            amount: 10.0,
            sagaId: saga.sagaId,
          ),
        );

        // Assert
        final completedEvent =
            eventBus.publishedEvents.first as SagaCompletedEvent;
        expect(completedEvent.sagaId, equals(saga.sagaId));
        expect(completedEvent.sagaType, equals('TestOrderProcessingSaga'));
        expect(completedEvent.stepsCompleted.length, equals(4));
        expect(completedEvent.duration, isA<Duration>());
      });

      test('should publish saga compensated event on failure', () async {
        // Arrange
        await saga.handleEvent(
          OrderRequestReceived(customerId: 'CUST-123', items: ['item1']),
        );

        commandBus.shouldFail = true;
        commandBus.failureMessage = 'Service unavailable';

        // Act
        await saga.handleEvent(
          OrderCreated(
            orderId: saga.state.orderId!,
            customerId: 'CUST-123',
            sagaId: saga.sagaId,
          ),
        );

        // Assert
        final compensatedEvent =
            eventBus.publishedEvents.first as SagaCompensatedEvent;
        expect(compensatedEvent.sagaId, equals(saga.sagaId));
        expect(compensatedEvent.sagaType, equals('TestOrderProcessingSaga'));
        expect(compensatedEvent.reason, contains('Service unavailable'));
        expect(
          compensatedEvent.stepsCompleted.length,
          equals(1),
        ); // Only CreateOrder completed
      });
    });

    group('Workflow Step Configuration', () {
      test('should configure step with all options', () {
        // Check that ReserveInventory step has all configurations
        final step = saga.steps['ReserveInventory']!;

        expect(step.name, equals('ReserveInventory'));
        expect(step.triggerEventType, equals(OrderCreated));
        expect(step.compensation, isNotNull);
        expect(step.isRequired, isTrue);
        expect(step.isStartingStep, isFalse);

        // Check timeout and retry configurations
        expect(saga.stepTimeouts.containsKey('ReserveInventory'), isTrue);
        expect(saga.retryPolicies.containsKey('ReserveInventory'), isTrue);

        final retryPolicy = saga.retryPolicies['ReserveInventory']!;
        expect(retryPolicy.maxRetries, equals(2));
        expect(retryPolicy.delay, equals(const Duration(milliseconds: 10)));
      });

      test('should mark CreateOrder as starting step', () {
        final step = saga.steps['CreateOrder']!;
        expect(step.isStartingStep, isTrue);
      });
    });
  });
}
