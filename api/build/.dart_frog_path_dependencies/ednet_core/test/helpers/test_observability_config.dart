part of '../test_helpers.dart';

/// Test observability configuration helper with per-test-case scoping
class TestObservabilityConfig {
  /// Silent configuration for normal test runs
  static ObservabilityConfiguration silent() {
    return const ObservabilityConfiguration(
      defaultLevel: ObservabilityLevel.none,
      channels: [],
    );
  }

  /// Error-only configuration for critical issue detection
  static ObservabilityConfiguration errorsOnly() {
    return ObservabilityConfiguration(
      defaultLevel: ObservabilityLevel.error,
      channels: [ConsoleObservabilityChannel()],
    );
  }

  /// Warning and above for moderate debugging
  static ObservabilityConfiguration warningsAndErrors() {
    return ObservabilityConfiguration(
      defaultLevel: ObservabilityLevel.warning,
      channels: [ConsoleObservabilityChannel()],
    );
  }

  /// Info level for general test debugging
  static ObservabilityConfiguration infoLevel() {
    return ObservabilityConfiguration(
      defaultLevel: ObservabilityLevel.info,
      channels: [ConsoleObservabilityChannel()],
    );
  }

  /// Full verbose logging for deep debugging (use sparingly)
  static ObservabilityConfiguration verbose() {
    return ObservabilityConfiguration(
      defaultLevel: ObservabilityLevel.trace,
      channels: [ConsoleObservabilityChannel()],
    );
  }

  /// Test tracing only (no console output, only internal tracing)
  static ObservabilityConfiguration testTracingOnly() {
    return ObservabilityConfiguration(
      defaultLevel: ObservabilityLevel.debug,
      channels: [TestTracingObservabilityChannel()],
    );
  }

  /// Configure global observability for test environment
  /// Default is silent to prevent massive log outputs
  static void setupForTests({ObservabilityConfiguration? config}) {
    ObservabilityMixin.configureGlobalObservability(config ?? silent());
  }

  /// Setup with environment variable support
  /// EDNET_LOG_LEVEL can be: silent, errors, warnings, info, verbose, tracing
  static void setupFromEnvironment() {
    final logLevel =
        Platform.environment['EDNET_LOG_LEVEL']?.toLowerCase() ?? 'silent';

    ObservabilityConfiguration config;
    switch (logLevel) {
      case 'errors':
        config = errorsOnly();
        break;
      case 'warnings':
        config = warningsAndErrors();
        break;
      case 'info':
        config = infoLevel();
        break;
      case 'verbose':
        config = verbose();
        break;
      case 'tracing':
        config = testTracingOnly();
        break;
      case 'silent':
      default:
        config = silent();
        break;
    }

    ObservabilityMixin.configureGlobalObservability(config);
  }

  // =========================================================================
  // PER-TEST-CASE OBSERVABILITY SCOPING
  // =========================================================================

  /// Creates a test-scoped observability configuration that automatically
  /// restores previous settings after test completion
  static TestObservabilityScope scopedTest({
    ObservabilityConfiguration? globalConfig,
    ObservabilityConfiguration? sessionConfig,
    DomainSession? session,
    String? testName,
  }) {
    return TestObservabilityScope._(
      globalConfig: globalConfig,
      sessionConfig: sessionConfig,
      session: session,
      testName: testName,
    );
  }

  /// Helper: Create a completely silent test scope
  static TestObservabilityScope silentTest({String? testName}) {
    return scopedTest(
      globalConfig: silent(),
      testName: testName ?? 'Silent Test',
    );
  }

  /// Helper: Create an error-only test scope for debugging failures
  static TestObservabilityScope errorOnlyTest({String? testName}) {
    return scopedTest(
      globalConfig: errorsOnly(),
      testName: testName ?? 'Error-Only Test',
    );
  }

  /// Helper: Create a full tracing test scope for complex debugging
  static TestObservabilityScope fullTracingTest({String? testName}) {
    return scopedTest(
      globalConfig: testTracingOnly(),
      testName: testName ?? 'Full Tracing Test',
    );
  }

  /// Helper: Create a verbose test scope for deep investigation
  static TestObservabilityScope verboseTest({String? testName}) {
    return scopedTest(
      globalConfig: verbose(),
      testName: testName ?? 'Verbose Test',
    );
  }

  /// Helper: Create a custom test scope with specific configuration
  static TestObservabilityScope customTest({
    required ObservabilityConfiguration config,
    String? testName,
  }) {
    return scopedTest(
      globalConfig: config,
      testName: testName ?? 'Custom Test',
    );
  }
}

/// Scoped observability configuration for individual test cases
/// Automatically restores previous configuration when disposed
class TestObservabilityScope {
  final ObservabilityConfiguration? _globalConfig;
  final ObservabilityConfiguration? _sessionConfig;
  final DomainSession? _session;
  final String? _testName;

  late final ObservabilityEventHandler _previousGlobalHandler;
  late final ObservabilityConfiguration? _previousSessionConfig;
  bool _isActive = false;

  TestObservabilityScope._({
    ObservabilityConfiguration? globalConfig,
    ObservabilityConfiguration? sessionConfig,
    DomainSession? session,
    String? testName,
  }) : _globalConfig = globalConfig,
       _sessionConfig = sessionConfig,
       _session = session,
       _testName = testName;

  /// Activate this test scope's observability configuration
  void activate() {
    if (_isActive) {
      throw StateError('TestObservabilityScope is already active');
    }

    // Preserve current global configuration
    _previousGlobalHandler = ObservabilityMixin.globalObservabilityHandler;

    // Apply new global configuration if specified
    if (_globalConfig != null) {
      ObservabilityMixin.configureGlobalObservability(_globalConfig!);
    }

    // Apply session-specific configuration if specified
    if (_session != null && _sessionConfig != null) {
      _previousSessionConfig = _session!.observability.configuration;
      _session!.configureObservability(_sessionConfig!);
    }

    _isActive = true;

    // Optional: Log test scope activation (only if not silent)
    if (_testName != null &&
        _globalConfig?.defaultLevel != ObservabilityLevel.none) {
      print(
        '🧪 Test scope activated: $_testName (level: ${_globalConfig?.defaultLevel.name})',
      );
    }
  }

  /// Deactivate and restore previous observability configuration
  void deactivate() {
    if (!_isActive) {
      return; // Already deactivated or never activated
    }

    // Restore global configuration
    ObservabilityMixin.globalObservabilityHandler = _previousGlobalHandler;

    // Restore session configuration if it was changed
    if (_session != null && _previousSessionConfig != null) {
      _session!.configureObservability(_previousSessionConfig!);
    }

    _isActive = false;

    // Optional: Log test scope deactivation (only if not silent)
    if (_testName != null &&
        _globalConfig?.defaultLevel != ObservabilityLevel.none) {
      print('🧪 Test scope deactivated: $_testName');
    }
  }

  /// Execute a test function within this observability scope
  T runTest<T>(T Function() testFunction) {
    activate();
    try {
      return testFunction();
    } finally {
      deactivate();
    }
  }

  /// Execute an async test function within this observability scope
  Future<T> runAsyncTest<T>(Future<T> Function() testFunction) async {
    activate();
    try {
      return await testFunction();
    } finally {
      deactivate();
    }
  }

  /// Get current observability level for this scope
  ObservabilityLevel? get currentLevel => _globalConfig?.defaultLevel;

  /// Check if console output is enabled for this scope
  bool get hasConsoleOutput =>
      _globalConfig?.channels.any((c) => c is ConsoleObservabilityChannel) ??
      false;

  /// Check if test tracing is enabled for this scope
  bool get hasTestTracing =>
      _globalConfig?.channels.any(
        (c) => c is TestTracingObservabilityChannel,
      ) ??
      false;
}

/// Custom observability channel that captures traces for test debugging
class TestTracingObservabilityChannel implements ObservabilityChannel {
  static final List<ObservabilityEvent> _capturedEvents = [];

  @override
  void log(ObservabilityEvent event) {
    // Store events in memory for test analysis
    _capturedEvents.add(event);
  }

  /// Get all captured events for test verification
  static List<ObservabilityEvent> getCapturedEvents() =>
      List.unmodifiable(_capturedEvents);

  /// Clear captured events (call between tests)
  static void clearCapturedEvents() {
    _capturedEvents.clear();
  }

  /// Dispose and clear all captured events (for test teardown)
  static void dispose() {
    clearCapturedEvents();
  }

  /// Global test cleanup helper - clears all observability state
  /// Call this in tearDown blocks to ensure clean test isolation
  static void globalCleanup() {
    // Clear the tracing channel's captured events
    clearCapturedEvents();

    // Clear any global observability handlers if possible
    // This helps prevent cross-test contamination
    try {
      ObservabilityExtension.clearAllObservabilityHandlers();
    } catch (e) {
      // Ignore errors - some tests may not have handlers to clear
    }
  }

  /// Get events by level
  static List<ObservabilityEvent> getEventsByLevel(ObservabilityLevel level) {
    return _capturedEvents.where((e) => e.level == level).toList();
  }

  /// Get events by source
  static List<ObservabilityEvent> getEventsBySource(String source) {
    return _capturedEvents.where((e) => e.source == source).toList();
  }
}
