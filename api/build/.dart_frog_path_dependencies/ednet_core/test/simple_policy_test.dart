import 'package:test/test.dart';
import '../lib/ednet_core.dart';

void main() {
  group('Simple Policy Execution Tests', () {
    late CommandBus commandBus;
    late EventBus eventBus;

    setUp(() {
      // Create a minimal domain model for testing
      final domain = Domain('TestDomain');
      Model(domain, 'TestModel');
      final domainModels = DomainModels(domain);

      DomainSession(domainModels);
      commandBus = CommandBus();
      eventBus = EventBus();

      // Set up basic infrastructure
      eventBus.setCommandBus(commandBus);
      commandBus.setEventPublisher(eventBus);
    });

    test('Policy registration and basic execution', () async {
      // Create a simple test policy
      final testPolicy = TestEventTriggeredPolicy('TestPolicy');

      // Register the policy
      eventBus.registerPolicy(testPolicy);

      // Create a test event
      final testEvent = TestDomainEvent(
        name: 'TestEventOccurred',
        aggregateId: 'test-123',
        aggregateType: 'TestAggregate',
      );

      // Publish the event
      await eventBus.publish(testEvent);

      // Verify policy was triggered
      expect(
        testPolicy.wasTriggered,
        isTrue,
        reason: 'Policy should have been triggered by the event',
      );
      expect(
        testPolicy.executionLog.length,
        greaterThan(0),
        reason: 'Policy should have execution log entries',
      );

      print('Policy execution log: ${testPolicy.executionLog}');
    });

    test('Command generation from policy', () async {
      // Create a test policy that generates commands
      final commandGeneratingPolicy = CommandGeneratingPolicy(
        'CommandGenPolicy',
      );

      // Register the policy
      eventBus.registerPolicy(commandGeneratingPolicy);

      // Create a test event
      final testEvent = TestDomainEvent(
        name: 'CommandTriggerEvent',
        aggregateId: 'cmd-test-123',
        aggregateType: 'CommandTestAggregate',
      );

      // Publish the event
      await eventBus.publish(testEvent);

      // Verify policy was triggered and generated commands
      expect(commandGeneratingPolicy.wasTriggered, isTrue);
      expect(
        commandGeneratingPolicy.commandsGenerated.length,
        greaterThan(0),
        reason: 'Policy should have generated commands',
      );

      print('Commands generated: ${commandGeneratingPolicy.commandsGenerated}');
    });
  });
}

/// Simple test policy for debugging
class TestEventTriggeredPolicy implements IEventTriggeredPolicy {
  @override
  final String name;

  bool wasTriggered = false;
  List<String> executionLog = [];

  TestEventTriggeredPolicy(this.name);

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    if (event is IDomainEvent) {
      executionLog.add('shouldTriggerOnEvent called for ${event.name}');
      return event.name == 'TestEventOccurred';
    }
    return false;
  }

  @override
  bool evaluate(dynamic entity) {
    executionLog.add('evaluate called with entity: ${entity?.runtimeType}');
    return true; // Always pass evaluation
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    wasTriggered = true;
    if (event is IDomainEvent) {
      executionLog.add('executeActions called for ${event.name}');
    }
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    if (event is IDomainEvent) {
      executionLog.add('generateCommands called for ${event.name}');
    }
    return []; // No commands for basic test
  }
}

/// Policy that generates commands for testing
class CommandGeneratingPolicy implements IEventTriggeredPolicy {
  @override
  final String name;

  bool wasTriggered = false;
  List<ICommandBusCommand> commandsGenerated = [];

  CommandGeneratingPolicy(this.name);

  @override
  bool shouldTriggerOnEvent(dynamic event) {
    if (event is IDomainEvent) {
      return event.name == 'CommandTriggerEvent';
    }
    return false;
  }

  @override
  bool evaluate(dynamic entity) {
    return true;
  }

  @override
  void executeActions(dynamic entity, dynamic event) {
    wasTriggered = true;
  }

  @override
  List<ICommandBusCommand> generateCommands(dynamic entity, dynamic event) {
    final command = TestCommand(
      'test-cmd-${DateTime.now().millisecondsSinceEpoch}',
    );
    commandsGenerated.add(command);
    return [command];
  }
}

/// Simple test domain event
class TestDomainEvent extends DomainEvent {
  TestDomainEvent({
    required String name,
    required String aggregateId,
    required String aggregateType,
  }) : super(
         name: name,
         aggregateId: aggregateId,
         aggregateType: aggregateType,
       );
}

/// Simple test command
class TestCommand implements ICommandBusCommand {
  @override
  final String id;

  TestCommand(this.id);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'type': 'TestCommand'};
}
