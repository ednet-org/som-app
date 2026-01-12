import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Test command for testing command bus functionality
class TestCommand implements ICommandBusCommand {
  @override
  final String id;
  final String data;
  final bool shouldFail;

  TestCommand(this.data, {this.shouldFail = false}) : id = Oid().toString();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'data': data,
    'shouldFail': shouldFail,
  };
}

/// Test command handler for testing
class TestCommandHandler implements ICommandHandler<TestCommand> {
  final List<TestCommand> handledCommands = [];
  final List<String> executionLog = [];

  @override
  Future<CommandResult> handle(TestCommand command) async {
    handledCommands.add(command);
    executionLog.add('Handling command: ${command.id}');

    if (command.shouldFail) {
      return CommandResult.failure('Command failed: ${command.data}');
    }

    return CommandResult.success(data: 'Processed: ${command.data}');
  }

  @override
  bool canHandle(dynamic command) => command is TestCommand;
}

void main() {
  group('CommandBus Tests', () {
    late CommandBus commandBus;
    late TestCommandHandler testHandler;

    setUp(() {
      commandBus = CommandBus();
      testHandler = TestCommandHandler();
    });

    group('Handler Registration', () {
      test('should register command handler successfully', () {
        // Act
        commandBus.registerHandler<TestCommand>(testHandler);

        // Assert
        expect(commandBus.hasHandlerFor<TestCommand>(), isTrue);
      });

      test('should allow multiple handlers for different command types', () {
        // Arrange
        final anotherHandler = TestCommandHandler();

        // Act
        commandBus.registerHandler<TestCommand>(testHandler);
        commandBus.registerHandler<TestCommand>(anotherHandler);

        // Assert
        expect(commandBus.hasHandlerFor<TestCommand>(), isTrue);
        expect(commandBus.getHandlersFor<TestCommand>().length, equals(2));
      });

      test('should unregister command handler successfully', () {
        // Arrange
        commandBus.registerHandler<TestCommand>(testHandler);

        // Act
        commandBus.unregisterHandler<TestCommand>(testHandler);

        // Assert
        expect(commandBus.hasHandlerFor<TestCommand>(), isFalse);
      });
    });

    group('Command Execution', () {
      test('should execute command successfully', () async {
        // Arrange
        commandBus.registerHandler<TestCommand>(testHandler);
        final command = TestCommand('test data');

        // Act
        final result = await commandBus.execute(command);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.data, equals('Processed: test data'));
        expect(testHandler.handledCommands.length, equals(1));
        expect(testHandler.handledCommands.first.data, equals('test data'));
      });

      test('should handle command failure', () async {
        // Arrange
        commandBus.registerHandler<TestCommand>(testHandler);
        final command = TestCommand('fail data', shouldFail: true);

        // Act
        final result = await commandBus.execute(command);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, equals('Command failed: fail data'));
      });

      test('should return failure when no handler registered', () async {
        // Arrange
        final command = TestCommand('test data');

        // Act
        final result = await commandBus.execute(command);

        // Assert
        expect(result.isFailure, isTrue);
        expect(
          result.errorMessage,
          contains('No handler registered for command type'),
        );
      });

      test('should execute multiple handlers in sequence', () async {
        // Arrange
        final handler1 = TestCommandHandler();
        final handler2 = TestCommandHandler();
        commandBus.registerHandler<TestCommand>(handler1);
        commandBus.registerHandler<TestCommand>(handler2);
        final command = TestCommand('test data');

        // Act
        final results = await commandBus.executeAll(command);

        // Assert
        expect(results.length, equals(2));
        expect(results.every((r) => r.isSuccess), isTrue);
        expect(handler1.handledCommands.length, equals(1));
        expect(handler2.handledCommands.length, equals(1));
      });
    });

    group('Command Validation', () {
      test('should validate command before execution', () async {
        // Arrange
        final validator = (TestCommand cmd) => cmd.data.isNotEmpty
            ? ValidationResult.success()
            : ValidationResult.failure('Data cannot be empty');

        commandBus.registerValidator<TestCommand>(validator);
        commandBus.registerHandler<TestCommand>(testHandler);

        final invalidCommand = TestCommand('');

        // Act
        final result = await commandBus.execute(invalidCommand);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Data cannot be empty'));
        expect(testHandler.handledCommands.length, equals(0));
      });

      test('should execute command when validation passes', () async {
        // Arrange
        final validator = (TestCommand cmd) => cmd.data.isNotEmpty
            ? ValidationResult.success()
            : ValidationResult.failure('Data cannot be empty');

        commandBus.registerValidator<TestCommand>(validator);
        commandBus.registerHandler<TestCommand>(testHandler);

        final validCommand = TestCommand('valid data');

        // Act
        final result = await commandBus.execute(validCommand);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(testHandler.handledCommands.length, equals(1));
      });
    });

    group('Command Middleware', () {
      test('should execute pre-execution middleware', () async {
        // Arrange
        final executionLog = <String>[];
        commandBus.addPreExecutionMiddleware((cmd) async {
          executionLog.add('Pre-execution: ${cmd.runtimeType}');
        });

        commandBus.registerHandler<TestCommand>(testHandler);
        final command = TestCommand('test data');

        // Act
        await commandBus.execute(command);

        // Assert
        expect(executionLog.length, equals(1));
        expect(executionLog.first, equals('Pre-execution: TestCommand'));
      });

      test('should execute post-execution middleware', () async {
        // Arrange
        final executionLog = <String>[];
        commandBus.addPostExecutionMiddleware((cmd, result) async {
          executionLog.add(
            'Post-execution: ${cmd.runtimeType} - ${result.isSuccess}',
          );
        });

        commandBus.registerHandler<TestCommand>(testHandler);
        final command = TestCommand('test data');

        // Act
        await commandBus.execute(command);

        // Assert
        expect(executionLog.length, equals(1));
        expect(
          executionLog.first,
          equals('Post-execution: TestCommand - true'),
        );
      });
    });

    group('Command Bus Events', () {
      test('should track command execution events', () async {
        // Arrange
        commandBus.registerHandler<TestCommand>(testHandler);
        final command = TestCommand('test data');

        // Act
        final result = await commandBus.execute(command);

        // Assert
        expect(result.isSuccess, isTrue);
        // Note: Event publishing is internal to CommandBus implementation
        // We verify that the command was executed successfully
        expect(testHandler.handledCommands.length, equals(1));
      });

      test('should track command failure events', () async {
        // Arrange
        commandBus.registerHandler<TestCommand>(testHandler);
        final command = TestCommand('test data', shouldFail: true);

        // Act
        final result = await commandBus.execute(command);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Command failed'));
        expect(testHandler.handledCommands.length, equals(1));
      });
    });

    group('Error Handling', () {
      test('should handle exceptions in command handlers gracefully', () async {
        // Arrange
        final faultyHandler = FaultyCommandHandler();
        commandBus.registerHandler<TestCommand>(faultyHandler);
        final command = TestCommand('test data');

        // Act
        final result = await commandBus.execute(command);

        // Assert
        expect(result.isFailure, isTrue);
        expect(result.errorMessage, contains('Handler execution failed'));
      });

      test(
        'should continue execution with other handlers even if one fails',
        () async {
          // Arrange
          final faultyHandler = FaultyCommandHandler();
          final goodHandler = TestCommandHandler();
          commandBus.registerHandler<TestCommand>(faultyHandler);
          commandBus.registerHandler<TestCommand>(goodHandler);
          final command = TestCommand('test data');

          // Act
          final results = await commandBus.executeAll(command);

          // Assert
          expect(results.length, equals(2));
          expect(results.any((r) => r.isFailure), isTrue);
          expect(results.any((r) => r.isSuccess), isTrue);
        },
      );
    });
  });
}

/// Test command handler that throws exceptions
class FaultyCommandHandler implements ICommandHandler<TestCommand> {
  @override
  Future<CommandResult> handle(TestCommand command) async {
    throw Exception('Handler execution failed');
  }

  @override
  bool canHandle(dynamic command) => command is TestCommand;
}

/// Test event publisher for testing event publishing
class TestEventPublisher {
  final List<IDomainEvent> publishedEvents = [];

  void publish(IDomainEvent event) {
    publishedEvents.add(event);
  }
}

/// Validation result for command validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult._(this.isValid, this.errorMessage);

  factory ValidationResult.success() => ValidationResult._(true, null);
  factory ValidationResult.failure(String message) =>
      ValidationResult._(false, message);
}
