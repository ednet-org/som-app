import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../test_helpers.dart';

/// Example tests demonstrating per-test-case observability configuration
void main() {
  group('Test Observability Configuration Examples', () {
    test('silent test - no logs should appear', () {
      // This test runs with completely silent observability
      final scope = TestObservabilityConfig.silentTest(
        testName: 'Silent Test Example',
      );

      scope.runTest(() {
        // Create a domain session and use observability
        final domain = Domain('TestDomain');
        Model(domain, 'TestModel');
        final session = DomainSession(DomainModels(domain));

        // Use observability methods - these should not produce console output
        session.info('This info message should be silent');
        session.debug('This debug message should be silent');
        session.warning('This warning should be silent');

        // Verify that the scope is properly configured
        expect(scope.currentLevel, equals(ObservabilityLevel.none));
        expect(scope.hasConsoleOutput, isFalse);
      });
    });

    test('error-only test - only errors should appear', () {
      // This test runs with error-only observability
      final scope = TestObservabilityConfig.errorOnlyTest(
        testName: 'Error-Only Test Example',
      );

      scope.runTest(() {
        final domain = Domain('TestDomain');
        Model(domain, 'TestModel');
        final session = DomainSession(DomainModels(domain));

        // These should not appear in console
        session.info('This info message should not appear');
        session.debug('This debug message should not appear');

        // This should appear in console
        session.error('This error message should appear');

        // Verify configuration
        expect(scope.currentLevel, equals(ObservabilityLevel.error));
        expect(scope.hasConsoleOutput, isTrue);
      });
    });

    test('custom test with tracing - events should be captured', () {
      // This test runs with custom tracing configuration
      final scope = TestObservabilityConfig.fullTracingTest(
        testName: 'Tracing Test Example',
      );

      scope.runTest(() {
        // Clear any existing captured events
        TestTracingObservabilityChannel.clearCapturedEvents();

        final domain = Domain('TestDomain');
        Model(domain, 'TestModel');
        final session = DomainSession(DomainModels(domain));

        // Configure the session to use tracing
        session.configureObservability(
          TestObservabilityConfig.testTracingOnly(),
        );

        // Generate some observability events
        session.info('Test info message');
        session.debug('Test debug message');

        // Verify events were captured
        final capturedEvents =
            TestTracingObservabilityChannel.getCapturedEvents();
        expect(capturedEvents.length, greaterThan(0));

        // Verify specific event content
        final infoEvents = TestTracingObservabilityChannel.getEventsByLevel(
          ObservabilityLevel.info,
        );
        expect(infoEvents.isNotEmpty, isTrue);

        // Verify scope configuration
        expect(scope.currentLevel, equals(ObservabilityLevel.debug));
        expect(scope.hasTestTracing, isTrue);
        expect(scope.hasConsoleOutput, isFalse);
      });
    });

    test('regular test inherits setup configuration', () {
      // This test runs with whatever was configured in setUp
      // In this case, it should inherit silent configuration

      final domain = Domain('TestDomain');
      Model(domain, 'TestModel');
      final session = DomainSession(DomainModels(domain));

      // This should be silent due to global configuration
      session.info('This should be silent due to global setup');

      // Can manually check global configuration
      final globalHandler = ObservabilityMixin.globalObservabilityHandler;
      expect(
        globalHandler.configuration.defaultLevel,
        equals(ObservabilityLevel.none),
      );
    });

    test('async test with scoped observability', () async {
      // Demonstrate async test scoping
      final scope = TestObservabilityConfig.verboseTest(
        testName: 'Async Verbose Test',
      );

      await scope.runAsyncTest(() async {
        final domain = Domain('TestDomain');
        Model(domain, 'TestModel');
        final session = DomainSession(DomainModels(domain));

        // Simulate async work
        await Future.delayed(const Duration(milliseconds: 10));

        session.trace('Async trace message');
        session.debug('Async debug message');
        session.info('Async info message');

        // Verify verbose configuration
        expect(scope.currentLevel, equals(ObservabilityLevel.trace));
        expect(scope.hasConsoleOutput, isTrue);
      });
    });

    test('environment variable configuration', () {
      // Demonstrate environment-based configuration
      // Note: This test doesn't set actual environment variables,
      // but shows how the API would work

      // TestObservabilityConfig.setupFromEnvironment();
      // Would read EDNET_LOG_LEVEL environment variable

      // Instead, we'll manually configure
      TestObservabilityConfig.setupForTests(
        config: TestObservabilityConfig.warningsAndErrors(),
      );

      final domain = Domain('TestDomain');
      Model(domain, 'TestModel');
      final session = DomainSession(DomainModels(domain));

      // These should not appear (below warning level)
      session.info('This info should not appear');
      session.debug('This debug should not appear');

      // These should appear
      session.warning('This warning should appear');
      session.error('This error should appear');
    });
  });

  setUp(() {
    // Configure silent observability for all tests by default
    TestObservabilityConfig.setupForTests(
      config: TestObservabilityConfig.silent(),
    );
  });

  tearDown(() {
    // Clean up any captured events
    TestTracingObservabilityChannel.clearCapturedEvents();
  });
}
