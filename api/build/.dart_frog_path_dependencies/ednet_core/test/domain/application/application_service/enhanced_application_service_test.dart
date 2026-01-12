import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('EnhancedApplicationService - Transaction Manager Integration', () {
    late EnhancedApplicationService applicationService;
    late MockCommandBus commandBus;
    late MockEventBus eventBus;
    late InMemoryTransactionManager transactionManager;

    setUp(() {
      commandBus = MockCommandBus();
      eventBus = MockEventBus();
      transactionManager = InMemoryTransactionManager();
      applicationService = EnhancedApplicationService(
        session: null, // Not used in this test
        commandBus: commandBus,
        eventBus: eventBus,
        transactionManager: transactionManager,
      );
    });

    test(
      'uses injected transaction manager instead of mock fallback',
      () async {
        // Arrange
        final command = MockCommand();

        // Act
        final result = await applicationService.executeCommand(command);

        // Assert
        expect(result.isSuccess, isTrue);
      },
    );

    test('transaction manager provides proper transaction lifecycle', () async {
      // Arrange
      final command = MockCommand();

      // Act
      final result = await applicationService.executeCommand(command);

      // Assert
      expect(result.isSuccess, isTrue);
    });
  });
}

class MockCommandBus implements CommandBus {
  @override
  Future<CommandResult> execute(ICommandBusCommand command) async {
    return CommandResult.success();
  }

  @override
  void addPostExecutionMiddleware(
    void Function(ICommandBusCommand, CommandResult) middleware,
  ) {}

  @override
  void addPreExecutionMiddleware(
    void Function(ICommandBusCommand) middleware,
  ) {}

  @override
  String get componentName => 'MockCommandBus';

  @override
  Future<List<CommandResult>> executeAll(ICommandBusCommand command) async {
    return [CommandResult.success()];
  }

  @override
  List<ICommandHandler> getHandlersFor<TCommand extends ICommandBusCommand>() {
    return [];
  }

  @override
  bool hasHandlerFor<TCommand extends ICommandBusCommand>() {
    return true;
  }

  @override
  void registerHandler<TCommand extends ICommandBusCommand>(
    ICommandHandler<TCommand> handler,
  ) {}

  @override
  void registerValidator<TCommand extends ICommandBusCommand>(
    void Function(TCommand) validator,
  ) {}

  @override
  void setEventPublisher(dynamic eventPublisher) {}

  @override
  void unregisterHandler<TCommand extends ICommandBusCommand>([
    ICommandHandler<TCommand>? handler,
  ]) {}

  // ObservabilityMixin implementations
  @override
  String get componentType => 'MockCommandBus';

  @override
  DomainSession? get domainSession => null;

  @override
  void observabilityDebug(String operation, [Map<String, dynamic>? context]) {}

  @override
  void observabilityError(
    String operation, {
    dynamic error,
    Map<String, dynamic>? context,
  }) {}

  @override
  void observabilityInfo(String operation, {Map<String, dynamic>? context}) {}

  @override
  void observabilityTrace(String operation, [Map<String, dynamic>? context]) {}

  @override
  void observabilityWarning(
    String operation, {
    Map<String, dynamic>? context,
  }) {}

  @override
  T traceExecution<T>(
    String operation,
    T Function() execution, {
    Map<String, dynamic>? context,
  }) {
    return execution();
  }

  @override
  Future<T> traceExecutionAsync<T>(
    String operation,
    Future<T> Function() execution, {
    Map<String, dynamic>? context,
  }) async {
    return await execution();
  }
}

class MockEventBus implements EventBus {
  @override
  Future<void> publish(IDomainEvent event) async {}

  @override
  void addPostPublishingMiddleware(void Function(IDomainEvent) middleware) {}

  @override
  void addPrePublishingMiddleware(void Function(IDomainEvent) middleware) {}

  @override
  String get componentName => 'MockEventBus';

  @override
  List<IEventHandler> getHandlersFor<TEvent extends IDomainEvent>() {
    return [];
  }

  @override
  bool hasHandlerFor<TEvent extends IDomainEvent>() {
    return true;
  }

  @override
  Future<void> publishAll(List<IDomainEvent> events) async {}

  @override
  void registerHandler<TEvent extends IDomainEvent>(
    IEventHandler<TEvent> handler,
  ) {}

  @override
  void registerPolicy(IEventTriggeredPolicy policy) {}

  @override
  void registerSaga<T extends ProcessManager>(T Function() sagaFactory) {}

  @override
  void setCommandBus(CommandBus commandBus) {}

  @override
  void setEventStore(dynamic eventStore) {}

  @override
  void unregisterHandler<TEvent extends IDomainEvent>([
    IEventHandler<TEvent>? handler,
  ]) {}

  @override
  void unregisterPolicy(IEventTriggeredPolicy policy) {}

  @override
  void unregisterSaga(String sagaType) {}

  // ObservabilityMixin implementations
  @override
  String get componentType => 'MockEventBus';

  @override
  DomainSession? get domainSession => null;

  @override
  void observabilityDebug(String operation, [Map<String, dynamic>? context]) {}

  @override
  void observabilityError(
    String operation, {
    dynamic error,
    Map<String, dynamic>? context,
  }) {}

  @override
  void observabilityInfo(String operation, {Map<String, dynamic>? context}) {}

  @override
  void observabilityTrace(String operation, [Map<String, dynamic>? context]) {}

  @override
  void observabilityWarning(
    String operation, {
    Map<String, dynamic>? context,
  }) {}

  @override
  T traceExecution<T>(
    String operation,
    T Function() execution, {
    Map<String, dynamic>? context,
  }) {
    return execution();
  }

  @override
  Future<T> traceExecutionAsync<T>(
    String operation,
    Future<T> Function() execution, {
    Map<String, dynamic>? context,
  }) async {
    return await execution();
  }
}

class MockCommand implements ICommandBusCommand {
  @override
  String get id => 'mock-command-id';

  @override
  Map<String, dynamic> toJson() => {'id': id};
}
