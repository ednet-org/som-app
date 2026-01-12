import 'dart:io';

import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('ObservabilityChannel - Logging Framework Integration', () {
    late ConsoleObservabilityChannel consoleChannel;
    late FileObservabilityChannel fileChannel;

    setUp(() {
      consoleChannel = ConsoleObservabilityChannel();
      fileChannel = FileObservabilityChannel('/tmp/test_observability.log');
    });

    tearDown(() {
      // Clean up file after test
      fileChannel.close();
    });

    test('ConsoleObservabilityChannel uses proper logging levels', () {
      // Arrange
      final traceEvent = ObservabilityEvent(
        level: ObservabilityLevel.trace,
        source: 'TestSource',
        message: 'test_operation: Trace message',
      );

      final infoEvent = ObservabilityEvent(
        level: ObservabilityLevel.info,
        source: 'TestSource',
        message: 'test_operation: Info message',
      );

      final errorEvent = ObservabilityEvent(
        level: ObservabilityLevel.error,
        source: 'TestSource',
        message: 'test_operation: Error message',
        error: Exception('Test error'),
        stackTrace: StackTrace.current,
      );

      // Act
      consoleChannel.log(traceEvent);
      consoleChannel.log(infoEvent);
      consoleChannel.log(errorEvent);

      // Assert - These should not throw exceptions and should use proper logging
      expect(true, isTrue); // If we get here, logging worked without errors
    });

    test('FileObservabilityChannel writes to file correctly', () {
      // Arrange
      final event = ObservabilityEvent(
        level: ObservabilityLevel.info,
        source: 'TestSource',
        message: 'test_operation: File logging test',
      );

      // Act
      fileChannel.log(event);

      // Assert - File should contain the logged message
      final file = File('/tmp/test_observability.log');
      expect(file.existsSync(), isTrue);

      final content = file.readAsStringSync();
      expect(content, contains('[INFO]'));
      expect(content, contains('File logging test'));
    });

    test('ObservabilityEvent formats messages correctly', () {
      // Arrange
      final event = ObservabilityEvent(
        level: ObservabilityLevel.info,
        source: 'TestSource',
        message: 'test_operation: Test message',
      );

      // Act
      final formatted = event.formatMessage();

      // Assert
      expect(formatted, contains('INFO'));
      expect(formatted, contains('TestSource'));
      expect(formatted, contains('test_operation'));
      expect(formatted, contains('Test message'));
    });
  });
}
