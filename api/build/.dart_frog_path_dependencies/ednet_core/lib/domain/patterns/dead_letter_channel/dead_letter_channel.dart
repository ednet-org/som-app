part of ednet_core;

final Logger _deadLetterLogger = Logger(
  'ednet_core.patterns.dead_letter_channel',
);

/// Dead Letter Channel Pattern
///
/// The Dead Letter Channel pattern provides a mechanism for handling messages
/// that cannot be delivered to their intended destination or processed successfully.
/// This pattern ensures that no message is lost and provides comprehensive error
/// handling and audit capabilities for failed message processing.
///
/// In EDNet/direct democracy contexts, dead letter channels are crucial for:
/// * Capturing failed vote submissions for audit and potential retry
/// * Archiving invalid proposal submissions with detailed error information
/// * Tracking routing failures in citizen notification systems
/// * Logging authentication failures for security monitoring
/// * Preserving expired messages that couldn't be processed in time
/// * Maintaining comprehensive audit trails for all failed operations

/// Abstract interface for dead letter channel
abstract class DeadLetterChannel {
  /// The channel that holds dead letter messages
  Channel get deadLetterChannel;

  /// Sends a message to the dead letter channel
  Future<void> sendToDeadLetter(
    Message message,
    DeadLetterReason reason, {
    Map<String, dynamic>? context,
  });

  /// Retrieves messages from the dead letter channel
  Stream<Message> receiveDeadLetters();

  /// Gets the count of messages in the dead letter channel
  Future<int> getDeadLetterCount();

  /// Clears all messages from the dead letter channel
  Future<void> clearDeadLetters();

  /// Replays messages from dead letter channel to a target channel
  Future<int> replayDeadLetters(
    Channel targetChannel, {
    DeadLetterFilter? filter,
  });

  /// Gets dead letter statistics
  DeadLetterStats getStats();
}

/// Reasons why a message was sent to dead letter channel
enum DeadLetterReason {
  /// Message could not be delivered to destination
  deliveryFailure,

  /// Message processing failed
  processingFailure,

  /// Message expired before processing
  expiration,

  /// Message was rejected by recipient
  rejection,

  /// Message routing failed
  routingFailure,

  /// Message validation failed
  validationFailure,

  /// System error occurred during processing
  systemError,

  /// Message exceeded retry limits
  maxRetriesExceeded,

  /// Message was quarantined for security reasons
  securityQuarantine,

  /// Unknown or unspecified reason
  unknown,
}

/// Dead letter message wrapper
class DeadLetterMessage extends Message {
  final Message originalMessage;
  final DeadLetterReason reason;
  final DateTime deadLetteredAt;
  final Map<String, dynamic> context;
  final String? errorMessage;
  final int retryCount;

  DeadLetterMessage({
    required this.originalMessage,
    required this.reason,
    required this.deadLetteredAt,
    this.context = const {},
    this.errorMessage,
    this.retryCount = 0,
  }) : super(
         payload: originalMessage.payload,
         metadata: {
           ...originalMessage.metadata,
           'deadLettered': true,
           'deadLetterReason': reason.toString(),
           'deadLetteredAt': deadLetteredAt.toIso8601String(),
           'originalMessageId': originalMessage.id,
           'retryCount': retryCount,
           if (errorMessage != null) 'errorMessage': errorMessage,
           ...context,
         },
         id: originalMessage.id,
       );

  /// Creates a dead letter message from a regular message
  factory DeadLetterMessage.fromMessage(
    Message message,
    DeadLetterReason reason, {
    Map<String, dynamic>? context,
    String? errorMessage,
    int retryCount = 0,
  }) {
    return DeadLetterMessage(
      originalMessage: message,
      reason: reason,
      deadLetteredAt: DateTime.now(),
      context: context ?? {},
      errorMessage: errorMessage,
      retryCount: retryCount,
    );
  }

  /// Gets the original message ID
  String get originalMessageId => originalMessage.id;

  /// Checks if message can be retried
  bool get canRetry => retryCount < 3; // Max 3 retries

  /// Creates a retry version of this message
  DeadLetterMessage createRetry() {
    return DeadLetterMessage(
      originalMessage: originalMessage,
      reason: reason,
      deadLetteredAt: deadLetteredAt,
      context: context,
      errorMessage: errorMessage,
      retryCount: retryCount + 1,
    );
  }
}

/// Filter for dead letter message operations
abstract class DeadLetterFilter {
  /// Determines if a dead letter message should be included
  bool shouldInclude(DeadLetterMessage message);

  /// Gets filter criteria for monitoring
  Map<String, dynamic> getFilterCriteria();
}

/// Basic dead letter filter by reason
class ReasonBasedDeadLetterFilter implements DeadLetterFilter {
  final List<DeadLetterReason> allowedReasons;

  ReasonBasedDeadLetterFilter(this.allowedReasons);

  @override
  bool shouldInclude(DeadLetterMessage message) {
    return allowedReasons.contains(message.reason);
  }

  @override
  Map<String, dynamic> getFilterCriteria() {
    return {
      'type': 'reason-based',
      'allowedReasons': allowedReasons.map((r) => r.toString()).toList(),
    };
  }
}

/// Time-based dead letter filter
class TimeBasedDeadLetterFilter implements DeadLetterFilter {
  final DateTime fromTime;
  final DateTime? toTime;

  TimeBasedDeadLetterFilter({required this.fromTime, this.toTime});

  @override
  bool shouldInclude(DeadLetterMessage message) {
    final deadLetteredAt = message.deadLetteredAt;
    if (deadLetteredAt.isBefore(fromTime)) return false;
    if (toTime != null && deadLetteredAt.isAfter(toTime!)) return false;
    return true;
  }

  @override
  Map<String, dynamic> getFilterCriteria() {
    return {
      'type': 'time-based',
      'fromTime': fromTime.toIso8601String(),
      'toTime': toTime?.toIso8601String(),
    };
  }
}

/// Composite dead letter filter
class CompositeDeadLetterFilter implements DeadLetterFilter {
  final List<DeadLetterFilter> filters;
  final bool requireAll; // true = AND, false = OR

  CompositeDeadLetterFilter({required this.filters, this.requireAll = true});

  @override
  bool shouldInclude(DeadLetterMessage message) {
    if (requireAll) {
      // All filters must match (AND)
      return filters.every((filter) => filter.shouldInclude(message));
    } else {
      // At least one filter must match (OR)
      return filters.any((filter) => filter.shouldInclude(message));
    }
  }

  @override
  Map<String, dynamic> getFilterCriteria() {
    return {
      'type': 'composite',
      'requireAll': requireAll,
      'filters': filters.map((f) => f.getFilterCriteria()).toList(),
    };
  }
}

/// Dead letter statistics
class DeadLetterStats {
  final int totalDeadLetters;
  final Map<DeadLetterReason, int> deadLettersByReason;
  final Map<String, int> deadLettersByType;
  final DateTime oldestDeadLetter;
  final DateTime newestDeadLetter;
  final int retriedMessages;
  final int successfullyReplayed;

  DeadLetterStats({
    required this.totalDeadLetters,
    required this.deadLettersByReason,
    required this.deadLettersByType,
    required this.oldestDeadLetter,
    required this.newestDeadLetter,
    required this.retriedMessages,
    required this.successfullyReplayed,
  });

  @override
  String toString() {
    return 'DeadLetterStats{total: $totalDeadLetters, retried: $retriedMessages, replayed: $successfullyReplayed}';
  }
}

/// Statistics tracker for dead letter operations
class DeadLetterStatsTracker {
  int _totalDeadLetters = 0;
  final Map<DeadLetterReason, int> _deadLettersByReason = {};
  final Map<String, int> _deadLettersByType = {};
  DateTime? _oldestDeadLetter;
  DateTime? _newestDeadLetter;
  int _retriedMessages = 0;
  int _successfullyReplayed = 0;

  void recordDeadLetter(DeadLetterMessage message) {
    _totalDeadLetters++;
    _deadLettersByReason[message.reason] =
        (_deadLettersByReason[message.reason] ?? 0) + 1;

    final messageType =
        message.originalMessage.metadata['messageType'] as String? ?? 'unknown';
    _deadLettersByType[messageType] =
        (_deadLettersByType[messageType] ?? 0) + 1;

    final deadLetteredAt = message.deadLetteredAt;
    if (_oldestDeadLetter == null ||
        deadLetteredAt.isBefore(_oldestDeadLetter!)) {
      _oldestDeadLetter = deadLetteredAt;
    }
    if (_newestDeadLetter == null ||
        deadLetteredAt.isAfter(_newestDeadLetter!)) {
      _newestDeadLetter = deadLetteredAt;
    }
  }

  void recordRetry() {
    _retriedMessages++;
  }

  void recordSuccessfulReplay() {
    _successfullyReplayed++;
  }

  DeadLetterStats getStats() {
    return DeadLetterStats(
      totalDeadLetters: _totalDeadLetters,
      deadLettersByReason: Map.from(_deadLettersByReason),
      deadLettersByType: Map.from(_deadLettersByType),
      oldestDeadLetter: _oldestDeadLetter ?? DateTime.now(),
      newestDeadLetter: _newestDeadLetter ?? DateTime.now(),
      retriedMessages: _retriedMessages,
      successfullyReplayed: _successfullyReplayed,
    );
  }
}

/// Basic dead letter channel implementation
class BasicDeadLetterChannel implements DeadLetterChannel {
  final Channel _deadLetterChannel;
  final DeadLetterStatsTracker _statsTracker = DeadLetterStatsTracker();
  final List<DeadLetterMessage> _storedMessages = [];

  BasicDeadLetterChannel(this._deadLetterChannel);

  @override
  Channel get deadLetterChannel => _deadLetterChannel;

  @override
  Future<void> sendToDeadLetter(
    Message message,
    DeadLetterReason reason, {
    Map<String, dynamic>? context,
  }) async {
    final deadLetterMessage = DeadLetterMessage.fromMessage(
      message,
      reason,
      context: context,
    );

    await _deadLetterChannel.send(deadLetterMessage);
    _storedMessages.add(deadLetterMessage);
    _statsTracker.recordDeadLetter(deadLetterMessage);
  }

  @override
  Stream<Message> receiveDeadLetters() {
    return _deadLetterChannel.receive();
  }

  @override
  Future<int> getDeadLetterCount() async {
    // In a real implementation, this would query the channel for message count
    // For now, we'll return a placeholder
    return 0;
  }

  @override
  Future<void> clearDeadLetters() async {
    // Clear stored messages
    _storedMessages.clear();
    // In a real implementation, this would also clear the dead letter channel
  }

  @override
  Future<int> replayDeadLetters(
    Channel targetChannel, {
    DeadLetterFilter? filter,
  }) async {
    int replayedCount = 0;

    // Use stored messages instead of infinite stream
    final messagesToReplay = List<DeadLetterMessage>.from(_storedMessages);

    for (final message in messagesToReplay) {
      // Apply filter if provided
      if (filter != null && !filter.shouldInclude(message)) {
        continue;
      }

      try {
        await targetChannel.send(message.originalMessage);
        replayedCount++;
        _statsTracker.recordSuccessfulReplay();
      } catch (e) {
        // Log replay failure but continue
      }
    }

    return replayedCount;
  }

  @override
  DeadLetterStats getStats() => _statsTracker.getStats();
}

/// Enhanced dead letter channel with retry capabilities
class RetryableDeadLetterChannel extends BasicDeadLetterChannel {
  final int _maxRetries;
  final Duration _retryDelay;
  final Map<String, int> _retryCounts = {};

  RetryableDeadLetterChannel(
    Channel deadLetterChannel, {
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 30),
  }) : _maxRetries = maxRetries,
       _retryDelay = retryDelay,
       super(deadLetterChannel);

  /// Attempts to retry a dead letter message
  Future<bool> retryDeadLetter(
    DeadLetterMessage deadLetterMessage,
    Channel targetChannel,
  ) async {
    final messageId = deadLetterMessage.originalMessageId;
    final trackedRetries = _retryCounts[messageId] ?? 0;
    final totalRetries = trackedRetries + deadLetterMessage.retryCount;

    if (totalRetries >= _maxRetries) {
      return false; // Max retries exceeded
    }

    // Wait before retrying
    if (totalRetries > 0) {
      await Future.delayed(_retryDelay);
    }

    try {
      await targetChannel.send(deadLetterMessage.originalMessage);
      _retryCounts[messageId] = trackedRetries + 1;
      _statsTracker.recordRetry();
      return true;
    } catch (e) {
      _retryCounts[messageId] = trackedRetries + 1;
      return false;
    }
  }

  /// Gets retry statistics for a message
  int getRetryCount(String messageId) {
    return _retryCounts[messageId] ?? 0;
  }

  /// Gets total retry count including message's original retry count
  int getTotalRetryCount(String messageId, int messageRetryCount) {
    return (_retryCounts[messageId] ?? 0) + messageRetryCount;
  }

  /// Clears retry counts for a message
  void clearRetryCount(String messageId) {
    _retryCounts.remove(messageId);
  }
}

/// Dead letter channel processor that automatically handles failures
class DeadLetterChannelProcessor {
  final DeadLetterChannel _deadLetterChannel;
  // final Map<String, Channel> _originalChannels; // Reserved for future channel restoration
  final Map<String, Function(Message)> _failureHandlers;

  DeadLetterChannelProcessor(
    this._deadLetterChannel, {
    Map<String, Function(Message)>? failureHandlers,
  }) : _failureHandlers = failureHandlers ?? {};

  /// Processes a failed message by sending it to dead letter channel
  Future<void> handleFailure(
    Message failedMessage,
    DeadLetterReason reason, {
    Map<String, dynamic>? context,
    String? errorMessage,
  }) async {
    await _deadLetterChannel.sendToDeadLetter(
      failedMessage,
      reason,
      context: context,
    );

    // Execute failure handler if available
    final messageType = failedMessage.metadata['messageType'] as String?;
    if (messageType != null && _failureHandlers.containsKey(messageType)) {
      try {
        await _failureHandlers[messageType]!(failedMessage);
      } catch (e) {
        // Log failure handler error but don't re-throw
      }
    }
  }

  /// Attempts to recover messages from dead letter channel
  Future<int> recoverMessages(
    Channel recoveryChannel, {
    DeadLetterFilter? filter,
  }) async {
    return _deadLetterChannel.replayDeadLetters(
      recoveryChannel,
      filter: filter,
    );
  }

  /// Monitors dead letter channel for specific conditions
  Future<void> monitorDeadLetters({
    Duration checkInterval = const Duration(minutes: 5),
    DeadLetterFilter? alertFilter,
    Function(List<DeadLetterMessage>)? alertHandler,
  }) async {
    while (true) {
      await Future.delayed(checkInterval);

      if (alertFilter != null && alertHandler != null) {
        final deadLetters = <DeadLetterMessage>[];

        await for (final message in _deadLetterChannel.receiveDeadLetters()) {
          if (message is DeadLetterMessage &&
              alertFilter.shouldInclude(message)) {
            deadLetters.add(message);
          }
        }

        if (deadLetters.isNotEmpty) {
          alertHandler(deadLetters);
        }
      }
    }
  }
}

/// Predefined dead letter channels for EDNet use cases

/// Voting dead letter channel
class VotingDeadLetterChannel extends BasicDeadLetterChannel {
  VotingDeadLetterChannel(Channel deadLetterChannel) : super(deadLetterChannel);

  /// Handles failed vote processing
  Future<void> handleFailedVote(
    Message voteMessage,
    String errorMessage, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      voteMessage,
      DeadLetterReason.processingFailure,
      context: {
        ...?context,
        'voteValidationError': errorMessage,
        'requiresAudit': true,
        'citizenId': voteMessage.metadata['citizenId'],
        'electionId': voteMessage.metadata['electionId'],
      },
    );
  }

  /// Handles vote delivery failures
  Future<void> handleVoteDeliveryFailure(
    Message voteMessage, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      voteMessage,
      DeadLetterReason.deliveryFailure,
      context: {...?context, 'deliveryAttempted': true, 'requiresRetry': true},
    );
  }
}

/// Proposal dead letter channel
class ProposalDeadLetterChannel extends BasicDeadLetterChannel {
  ProposalDeadLetterChannel(Channel deadLetterChannel)
    : super(deadLetterChannel);

  /// Handles invalid proposal submissions
  Future<void> handleInvalidProposal(
    Message proposalMessage,
    List<String> validationErrors, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      proposalMessage,
      DeadLetterReason.validationFailure,
      context: {
        ...?context,
        'validationErrors': validationErrors,
        'proposalId': proposalMessage.metadata['proposalId'],
        'authorId': proposalMessage.metadata['authorId'],
        'requiresReview': true,
      },
    );
  }

  /// Handles proposal routing failures
  Future<void> handleProposalRoutingFailure(
    Message proposalMessage, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      proposalMessage,
      DeadLetterReason.routingFailure,
      context: {
        ...?context,
        'routingAttempted': true,
        'targetChannels': proposalMessage.metadata['targetChannels'],
      },
    );
  }
}

/// Authentication dead letter channel
class AuthenticationDeadLetterChannel extends BasicDeadLetterChannel {
  AuthenticationDeadLetterChannel(Channel deadLetterChannel)
    : super(deadLetterChannel);

  /// Handles authentication failures
  Future<void> handleAuthenticationFailure(
    Message authMessage,
    String failureReason, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      authMessage,
      DeadLetterReason.processingFailure,
      context: {
        ...?context,
        'authFailureReason': failureReason,
        'citizenId': authMessage.metadata['citizenId'],
        'requiresSecurityReview': true,
        'ipAddress': authMessage.metadata['ipAddress'],
        'userAgent': authMessage.metadata['userAgent'],
      },
    );
  }

  /// Handles security quarantine events
  Future<void> handleSecurityQuarantine(
    Message message,
    String quarantineReason, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      message,
      DeadLetterReason.securityQuarantine,
      context: {
        ...?context,
        'quarantineReason': quarantineReason,
        'quarantinedAt': DateTime.now().toIso8601String(),
        'requiresSecurityReview': true,
      },
    );
  }
}

/// System dead letter channel for general system errors
class SystemDeadLetterChannel extends RetryableDeadLetterChannel {
  SystemDeadLetterChannel(Channel deadLetterChannel, {int maxRetries = 3})
    : super(deadLetterChannel, maxRetries: maxRetries);

  /// Handles system processing errors
  Future<void> handleSystemError(
    Message message,
    String errorMessage,
    StackTrace stackTrace, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      message,
      DeadLetterReason.systemError,
      context: {
        ...?context,
        'systemError': errorMessage,
        'stackTrace': stackTrace.toString(),
        'systemVersion': context?['systemVersion'],
        'requiresDeveloperAttention': true,
      },
    );
  }

  /// Handles expired messages
  Future<void> handleExpiredMessage(
    Message expiredMessage, {
    Map<String, dynamic>? context,
  }) async {
    await sendToDeadLetter(
      expiredMessage,
      DeadLetterReason.expiration,
      context: {
        ...?context,
        'expiredAt': DateTime.now().toIso8601String(),
        'originalExpiry': expiredMessage.metadata['expiresAt'],
      },
    );
  }

  /// Attempts to recover system errors
  Future<bool> attemptRecovery(
    DeadLetterMessage deadLetterMessage,
    Channel recoveryChannel,
  ) async {
    // Check if this is a recoverable error
    final errorMessage = deadLetterMessage.errorMessage;
    if (errorMessage != null &&
        (errorMessage.contains('timeout') ||
            errorMessage.contains('temporary'))) {
      return retryDeadLetter(deadLetterMessage, recoveryChannel);
    }
    return false;
  }
}

/// EDNet Democracy Dead Letter System
class EDNetDeadLetterSystem {
  final Map<String, DeadLetterChannel> _domainChannels = {};
  final DeadLetterChannelProcessor _processor;
  final Map<String, Function(Message)> _failureHandlers = {};

  EDNetDeadLetterSystem()
    : _processor = DeadLetterChannelProcessor(
        BasicDeadLetterChannel(
          InMemoryChannel(id: 'system-dead-letter', broadcast: true),
        ),
      ) {
    _initializeDomainChannels();
    _initializeFailureHandlers();
  }

  void _initializeDomainChannels() {
    _domainChannels['voting'] = VotingDeadLetterChannel(
      InMemoryChannel(id: 'voting-dead-letter', broadcast: true),
    );
    _domainChannels['proposals'] = ProposalDeadLetterChannel(
      InMemoryChannel(id: 'proposal-dead-letter', broadcast: true),
    );
    _domainChannels['authentication'] = AuthenticationDeadLetterChannel(
      InMemoryChannel(id: 'auth-dead-letter', broadcast: true),
    );
    _domainChannels['system'] = SystemDeadLetterChannel(
      InMemoryChannel(id: 'system-dead-letter', broadcast: true),
    );
  }

  void _initializeFailureHandlers() {
    _failureHandlers['vote_failed'] = (Message message) async {
      // Log vote failure for audit
      _deadLetterLogger.info('Vote failure logged: ${message.id}');
    };

    _failureHandlers['proposal_rejected'] = (Message message) async {
      // Notify proposal author
      _deadLetterLogger.info(
        'Proposal rejection notification sent for: ${message.id}',
      );
    };

    _failureHandlers['auth_failure'] = (Message message) async {
      // Security alert for authentication failure
      _deadLetterLogger.warning(
        'Security alert: Authentication failure for: ${message.id}',
      );
    };
  }

  /// Handles a failed message in the appropriate domain channel
  Future<void> handleFailure(
    Message failedMessage,
    DeadLetterReason reason, {
    Map<String, dynamic>? context,
    String? errorMessage,
  }) async {
    final domain = failedMessage.metadata['domain'] as String? ?? 'system';
    final channel = _domainChannels[domain] ?? _domainChannels['system']!;

    await channel.sendToDeadLetter(failedMessage, reason, context: context);

    // Execute domain-specific failure handler
    final messageType = failedMessage.metadata['messageType'] as String?;
    if (messageType != null && _failureHandlers.containsKey(messageType)) {
      try {
        await _failureHandlers[messageType]!(failedMessage);
      } catch (e) {
        // Log failure handler error
      }
    }
  }

  /// Handles a failed vote
  Future<void> handleFailedVote(
    Message voteMessage,
    String errorMessage, {
    Map<String, dynamic>? context,
  }) async {
    final votingChannel = _domainChannels['voting'] as VotingDeadLetterChannel;
    await votingChannel.handleFailedVote(
      voteMessage,
      errorMessage,
      context: context,
    );
  }

  /// Handles vote delivery failure
  Future<void> handleVoteDeliveryFailure(
    Message voteMessage, {
    Map<String, dynamic>? context,
  }) async {
    final votingChannel = _domainChannels['voting'] as VotingDeadLetterChannel;
    await votingChannel.handleVoteDeliveryFailure(
      voteMessage,
      context: context,
    );
  }

  /// Handles invalid proposal
  Future<void> handleInvalidProposal(
    Message proposalMessage,
    List<String> validationErrors, {
    Map<String, dynamic>? context,
  }) async {
    final proposalChannel =
        _domainChannels['proposals'] as ProposalDeadLetterChannel;
    await proposalChannel.handleInvalidProposal(
      proposalMessage,
      validationErrors,
      context: context,
    );
  }

  /// Handles authentication failure
  Future<void> handleAuthenticationFailure(
    Message authMessage,
    String failureReason, {
    Map<String, dynamic>? context,
  }) async {
    final authChannel =
        _domainChannels['authentication'] as AuthenticationDeadLetterChannel;
    await authChannel.handleAuthenticationFailure(
      authMessage,
      failureReason,
      context: context,
    );
  }

  /// Handles system error
  Future<void> handleSystemError(
    Message message,
    String errorMessage,
    StackTrace stackTrace, {
    Map<String, dynamic>? context,
  }) async {
    final systemChannel = _domainChannels['system'] as SystemDeadLetterChannel;
    await systemChannel.handleSystemError(
      message,
      errorMessage,
      stackTrace,
      context: context,
    );
  }

  /// Attempts to recover messages from dead letter channels
  Future<int> recoverMessages(
    String domain,
    Channel recoveryChannel, {
    DeadLetterFilter? filter,
  }) async {
    final channel = _domainChannels[domain];
    if (channel == null) {
      throw ArgumentError('Unknown domain: $domain');
    }

    return channel.replayDeadLetters(recoveryChannel, filter: filter);
  }

  /// Gets statistics for all domain channels
  Map<String, DeadLetterStats> getDomainStats() {
    final stats = <String, DeadLetterStats>{};
    for (final entry in _domainChannels.entries) {
      stats[entry.key] = entry.value.getStats();
    }
    return stats;
  }

  /// Gets a specific domain channel
  DeadLetterChannel? getDomainChannel(String domain) {
    return _domainChannels[domain];
  }

  /// Clears all dead letter channels
  Future<void> clearAllDeadLetters() async {
    for (final channel in _domainChannels.values) {
      await channel.clearDeadLetters();
    }
  }

  /// Starts monitoring all dead letter channels
  Future<void> startMonitoring({
    Duration checkInterval = const Duration(minutes: 5),
    Function(String, List<DeadLetterMessage>)? alertHandler,
  }) async {
    if (alertHandler == null) return;

    for (final entry in _domainChannels.entries) {
      final domain = entry.key;
      final _ = entry
          .value; // channel - reserved for domain-specific dead letter processing

      // Start monitoring for each domain
      unawaited(
        _processor.monitorDeadLetters(
          checkInterval: checkInterval,
          alertFilter: ReasonBasedDeadLetterFilter([
            DeadLetterReason.systemError,
            DeadLetterReason.securityQuarantine,
            DeadLetterReason.maxRetriesExceeded,
          ]),
          alertHandler: (deadLetters) {
            alertHandler(domain, deadLetters);
          },
        ),
      );
    }
  }
}
