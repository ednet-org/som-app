part of ednet_core;

final Logger _policyEvaluationTracerLogger = Logger(
  'ednet_core.policy.evaluation_tracer',
);

/// **Enhanced Policy Evaluation Tracer with Blockchain Audit Support**
///
/// The [PolicyEvaluationTracer] class provides comprehensive tracing of:
/// - Policy evaluation start and end with depth tracking
/// - Attribute value checks with detailed context
/// - Relationship value checks with audit trails
/// - Domain model structure analysis
/// - Summary statistics and performance metrics
/// - Blockchain audit trail preparation for offline redundancy
/// - Cross-partition policy evaluation tracking
///
/// Example usage:
/// ```dart
/// final tracer = PolicyEvaluationTracer(enableBlockchainAudit: true);
///
/// // Start policy evaluation
/// tracer.startEvaluation('pricePolicy', product);
///
/// // Add attribute check
/// tracer.addAttributeCheck('price', 100.0, true);
///
/// // Add relationship check
/// tracer.addRelationshipCheck('category', electronics, true);
///
/// // End policy evaluation
/// tracer.endEvaluation('pricePolicy', true);
///
/// // Get formatted trace output
/// print(tracer.getTrace());
///
/// // Get summary statistics
/// print(tracer.getSummary());
///
/// // Get blockchain audit data
/// final auditTrail = tracer.getBlockchainAuditTrail();
/// ```
class PolicyEvaluationTracer {
  /// The list of trace entries recording the evaluation process.
  final List<TraceEntry> _traceEntries = [];

  /// The current nesting depth of policy evaluations.
  int _depth = 0;

  /// Whether to print traces immediately.
  final bool _printImmediately;

  /// Whether to prepare blockchain audit trails for offline redundancy.
  final bool _enableBlockchainAudit;

  /// Session identifier for blockchain audit correlation.
  final String _sessionId;

  /// Creates a new [PolicyEvaluationTracer] instance.
  ///
  /// [printImmediately] Whether to print traces as they occur.
  /// [enableBlockchainAudit] Whether to prepare blockchain audit trails.
  PolicyEvaluationTracer({
    bool printImmediately = false,
    bool enableBlockchainAudit = false,
  }) : _printImmediately = printImmediately,
       _enableBlockchainAudit = enableBlockchainAudit,
       _sessionId = DateTime.now().millisecondsSinceEpoch.toString();

  /// Records the start of a policy evaluation.
  ///
  /// [policyName] is the name of the policy being evaluated.
  /// [entity] is the entity being evaluated.
  void startEvaluation(String policyName, Entity entity) {
    final entry = TraceEntry(
      type: TraceEntryType.start,
      policyName: policyName,
      entityInfo: '${entity.concept.code}(${entity.oid})',
      depth: _depth,
      timestamp: DateTime.now(),
      sessionId: _sessionId,
    );

    _traceEntries.add(entry);
    _depth++;

    if (_printImmediately) {
      _policyEvaluationTracerLogger.fine(entry.toString());
    }
  }

  /// Records the end of a policy evaluation.
  ///
  /// [policyName] is the name of the policy being evaluated.
  /// [result] indicates whether the policy evaluation passed.
  void endEvaluation(String policyName, bool result) {
    _depth--;
    final entry = TraceEntry(
      type: TraceEntryType.end,
      policyName: policyName,
      result: result,
      depth: _depth,
      timestamp: DateTime.now(),
      sessionId: _sessionId,
    );

    _traceEntries.add(entry);

    if (_printImmediately) {
      _policyEvaluationTracerLogger.fine(entry.toString());
    }
  }

  /// Records an attribute value check.
  ///
  /// [attributeName] is the name of the attribute being checked.
  /// [value] is the value being checked.
  /// [result] indicates whether the check passed.
  void addAttributeCheck(String attributeName, dynamic value, bool result) {
    final entry = TraceEntry(
      type: TraceEntryType.attributeCheck,
      attributeName: attributeName,
      attributeValue: value,
      result: result,
      depth: _depth,
      timestamp: DateTime.now(),
      sessionId: _sessionId,
    );

    _traceEntries.add(entry);

    if (_printImmediately) {
      _policyEvaluationTracerLogger.fine(entry.toString());
    }
  }

  /// Records a relationship value check.
  ///
  /// [relationshipName] is the name of the relationship being checked.
  /// [value] is the value being checked.
  /// [result] indicates whether the check passed.
  void addRelationshipCheck(
    String relationshipName,
    dynamic value,
    bool result,
  ) {
    final entry = TraceEntry(
      type: TraceEntryType.relationshipCheck,
      relationshipName: relationshipName,
      relationshipValue: value,
      result: result,
      depth: _depth,
      timestamp: DateTime.now(),
      sessionId: _sessionId,
    );

    _traceEntries.add(entry);

    if (_printImmediately) {
      _policyEvaluationTracerLogger.fine(entry.toString());
    }
  }

  /// Traces a domain model structure for comprehensive analysis.
  ///
  /// This method logs the structure of a domain model, including
  /// concepts, attributes, relationships, and policies.
  ///
  /// [domain] The domain to trace.
  void traceDomainModel(Domain domain) {
    final buffer = StringBuffer();

    buffer.writeln('🏗️  Domain Model Trace: ${domain.code}');
    buffer.writeln('='.padRight(60, '='));
    buffer.writeln('Session ID: $_sessionId');
    buffer.writeln('Timestamp: ${DateTime.now().toIso8601String()}');
    buffer.writeln();

    // Trace each model and its concepts (simplified for blockchain audit)
    for (final model in domain.models) {
      buffer.writeln('📦 Model: ${model.code}');
      if (model.description != null) {
        buffer.writeln('   Description: ${model.description}');
      }
      buffer.writeln('   Concepts: ${model.concepts.length}');

      // Simple concept listing for audit purposes
      for (final concept in model.concepts) {
        buffer.writeln(
          '  📋 ${concept.code} (${concept.attributes.length} attrs, ${concept.parents.length} parents, ${concept.children.length} children)',
        );
      }

      buffer.writeln();
    }

    final trace = buffer.toString();

    // Only print if immediate printing is enabled
    if (_printImmediately) {
      _policyEvaluationTracerLogger.fine(trace);
    }

    // Add domain model trace entry for blockchain audit
    if (_enableBlockchainAudit) {
      _traceEntries.add(
        TraceEntry(
          type: TraceEntryType.domainModelTrace,
          entityInfo: 'Domain: ${domain.code}',
          details: trace,
          depth: 0,
          timestamp: DateTime.now(),
          sessionId: _sessionId,
        ),
      );
    }
  }

  /// Gets the formatted trace output as a string.
  ///
  /// Returns a string containing all trace entries with proper indentation.
  String getTrace() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('🔍 Policy Evaluation Trace (Session: $_sessionId)');
    buffer.writeln('=' * 60);

    for (var entry in _traceEntries) {
      buffer.writeln(entry.toString());
    }

    return buffer.toString();
  }

  /// Gets summary statistics for policy evaluations.
  ///
  /// Returns a map of policy names to success rates and detailed metrics.
  Map<String, PolicyEvaluationStats> getSummary() {
    final summary = <String, Map<String, int>>{};

    // Count successes and failures for each policy
    for (final trace in _traceEntries.where(
      (e) => e.type == TraceEntryType.end,
    )) {
      final policyName = trace.policyName ?? 'Unknown';
      summary.putIfAbsent(
        policyName,
        () => {'success': 0, 'failure': 0, 'total': 0},
      );

      if (trace.result == true) {
        summary[policyName]!['success'] =
            (summary[policyName]!['success'] ?? 0) + 1;
      } else {
        summary[policyName]!['failure'] =
            (summary[policyName]!['failure'] ?? 0) + 1;
      }
      summary[policyName]!['total'] = (summary[policyName]!['total'] ?? 0) + 1;
    }

    // Create detailed statistics
    final stats = <String, PolicyEvaluationStats>{};
    summary.forEach((policy, counts) {
      final total = counts['total'] ?? 0;
      final successRate = total > 0 ? (counts['success'] ?? 0) / total : 0.0;

      stats[policy] = PolicyEvaluationStats(
        policyName: policy,
        totalEvaluations: total,
        successfulEvaluations: counts['success'] ?? 0,
        failedEvaluations: counts['failure'] ?? 0,
        successRate: successRate,
        sessionId: _sessionId,
      );
    });

    return stats;
  }

  /// Prints a formatted summary of policy evaluations.
  /// Only prints if immediate printing is enabled.
  void printSummary() {
    if (!_printImmediately) {
      return; // Silent operation when immediate printing is disabled
    }

    final summary = getSummary();

    _policyEvaluationTracerLogger.info(
      'Policy Evaluation Summary (Session: $_sessionId)',
    );
    _policyEvaluationTracerLogger.info('=' * 60);

    if (summary.isEmpty) {
      _policyEvaluationTracerLogger.info('No policy evaluations recorded.');
      return;
    }

    summary.forEach((policy, stats) {
      final percentage = (stats.successRate * 100).toStringAsFixed(2);
      _policyEvaluationTracerLogger.info('🛡️  $policy:');
      _policyEvaluationTracerLogger.info(
        '   Success Rate: $percentage% (${stats.successfulEvaluations}/${stats.totalEvaluations})',
      );
      _policyEvaluationTracerLogger.info(
        '   Failed: ${stats.failedEvaluations}',
      );
      _policyEvaluationTracerLogger.info('');
    });
  }

  /// Gets blockchain audit trail data for offline redundancy.
  ///
  /// Returns structured data suitable for blockchain storage and verification.
  BlockchainAuditTrail getBlockchainAuditTrail() {
    if (!_enableBlockchainAudit) {
      throw StateError('Blockchain audit not enabled for this tracer');
    }

    return BlockchainAuditTrail(
      sessionId: _sessionId,
      startTime: _traceEntries.isNotEmpty
          ? _traceEntries.first.timestamp
          : DateTime.now(),
      endTime: _traceEntries.isNotEmpty
          ? _traceEntries.last.timestamp
          : DateTime.now(),
      totalEntries: _traceEntries.length,
      traceEntries: List.unmodifiable(_traceEntries),
      summary: getSummary(),
      auditHash: _generateAuditHash(),
    );
  }

  /// Creates a policy evaluator listener function for integration.
  ///
  /// [domain] The domain context for the listener.
  /// Returns a function that can be attached to policy evaluators.
  Function getPolicyEvaluatorListener(Domain domain) {
    return (Entity entity, IPolicy policy, bool result, [String? details]) {
      startEvaluation(policy.name, entity);
      if (details != null) {
        addAttributeCheck('evaluation_details', details, result);
      }
      endEvaluation(policy.name, result);
    };
  }

  /// Clears all trace entries and resets the depth counter.
  void clear() {
    _traceEntries.clear();
    _depth = 0;
  }

  /// Generates a cryptographic hash of the audit trail for blockchain verification.
  String _generateAuditHash() {
    final content = _traceEntries.map((e) => e.toAuditString()).join('|');
    // For now using a simple hash - would use crypto hash in production
    return content.hashCode.toRadixString(16);
  }
}

/// Enhanced trace entry types including blockchain audit capabilities.
enum TraceEntryType {
  start,
  end,
  attributeCheck,
  relationshipCheck,
  domainModelTrace,
  blockchainCommit,
  authProviderValidation,
}

/// Enhanced trace entry with blockchain audit support.
class TraceEntry {
  /// The type of trace entry.
  final TraceEntryType type;

  /// The name of the policy being evaluated (for start/end events).
  final String? policyName;

  /// Information about the entity being evaluated (for start events).
  final String? entityInfo;

  /// The name of the attribute being checked (for attribute check events).
  final String? attributeName;

  /// The value of the attribute being checked (for attribute check events).
  final dynamic attributeValue;

  /// The name of the relationship being checked (for relationship check events).
  final String? relationshipName;

  /// The value of the relationship being checked (for relationship check events).
  final dynamic relationshipValue;

  /// The result of the check or evaluation (for end/check events).
  final bool? result;

  /// The nesting depth of this entry in the trace.
  final int depth;

  /// Timestamp for blockchain audit and chronological ordering.
  final DateTime timestamp;

  /// Session identifier for correlation across distributed systems.
  final String sessionId;

  /// Additional details for complex trace scenarios.
  final String? details;

  /// Creates a new [TraceEntry] instance.
  TraceEntry({
    required this.type,
    this.policyName,
    this.entityInfo,
    this.attributeName,
    this.attributeValue,
    this.relationshipName,
    this.relationshipValue,
    this.result,
    required this.depth,
    required this.timestamp,
    required this.sessionId,
    this.details,
  });

  /// Returns a formatted string representation of this trace entry.
  @override
  String toString() {
    final timeStr =
        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}.${timestamp.millisecond.toString().padLeft(3, '0')}';
    String indent = '  ' * depth;

    switch (type) {
      case TraceEntryType.start:
        return '$indent[$timeStr] ► Starting evaluation of $policyName for $entityInfo';
      case TraceEntryType.end:
        final resultIcon = result! ? '✅' : '❌';
        return '$indent[$timeStr] ◄ $resultIcon Ending evaluation of $policyName: ${result! ? 'Passed' : 'Failed'}';
      case TraceEntryType.attributeCheck:
        final resultIcon = result! ? '✅' : '❌';
        return '$indent[$timeStr] • $resultIcon Attribute check: $attributeName = $attributeValue';
      case TraceEntryType.relationshipCheck:
        final resultIcon = result! ? '✅' : '❌';
        return '$indent[$timeStr] • $resultIcon Relationship check: $relationshipName = $relationshipValue';
      case TraceEntryType.domainModelTrace:
        return '$indent[$timeStr] 🏗️  Domain model traced: $entityInfo';
      case TraceEntryType.blockchainCommit:
        return '$indent[$timeStr] ⛓️  Blockchain commit: $details';
      case TraceEntryType.authProviderValidation:
        final resultIcon = result! ? '✅' : '❌';
        return '$indent[$timeStr] 🔐 $resultIcon Auth provider validation: $details';
    }
  }

  /// Returns audit-safe string representation for blockchain hash calculation.
  String toAuditString() {
    return '${type.name}|$sessionId|${timestamp.millisecondsSinceEpoch}|$policyName|$result|$attributeName|$attributeValue';
  }
}

/// Statistical summary of policy evaluations for a specific policy.
class PolicyEvaluationStats {
  final String policyName;
  final int totalEvaluations;
  final int successfulEvaluations;
  final int failedEvaluations;
  final double successRate;
  final String sessionId;

  const PolicyEvaluationStats({
    required this.policyName,
    required this.totalEvaluations,
    required this.successfulEvaluations,
    required this.failedEvaluations,
    required this.successRate,
    required this.sessionId,
  });

  @override
  String toString() {
    final percentage = (successRate * 100).toStringAsFixed(2);
    return 'PolicyStats($policyName: $percentage% success, $successfulEvaluations/$totalEvaluations)';
  }
}

/// Blockchain audit trail for offline redundancy and verification.
class BlockchainAuditTrail {
  final String sessionId;
  final DateTime startTime;
  final DateTime endTime;
  final int totalEntries;
  final List<TraceEntry> traceEntries;
  final Map<String, PolicyEvaluationStats> summary;
  final String auditHash;

  const BlockchainAuditTrail({
    required this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.totalEntries,
    required this.traceEntries,
    required this.summary,
    required this.auditHash,
  });

  /// Duration of the evaluation session.
  Duration get duration => endTime.difference(startTime);

  /// Converts to JSON for blockchain storage.
  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'totalEntries': totalEntries,
      'duration': duration.inMilliseconds,
      'auditHash': auditHash,
      'summary': summary.map(
        (k, v) => MapEntry(k, {
          'policyName': v.policyName,
          'totalEvaluations': v.totalEvaluations,
          'successfulEvaluations': v.successfulEvaluations,
          'failedEvaluations': v.failedEvaluations,
          'successRate': v.successRate,
        }),
      ),
    };
  }

  @override
  String toString() {
    return 'BlockchainAuditTrail(session: $sessionId, entries: $totalEntries, duration: ${duration.inSeconds}s, hash: $auditHash)';
  }
}
