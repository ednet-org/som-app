part of ednet_core;

final Logger _observabilityLogger = Logger('ednet_core.observability');

/// Runtime environment types for environment-aware observability configuration
enum RuntimeEnvironment {
  /// Development environment: Maximum verbosity for debugging
  development,

  /// Staging environment: Balanced for pre-production testing
  staging,

  /// Production environment: Minimal overhead, errors only
  production,

  /// Testing environment: Silent by default, configurable per test
  testing,

  /// Custom environment: User-defined configuration
  custom,
}

/// Observability levels for the EDNet ecosystem
enum ObservabilityLevel {
  trace, // Most verbose - all operations
  debug, // Debugging information
  info, // General information
  warning, // Warnings
  error, // Errors only
  none, // No logging
}

/// Configuration for observability in EDNet Core
class ObservabilityConfiguration {
  final ObservabilityLevel defaultLevel;
  final Map<String, ObservabilityLevel> categoryLevels;
  final List<ObservabilityChannel> channels;
  final bool includeStackTraces;
  final bool includeTimestamps;
  final bool includeComponentContext;
  final RuntimeEnvironment? environment;

  const ObservabilityConfiguration({
    this.defaultLevel = ObservabilityLevel.error,
    this.categoryLevels = const {},
    this.channels = const [],
    this.includeStackTraces = false,
    this.includeTimestamps = true,
    this.includeComponentContext = true,
    this.environment,
  });

  /// Get level for a specific category, falling back to default
  ObservabilityLevel getLevelForCategory(String category) {
    return categoryLevels[category] ?? defaultLevel;
  }

  /// Check if a level should be logged
  bool shouldLog(ObservabilityLevel level, {String? category}) {
    final targetLevel = category != null
        ? getLevelForCategory(category)
        : defaultLevel;
    return level.index >= targetLevel.index;
  }
}

/// Factory for environment-specific observability configurations
///
/// Provides industry-standard presets for different runtime environments,
/// enabling easy configuration switching without modifying code.
class ObservabilityEnvironmentPresets {
  /// Development preset: Maximum verbosity for debugging
  ///
  /// - Default level: trace (most verbose)
  /// - All categories enabled at debug or trace level
  /// - Console and file logging enabled
  /// - Stack traces included
  /// - Timestamps and context included
  static ObservabilityConfiguration development() =>
      const ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.trace,
        categoryLevels: {
          'domain': ObservabilityLevel.trace,
          'infrastructure': ObservabilityLevel.debug,
          'application': ObservabilityLevel.debug,
          'patterns': ObservabilityLevel.debug,
          'commands': ObservabilityLevel.trace,
          'events': ObservabilityLevel.trace,
          'policies': ObservabilityLevel.debug,
        },
        channels: [ConsoleObservabilityChannel()],
        includeStackTraces: true,
        includeTimestamps: true,
        includeComponentContext: true,
        environment: RuntimeEnvironment.development,
      );

  /// Staging preset: Balanced for pre-production testing
  ///
  /// - Default level: info
  /// - Important categories at info, infrastructure at warning
  /// - Console logging enabled
  /// - Stack traces not included (performance)
  /// - Timestamps and context included
  static ObservabilityConfiguration staging() =>
      const ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.info,
        categoryLevels: {
          'domain': ObservabilityLevel.info,
          'infrastructure': ObservabilityLevel.warning,
          'application': ObservabilityLevel.info,
          'patterns': ObservabilityLevel.warning,
          'commands': ObservabilityLevel.info,
          'events': ObservabilityLevel.info,
          'policies': ObservabilityLevel.warning,
        },
        channels: [ConsoleObservabilityChannel()],
        includeStackTraces: false,
        includeTimestamps: true,
        includeComponentContext: true,
        environment: RuntimeEnvironment.staging,
      );

  /// Production preset: Minimal overhead, errors and warnings only
  ///
  /// - Default level: warning
  /// - Critical categories at error level
  /// - No console logging (silent operation)
  /// - Stack traces included only for errors
  /// - Timestamps included, context minimized
  static ObservabilityConfiguration production() =>
      const ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.warning,
        categoryLevels: {
          'domain': ObservabilityLevel.error,
          'infrastructure': ObservabilityLevel.error,
          'application': ObservabilityLevel.warning,
          'patterns': ObservabilityLevel.error,
          'commands': ObservabilityLevel.error,
          'events': ObservabilityLevel.error,
          'policies': ObservabilityLevel.error,
        },
        channels: [],
        includeStackTraces: true, // Only for errors
        includeTimestamps: true,
        includeComponentContext: false, // Minimize overhead
        environment: RuntimeEnvironment.production,
      );

  /// Testing preset: Silent by default, configurable per test
  ///
  /// - Default level: none (silent)
  /// - No categories configured
  /// - No channels (completely silent)
  /// - No stack traces, timestamps, or context
  /// - Tests can override as needed
  static ObservabilityConfiguration testing() =>
      const ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.none,
        categoryLevels: {},
        channels: [],
        includeStackTraces: false,
        includeTimestamps: false,
        includeComponentContext: false,
        environment: RuntimeEnvironment.testing,
      );

  /// Get preset by environment
  static ObservabilityConfiguration forEnvironment(
    RuntimeEnvironment environment,
  ) {
    switch (environment) {
      case RuntimeEnvironment.development:
        return development();
      case RuntimeEnvironment.staging:
        return staging();
      case RuntimeEnvironment.production:
        return production();
      case RuntimeEnvironment.testing:
        return testing();
      case RuntimeEnvironment.custom:
        throw ArgumentError(
          'Custom environment requires explicit configuration',
        );
    }
  }
}

/// Abstract base class for observability channels
abstract class ObservabilityChannel {
  const ObservabilityChannel();

  void log(ObservabilityEvent event);
}

/// Console logging channel
class ConsoleObservabilityChannel extends ObservabilityChannel {
  const ConsoleObservabilityChannel();

  @override
  void log(ObservabilityEvent event) {
    final message = event.formatMessage();

    switch (event.level) {
      case ObservabilityLevel.trace:
        _observabilityLogger.finest(message);
        break;
      case ObservabilityLevel.debug:
        _observabilityLogger.fine(message);
        break;
      case ObservabilityLevel.info:
        _observabilityLogger.info(message);
        break;
      case ObservabilityLevel.warning:
        _observabilityLogger.warning(message);
        break;
      case ObservabilityLevel.error:
        _observabilityLogger.severe(message, event.error, event.stackTrace);
        break;
      case ObservabilityLevel.none:
        // Don't log anything for none level
        break;
    }
  }
}

/// File logging channel
class FileObservabilityChannel extends ObservabilityChannel {
  final String filePath;
  final IOSink? _fileSink;

  FileObservabilityChannel(this.filePath) : _fileSink = null;

  FileObservabilityChannel.withSink(this.filePath, this._fileSink);

  @override
  void log(ObservabilityEvent event) {
    final message = event.formatMessage();

    switch (event.level) {
      case ObservabilityLevel.trace:
        _writeToFile('[TRACE] $message');
        break;
      case ObservabilityLevel.debug:
        _writeToFile('[DEBUG] $message');
        break;
      case ObservabilityLevel.info:
        _writeToFile('[INFO] $message');
        break;
      case ObservabilityLevel.warning:
        _writeToFile('[WARN] $message');
        break;
      case ObservabilityLevel.error:
        _writeToFile('[ERROR] $message');
        if (event.error != null) {
          _writeToFile('Error: ${event.error}');
        }
        if (event.stackTrace != null) {
          _writeToFile('StackTrace: ${event.stackTrace}');
        }
        break;
      case ObservabilityLevel.none:
        // Don't log anything for none level
        break;
    }
  }

  void _writeToFile(String message) {
    try {
      if (_fileSink != null) {
        _fileSink.writeln('${DateTime.now().toIso8601String()}: $message');
      } else {
        // Fallback: write to the specified file path
        final file = File(filePath);
        file.writeAsStringSync(
          '${DateTime.now().toIso8601String()}: $message\n',
          mode: FileMode.append,
        );
      }
    } catch (e) {
      _observabilityLogger.warning('Failed to write to log file $filePath', e);
    }
  }

  /// Closes the file sink if one was provided
  void close() {
    _fileSink?.close();
  }
}

/// Represents an observability event
class ObservabilityEvent {
  final ObservabilityLevel level;
  final String source;
  final String message;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final Object? error;
  final StackTrace? stackTrace;

  ObservabilityEvent({
    required this.level,
    required this.source,
    required this.message,
    this.data = const {},
    DateTime? timestamp,
    this.error,
    this.stackTrace,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Format the event as a log message
  String formatMessage() {
    final buffer = StringBuffer();
    buffer.write('[${timestamp.toIso8601String()}] ');
    buffer.write('[${level.name.toUpperCase()}] ');
    buffer.write('[$source] ');
    buffer.write(message);

    if (data.isNotEmpty) {
      buffer.write(' | Data: $data');
    }

    return buffer.toString();
  }
}

/// Observer that handles Event objects and logs them based on configuration
class ObservabilityEventHandler {
  final ObservabilityConfiguration configuration;

  ObservabilityEventHandler({ObservabilityConfiguration? configuration})
    : configuration = configuration ?? const ObservabilityConfiguration();

  /// Process an Event and log it if appropriate
  void handleEvent(Event event) {
    final level = _determineEventLevel(event);

    // Check if we should log this event
    if (level.index < configuration.defaultLevel.index) {
      return;
    }

    // Create observability event
    final obsEvent = ObservabilityEvent(
      level: level,
      source: event.entity?.concept.code ?? 'System',
      message: '${event.name}: ${event.description}',
      data: event.data,
    );

    // Send to all channels
    for (final channel in configuration.channels) {
      channel.log(obsEvent);
    }
  }

  /// Determine the observability level for an event
  ObservabilityLevel _determineEventLevel(Event event) {
    // Check for specific event name patterns
    if (event.name.contains('Error') || event.name.contains('Failed')) {
      return ObservabilityLevel.error;
    } else if (event.name.contains('Warning')) {
      return ObservabilityLevel.warning;
    } else if (event.name.contains('Started') ||
        event.name.contains('Completed')) {
      return ObservabilityLevel.debug;
    } else if (event.name.contains('Trace')) {
      return ObservabilityLevel.trace;
    }

    // Check handlers for hints
    if (event.handlers.contains('Trace')) {
      return ObservabilityLevel.trace;
    } else if (event.handlers.contains('Debug')) {
      return ObservabilityLevel.debug;
    }

    return ObservabilityLevel.info;
  }
}

/// Extension to add observability to DomainSession
extension ObservabilityExtension on DomainSession {
  static final _observabilityHandlers =
      <DomainSession, ObservabilityEventHandler>{};

  /// Get or create the observability handler for this session
  ObservabilityEventHandler get observability {
    return _observabilityHandlers.putIfAbsent(
      this,
      () => ObservabilityEventHandler(),
    );
  }

  /// Configure observability for this session
  void configureObservability(ObservabilityConfiguration configuration) {
    _observabilityHandlers[this] = ObservabilityEventHandler(
      configuration: configuration,
    );
  }

  /// Log an event through the observability system
  void logEvent(Event event) {
    observability.handleEvent(event);
  }

  /// Create and log a trace event
  void trace(String message, {Map<String, dynamic>? data}) {
    final event = Event('Trace', message, ['Trace'], null, data ?? {});
    logEvent(event);
  }

  /// Create and log a debug event
  void debug(String message, {Map<String, dynamic>? data}) {
    final event = Event('Debug', message, ['Debug'], null, data ?? {});
    logEvent(event);
  }

  /// Create and log an info event
  void info(String message, {Map<String, dynamic>? data}) {
    final event = Event('Info', message, [], null, data ?? {});
    logEvent(event);
  }

  /// Create and log a warning event
  void warning(String message, {Map<String, dynamic>? data}) {
    final event = Event('Warning', message, [], null, data ?? {});
    logEvent(event);
  }

  /// Create and log an error event
  void error(String message, {Map<String, dynamic>? data}) {
    final event = Event('Error', message, [], null, data ?? {});
    logEvent(event);
  }

  /// Clear all observability handlers (useful for testing cleanup)
  static void clearAllObservabilityHandlers() {
    _observabilityHandlers.clear();
  }
}

/// Mixin to provide idiomatic observability for EDNet Core architectural artifacts
///
/// This mixin integrates with the established EDNet Core observability patterns
/// and provides structured logging capabilities for domain infrastructure components.
mixin ObservabilityMixin {
  /// Optional domain session for observability context
  DomainSession? get domainSession => null;

  /// Component name for observability context
  String get componentName;

  /// Component type for categorization
  String get componentType => runtimeType.toString();

  /// Get observability handler, fallback to global if no session
  ObservabilityEventHandler get _observabilityHandler {
    if (domainSession != null) {
      return domainSession!.observability;
    }
    // Fallback to global observability handler
    return _globalObservabilityHandler;
  }

  /// Configure global observability for components without domain session
  static void configureGlobalObservability(ObservabilityConfiguration config) {
    _globalObservabilityHandler = ObservabilityEventHandler(
      configuration: config,
    );
  }

  /// Global fallback observability handler (mutable reference)
  /// Package-private for test configuration access
  static ObservabilityEventHandler _globalObservabilityHandler =
      ObservabilityEventHandler(
        configuration: const ObservabilityConfiguration(
          defaultLevel: ObservabilityLevel.error,
          channels: [], // No channels by default - silent operation
        ),
      );

  /// Getter for accessing global handler (for testing)
  static ObservabilityEventHandler get globalObservabilityHandler =>
      _globalObservabilityHandler;

  /// Setter for global handler (for testing)
  static set globalObservabilityHandler(ObservabilityEventHandler handler) {
    _globalObservabilityHandler = handler;
  }

  /// Configure library-wide observability defaults for silent operation
  /// This ensures tests and library usage don't generate noise by default
  static void configureLibraryDefaults({
    ObservabilityLevel defaultLevel = ObservabilityLevel.error,
    List<ObservabilityChannel> channels = const [],
  }) {
    _globalObservabilityHandler = ObservabilityEventHandler(
      configuration: ObservabilityConfiguration(
        defaultLevel: defaultLevel,
        channels: channels,
      ),
    );
  }

  /// Log trace level event
  void observabilityTrace(String operation, [Map<String, dynamic>? context]) {
    _logObservabilityEvent(ObservabilityLevel.trace, operation, context);
  }

  /// Log debug level event
  void observabilityDebug(String operation, [Map<String, dynamic>? context]) {
    _logObservabilityEvent(ObservabilityLevel.debug, operation, context);
  }

  /// Log info level event
  void observabilityInfo(String operation, {Map<String, dynamic>? context}) {
    _logObservabilityEvent(ObservabilityLevel.info, operation, context);
  }

  /// Log warning level event
  void observabilityWarning(String operation, {Map<String, dynamic>? context}) {
    _logObservabilityEvent(ObservabilityLevel.warning, operation, context);
  }

  /// Log error level event
  void observabilityError(
    String operation, {
    dynamic error,
    Map<String, dynamic>? context,
  }) {
    final errorContext = <String, dynamic>{
      if (context != null) ...context,
      if (error != null) 'error': error.toString(),
      'errorType': error.runtimeType.toString(),
    };
    _logObservabilityEvent(ObservabilityLevel.error, operation, errorContext);
  }

  /// Log execution flow with operation timing (renamed to avoid conflict)
  T traceExecution<T>(
    String operation,
    T Function() execution, {
    Map<String, dynamic>? context,
  }) {
    final startTime = DateTime.now();
    observabilityDebug('$operation.started', context);

    try {
      final result = execution();
      final duration = DateTime.now().difference(startTime);

      observabilityDebug('$operation.completed', {
        ...?context,
        'duration_ms': duration.inMilliseconds,
        'success': true,
      });

      return result;
    } catch (error, stackTrace) {
      final duration = DateTime.now().difference(startTime);

      observabilityError(
        '$operation.failed',
        error: error,
        context: {
          ...?context,
          'duration_ms': duration.inMilliseconds,
          'stackTrace': stackTrace.toString(),
        },
      );
      rethrow;
    }
  }

  /// Log async execution flow with operation timing (renamed to avoid conflict)
  Future<T> traceExecutionAsync<T>(
    String operation,
    Future<T> Function() execution, {
    Map<String, dynamic>? context,
  }) async {
    final startTime = DateTime.now();
    observabilityDebug('$operation.started', context);

    try {
      final result = await execution();
      final duration = DateTime.now().difference(startTime);

      observabilityDebug('$operation.completed', {
        ...?context,
        'duration_ms': duration.inMilliseconds,
        'success': true,
      });

      return result;
    } catch (error, stackTrace) {
      final duration = DateTime.now().difference(startTime);

      observabilityError(
        '$operation.failed',
        error: error,
        context: {
          ...?context,
          'duration_ms': duration.inMilliseconds,
          'stackTrace': stackTrace.toString(),
        },
      );
      rethrow;
    }
  }

  /// Internal method to log observability events
  void _logObservabilityEvent(
    ObservabilityLevel level,
    String operation,
    Map<String, dynamic>? context,
  ) {
    final event = ObservabilityEvent(
      level: level,
      source: '$componentType.$componentName',
      message: operation,
      data: {
        'component': componentName,
        'componentType': componentType,
        'timestamp': DateTime.now().toIso8601String(),
        ...?context,
      },
    );

    for (final channel in _observabilityHandler.configuration.channels) {
      channel.log(event);
    }
  }
}
