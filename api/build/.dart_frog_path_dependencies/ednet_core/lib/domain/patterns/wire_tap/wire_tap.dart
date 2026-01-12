part of ednet_core;

/// Wire Tap Pattern
///
/// The Wire Tap pattern allows you to inspect messages that travel on a channel
/// without disturbing the flow of the message. This is useful for monitoring,
/// auditing, debugging, and logging message traffic in messaging systems.
///
/// In EDNet/direct democracy contexts, wire tapping is crucial for:
/// * Auditing voting processes and ensuring transparency
/// * Monitoring citizen engagement and deliberation activities
/// * Debugging proposal submission and amendment workflows
/// * Logging administrative actions for compliance and security
/// * Analyzing message patterns for system optimization
/// * Real-time monitoring of democratic processes

/// Abstract interface for wire tap functionality
abstract class WireTap {
  /// The channel being tapped
  Channel get tappedChannel;

  /// The channel where tapped messages are sent
  Channel get tapChannel;

  /// Starts the wire tap
  Future<void> start();

  /// Stops the wire tap
  Future<void> stop();

  /// Checks if the wire tap is currently active
  bool get isActive;

  /// Gets wire tap statistics
  WireTapStats getStats();
}

/// Statistics for wire tap monitoring
class WireTapStats {
  final int totalMessages;
  final DateTime startedAt;
  final DateTime? stoppedAt;
  final Duration uptime;
  final Map<String, dynamic> messageTypes;

  WireTapStats({
    required this.totalMessages,
    required this.startedAt,
    this.stoppedAt,
    required this.uptime,
    required this.messageTypes,
  });

  @override
  String toString() {
    return 'WireTapStats{messages: $totalMessages, uptime: $uptime, types: ${messageTypes.length}}';
  }
}

/// Basic wire tap implementation
class BasicWireTap implements WireTap {
  final Channel _tappedChannel;
  final Channel _tapChannel;
  final bool _selectiveTapping;
  final WireTapFilter? _filter;
  final WireTapTransformer? _transformer;

  StreamSubscription<Message>? _subscription;
  final _stats = <String, dynamic>{
    'totalMessages': 0,
    'messageTypes': <String, int>{},
  };
  DateTime? _startedAt;
  DateTime? _stoppedAt;

  BasicWireTap(
    this._tappedChannel,
    this._tapChannel, {
    bool selectiveTapping = false,
    WireTapFilter? filter,
    WireTapTransformer? transformer,
  }) : _selectiveTapping = selectiveTapping,
       _filter = filter,
       _transformer = transformer;

  @override
  Channel get tappedChannel => _tappedChannel;

  @override
  Channel get tapChannel => _tapChannel;

  @override
  Future<void> start() async {
    if (isActive) return;

    _startedAt = DateTime.now();
    _stoppedAt = null;

    _subscription = _tappedChannel.receive().listen(
      (message) async {
        try {
          // Update statistics
          _stats['totalMessages'] = (_stats['totalMessages'] as int) + 1;
          final messageType = _getMessageType(message);
          final typeStats = _stats['messageTypes'] as Map<String, int>;
          typeStats[messageType] = (typeStats[messageType] ?? 0) + 1;

          // Apply selective tapping if enabled
          if (_selectiveTapping && _filter != null) {
            if (!_filter.shouldTap(message)) {
              return; // Skip this message
            }
          }

          // Transform message if transformer is provided
          Message tapMessage = message;
          if (_transformer != null) {
            tapMessage = await _transformer.transform(message);
          }

          // Send to tap channel
          await _tapChannel.send(tapMessage);
        } catch (e) {
          // Log error but don't stop the wire tap
          // In a real implementation, you'd have proper error handling/logging
        }
      },
      onError: (error) {
        // Handle stream errors
      },
      onDone: () {
        // Handle stream completion
        stop();
      },
    );
  }

  @override
  Future<void> stop() async {
    if (!isActive) return;

    _stoppedAt = DateTime.now();
    await _subscription?.cancel();
    _subscription = null;
  }

  @override
  bool get isActive => _subscription != null;

  @override
  WireTapStats getStats() {
    final totalMessages = _stats['totalMessages'] as int;
    final messageTypes = Map<String, dynamic>.from(
      _stats['messageTypes'] as Map<String, int>,
    );

    return WireTapStats(
      totalMessages: totalMessages,
      startedAt: _startedAt ?? DateTime.now(),
      stoppedAt: _stoppedAt,
      uptime: _startedAt != null
          ? (_stoppedAt ?? DateTime.now()).difference(_startedAt!)
          : Duration.zero,
      messageTypes: messageTypes,
    );
  }

  String _getMessageType(Message message) {
    // Try to determine message type from metadata or payload
    if (message.metadata.containsKey('messageType')) {
      return message.metadata['messageType'] as String;
    }

    if (message.payload is Map<String, dynamic> &&
        (message.payload as Map<String, dynamic>).containsKey('type')) {
      return (message.payload as Map<String, dynamic>)['type'] as String;
    }

    // Default type
    return message.payload.runtimeType.toString();
  }
}

/// Filter interface for selective wire tapping
abstract class WireTapFilter {
  /// Determines whether a message should be tapped
  bool shouldTap(Message message);

  /// Gets filter criteria for monitoring/debugging
  Map<String, dynamic> getFilterCriteria();
}

/// Content-based wire tap filter
class ContentBasedWireTapFilter implements WireTapFilter {
  final List<WireTapCondition> conditions;
  final bool matchAll; // true = AND, false = OR

  ContentBasedWireTapFilter({required this.conditions, this.matchAll = true});

  @override
  bool shouldTap(Message message) {
    if (matchAll) {
      // All conditions must match (AND)
      return conditions.every((condition) => condition.matches(message));
    } else {
      // At least one condition must match (OR)
      return conditions.any((condition) => condition.matches(message));
    }
  }

  @override
  Map<String, dynamic> getFilterCriteria() {
    return {
      'type': 'content-based',
      'matchAll': matchAll,
      'conditions': conditions.map((c) => c.toMap()).toList(),
    };
  }
}

/// Condition for wire tap filtering
class WireTapCondition {
  final String field;
  final WireTapOperator operator;
  final dynamic value;

  WireTapCondition({required this.field, required this.operator, this.value});

  bool matches(Message message) {
    dynamic fieldValue;

    // Extract field value from message
    if (message.metadata.containsKey(field)) {
      fieldValue = message.metadata[field];
    } else if (message.payload is Map<String, dynamic> &&
        (message.payload as Map<String, dynamic>).containsKey(field)) {
      fieldValue = (message.payload as Map<String, dynamic>)[field];
    } else {
      return false; // Field not found
    }

    // Apply operator
    switch (operator) {
      case WireTapOperator.equals:
        return fieldValue == value;
      case WireTapOperator.notEquals:
        return fieldValue != value;
      case WireTapOperator.contains:
        if (fieldValue is String && value is String) {
          return fieldValue.contains(value);
        }
        if (fieldValue is List) {
          return fieldValue.contains(value);
        }
        return false;
      case WireTapOperator.greaterThan:
        if (fieldValue is num && value is num) {
          return fieldValue > value;
        }
        return false;
      case WireTapOperator.lessThan:
        if (fieldValue is num && value is num) {
          return fieldValue < value;
        }
        return false;
      case WireTapOperator.exists:
        return fieldValue != null;
      case WireTapOperator.notExists:
        return fieldValue == null;
    }
  }

  Map<String, dynamic> toMap() {
    return {'field': field, 'operator': operator.toString(), 'value': value};
  }
}

/// Operators for wire tap conditions
enum WireTapOperator {
  equals,
  notEquals,
  contains,
  greaterThan,
  lessThan,
  exists,
  notExists,
}

/// Transformer interface for modifying tapped messages
abstract class WireTapTransformer {
  /// Transforms a message before it goes to the tap channel
  Future<Message> transform(Message message);
}

/// Basic wire tap transformer that adds tap metadata
class MetadataWireTapTransformer implements WireTapTransformer {
  final String tapSource;
  final Map<String, dynamic> additionalMetadata;

  MetadataWireTapTransformer({
    required this.tapSource,
    this.additionalMetadata = const {},
  });

  @override
  Future<Message> transform(Message message) async {
    final transformedMetadata = Map<String, dynamic>.from(message.metadata);
    transformedMetadata['tapped'] = true;
    transformedMetadata['tapSource'] = tapSource;
    transformedMetadata['tapTimestamp'] = DateTime.now().toIso8601String();
    transformedMetadata.addAll(additionalMetadata);

    return Message(
      payload: message.payload,
      metadata: transformedMetadata,
      id: message.id,
    );
  }
}

/// Audit wire tap transformer that adds audit information
class AuditWireTapTransformer implements WireTapTransformer {
  final String auditReason;
  final String auditorId;

  AuditWireTapTransformer({required this.auditReason, required this.auditorId});

  @override
  Future<Message> transform(Message message) async {
    final auditMetadata = {
      'audit': {
        'reason': auditReason,
        'auditorId': auditorId,
        'timestamp': DateTime.now().toIso8601String(),
        'messageId': message.id,
        'messageType': message.payload.runtimeType.toString(),
      },
    };

    final transformedMetadata = Map<String, dynamic>.from(message.metadata);
    transformedMetadata.addAll(auditMetadata);

    return Message(
      payload: message.payload,
      metadata: transformedMetadata,
      id: message.id,
    );
  }
}

/// Composite wire tap that combines multiple taps
class CompositeWireTap implements WireTap {
  final List<WireTap> _taps;
  final String _compositeName;

  CompositeWireTap(this._compositeName, this._taps);

  @override
  Channel get tappedChannel => _taps.first.tappedChannel; // All taps should monitor the same channel

  @override
  Channel get tapChannel => _taps.first.tapChannel; // Primary tap channel

  @override
  Future<void> start() async {
    for (final tap in _taps) {
      await tap.start();
    }
  }

  @override
  Future<void> stop() async {
    for (final tap in _taps) {
      await tap.stop();
    }
  }

  @override
  bool get isActive => _taps.any((tap) => tap.isActive);

  @override
  WireTapStats getStats() {
    final totalMessages = _taps.fold<int>(
      0,
      (sum, tap) => sum + tap.getStats().totalMessages,
    );
    final startedAt = _taps
        .map((tap) => tap.getStats().startedAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
    final stoppedAt = _taps.every((tap) => tap.getStats().stoppedAt != null)
        ? _taps
              .map((tap) => tap.getStats().stoppedAt!)
              .reduce((a, b) => a.isAfter(b) ? a : b)
        : null;
    final uptime = _taps.fold<Duration>(
      Duration.zero,
      (sum, tap) => sum + tap.getStats().uptime,
    );

    final combinedMessageTypes = <String, dynamic>{};
    for (final tap in _taps) {
      final stats = tap.getStats();
      stats.messageTypes.forEach((key, value) {
        combinedMessageTypes[key] =
            (combinedMessageTypes[key] ?? 0) + (value as int);
      });
    }

    return WireTapStats(
      totalMessages: totalMessages,
      startedAt: startedAt,
      stoppedAt: stoppedAt,
      uptime: uptime,
      messageTypes: combinedMessageTypes,
    );
  }

  @override
  String toString() {
    return 'CompositeWireTap{name: $_compositeName, taps: ${_taps.length}}';
  }
}

/// Predefined wire taps for EDNet use cases

/// Voting audit wire tap - monitors all voting-related messages
class VotingAuditWireTap extends BasicWireTap {
  VotingAuditWireTap(Channel tappedChannel, Channel auditChannel)
    : super(
        tappedChannel,
        auditChannel,
        selectiveTapping: true,
        filter: ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'messageType',
              operator: WireTapOperator.equals,
              value: 'vote',
            ),
            WireTapCondition(
              field: 'messageType',
              operator: WireTapOperator.equals,
              value: 'vote_result',
            ),
          ],
          matchAll: false, // OR condition
        ),
        transformer: AuditWireTapTransformer(
          auditReason: 'Voting Process Audit',
          auditorId: 'ednet-audit-system',
        ),
      );
}

/// Proposal monitoring wire tap - tracks proposal-related activities
class ProposalMonitoringWireTap extends BasicWireTap {
  ProposalMonitoringWireTap(Channel tappedChannel, Channel monitoringChannel)
    : super(
        tappedChannel,
        monitoringChannel,
        selectiveTapping: true,
        filter: ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'messageType',
              operator: WireTapOperator.contains,
              value: 'proposal',
            ),
          ],
        ),
        transformer: MetadataWireTapTransformer(
          tapSource: 'proposal-monitor',
          additionalMetadata: {
            'monitoring': {
              'purpose': 'Proposal Activity Tracking',
              'trackedFields': ['creation', 'amendment', 'voting', 'closure'],
            },
          },
        ),
      );
}

/// Wire tap manager for coordinating multiple wire taps
class WireTapManager {
  final List<WireTap> _taps = [];
  final Map<String, WireTap> _namedTaps = {};

  /// Adds a wire tap to the manager
  void addTap(String name, WireTap tap) {
    _taps.add(tap);
    _namedTaps[name] = tap;
  }

  /// Removes a wire tap by name
  void removeTap(String name) {
    final tap = _namedTaps.remove(name);
    if (tap != null) {
      _taps.remove(tap);
    }
  }

  /// Gets a wire tap by name
  WireTap? getTap(String name) => _namedTaps[name];

  /// Starts all managed wire taps
  Future<void> startAll() async {
    for (final tap in _taps) {
      await tap.start();
    }
  }

  /// Stops all managed wire taps
  Future<void> stopAll() async {
    for (final tap in _taps) {
      await tap.stop();
    }
  }

  /// Gets combined statistics for all managed wire taps
  Map<String, WireTapStats> getAllStats() {
    final stats = <String, WireTapStats>{};
    _namedTaps.forEach((name, tap) {
      stats[name] = tap.getStats();
    });
    return stats;
  }

  /// Gets summary statistics across all taps
  Map<String, dynamic> getSummaryStats() {
    int totalMessages = 0;
    final messageTypes = <String, int>{};

    for (final tap in _taps) {
      final stats = tap.getStats();
      totalMessages += stats.totalMessages;
      stats.messageTypes.forEach((type, count) {
        messageTypes[type] = (messageTypes[type] ?? 0) + (count as int);
      });
    }

    return {
      'totalTaps': _taps.length,
      'totalMessages': totalMessages,
      'activeTaps': _taps.where((tap) => tap.isActive).length,
      'messageTypes': messageTypes,
    };
  }
}
