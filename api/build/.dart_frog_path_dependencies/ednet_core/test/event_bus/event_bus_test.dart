import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test event for testing event bus functionality
class TestDomainEvent implements IDomainEvent {
  @override
  final String id;

  @override
  final DateTime timestamp;

  @override
  final String name;

  @override
  final Entity? entity;

  @override
  String aggregateId;

  @override
  String aggregateType;

  @override
  int aggregateVersion;

  final String testData;

  TestDomainEvent({
    required this.name,
    required this.testData,
    this.entity,
    String? aggregateId,
    String? aggregateType,
    int? aggregateVersion,
  }) : id = Oid().toString(),
       timestamp = DateTime.now(),
       aggregateId = aggregateId ?? '',
       aggregateType = aggregateType ?? '',
       aggregateVersion = aggregateVersion ?? 0;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'name': name,
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'testData': testData,
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
  Event toBaseEvent() {
    return Event(name, 'Test domain event: $name', [], entity, toJson());
  }
}

/// Test event handler for testing
class TestEventHandler implements IEventHandler<TestDomainEvent> {
  final List<TestDomainEvent> handledEvents = [];
  final List<String> executionLog = [];
  final Function()? _onHandle;
  bool shouldFail = false;

  TestEventHandler([this._onHandle]);

  @override
  Future<void> handle(TestDomainEvent event) async {
    if (shouldFail) {
      throw Exception('Handler intentionally failed');
    }
    handledEvents.add(event);
    executionLog.add('handled: ${event.name}');
    _onHandle?.call();
  }

  @override
  bool canHandle(IDomainEvent event) => event is TestDomainEvent;

  @override
  String get handlerName => 'TestEventHandler';
}

/// Test policy that reacts to events and generates commands
class TestPolicy implements IEventTriggeredPolicy {
  @override
  String get name => 'TestPolicy';

  String get description => 'A test policy for event bus testing';

  PolicyScope? get scope => PolicyScope({'TestConcept'});

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    return event is TestDomainEvent;
  }

  @override
  bool evaluate(dynamic entity) => true;

  PolicyEvaluationResult evaluateWithDetails(dynamic entity) {
    return PolicyEvaluationResult(true, []);
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    executedActions++;
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    return [TestCommand()];
  }

  int executedActions = 0;
}

/// Test command for policy command generation
class TestCommand implements ICommandBusCommand {
  @override
  final String id;

  final String data;

  TestCommand({String? data})
    : id = Oid().toString(),
      data = data ?? 'test_command_data';

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': 'TestCommand', 'data': data};
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }
}

/// Test saga for event bus integration testing
class TestSagaForEventBus extends ProcessManager<TestSagaState> {
  final List<String> executionLog = [];
  final List<IDomainEvent> receivedEvents = [];

  TestSagaForEventBus() : super('TestSagaForEventBus');

  @override
  TestSagaState createInitialState() => TestSagaState();

  @override
  void configureWorkflow() {
    step(
      'InitialStep',
    ).whenEvent<TestDomainEvent>().then(handleInitialEvent).asStartingStep();

    step('SecondStep').whenEvent<SecondTestEvent>().then(handleSecondEvent);
  }

  Future<void> handleInitialEvent(TestDomainEvent event) async {
    executionLog.add('handleInitialEvent');
    receivedEvents.add(event);
    state.testData = event.testData;
  }

  Future<void> handleSecondEvent(SecondTestEvent event) async {
    executionLog.add('handleSecondEvent');
    receivedEvents.add(event);
    state.completedSteps.add('SecondStep');
  }

  @override
  Future<bool> correlateEvent(dynamic event) async {
    // For starting events
    if (event is TestDomainEvent && state.isNew) {
      return event.testData == 'start_saga';
    }

    // For subsequent events, correlate by saga ID if present
    if (event.sagaId != null) {
      return event.sagaId == sagaId;
    }

    // Fallback correlation by test data
    if (event.testData != null && state.testData != null) {
      return event.testData.contains(state.testData!);
    }

    return false;
  }
}

/// Test saga state
class TestSagaState extends SagaState {
  String? testData;

  TestSagaState({String? sagaId, DateTime? startedAt})
    : super(sagaId: sagaId, startedAt: startedAt);

  @override
  Map<String, dynamic> toJson() => {
    'sagaId': sagaId,
    'testData': testData,
    'startedAt': startedAt.toIso8601String(),
    'lastUpdated': lastUpdated.toIso8601String(),
    'currentStep': currentStep,
    'isCompleted': isCompleted,
    'hasFailed': hasFailed,
    'completedSteps': completedSteps.toList(),
  };

  @override
  void fromJson(Map<String, dynamic> json) {
    testData = json['testData'];
    currentStep = json['currentStep'];
    isCompleted = json['isCompleted'] ?? false;
    hasFailed = json['hasFailed'] ?? false;

    if (json['completedSteps'] != null) {
      completedSteps.addAll(List<String>.from(json['completedSteps']));
    }
  }
}

/// Second test event for multi-step saga testing
class SecondTestEvent implements IDomainEvent {
  @override
  final String id;

  @override
  final DateTime timestamp;

  @override
  final String name;

  @override
  final Entity? entity;

  @override
  String aggregateId;

  @override
  String aggregateType;

  @override
  int aggregateVersion;

  final String testData;
  String? sagaId;

  SecondTestEvent({
    required this.testData,
    this.entity,
    this.sagaId,
    String? aggregateId,
    String? aggregateType,
    int? aggregateVersion,
  }) : id = Oid().toString(),
       timestamp = DateTime.now(),
       name = 'SecondTestEvent',
       aggregateId = aggregateId ?? '',
       aggregateType = aggregateType ?? '',
       aggregateVersion = aggregateVersion ?? 0;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'name': name,
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'testData': testData,
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
  Event toBaseEvent() {
    return Event(name, 'Second test event: $name', [], entity, toJson());
  }
}

// Test domain and model setup - these need to be at module level for concept creation
var testDomain = Domain('TestDomain');
var testModel = Model(testDomain, 'TestModel');

class TestEntityForBus extends Entity<TestEntityForBus> {
  TestEntityForBus() : super() {
    concept = Concept(testModel, 'TestEntityForBus');
  }
}

void main() {
  group('EventBus Tests', () {
    late EventBus eventBus;
    late TestPolicy testPolicy;

    setUp(() {
      eventBus = EventBus();
      testPolicy = TestPolicy();
    });

    test('should register and trigger event handlers', () async {
      var handlerExecuted = false;
      final handler = TestEventHandler(() {
        handlerExecuted = true;
      });

      eventBus.registerHandler<TestDomainEvent>(handler);

      final testEvent = TestDomainEvent(
        name: 'TestEvent',
        testData: 'test_data',
      );
      await eventBus.publish(testEvent);

      expect(handlerExecuted, isTrue);
    });

    test('should register and trigger policies', () async {
      eventBus.registerPolicy(testPolicy);

      final testEvent = TestDomainEvent(
        name: 'TestEvent',
        testData: 'test_data',
      );
      await eventBus.publish(testEvent);

      expect(testPolicy.executedActions, equals(1));
    });

    test('should not trigger policies for unrelated events', () async {
      eventBus.registerPolicy(testPolicy);

      final otherEvent = SecondTestEvent(testData: 'other_data');
      await eventBus.publish(otherEvent);

      expect(testPolicy.executedActions, equals(0));
    });

    test('should handle multiple policies for same event', () async {
      final policy2 = TestPolicy();
      eventBus.registerPolicy(testPolicy);
      eventBus.registerPolicy(policy2);

      final testEvent = TestDomainEvent(
        name: 'TestEvent',
        testData: 'test_data',
      );
      await eventBus.publish(testEvent);

      expect(testPolicy.executedActions, equals(1));
      expect(policy2.executedActions, equals(1));
    });

    test('should unregister policies', () async {
      eventBus.registerPolicy(testPolicy);
      eventBus.unregisterPolicy(testPolicy);

      final testEvent = TestDomainEvent(
        name: 'TestEvent',
        testData: 'test_data',
      );
      await eventBus.publish(testEvent);

      expect(testPolicy.executedActions, equals(0));
    });

    test('should get handlers for event type', () {
      final handler = TestEventHandler();
      eventBus.registerHandler<TestDomainEvent>(handler);

      final handlers = eventBus.getHandlersFor<TestDomainEvent>();
      expect(handlers, contains(handler));
    });

    test('should check if handlers exist for event type', () {
      expect(eventBus.hasHandlerFor<TestDomainEvent>(), isFalse);

      final handler = TestEventHandler();
      eventBus.registerHandler<TestDomainEvent>(handler);

      expect(eventBus.hasHandlerFor<TestDomainEvent>(), isTrue);
    });

    test('should unregister handlers', () {
      final handler = TestEventHandler();
      eventBus.registerHandler<TestDomainEvent>(handler);

      expect(eventBus.hasHandlerFor<TestDomainEvent>(), isTrue);

      eventBus.unregisterHandler<TestDomainEvent>(handler);

      expect(eventBus.hasHandlerFor<TestDomainEvent>(), isFalse);
    });
  });
}

/// Test entity for policy testing
class TestEntity extends Entity<TestEntity> {
  TestEntity() {
    concept = TestConcept();
  }
}

/// Test concept for entity testing
class TestConcept extends Concept {
  TestConcept() : super(testModel, 'TestEntity');

  @override
  String get name => 'TestEntity';
}

/// Named event handler that only handles specific event names
class TestNamedEventHandler implements IEventHandler<TestDomainEvent> {
  final List<TestDomainEvent> handledEvents = [];

  @override
  Future<void> handle(TestDomainEvent event) async {
    handledEvents.add(event);
  }

  @override
  bool canHandle(IDomainEvent event) {
    return event is TestDomainEvent && event.name == 'SpecialEvent';
  }

  @override
  String get handlerName => 'TestNamedEventHandler';
}

/// Test command handler for command bus integration
class TestCommandHandler implements ICommandHandler<TestCommand> {
  final List<TestCommand> handledCommands = [];

  @override
  Future<CommandResult> handle(TestCommand command) async {
    handledCommands.add(command);
    return CommandResult.success(data: 'Command handled: ${command.data}');
  }

  @override
  bool canHandle(dynamic command) => command is TestCommand;
}

/// Test event store for persistence testing
class TestEventStore {
  final List<IDomainEvent> storedEvents = [];

  Future<void> store(IDomainEvent event) async {
    storedEvents.add(event);
  }
}

/// Test handler for saga completed events
class TestSagaCompletedHandler implements IEventHandler<SagaCompletedEvent> {
  final List<IDomainEvent> _handledEvents;

  TestSagaCompletedHandler(this._handledEvents);

  @override
  Future<void> handle(SagaCompletedEvent event) async {
    _handledEvents.add(event);
  }

  @override
  bool canHandle(IDomainEvent event) => event is SagaCompletedEvent;

  @override
  String get handlerName => 'TestSagaCompletedHandler';
}
