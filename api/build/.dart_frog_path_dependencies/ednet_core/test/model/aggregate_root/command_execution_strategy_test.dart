import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test aggregate for demonstrating strategy pattern
class TestAggregate extends AggregateRoot<TestAggregate> {
  String _state = 'initial';
  String _previousState = 'initial';

  String get state => _state;

  @override
  Concept get concept {
    final domain = Domain('TestDomain');
    final model = Model(domain, 'TestModel');
    final concept = Concept(model, 'TestAggregate');
    concept.entry = true;
    return concept;
  }

  @override
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();
    if (_state == 'invalid') {
      exceptions.add(
        ValidationException('state', 'State cannot be invalid', entity: this),
      );
    }
    return exceptions;
  }

  @override
  void applyEvent(dynamic event) {
    if (event is Event && event.name == 'StateChanged') {
      _previousState = _state; // Store previous state for rollback
      _state = event.data['newState'] ?? _state;
    } else if (event is Event && event.name == 'StateReverted') {
      _state = event.data['revertedState'] ?? _previousState;
    }
  }

  /// Rollback to previous state (for testing rollback mechanism)
  void rollbackState() {
    _state = _previousState;
  }
}

/// Test command implementing ICommand interface
class TestStrategyCommand implements ICommand {
  final String targetState;
  final bool shouldFail;
  bool _executed = false;
  final List<Event> _events = [];

  TestStrategyCommand(this.targetState, {this.shouldFail = false});

  @override
  String get name => 'TestStrategyCommand';

  @override
  String get category => 'test';

  @override
  String get description => 'Test command for strategy pattern';

  @override
  Event get successEvent =>
      Event('CommandSucceeded', 'Command succeeded', [], null, {});

  @override
  Event get failureEvent =>
      Event('CommandFailed', 'Command failed', [], null, {});

  @override
  bool get done => _executed;

  @override
  bool get undone => false;

  @override
  bool get redone => false;

  @override
  bool doIt() {
    if (shouldFail) {
      return false;
    }

    _executed = true;
    _events.add(
      Event('StateChanged', 'State was changed', [], null, {
        'newState': targetState,
      }),
    );
    return true;
  }

  @override
  bool undo() {
    _executed = false;
    // Generate a reverse event to undo the state change
    _events.clear();
    _events.add(
      Event('StateReverted', 'State was reverted', [], null, {
        'revertedState': 'initial', // Revert to initial state
      }),
    );
    return true;
  }

  @override
  bool redo() {
    return doIt();
  }

  @override
  List<Event> getEvents() => List.from(_events);
}

/// Custom strategy for testing
class TestCustomStrategy implements ICommandExecutionStrategy {
  @override
  String get strategyName => 'TestCustomStrategy';

  @override
  bool canHandle(ICommand command) {
    return command is TestStrategyCommand;
  }

  @override
  dynamic execute(dynamic aggregateRoot, ICommand command) {
    if (aggregateRoot is! TestAggregate) {
      return CommandResult.failure('Wrong aggregate type');
    }

    if (command is! TestStrategyCommand) {
      return CommandResult.failure('Wrong command type');
    }

    // Custom logic: prefix state with "custom_"
    final customCommand = TestStrategyCommand('custom_${command.targetState}');

    if (!customCommand.doIt()) {
      return CommandResult.failure('Custom command execution failed');
    }

    // Apply events
    for (var event in customCommand.getEvents()) {
      aggregateRoot.applyEvent(event);
    }

    return CommandResult.success(
      data: {'strategy': strategyName, 'customState': aggregateRoot.state},
    );
  }
}

void main() {
  group('Command Execution Strategy Pattern Tests', () {
    late TestAggregate aggregate;

    setUp(() {
      aggregate = TestAggregate();
    });

    test('should use default strategy for ICommand', () {
      // Arrange
      final command = TestStrategyCommand('newState');

      // Act
      final result = aggregate.executeCommand(command);

      // Assert
      if (result is CommandResult) {
        expect(result.isSuccess, isTrue);
      } else {
        expect(result['isSuccess'], isTrue);
      }
      expect(aggregate.state, equals('newState'));
      expect(aggregate.version, greaterThan(0));
    });

    test('should use legacy execution for non-ICommand', () {
      // Arrange
      final legacyCommand = MockLegacyCommand();

      // Act
      final result = aggregate.executeCommand(legacyCommand);

      // Assert
      expect(result['isSuccess'], isTrue);
      expect(result['data']['id'], isNotNull);
    });

    test('should allow strategy replacement', () {
      // Arrange
      final customStrategy = TestCustomStrategy();
      aggregate.commandExecutionStrategy = customStrategy;
      final command = TestStrategyCommand('testState');

      // Act
      final result = aggregate.executeCommand(command);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data['strategy'], equals('TestCustomStrategy'));
      expect(aggregate.state, equals('custom_testState'));
    });

    test('should handle command execution failure', () {
      // Arrange
      final command = TestStrategyCommand('failState', shouldFail: true);

      // Act
      final result = aggregate.executeCommand(command);

      // Assert
      if (result is CommandResult) {
        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('Command execution failed'));
      } else {
        expect(result['isSuccess'], isFalse);
        expect(result['errorMessage'], contains('Command execution failed'));
      }
    });

    test('should handle business rule violations', () {
      // Arrange
      final command = TestStrategyCommand('invalid');

      // Act
      final result = aggregate.executeCommand(command);

      // Assert
      if (result is CommandResult) {
        expect(result.isSuccess, isFalse);
        expect(result.errorMessage, contains('State cannot be invalid'));
      } else {
        expect(result['isSuccess'], isFalse);
        expect(result['errorMessage'], contains('State cannot be invalid'));
      }
      expect(aggregate.state, equals('initial')); // Should be rolled back
    });

    test('should use EventSourcingCommandStrategy', () {
      // Arrange
      final eventSourcingStrategy = EventSourcingCommandStrategy();
      aggregate.commandExecutionStrategy = eventSourcingStrategy;
      final command = TestStrategyCommand('eventSourcedState');

      // Act
      final result = aggregate.executeCommand(command);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data['events'], equals(1));
      expect(aggregate.state, equals('eventSourcedState'));
    });

    test('should use PolicyDrivenCommandStrategy', () {
      // Arrange
      final policyStrategy = PolicyDrivenCommandStrategy();
      aggregate.commandExecutionStrategy = policyStrategy;
      final command = TestStrategyCommand('policyDrivenState');

      // Act
      final result = aggregate.executeCommand(command);

      // Assert
      expect(result.isSuccess, isTrue);
      expect(result.data['policyCompliant'], isTrue);
      expect(aggregate.state, equals('policyDrivenState'));
    });

    test('should demonstrate strategy pattern benefits', () {
      // This test shows how different strategies can be used for different scenarios

      // Default strategy for normal operations
      final normalCommand = TestStrategyCommand('normal');
      var result = aggregate.executeCommand(normalCommand);
      if (result is CommandResult) {
        expect(result.isSuccess, isTrue);
      } else {
        expect(result['isSuccess'], isTrue);
      }
      expect(aggregate.state, equals('normal'));

      // Event sourcing strategy for audit-critical operations
      aggregate.commandExecutionStrategy = EventSourcingCommandStrategy();
      final auditCommand = TestStrategyCommand('audited');
      result = aggregate.executeCommand(auditCommand);
      expect(result.isSuccess, isTrue);
      expect(result.data.containsKey('events'), isTrue);

      // Custom strategy for specialized business logic
      aggregate.commandExecutionStrategy = TestCustomStrategy();
      final customCommand = TestStrategyCommand('specialized');
      result = aggregate.executeCommand(customCommand);
      expect(result.isSuccess, isTrue);
      expect(aggregate.state, equals('custom_specialized'));
    });
  });
}

/// Mock legacy command for testing backward compatibility
class MockLegacyCommand {
  bool doIt() => true;
  bool undo() => true;
  bool redo() => true;
  List<Event> getEvents() => [];
}
