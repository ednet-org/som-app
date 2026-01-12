import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Policy Engine', () {
    late PolicyEngine policyEngine;
    late Domain domain;
    late DomainSession session;

    setUp(() {
      domain = Domain('TestDomain');
      Model(domain, 'TestModel');
      session = DomainSession(DomainModels(domain));
      policyEngine = PolicyEngine(session);
    });

    test('should be created with a session', () {
      expect(policyEngine.session, equals(session));
      expect(policyEngine.policies, isEmpty);
    });

    test('should add a policy to the engine', () {
      final policy = TestPolicy('testPolicy');

      policyEngine.addPolicy(policy);

      expect(policyEngine.policies, hasLength(1));
      expect(policyEngine.policies.first, equals(policy));
    });

    test('should remove a policy from the engine', () {
      final policy = TestPolicy('testPolicy');
      policyEngine.addPolicy(policy);
      expect(policyEngine.policies, hasLength(1));

      final removed = policyEngine.removePolicy(policy);

      expect(removed, isTrue);
      expect(policyEngine.policies, isEmpty);
    });

    test('should return false when removing non-existent policy', () {
      final policy = TestPolicy('testPolicy');

      final removed = policyEngine.removePolicy(policy);

      expect(removed, isFalse);
      expect(policyEngine.policies, isEmpty);
    });

    test('should get applicable policies for an entity', () {
      final applicablePolicy = TestPolicy('applicable', shouldApply: true);
      final nonApplicablePolicy = TestPolicy(
        'nonApplicable',
        shouldApply: false,
      );

      policyEngine.addPolicy(applicablePolicy);
      policyEngine.addPolicy(nonApplicablePolicy);

      final entity = TestEntity();
      final applicable = policyEngine.getApplicablePolicies(entity);

      expect(applicable, hasLength(1));
      expect(applicable.first, equals(applicablePolicy));
    });

    test('should execute applicable policies for an entity', () {
      final policy = TestEventTriggeredPolicy('eventPolicy', shouldApply: true);
      policyEngine.addPolicy(policy);

      final entity = TestEntity();
      final commands = policyEngine.executePolicies(entity);

      expect(commands, isNotEmpty);
      expect(policy.wasExecuted, isTrue);
    });

    test('should process events through triggered policies', () {
      final policy = TestEventTriggeredPolicy('eventPolicy', shouldApply: true);
      policyEngine.addPolicy(policy);

      final entity = TestEntity();
      final event = Event('TestEvent', 'Test event description', [], entity);
      final commands = policyEngine.processEvent(entity, event);

      expect(commands, isNotEmpty);
      expect(policy.wasExecuted, isTrue);
    });
  });
}

class TestPolicy extends Policy {
  final bool shouldApply;

  TestPolicy(String name, {this.shouldApply = true})
    : super(name, 'Test policy description', (entity) => true);

  @override
  bool evaluate(Entity entity) {
    return shouldApply;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestPolicy &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class TestEventTriggeredPolicy extends Policy {
  final bool shouldApply;
  bool wasExecuted = false;

  TestEventTriggeredPolicy(String name, {this.shouldApply = true})
    : super(name, 'Test event-triggered policy description', (entity) => true);

  @override
  bool evaluate(Entity entity) {
    return shouldApply;
  }

  bool shouldTriggerOnEvent(Event event) {
    return true;
  }

  void executeActions(Entity entity, Event event) {
    wasExecuted = true;
  }

  List<dynamic> generateCommands(Entity entity, Event event) {
    return ['TestCommand'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestEventTriggeredPolicy &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

class TestEntity extends Entity<TestEntity> {
  TestEntity() : super() {
    // Initialize with a simple concept
    concept = Concept(testModel, 'TestEntity');
  }

  @override
  String toString() => 'TestEntity';
}

// Helper to create a simple test model
Model get testModel {
  final domain = Domain('TestDomain');
  return Model(domain, 'TestModel');
}
