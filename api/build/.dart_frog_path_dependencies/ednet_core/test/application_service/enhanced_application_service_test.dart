import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test command for application service testing
class TestApplicationCommand implements ICommandBusCommand {
  @override
  final String id;
  final String customerId;
  final String orderData;
  final bool shouldFail;

  TestApplicationCommand({
    required this.customerId,
    required this.orderData,
    this.shouldFail = false,
  }) : id = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'orderData': orderData,
    'shouldFail': shouldFail,
  };
}

/// Test aggregate for application service testing
class TestOrderAggregate extends AggregateRoot<TestOrderAggregate> {
  String? customerId;
  String? orderData;
  String status = 'created';

  TestOrderAggregate() {
    concept = TestOrderConcept();
  }

  CommandResult processCommand(TestApplicationCommand command) {
    if (command.shouldFail) {
      return CommandResult.failure('Order processing failed');
    }

    customerId = command.customerId;
    orderData = command.orderData;
    status = 'processed';

    // Record domain event
    recordEventLegacy(
      'OrderProcessed',
      'Order was successfully processed',
      ['OrderConfirmationHandler'],
      data: {
        'orderId': oid.toString(),
        'customerId': customerId,
        'orderData': orderData,
      },
    );

    return CommandResult.success(data: {'orderId': oid.toString()});
  }

  @override
  CommandResult executeCommand(dynamic command) {
    if (command is TestApplicationCommand) {
      return processCommand(command);
    }
    return CommandResult.failure('Unknown command type');
  }

  @override
  void applyEvent(dynamic event) {
    if (event?.name == 'OrderProcessed') {
      status = 'confirmed';
    }
  }
}

/// Test concept for aggregate - fixed to extend Concept properly
class TestOrderConcept extends Concept {
  TestOrderConcept() : super(testModel, 'TestOrder');
}

/// Test repository for application service testing
class TestOrderRepository {
  final Map<String, TestOrderAggregate> _store = {};
  final List<TestOrderAggregate> savedAggregates = [];
  final List<String> operationLog = [];

  Future<TestOrderAggregate?> findById(String id) async {
    operationLog.add('findById: $id');
    return _store[id];
  }

  Future<void> save(TestOrderAggregate aggregate) async {
    operationLog.add('save: ${aggregate.oid}');
    _store[aggregate.oid.toString()] = aggregate;
    savedAggregates.add(aggregate);
  }

  TestOrderAggregate createNew() {
    final aggregate = TestOrderAggregate();
    operationLog.add('createNew: ${aggregate.oid}');
    return aggregate;
  }
}

/// Test command handler for application service integration
class TestApplicationCommandHandler
    implements ICommandHandler<TestApplicationCommand> {
  final TestOrderRepository _repository;
  final List<TestApplicationCommand> handledCommands = [];

  TestApplicationCommandHandler(
    this._repository, {
    EventBus? eventBus,
  }); // eventBus parameter removed as unused

  @override
  Future<CommandResult> handle(TestApplicationCommand command) async {
    handledCommands.add(command);

    // Simulate aggregate loading and command processing
    final aggregate = _repository.createNew();
    final result = aggregate.processCommand(command);

    if (result.isSuccess) {
      await _repository.save(aggregate);

      // Note: Don't manually publish events here when using EnhancedApplicationService
      // The EnhancedApplicationService will handle event publishing automatically
      // This prevents double event publishing
    }

    return result;
  }

  @override
  bool canHandle(dynamic command) => command is TestApplicationCommand;

  // Removed unused method _createDomainEventFromBaseEvent - was not referenced in tests
}

/// Test event handler for application service integration
class TestOrderEventHandler implements IEventHandler<IDomainEvent> {
  final List<IDomainEvent> handledEvents = [];

  @override
  Future<void> handle(IDomainEvent event) async {
    handledEvents.add(event);
  }

  @override
  bool canHandle(IDomainEvent event) => event.name == 'OrderProcessed';

  @override
  String get handlerName => 'TestOrderEventHandler';
}

/// Test transaction for application service testing
class TestTransaction {
  final String name;
  bool isCommitted = false;
  bool isRolledBack = false;
  final List<String> operationLog = [];

  TestTransaction(this.name);

  void commit() {
    operationLog.add('commit');
    isCommitted = true;
  }

  void rollback() {
    operationLog.add('rollback');
    isRolledBack = true;
  }

  bool get isActive => !isCommitted && !isRolledBack;
}

/// Test session for application service testing
class TestDomainSession {
  final List<TestTransaction> transactions = [];
  final List<IDomainEvent> publishedEvents = [];

  TestTransaction beginTransaction(String name) {
    final transaction = TestTransaction(name);
    transactions.add(transaction);
    return transaction;
  }

  void publishEvent(IDomainEvent event) {
    publishedEvents.add(event);
  }
}

/// Faulty command handler for testing error scenarios
class FaultyCommandHandler implements ICommandHandler<TestApplicationCommand> {
  @override
  Future<CommandResult> handle(TestApplicationCommand command) async {
    throw Exception('Command handler failure');
  }

  @override
  bool canHandle(dynamic command) => command is TestApplicationCommand;
}

/// Faulty event handler for testing event publishing error scenarios
class FaultyEventHandler implements IEventHandler<IDomainEvent> {
  @override
  Future<void> handle(IDomainEvent event) async {
    throw Exception('Event handler failure');
  }

  @override
  bool canHandle(IDomainEvent event) => true;

  @override
  String get handlerName => 'FaultyEventHandler';
}

/// Validation result for testing
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.success() => ValidationResult._(true, null);
  factory ValidationResult.failure(String message) =>
      ValidationResult._(false, message);
}

// Test domain and model setup at module level
var testDomain = Domain('TestDomain');
var testModel = Model(testDomain, 'TestModel');

void main() {
  group('Enhanced Application Service Tests', () {
    late EnhancedApplicationService appService;
    late CommandBus commandBus;
    late EventBus eventBus;
    late TestDomainSession session;
    late TestApplicationCommandHandler commandHandler;
    late TestOrderEventHandler eventHandler;
    late TestOrderRepository repository;

    setUp(() {
      commandBus = CommandBus();
      eventBus = EventBus();
      session = TestDomainSession();
      repository = TestOrderRepository();
      commandHandler = TestApplicationCommandHandler(
        repository,
        eventBus: eventBus,
      );
      eventHandler = TestOrderEventHandler();

      // Register handlers
      commandBus.registerHandler<TestApplicationCommand>(commandHandler);
      eventBus.registerHandler<IDomainEvent>(eventHandler);

      // Create application service with proper named parameters
      appService = EnhancedApplicationService(
        session: session,
        commandBus: commandBus,
        eventBus: eventBus,
      );
    });

    group('Command Execution with Transaction Management', () {
      test('should execute command successfully with transaction', () async {
        // Arrange
        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'Test order data',
        );

        // Act
        final result = await appService.executeCommand(command);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(commandHandler.handledCommands.length, equals(1));
      });

      test('should rollback transaction on command failure', () async {
        // Arrange
        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'Test order data',
          shouldFail: true,
        );

        // Act
        final result = await appService.executeCommand(command);

        // Assert
        expect(result.isFailure, isTrue);
      });

      test('should handle command handler exceptions gracefully', () async {
        // Arrange - unregister the working handler first, then register faulty handler
        commandBus.unregisterHandler<TestApplicationCommand>(commandHandler);
        final faultyHandler = FaultyCommandHandler();
        commandBus.registerHandler<TestApplicationCommand>(faultyHandler);

        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'Test order data',
        );

        // Act
        final result = await appService.executeCommand(command);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('handler failure'));
      });
    });

    group('Event Publishing Coordination', () {
      test(
        'should publish events after successful command execution',
        () async {
          // Arrange
          eventHandler.handledEvents.clear(); // Clear any previous events

          final command = TestApplicationCommand(
            customerId: 'CUST-123',
            orderData: 'Test order data',
          );

          // Act
          final result = await appService.executeCommand(command);

          // Assert
          expect(result.isSuccess, isTrue);
          expect(eventHandler.handledEvents.length, equals(1));
          expect(
            eventHandler.handledEvents.first.name,
            equals('OrderProcessed'),
          );
        },
      );

      test('should not publish events if command execution fails', () async {
        // Arrange
        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'Test order data',
          shouldFail: true,
        );

        // Act
        final result = await appService.executeCommand(command);

        // Assert
        expect(result.isFailure, isTrue);
        expect(eventHandler.handledEvents.length, equals(0));
      });

      test('should handle event publishing failures gracefully', () async {
        // Arrange
        final faultyEventHandler = FaultyEventHandler();
        eventBus.registerHandler<IDomainEvent>(faultyEventHandler);

        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'Test order data',
        );

        // Act
        final result = await appService.executeCommand(command);

        // Assert - command should still succeed even if event publishing fails
        expect(result.isSuccess, isTrue);
      });
    });

    group('Aggregate Lifecycle Management', () {
      test('should load existing aggregate and execute command', () async {
        // Arrange - create and save an aggregate first
        final existingAggregate = repository.createNew();
        await repository.save(existingAggregate);

        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'Update order data',
        );

        // Act
        final result = await appService.executeCommandOnAggregate(
          command,
          existingAggregate.oid.toString(),
          repository,
        );

        // Assert
        if (result.isFailure) {
          print('Command failed with error: ${result.errorMessage}');
        }
        expect(result.isSuccess, isTrue);
        expect(
          repository.operationLog,
          contains('findById: ${existingAggregate.oid}'),
        );
      });

      test('should create new aggregate when not found', () async {
        // Arrange
        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'New order data',
        );

        // Act
        final result = await appService.executeCommandOnNewAggregate(
          command,
          repository,
        );

        // Assert
        if (result.isFailure) {
          print('Command failed with error: ${result.errorMessage}');
        }
        expect(result.isSuccess, isTrue);
        expect(repository.operationLog, contains(startsWith('createNew:')));
        expect(repository.savedAggregates.length, equals(1));
      });

      test('should validate aggregate before command execution', () async {
        // Arrange
        final command = TestApplicationCommand(
          customerId: '', // Invalid customer ID
          orderData: 'Test order data',
        );

        // Act
        final result = await appService.executeCommandWithValidation(
          command,
          repository,
          validator: (cmd) =>
              (cmd as TestApplicationCommand).customerId.isNotEmpty
              ? ValidationResult.success()
              : ValidationResult.failure('Customer ID required'),
        );

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Customer ID required'));
        expect(repository.savedAggregates.length, equals(0));
      });
    });

    group('Workflow Orchestration', () {
      test(
        'should execute multi-step workflow with proper transaction boundaries',
        () async {
          // Arrange
          final commands = <ICommandBusCommand>[
            TestApplicationCommand(customerId: 'CUST-123', orderData: 'Step 1'),
            TestApplicationCommand(customerId: 'CUST-123', orderData: 'Step 2'),
            TestApplicationCommand(customerId: 'CUST-123', orderData: 'Step 3'),
          ];

          // Act
          final results = await appService.executeWorkflow(commands);

          // Assert
          expect(results.length, equals(3));
          expect(results.every((r) => r.isSuccess), isTrue);
        },
      );

      test('should rollback entire workflow on any step failure', () async {
        // Arrange
        final commands = <ICommandBusCommand>[
          TestApplicationCommand(customerId: 'CUST-123', orderData: 'Step 1'),
          TestApplicationCommand(
            customerId: 'CUST-123',
            orderData: 'Step 2',
            shouldFail: true,
          ),
          TestApplicationCommand(customerId: 'CUST-123', orderData: 'Step 3'),
        ];

        // Act
        final results = await appService.executeWorkflow(commands);

        // Assert
        expect(results.length, equals(2)); // Should stop at failure
        expect(results.last.isFailure, isTrue);
      });
    });

    group('Performance and Monitoring', () {
      test('should provide execution metrics', () async {
        // Arrange
        final command = TestApplicationCommand(
          customerId: 'CUST-123',
          orderData: 'Test order data',
        );

        // Act
        final result = await appService.executeCommandWithMetrics(command);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, isNotNull);
        expect(result.data!['metrics'], isNotNull);
        expect(
          result.data!['metrics']['commandType'],
          equals('TestApplicationCommand'),
        );
      });

      test('should handle concurrent command execution', () async {
        // Arrange
        final commands = List.generate(
          5,
          (i) => TestApplicationCommand(
            customerId: 'CUST-$i',
            orderData: 'Concurrent test $i',
          ),
        );

        // Act
        final futures = commands.map((cmd) => appService.executeCommand(cmd));
        final results = await Future.wait(futures);

        // Assert
        expect(results.length, equals(5));
        expect(results.every((r) => r.isSuccess), isTrue);
        expect(commandHandler.handledCommands.length, equals(5));
      });
    });

    test('should execute workflow with multiple commands', () async {
      final commands = <ICommandBusCommand>[
        TestApplicationCommand(customerId: 'CUST-123', orderData: 'item1'),
        TestApplicationCommand(customerId: 'CUST-123', orderData: 'item2'),
      ];

      final results = await appService.executeWorkflow(commands);

      expect(results.length, equals(2));
      expect(results.every((r) => r.isSuccess), isTrue);
    });
  });
}
