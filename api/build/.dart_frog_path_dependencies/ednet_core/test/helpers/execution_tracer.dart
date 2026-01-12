import 'package:ednet_core/ednet_core.dart';

/// Enhanced execution tracer for debugging test failures.
///
/// This class captures detailed traces of command execution, event publishing,
/// and policy triggering to help understand what's happening in failing tests.
///
/// Traces are only printed when TEST_TRACE=true is set via:
/// dart test -D TEST_TRACE=true
class ExecutionTracer with ObservabilityMixin {
  @override
  String get componentName => 'ExecutionTracer';

  /// Check if test tracing is enabled
  static const bool _testTraceEnabled = bool.fromEnvironment(
    'TEST_TRACE',
    defaultValue: false,
  );
  final List<TraceEntry> _traces = [];
  static ExecutionTracer? _instance;

  /// Gets the singleton instance of the execution tracer
  static ExecutionTracer get instance {
    _instance ??= ExecutionTracer();
    return _instance!;
  }

  /// Clears all traces (useful between test runs)
  void clear() {
    _traces.clear();
  }

  /// Records a trace entry
  void trace(
    String operation,
    String level,
    Map<String, dynamic> context, [
    Object? error,
  ]) {
    final entry = TraceEntry(
      timestamp: DateTime.now(),
      operation: operation,
      level: level,
      context: Map<String, dynamic>.from(context),
      error: error?.toString(),
    );
    _traces.add(entry);

    // Only print to console if TEST_TRACE=true
    if (_testTraceEnabled) {
      observabilityTrace(operation, {
        ...context,
        'level': level,
        if (error != null) 'error': error.toString(),
      });
    }
  }

  /// Gets all traces
  List<TraceEntry> get traces => List.unmodifiable(_traces);

  /// Gets traces for a specific operation
  List<TraceEntry> getTracesFor(String operation) {
    return _traces.where((t) => t.operation == operation).toList();
  }

  /// Gets traces by level (trace, debug, info, warning, error)
  List<TraceEntry> getTracesByLevel(String level) {
    return _traces.where((t) => t.level == level).toList();
  }

  /// Prints a detailed execution summary
  void printExecutionSummary() {
    if (!_testTraceEnabled) return;

    observabilityInfo(
      'executionSummary.start',
      context: {'totalTraces': _traces.length},
    );
    // ignore: avoid_print
    print('\n' + '=' * 80);
    // ignore: avoid_print
    print('EXECUTION TRACE SUMMARY');
    // ignore: avoid_print
    print('=' * 80);
    // ignore: avoid_print
    print('Total traces: ${_traces.length}');

    final groupedByOperation = <String, List<TraceEntry>>{};
    for (final trace in _traces) {
      groupedByOperation.putIfAbsent(trace.operation, () => []).add(trace);
    }

    // ignore: avoid_print
    print('\nOperations executed:');
    for (final operation in groupedByOperation.keys) {
      final count = groupedByOperation[operation]!.length;
      final errors = groupedByOperation[operation]!
          .where((t) => t.error != null)
          .length;
      final errorStr = errors > 0 ? ' ($errors errors)' : '';
      // ignore: avoid_print
      print('  • $operation: $count traces$errorStr');
    }

    final errors = _traces.where((t) => t.error != null).toList();
    if (errors.isNotEmpty) {
      // ignore: avoid_print
      print('\n❌ ERRORS DETECTED:');
      for (final error in errors) {
        // ignore: avoid_print
        print(
          '  ${error.timestamp.toIso8601String()} [${error.level}] ${error.operation}',
        );
        // ignore: avoid_print
        print('     ERROR: ${error.error}');
        if (error.context.isNotEmpty) {
          // ignore: avoid_print
          print('     Context: ${error.context}');
        }
        // ignore: avoid_print
        print('');
      }
    }
    // ignore: avoid_print
    print('=' * 80 + '\n');
  }

  /// Prints detailed traces for debugging
  void printDetailedTraces({String? filterOperation, String? filterLevel}) {
    if (!_testTraceEnabled) return;

    var filteredTraces = _traces;

    if (filterOperation != null) {
      filteredTraces = filteredTraces
          .where((t) => t.operation.contains(filterOperation))
          .toList();
    }

    if (filterLevel != null) {
      filteredTraces = filteredTraces
          .where((t) => t.level == filterLevel)
          .toList();
    }
    // ignore: avoid_print
    print('\n' + '=' * 100);
    // ignore: avoid_print
    print('DETAILED EXECUTION TRACES');
    if (filterOperation != null || filterLevel != null) {
      // ignore: avoid_print
      print(
        'Filtered by: ${filterOperation ?? 'all operations'}, level: ${filterLevel ?? 'all levels'}',
      );
    }
    // ignore: avoid_print
    print('=' * 100);

    for (final trace in filteredTraces) {
      final timestamp = trace.timestamp.toIso8601String();
      // ignore: avoid_print
      print(
        '\n📍 $timestamp [${trace.level.toUpperCase()}] ${trace.operation}',
      );

      if (trace.context.isNotEmpty) {
        // ignore: avoid_print
        print('  📋 Context:');
        trace.context.forEach((key, value) {
          // ignore: avoid_print
          print('     $key: $value');
        });
      }

      if (trace.error != null) {
        // ignore: avoid_print
        print('  ❌ ERROR: ${trace.error}');
      }
    }
    // ignore: avoid_print
    print('\n' + '=' * 100 + '\n');
  }

  /// Analyzes command flow for debugging
  void analyzeCommandFlow() {
    if (!_testTraceEnabled) return;
    // ignore: avoid_print
    print('\n' + '=' * 80);
    // ignore: avoid_print
    print('COMMAND FLOW ANALYSIS');
    // ignore: avoid_print
    print('=' * 80);

    final commandTraces = _traces
        .where(
          (t) =>
              t.operation.contains('command') ||
              t.operation.contains('Command'),
        )
        .toList();

    if (commandTraces.isEmpty) {
      // ignore: avoid_print
      print('No command-related traces found.');
      // ignore: avoid_print
      print('=' * 80 + '\n');
      return;
    }
    // ignore: avoid_print
    print('Command execution timeline:');
    for (final trace in commandTraces) {
      final commandType = trace.context['commandType'] ?? 'Unknown';
      final commandId = trace.context['commandId'] ?? 'Unknown';
      final success = trace.context['success'];
      final errorMessage = trace.context['errorMessage'];

      String status = '';
      if (success == true) {
        status = '✅';
      } else if (success == false) {
        status = '❌';
      } else {
        status = '🔄';
      }
      // ignore: avoid_print
      print('  $status ${trace.operation}: $commandType ($commandId)');

      if (errorMessage != null) {
        // ignore: avoid_print
        print('     Error: $errorMessage');
      }
    }
    // ignore: avoid_print
    print('=' * 80 + '\n');
  }

  /// Analyzes policy execution for debugging
  void analyzePolicyFlow() {
    if (!_testTraceEnabled) return;
    // ignore: avoid_print
    print('\n' + '=' * 80);
    // ignore: avoid_print
    print('POLICY FLOW ANALYSIS');
    // ignore: avoid_print
    print('=' * 80);

    final policyTraces = _traces
        .where(
          (t) =>
              t.operation.contains('policy') || t.operation.contains('Policy'),
        )
        .toList();

    if (policyTraces.isEmpty) {
      // ignore: avoid_print
      print('No policy-related traces found.');
      // ignore: avoid_print
      print('=' * 80 + '\n');
      return;
    }
    // ignore: avoid_print
    print('Policy execution timeline:');
    for (final trace in policyTraces) {
      final policyName = trace.context['policyName'] ?? 'Unknown';
      final eventName = trace.context['eventName'] ?? 'Unknown';
      final commandsGenerated = trace.context['commandsGenerated'] ?? 0;
      final skipped = trace.context['skipped'];

      String status = '';
      if (skipped != null) {
        status = '⏭️';
      } else if (commandsGenerated > 0) {
        status = '🎯';
      } else {
        status = '🔄';
      }
      // ignore: avoid_print
      print('  $status ${trace.operation}: $policyName (event: $eventName)');

      if (commandsGenerated > 0) {
        final commands = trace.context['commands'] as List?;
        // ignore: avoid_print
        print('     Generated commands: $commandsGenerated');
        if (commands != null) {
          for (final command in commands) {
            // ignore: avoid_print
            print('       • $command');
          }
        }
      }

      if (skipped != null) {
        // ignore: avoid_print
        print('     Skipped: $skipped');
      }
    }
    // ignore: avoid_print
    print('=' * 80 + '\n');
  }
}

/// Represents a single trace entry
class TraceEntry {
  final DateTime timestamp;
  final String operation;
  final String level;
  final Map<String, dynamic> context;
  final String? error;

  TraceEntry({
    required this.timestamp,
    required this.operation,
    required this.level,
    required this.context,
    this.error,
  });

  @override
  String toString() {
    final contextStr = context.isEmpty ? '' : ' - $context';
    final errorStr = error != null ? ' ERROR: $error' : '';
    return '${timestamp.toIso8601String()} [$level] $operation$contextStr$errorStr';
  }
}

/// Custom observability channel that captures traces for execution debugging
class ExecutionTracingObservabilityChannel implements ObservabilityChannel {
  final ExecutionTracer _tracer = ExecutionTracer.instance;

  @override
  void log(ObservabilityEvent event) {
    _tracer.trace(
      event.source,
      event.level.name,
      event.data,
      null, // ObservabilityEvent doesn't have error field
    );
  }
}
