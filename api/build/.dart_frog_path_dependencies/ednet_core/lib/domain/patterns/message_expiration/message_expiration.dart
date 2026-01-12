part of ednet_core;

/// Note: MessagePatternsConfig classes are defined in config/message_patterns_config.dart

/// Message Expiration Pattern
///
/// The Message Expiration pattern ensures that messages have a limited lifetime
/// and are automatically handled when they expire. This pattern is essential for
/// time-sensitive operations where stale messages could cause incorrect behavior
/// or security issues.
///
/// In EDNet/direct democracy contexts, message expiration is crucial for:
/// * Election voting periods with strict deadlines
/// * Proposal amendment windows that close automatically
/// * Authentication sessions that timeout for security
/// * Deliberation periods with time limits
/// * Emergency alerts that become stale
/// * Real-time notifications with limited validity

/// Abstract interface for message expiration
abstract class MessageExpirationHandler {
  /// Checks if a message has expired
  bool isExpired(Message message);

  /// Gets the expiration time for a message
  DateTime? getExpirationTime(Message message);

  /// Handles an expired message
  Future<void> handleExpiredMessage(Message message);

  /// Gets expiration statistics
  ExpirationStats getStats();
}

/// Strongly-typed message expiration handler for TypedMessage
abstract class TypedMessageExpirationHandler {
  /// Checks if a typed message has expired
  bool isExpired(TypedMessage message);

  /// Gets the expiration time for a typed message
  DateTime? getExpirationTime(TypedMessage message);

  /// Handles an expired typed message
  Future<void> handleExpiredMessage(TypedMessage message);

  /// Gets expiration statistics
  ExpirationStats getStats();
}

/// Expiration statistics
class ExpirationStats {
  final int totalMessages;
  final int expiredMessages;
  final int activeMessages;
  final Map<String, int> expirationsByType;
  final Duration averageTimeToExpiry;
  final DateTime lastExpirationCheck;

  ExpirationStats({
    required this.totalMessages,
    required this.expiredMessages,
    required this.activeMessages,
    required this.expirationsByType,
    required this.averageTimeToExpiry,
    DateTime? lastExpirationCheck,
  }) : lastExpirationCheck = lastExpirationCheck ?? DateTime.now();

  double get expirationRate =>
      totalMessages > 0 ? expiredMessages / totalMessages : 0.0;

  @override
  String toString() {
    return 'ExpirationStats{messages: $totalMessages, expired: $expiredMessages, '
        'active: $activeMessages, rate: ${(expirationRate * 100).round()}%}';
  }
}

/// Time-to-live (TTL) based expiration
class TtlExpirationHandler implements MessageExpirationHandler {
  final Duration _defaultTtl;
  final Map<String, Duration> _typeSpecificTtl;
  final ExpirationAction _defaultAction;
  final Map<String, ExpirationAction> _typeSpecificActions;
  final ExpirationStatsTracker _statsTracker;

  TtlExpirationHandler({
    Duration defaultTtl = const Duration(hours: 24),
    Map<String, Duration>? typeSpecificTtl,
    ExpirationAction defaultAction = ExpirationAction.discard,
    Map<String, ExpirationAction>? typeSpecificActions,
  }) : _defaultTtl = defaultTtl,
       _typeSpecificTtl = typeSpecificTtl ?? {},
       _defaultAction = defaultAction,
       _typeSpecificActions = typeSpecificActions ?? {},
       _statsTracker = ExpirationStatsTracker();

  @override
  bool isExpired(Message message) {
    _statsTracker.recordMessageCheck(message);
    final expirationTime = getExpirationTime(message);
    if (expirationTime == null) return false;

    final expired = DateTime.now().isAfter(expirationTime);
    if (expired) {
      _statsTracker.recordExpiration(message);
    }
    return expired;
  }

  @override
  DateTime? getExpirationTime(Message message) {
    try {
      // Check for explicit expiration time in metadata
      if (message.metadata.containsKey('expiresAt')) {
        final expiresAt = message.metadata['expiresAt'];
        if (expiresAt is String) {
          return DateTime.parse(expiresAt);
        } else if (expiresAt is DateTime) {
          return expiresAt;
        }
      }

      // Check for TTL in metadata
      if (message.metadata.containsKey('ttl')) {
        final ttl = message.metadata['ttl'];
        if (ttl is int) {
          return message.metadata.containsKey('createdAt')
              ? DateTime.parse(
                  message.metadata['createdAt'] as String,
                ).add(Duration(seconds: ttl))
              : DateTime.now().add(Duration(seconds: ttl));
        } else if (ttl is Duration) {
          return message.metadata.containsKey('createdAt')
              ? DateTime.parse(message.metadata['createdAt'] as String).add(ttl)
              : DateTime.now().add(ttl);
        }
      }

      // Use type-specific TTL
      final messageType = message.metadata['messageType'] as String?;
      if (messageType != null && _typeSpecificTtl.containsKey(messageType)) {
        final createdAt = message.metadata.containsKey('createdAt')
            ? DateTime.parse(message.metadata['createdAt'] as String)
            : DateTime.now();
        return createdAt.add(_typeSpecificTtl[messageType]!);
      }

      // Use default TTL
      final createdAt = message.metadata.containsKey('createdAt')
          ? DateTime.parse(message.metadata['createdAt'] as String)
          : DateTime.now();
      return createdAt.add(_defaultTtl);
    } catch (e) {
      // If date parsing fails, treat the message as non-expiring
      return null;
    }
  }

  @override
  Future<void> handleExpiredMessage(Message message) async {
    final messageType = message.metadata['messageType'] as String?;
    final action =
        messageType != null && _typeSpecificActions.containsKey(messageType)
        ? _typeSpecificActions[messageType]!
        : _defaultAction;

    switch (action) {
      case ExpirationAction.discard:
        // Message is simply discarded - no action needed
        break;
      case ExpirationAction.archive:
        await _archiveMessage(message);
        break;
      case ExpirationAction.notify:
        await _notifyExpiration(message);
        break;
      case ExpirationAction.retry:
        await _retryMessage(message);
        break;
      case ExpirationAction.deadLetter:
        await _sendToDeadLetter(message);
        break;
    }
  }

  @override
  ExpirationStats getStats() => _statsTracker.getStats();

  Future<void> _archiveMessage(Message message) async {
    // In a real implementation, this would archive to persistent storage
    // For now, just log the archival
  }

  Future<void> _notifyExpiration(Message message) async {
    // In a real implementation, this would send notifications
    // For now, just mark as notified
  }

  Future<void> _retryMessage(Message message) async {
    // In a real implementation, this would retry the message
    // For now, just mark as retried
  }

  Future<void> _sendToDeadLetter(Message message) async {
    // In a real implementation, this would send to dead letter channel
    // For now, just mark as sent to dead letter
  }
}

/// Expiration actions
enum ExpirationAction {
  discard, // Simply discard the expired message
  archive, // Archive the message for later analysis
  notify, // Notify relevant parties about expiration
  retry, // Retry the message operation
  deadLetter, // Send to dead letter channel
}

/// Statistics tracker for expiration operations
class ExpirationStatsTracker {
  int _totalMessages = 0;
  int _expiredMessages = 0;
  final List<Duration> _timeToExpiryList = [];
  final Map<String, int> _expirationsByType = {};
  DateTime? _lastExpirationCheck;

  void recordMessageCheck(Message message) {
    _totalMessages++;
    _lastExpirationCheck = DateTime.now();
  }

  void recordExpiration(Message message) {
    _expiredMessages++;
    _lastExpirationCheck = DateTime.now();

    final messageType = message.metadata['messageType'] as String? ?? 'unknown';
    _expirationsByType[messageType] =
        (_expirationsByType[messageType] ?? 0) + 1;

    // Record time to expiry if available
    try {
      final expirationTime = message.metadata['expiresAt'];
      if (expirationTime != null) {
        final expiresAt = expirationTime is String
            ? DateTime.parse(expirationTime)
            : expirationTime as DateTime;
        final timeToExpiry = expiresAt.difference(DateTime.now());
        if (timeToExpiry.isNegative) {
          _timeToExpiryList.add(timeToExpiry.abs());
        }
      }
    } catch (e) {
      // Skip time recording if date parsing fails
    }
  }

  ExpirationStats getStats() {
    final averageTimeToExpiry = _timeToExpiryList.isNotEmpty
        ? _timeToExpiryList.reduce((a, b) => a + b) ~/ _timeToExpiryList.length
        : Duration.zero;

    return ExpirationStats(
      totalMessages: _totalMessages,
      expiredMessages: _expiredMessages,
      activeMessages: _totalMessages - _expiredMessages,
      expirationsByType: Map.from(_expirationsByType),
      averageTimeToExpiry: averageTimeToExpiry,
      lastExpirationCheck: _lastExpirationCheck,
    );
  }
}

/// Strongly-typed TTL expiration handler for TypedMessage
class TypedTtlExpirationHandler implements TypedMessageExpirationHandler {
  final Duration _defaultTtl;
  final Map<String, Duration> _typeSpecificTtl;
  final ExpirationAction _defaultAction;
  final Map<String, ExpirationAction> _typeSpecificActions;
  final TypedExpirationStatsTracker _statsTracker;

  TypedTtlExpirationHandler({
    Duration defaultTtl = const Duration(hours: 24),
    Map<String, Duration>? typeSpecificTtl,
    ExpirationAction defaultAction = ExpirationAction.discard,
    Map<String, ExpirationAction>? typeSpecificActions,
  }) : _defaultTtl = defaultTtl,
       _typeSpecificTtl = typeSpecificTtl ?? {},
       _defaultAction = defaultAction,
       _typeSpecificActions = typeSpecificActions ?? {},
       _statsTracker = TypedExpirationStatsTracker();

  @override
  bool isExpired(TypedMessage message) {
    _statsTracker.recordMessageCheck(message);
    final expirationTime = getExpirationTime(message);
    if (expirationTime == null) return false;

    final expired = DateTime.now().isAfter(expirationTime);
    if (expired) {
      _statsTracker.recordExpiration(message);
    }
    return expired;
  }

  @override
  DateTime? getExpirationTime(TypedMessage message) {
    // For TypedMessage, check expiration directly from the message object
    if (message.expiration != null) {
      return message.expiration!.expiresAt;
    }

    // Use type-specific TTL
    final messageType = message.messageType;
    if (_typeSpecificTtl.containsKey(messageType)) {
      return message.createdAt.add(_typeSpecificTtl[messageType]!);
    }

    // Use default TTL
    return message.createdAt.add(_defaultTtl);
  }

  @override
  Future<void> handleExpiredMessage(TypedMessage message) async {
    final messageType = message.messageType;
    final action = _typeSpecificActions.containsKey(messageType)
        ? _typeSpecificActions[messageType]!
        : _defaultAction;

    switch (action) {
      case ExpirationAction.discard:
        // Message is simply discarded - no action needed
        break;
      case ExpirationAction.archive:
        await _archiveMessage(message);
        break;
      case ExpirationAction.notify:
        await _notifyExpiration(message);
        break;
      case ExpirationAction.retry:
        await _retryMessage(message);
        break;
      case ExpirationAction.deadLetter:
        await _sendToDeadLetter(message);
        break;
    }
  }

  @override
  ExpirationStats getStats() => _statsTracker.getStats();

  Future<void> _archiveMessage(TypedMessage message) async {
    // In a real implementation, this would archive to persistent storage
    // For now, just log the archival
  }

  Future<void> _notifyExpiration(TypedMessage message) async {
    // In a real implementation, this would send notifications
    // For now, just mark as notified
  }

  Future<void> _retryMessage(TypedMessage message) async {
    // In a real implementation, this would retry the message
    // For now, just mark as retried
  }

  Future<void> _sendToDeadLetter(TypedMessage message) async {
    // In a real implementation, this would send to dead letter channel
    // For now, just mark as sent to dead letter
  }
}

/// Strongly-typed statistics tracker for expiration operations
class TypedExpirationStatsTracker {
  int _totalMessages = 0;
  int _expiredMessages = 0;
  final List<Duration> _timeToExpiryList = [];
  final Map<String, int> _expirationsByType = {};
  DateTime? _lastExpirationCheck;

  void recordMessageCheck(TypedMessage message) {
    _totalMessages++;
    _lastExpirationCheck = DateTime.now();
  }

  void recordExpiration(TypedMessage message) {
    _expiredMessages++;
    _lastExpirationCheck = DateTime.now();

    final messageType = message.messageType;
    _expirationsByType[messageType] =
        (_expirationsByType[messageType] ?? 0) + 1;

    // Record time to expiry if available
    if (message.expiration != null) {
      final timeToExpiry = message.expiration!.expiresAt.difference(
        DateTime.now(),
      );
      if (timeToExpiry.isNegative) {
        _timeToExpiryList.add(timeToExpiry.abs());
      }
    }
  }

  ExpirationStats getStats() {
    final averageTimeToExpiry = _timeToExpiryList.isNotEmpty
        ? _timeToExpiryList.reduce((a, b) => a + b) ~/ _timeToExpiryList.length
        : Duration.zero;

    return ExpirationStats(
      totalMessages: _totalMessages,
      expiredMessages: _expiredMessages,
      activeMessages: _totalMessages - _expiredMessages,
      expirationsByType: Map.from(_expirationsByType),
      averageTimeToExpiry: averageTimeToExpiry,
      lastExpirationCheck: _lastExpirationCheck,
    );
  }
}

/// Message with built-in expiration
class ExpirableMessage extends Message {
  final Duration? ttl;
  final ExpirationAction expirationAction;

  ExpirableMessage({
    required dynamic payload,
    Map<String, dynamic>? metadata,
    this.ttl,
    this.expirationAction = ExpirationAction.discard,
    String? id,
  }) : super(
         payload: payload,
         metadata: {
           ...?metadata,
           if (ttl != null) 'ttl': ttl.inSeconds,
           'expirationAction': expirationAction.toString(),
           'createdAt': DateTime.now().toIso8601String(),
         },
         id: id,
       );

  /// Creates a message that expires at a specific time
  ExpirableMessage.expiresAt({
    required dynamic payload,
    required DateTime expiresAt,
    Map<String, dynamic>? metadata,
    ExpirationAction expirationAction = ExpirationAction.discard,
    String? id,
  }) : ttl = expiresAt.difference(DateTime.now()),
       expirationAction = expirationAction,
       super(
         payload: payload,
         metadata: {
           ...?metadata,
           'expiresAt': expiresAt.toIso8601String(),
           'expirationAction': expirationAction.toString(),
           'createdAt': DateTime.now().toIso8601String(),
         },
         id: id,
       );

  /// Checks if this message has expired
  bool get isExpired {
    final expirationTime = getExpirationTime();
    return expirationTime != null && DateTime.now().isAfter(expirationTime);
  }

  /// Gets the expiration time for this message
  DateTime? getExpirationTime() {
    try {
      if (metadata.containsKey('expiresAt')) {
        final expiresAt = metadata['expiresAt'];
        if (expiresAt is String) {
          return DateTime.parse(expiresAt);
        } else if (expiresAt is DateTime) {
          return expiresAt;
        }
      }

      if (metadata.containsKey('ttl') && metadata.containsKey('createdAt')) {
        final ttlSeconds = metadata['ttl'] as int;
        final createdAt = DateTime.parse(metadata['createdAt'] as String);
        return createdAt.add(Duration(seconds: ttlSeconds));
      }

      return null;
    } catch (e) {
      // If date parsing fails, treat the message as non-expiring
      return null;
    }
  }

  /// Gets the remaining time before expiration
  Duration? get timeUntilExpiration {
    final expirationTime = getExpirationTime();
    if (expirationTime == null) return null;

    final remaining = expirationTime.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }
}

/// Channel that automatically handles message expiration
class ExpirableMessageChannel implements Channel {
  @override
  final String id;
  @override
  final String? name;

  final Channel _delegateChannel;
  final MessageExpirationHandler _expirationHandler;
  final Timer? _cleanupTimer;

  ExpirableMessageChannel({
    required this.id,
    required Channel delegateChannel,
    required MessageExpirationHandler expirationHandler,
    Duration? cleanupInterval,
    this.name,
    MessagePatternsConfigProvider? configProvider,
  }) : _delegateChannel = delegateChannel,
       _expirationHandler = expirationHandler,
       _cleanupTimer = Timer.periodic(
         cleanupInterval ??
             DefaultMessagePatternsConfigProvider()
                 .config
                 .defaultMessageExpirationCleanupInterval,
         (_) {
           // In a real implementation, this would clean up expired messages
         },
       );

  @override
  Future<void> send(Message message) async {
    // Check if message is already expired before sending
    if (_expirationHandler.isExpired(message)) {
      await _expirationHandler.handleExpiredMessage(message);
      return;
    }

    await _delegateChannel.send(message);
  }

  @override
  Stream<Message> receive() {
    return _delegateChannel.receive().map((message) {
      // Check expiration on receive
      if (_expirationHandler.isExpired(message)) {
        _expirationHandler.handleExpiredMessage(message);
        // Return a marker message instead of the expired one
        return Message(
          payload: {'type': 'expired_message', 'originalId': message.id},
          metadata: {'messageType': 'system', 'expired': true},
        );
      }
      return message;
    });
  }

  @override
  Future<void> close() async {
    _cleanupTimer?.cancel();
    await _delegateChannel.close();
  }

  /// Gets expiration statistics
  ExpirationStats getExpirationStats() => _expirationHandler.getStats();
}

/// Expiration-aware message processor
class ExpirationAwareProcessor {
  final MessageExpirationHandler _expirationHandler;
  final Function(Message) _processFunction;
  final Function(Message)? _onExpired;

  ExpirationAwareProcessor(
    this._expirationHandler,
    this._processFunction, {
    Function(Message)? onExpired,
  }) : _onExpired = onExpired;

  /// Processes a message with expiration checking
  Future<void> processMessage(Message message) async {
    if (_expirationHandler.isExpired(message)) {
      if (_onExpired != null) {
        await _onExpired(message);
      } else {
        await _expirationHandler.handleExpiredMessage(message);
      }
      return;
    }

    await _processFunction(message);
  }

  /// Gets expiration statistics
  ExpirationStats getStats() => _expirationHandler.getStats();
}

/// Predefined expiration handlers for EDNet use cases

/// Voting session expiration handler
class VotingExpirationHandler extends TtlExpirationHandler {
  VotingExpirationHandler()
    : super(
        defaultTtl: const Duration(hours: 24), // 24 hours for general voting
        typeSpecificTtl: {
          'vote_cast': const Duration(
            hours: 12,
          ), // Votes can be cast within 12 hours
          'vote_verification': const Duration(
            minutes: 30,
          ), // Verification expires in 30 minutes
          'election_announcement': const Duration(
            days: 7,
          ), // Election announcements last 7 days
        },
        defaultAction: ExpirationAction.deadLetter,
        typeSpecificActions: {
          'vote_cast': ExpirationAction.archive,
          'vote_verification': ExpirationAction.notify,
          'election_announcement': ExpirationAction.discard,
        },
      );
}

/// Proposal expiration handler
class ProposalExpirationHandler extends TtlExpirationHandler {
  ProposalExpirationHandler()
    : super(
        defaultTtl: const Duration(days: 30), // 30 days for general proposals
        typeSpecificTtl: {
          'proposal_amendment': const Duration(
            days: 14,
          ), // Amendments expire in 14 days
          'proposal_vote': const Duration(days: 7), // Voting period is 7 days
          'proposal_discussion': const Duration(
            days: 21,
          ), // Discussion period is 21 days
        },
        defaultAction: ExpirationAction.archive,
        typeSpecificActions: {
          'proposal_vote': ExpirationAction.deadLetter,
          'proposal_amendment': ExpirationAction.notify,
          'proposal_discussion': ExpirationAction.discard,
        },
      );
}

/// Authentication expiration handler
class AuthenticationExpirationHandler extends TtlExpirationHandler {
  AuthenticationExpirationHandler()
    : super(
        defaultTtl: const Duration(hours: 8), // 8 hours for general sessions
        typeSpecificTtl: {
          'login_session': const Duration(
            hours: 8,
          ), // Login sessions last 8 hours
          'api_token': const Duration(hours: 1), // API tokens last 1 hour
          'password_reset': const Duration(
            hours: 1,
          ), // Password reset links last 1 hour
          'two_factor': const Duration(
            minutes: 10,
          ), // 2FA codes last 10 minutes
        },
        defaultAction: ExpirationAction.discard,
        typeSpecificActions: {
          'login_session': ExpirationAction.notify,
          'api_token': ExpirationAction.deadLetter,
          'password_reset': ExpirationAction.notify,
          'two_factor': ExpirationAction.discard,
        },
      );
}

/// Deliberation expiration handler
class DeliberationExpirationHandler extends TtlExpirationHandler {
  DeliberationExpirationHandler()
    : super(
        defaultTtl: const Duration(
          days: 14,
        ), // 14 days for general deliberation
        typeSpecificTtl: {
          'deliberation_topic': const Duration(days: 30), // Topics last 30 days
          'citizen_input': const Duration(
            days: 7,
          ), // Citizen inputs expire in 7 days
          'moderator_action': const Duration(
            days: 1,
          ), // Moderator actions expire in 1 day
          'poll_response': const Duration(
            hours: 24,
          ), // Poll responses last 24 hours
        },
        defaultAction: ExpirationAction.archive,
        typeSpecificActions: {
          'deliberation_topic': ExpirationAction.notify,
          'citizen_input': ExpirationAction.archive,
          'moderator_action': ExpirationAction.deadLetter,
          'poll_response': ExpirationAction.discard,
        },
      );
}

/// Emergency expiration handler
class EmergencyExpirationHandler extends TtlExpirationHandler {
  EmergencyExpirationHandler()
    : super(
        defaultTtl: const Duration(
          hours: 24,
        ), // 24 hours for emergency messages
        typeSpecificTtl: {
          'critical_alert': const Duration(
            hours: 1,
          ), // Critical alerts expire in 1 hour
          'warning_alert': const Duration(hours: 6), // Warnings last 6 hours
          'info_alert': const Duration(hours: 12), // Info alerts last 12 hours
          'system_alert': const Duration(
            hours: 2,
          ), // System alerts last 2 hours
        },
        defaultAction: ExpirationAction.archive,
        typeSpecificActions: {
          'critical_alert': ExpirationAction.notify,
          'warning_alert': ExpirationAction.notify,
          'info_alert': ExpirationAction.discard,
          'system_alert': ExpirationAction.deadLetter,
        },
      );
}

/// Notification expiration handler
class NotificationExpirationHandler extends TtlExpirationHandler {
  NotificationExpirationHandler()
    : super(
        defaultTtl: const Duration(
          hours: 24,
        ), // 24 hours for general notifications
        typeSpecificTtl: {
          'urgent_notification': const Duration(
            hours: 1,
          ), // Urgent notifications expire in 1 hour
          'reminder': const Duration(hours: 6), // Reminders last 6 hours
          'update': const Duration(days: 3), // Updates last 3 days
          'marketing': const Duration(
            days: 7,
          ), // Marketing messages last 7 days
        },
        defaultAction: ExpirationAction.discard,
        typeSpecificActions: {
          'urgent_notification': ExpirationAction.notify,
          'reminder': ExpirationAction.deadLetter,
          'update': ExpirationAction.archive,
          'marketing': ExpirationAction.discard,
        },
      );
}

/// EDNet Democracy Expiration System
class EDNetExpirationSystem {
  final Map<String, MessageExpirationHandler> _handlers = {};
  final Map<String, ExpirableMessageChannel> _channels = {};
  final ExpirationSystemStats _stats = ExpirationSystemStats();

  /// Initializes the expiration system with standard handlers
  void initialize() {
    _handlers['voting'] = VotingExpirationHandler();
    _handlers['proposals'] = ProposalExpirationHandler();
    _handlers['authentication'] = AuthenticationExpirationHandler();
    _handlers['deliberation'] = DeliberationExpirationHandler();
    _handlers['emergency'] = EmergencyExpirationHandler();
    _handlers['notifications'] = NotificationExpirationHandler();
  }

  /// Creates an expirable message channel for a specific domain
  ExpirableMessageChannel createExpirableChannel(
    String channelId,
    String domain, {
    String? name,
  }) {
    final handler = _handlers[domain] ?? TtlExpirationHandler();
    final delegateChannel = InMemoryChannel(
      id: '$channelId-delegate',
      broadcast: true,
    );

    final channel = ExpirableMessageChannel(
      id: channelId,
      delegateChannel: delegateChannel,
      expirationHandler: handler,
      name: name,
    );

    _channels[channelId] = channel;
    _stats.recordChannelCreation(channelId, domain);

    return channel;
  }

  /// Gets an existing expirable channel
  ExpirableMessageChannel? getChannel(String channelId) {
    return _channels[channelId];
  }

  /// Creates an expirable message with appropriate TTL for the domain
  ExpirableMessage createExpirableMessage(
    String domain,
    dynamic payload, {
    Map<String, dynamic>? metadata,
    Duration? customTtl,
    ExpirationAction? expirationAction,
  }) {
    final _ =
        _handlers[domain]; // handler - reserved for domain-specific expiration handling
    final ttl = customTtl ?? _getDefaultTtlForDomain(domain, payload);
    final action = expirationAction ?? _getDefaultActionForDomain(domain);

    return ExpirableMessage(
      payload: payload,
      metadata: {
        ...?metadata,
        'domain': domain,
        'createdAt': DateTime.now().toIso8601String(),
      },
      ttl: ttl,
      expirationAction: action,
    );
  }

  /// Checks if a message has expired
  bool isMessageExpired(Message message) {
    final domain = message.metadata['domain'] as String?;
    final handler = domain != null ? _handlers[domain] : null;

    return handler?.isExpired(message) ?? false;
  }

  /// Handles an expired message
  Future<void> handleExpiredMessage(Message message) async {
    final domain = message.metadata['domain'] as String?;
    final handler = domain != null ? _handlers[domain] : TtlExpirationHandler();

    if (handler != null) {
      await handler.handleExpiredMessage(message);
      _stats.recordExpiration(message, domain ?? 'unknown');
    } else {
      // Fallback: just record the expiration without handling
      _stats.recordExpiration(message, domain ?? 'unknown');
    }
  }

  /// Gets system-wide expiration statistics
  ExpirationSystemStats getSystemStats() => _stats;

  /// Cleans up expired messages across all channels
  Future<void> cleanupExpiredMessages() async {
    for (final _ in _channels.values) {
      // channel - reserved for expiration cleanup processing
      // In a real implementation, this would iterate through channel messages
      // and clean up expired ones
    }
  }

  /// Shuts down the expiration system
  Future<void> shutdown() async {
    for (final channel in _channels.values) {
      await channel.close();
    }
    _channels.clear();
  }

  Duration _getDefaultTtlForDomain(String domain, dynamic payload) {
    switch (domain) {
      case 'voting':
        return const Duration(hours: 12);
      case 'proposals':
        return const Duration(days: 30);
      case 'authentication':
        return const Duration(hours: 8);
      case 'deliberation':
        return const Duration(days: 14);
      case 'emergency':
        return const Duration(hours: 24);
      case 'notifications':
        return const Duration(hours: 24);
      default:
        return const Duration(hours: 24);
    }
  }

  ExpirationAction _getDefaultActionForDomain(String domain) {
    switch (domain) {
      case 'voting':
        return ExpirationAction.archive;
      case 'proposals':
        return ExpirationAction.archive;
      case 'authentication':
        return ExpirationAction.discard;
      case 'deliberation':
        return ExpirationAction.archive;
      case 'emergency':
        return ExpirationAction.notify;
      case 'notifications':
        return ExpirationAction.discard;
      default:
        return ExpirationAction.discard;
    }
  }
}

/// System-wide expiration statistics
class ExpirationSystemStats {
  final Map<String, int> _channelsByDomain = {};
  final Map<String, int> _expirationsByDomain = {};
  final Map<String, int> _messagesByDomain = {};
  DateTime? _lastCleanup;

  void recordChannelCreation(String channelId, String domain) {
    _channelsByDomain[domain] = (_channelsByDomain[domain] ?? 0) + 1;
  }

  void recordExpiration(Message message, String domain) {
    _expirationsByDomain[domain] = (_expirationsByDomain[domain] ?? 0) + 1;
    _messagesByDomain[domain] = (_messagesByDomain[domain] ?? 0) + 1;
  }

  Map<String, dynamic> getStats() {
    return {
      'channelsByDomain': _channelsByDomain,
      'expirationsByDomain': _expirationsByDomain,
      'messagesByDomain': _messagesByDomain,
      'lastCleanup': _lastCleanup?.toIso8601String(),
      'totalChannels': _channelsByDomain.values.fold(
        0,
        (sum, count) => sum + count,
      ),
      'totalExpirations': _expirationsByDomain.values.fold(
        0,
        (sum, count) => sum + count,
      ),
      'totalMessages': _messagesByDomain.values.fold(
        0,
        (sum, count) => sum + count,
      ),
    };
  }
}
