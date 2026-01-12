# Per-Test-Case Observability Configuration Guide

## Overview

The EDNet Core testing framework now supports **per-test-case observability configuration**, allowing you to control logging and tracing at the individual test level rather than just the test suite level.

## Key Benefits

- **Silent by Default**: Tests run silently unless explicitly configured otherwise
- **Granular Control**: Each test can have its own observability level
- **Automatic Cleanup**: Configuration is automatically restored after each test
- **Performance**: Massive log outputs eliminated from normal test runs
- **Debugging Flexibility**: Easy to enable verbose logging for specific failing tests

## Basic Usage

### 1. Silent Tests (Default)
```dart
test('my silent test', () {
  final scope = TestObservabilityConfig.silentTest();
  
  scope.runTest(() {
    // This test runs completely silently
    session.info('This will not appear in console');
    // ... test logic
  });
});
```

### 2. Error-Only Tests (For Debugging Failures)
```dart
test('my error-only test', () {
  final scope = TestObservabilityConfig.errorOnlyTest();
  
  scope.runTest(() {
    // Only errors will appear in console
    session.info('Silent');        // No output
    session.error('Visible!');     // Shows in console
    // ... test logic
  });
});
```

### 3. Full Tracing Tests (For Complex Debugging)
```dart
test('my tracing test', () {
  final scope = TestObservabilityConfig.fullTracingTest();
  
  scope.runTest(() {
    // Events are captured for analysis, no console output
    session.debug('Captured for analysis');
    
    // Verify captured events
    final events = TestTracingObservabilityChannel.getCapturedEvents();
    expect(events.length, greaterThan(0));
  });
});
```

### 4. Verbose Tests (For Deep Investigation)
```dart
test('my verbose test', () {
  final scope = TestObservabilityConfig.verboseTest();
  
  scope.runTest(() {
    // All levels appear in console (use sparingly!)
    session.trace('Trace message');
    session.debug('Debug message');
    session.info('Info message');
    // ... test logic
  });
});
```

## Advanced Usage

### Custom Configuration
```dart
test('my custom test', () {
  final customConfig = ObservabilityConfiguration(
    defaultLevel: ObservabilityLevel.warning,
    channels: [ConsoleObservabilityChannel()],
  );
  
  final scope = TestObservabilityConfig.customTest(
    config: customConfig,
    testName: 'Custom Warning Test',
  );
  
  scope.runTest(() {
    // Only warnings and errors appear
    // ... test logic
  });
});
```

### Async Tests
```dart
test('my async test', () async {
  final scope = TestObservabilityConfig.errorOnlyTest();
  
  await scope.runAsyncTest(() async {
    // Async test with scoped observability
    await Future.delayed(Duration(milliseconds: 10));
    session.error('This appears');
    // ... async test logic
  });
});
```

### Environment-Based Configuration
```dart
setUp(() {
  // Configure based on EDNET_LOG_LEVEL environment variable
  // Values: silent, errors, warnings, info, verbose, tracing
  TestObservabilityConfig.setupFromEnvironment();
});
```

## Test Suite Configuration

### Global Silent Setup (Recommended)
```dart
setUp(() {
  // Configure all tests to be silent by default
  TestObservabilityConfig.setupForTests(
    config: TestObservabilityConfig.silent()
  );
});

tearDown(() {
  // Clean up captured events
  TestTracingObservabilityChannel.clearCapturedEvents();
});
```

### Individual Test Override
```dart
group('My Test Group', () {
  setUp(() {
    // Silent by default for the group
    TestObservabilityConfig.setupForTests(
      config: TestObservabilityConfig.silent()
    );
  });

  test('normal test - inherits silent config', () {
    // Runs silently
    session.info('Not visible');
  });

  test('debug test - overrides with verbose', () {
    final scope = TestObservabilityConfig.verboseTest();
    scope.runTest(() {
      // Runs with full verbosity
      session.info('Visible!');
    });
  });
});
```

## Migration from Suite-Level Configuration

### Before (Suite-Level Only)
```dart
setUp(() {
  // Applied to ALL tests in the group
  ObservabilityMixin.configureGlobalObservability(
    ObservabilityConfiguration(
      defaultLevel: ObservabilityLevel.error,
      channels: [ConsoleObservabilityChannel()],
    ),
  );
});
```

### After (Per-Test Control)
```dart
setUp(() {
  // Silent by default
  TestObservabilityConfig.setupForTests(
    config: TestObservabilityConfig.silent()
  );
});

// Individual tests can override as needed
test('failing test that needs debugging', () {
  final scope = TestObservabilityConfig.errorOnlyTest();
  scope.runTest(() {
    // Only this test shows error output
    // ... test logic
  });
});

test('complex integration test', () {
  final scope = TestObservabilityConfig.fullTracingTest();
  scope.runTest(() {
    // Only this test captures detailed traces
    // ... test logic
  });
});
```

## Best Practices

### 1. Default to Silent
```dart
setUp(() {
  TestObservabilityConfig.setupForTests(
    config: TestObservabilityConfig.silent()
  );
});
```

### 2. Use Error-Only for Debugging Failures
```dart
test('failing test', () {
  final scope = TestObservabilityConfig.errorOnlyTest();
  scope.runTest(() {
    // Debug why this test is failing
    // ... test logic
  });
});
```

### 3. Use Tracing for Event Analysis
```dart
test('policy execution test', () {
  final scope = TestObservabilityConfig.fullTracingTest();
  scope.runTest(() {
    // ... execute policies
    
    // Analyze what happened
    final events = TestTracingObservabilityChannel.getCapturedEvents();
    final policyEvents = TestTracingObservabilityChannel.getEventsBySource('PolicyEvaluator');
    expect(policyEvents.length, equals(3));
  });
});
```

### 4. Minimize Verbose Usage
```dart
// Only use verbose for deep investigation of complex issues
test('complex saga debugging', () {
  final scope = TestObservabilityConfig.verboseTest();
  scope.runTest(() {
    // This will generate A LOT of output - use sparingly
    // ... complex test logic
  });
});
```

## Configuration Reference

| Method | Level | Console Output | Event Capture | Use Case |
|--------|-------|----------------|---------------|----------|
| `silent()` | none | ❌ | ❌ | Normal tests |
| `errorsOnly()` | error | ✅ | ❌ | Debugging failures |
| `warningsAndErrors()` | warning | ✅ | ❌ | Moderate debugging |
| `infoLevel()` | info | ✅ | ❌ | General debugging |
| `testTracingOnly()` | debug | ❌ | ✅ | Event analysis |
| `verbose()` | trace | ✅ | ❌ | Deep investigation |

## Environment Variables

Set `EDNET_LOG_LEVEL` to control default behavior:
- `silent` - No output (default)
- `errors` - Error messages only
- `warnings` - Warnings and errors
- `info` - Info level and above
- `verbose` - All levels to console
- `tracing` - All levels to event capture

## Integration with TDD Workflow

```dart
group('TDD Cycle with Observability', () {
  setUp(() {
    TestObservabilityConfig.setupForTests(
      config: TestObservabilityConfig.silent()
    );
  });

  test('RED: failing test with error tracking', () {
    final scope = TestObservabilityConfig.errorOnlyTest(
      testName: 'RED - PolicyExecution'
    );
    
    scope.runTest(() {
      // This test should fail and show error details
      expect(() => policy.execute(entity), throwsA(isA<PolicyViolationException>()));
    });
  });

  test('GREEN: passing test with tracing verification', () {
    final scope = TestObservabilityConfig.fullTracingTest(
      testName: 'GREEN - PolicyExecution'
    );
    
    scope.runTest(() {
      // Test passes and we can verify the execution path
      policy.execute(entity);
      
      final events = TestTracingObservabilityChannel.getCapturedEvents();
      expect(events.any((e) => e.source.contains('Policy')), isTrue);
    });
  });

  test('REFACTOR: silent performance test', () {
    // No scope needed - inherits silent configuration
    // Fast execution without logging overhead
    final stopwatch = Stopwatch()..start();
    
    for (int i = 0; i < 1000; i++) {
      policy.execute(entity);
    }
    
    stopwatch.stop();
    expect(stopwatch.elapsedMilliseconds, lessThan(100));
  });
});
```

This system provides precise control over observability per test while maintaining excellent performance and debuggability. 