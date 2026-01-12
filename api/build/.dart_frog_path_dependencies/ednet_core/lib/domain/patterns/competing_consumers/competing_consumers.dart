part of ednet_core;

final Logger _competingConsumersLogger = Logger(
  'ednet_core.patterns.competing_consumers',
);

/// IMPORTANT: This is a part file of ednet_core library.
/// Do NOT analyze this file directly with `dart analyze competing_consumers.dart`
/// as it will show "Undefined class" errors for Channel, Message, etc.
///
/// Always analyze through the library:
/// - dart analyze lib/
/// - dart analyze lib/ednet_core.dart
///
/// Classes like Channel, Message, TypedMessage are defined in other parts
/// of the ednet_core library and are accessible when analyzed properly.

/// Competing Consumers Pattern
///
/// The Competing Consumers pattern enables multiple consumers to process messages
/// from the same channel concurrently, providing load balancing and horizontal
/// scalability for message processing systems.
///
/// In EDNet/direct democracy contexts, competing consumers are crucial for:
/// * Parallel processing of citizen votes across distributed voting centers
/// * Concurrent deliberation of multiple topics by different citizen groups
/// * Load-balanced processing of proposal reviews and amendments
/// * Distributed analysis of citizen engagement metrics and feedback
/// * Parallel audit trail processing and compliance checking
/// * Concurrent notification delivery to citizens across different regions

/// Abstract interface for message consumers
abstract class MessageConsumer {
  /// The unique identifier for this consumer
  String get consumerId;

  /// The channel this consumer is listening to
  Channel get channel;

  /// Processes a message
  Future<MessageProcessingResult> processMessage(Message message);

  /// Checks if this consumer can handle the given message type
  bool canHandle(Message message);

  /// Gets consumer statistics
  ConsumerStats getStats();

  /// Starts the consumer
  Future<void> start();

  /// Stops the consumer
  Future<void> stop();

  /// Checks if the consumer is currently active
  bool get isActive;
}

/// Strongly-typed message consumer interface for TypedMessage
abstract class TypedMessageConsumer {
  /// The unique identifier for this consumer
  String get consumerId;

  /// The channel this consumer is listening to
  Channel get channel;

  /// Processes a typed message
  Future<TypedMessageProcessingResult> processMessage(TypedMessage message);

  /// Checks if this consumer can handle the given message type
  bool canHandle(TypedMessage message);

  /// Gets consumer statistics
  ConsumerStats getStats();

  /// Starts the consumer
  Future<void> start();

  /// Stops the consumer
  Future<void> stop();

  /// Checks if the consumer is currently active
  bool get isActive;
}

/// Result of message processing
class MessageProcessingResult {
  final Message originalMessage;
  final bool success;
  final dynamic result;
  final Duration processingTime;
  final String? errorMessage;
  final DateTime processedAt;

  MessageProcessingResult({
    required this.originalMessage,
    required this.success,
    this.result,
    required this.processingTime,
    this.errorMessage,
    DateTime? processedAt,
  }) : processedAt = processedAt ?? DateTime.now();

  @override
  String toString() {
    return 'MessageProcessingResult{success: $success, time: $processingTime, error: $errorMessage}';
  }
}

/// Result of typed message processing
class TypedMessageProcessingResult {
  final TypedMessage originalMessage;
  final bool success;
  final dynamic result;
  final Duration processingTime;
  final String? errorMessage;
  final DateTime processedAt;

  TypedMessageProcessingResult({
    required this.originalMessage,
    required this.success,
    this.result,
    required this.processingTime,
    this.errorMessage,
    DateTime? processedAt,
  }) : processedAt = processedAt ?? DateTime.now();

  @override
  String toString() {
    return 'TypedMessageProcessingResult{success: $success, time: $processingTime, error: $errorMessage}';
  }
}

/// Consumer statistics
class ConsumerStats {
  final String consumerId;
  final int messagesProcessed;
  final int messagesSucceeded;
  final int messagesFailed;
  final Duration totalProcessingTime;
  final Duration averageProcessingTime;
  final DateTime lastActivity;
  final Map<String, int> messageTypesProcessed;

  ConsumerStats({
    required this.consumerId,
    required this.messagesProcessed,
    required this.messagesSucceeded,
    required this.messagesFailed,
    required this.totalProcessingTime,
    required this.averageProcessingTime,
    DateTime? lastActivity,
    required this.messageTypesProcessed,
  }) : lastActivity = lastActivity ?? DateTime.now();

  double get successRate =>
      messagesProcessed > 0 ? messagesSucceeded / messagesProcessed : 0.0;
}

/// Competing consumers coordinator
class CompetingConsumersCoordinator {
  final Channel _sourceChannel;
  final List<MessageConsumer> _consumers;
  final ConsumerSelectionStrategy _selectionStrategy;
  final MessagePatternsConfigProvider _configProvider;

  final Map<String, StreamSubscription<Message>> _subscriptions = {};
  final Map<String, ConsumerStats> _consumerStats = {};
  StreamSubscription<Message>? _messageSubscription;
  bool _isRunning = false;
  int _nextConsumerIndex = 0;
  final Random _random = Random();

  // Track in-flight messages to prevent race conditions
  final Set<String> _processingMessages = <String>{};

  bool _lifecycleOperationInProgress = false;

  // Backpressure management
  static const int _maxConcurrentMessages = 100;
  int _currentConcurrentMessages = 0;
  final _backpressureCompleter = <Completer<void>>[];

  CompetingConsumersCoordinator(
    this._sourceChannel,
    this._consumers, {
    Duration? consumerTimeout,
    ConsumerSelectionStrategy selectionStrategy =
        ConsumerSelectionStrategy.roundRobin,
    MessagePatternsConfigProvider? configProvider,
  }) : _configProvider =
           configProvider ?? DefaultMessagePatternsConfigProvider(),
       _selectionStrategy = selectionStrategy;

  /// Starts the competing consumers
  Future<void> start() async {
    return await _synchronizedLifecycleOperation(() async {
      if (_isRunning) return;

      _isRunning = true;

      // Initialize consumer stats
      for (final consumer in _consumers) {
        _consumerStats[consumer.consumerId] = ConsumerStats(
          consumerId: consumer.consumerId,
          messagesProcessed: 0,
          messagesSucceeded: 0,
          messagesFailed: 0,
          totalProcessingTime: Duration.zero,
          averageProcessingTime: Duration.zero,
          messageTypesProcessed: {},
        );
      }

      // Start all consumers with error handling
      for (final consumer in _consumers) {
        try {
          await consumer.start();
        } catch (e) {
          // Log error but continue with other consumers
          _competingConsumersLogger.warning(
            'Error starting consumer ${consumer.consumerId}: $e',
          );
        }
      }

      // Set up single listener that distributes messages to consumers with backpressure
      _messageSubscription = _sourceChannel.receive().listen(
        (message) async {
          try {
            await _distributeMessageToConsumerWithBackpressure(message);
          } catch (e) {
            // Handle distribution errors gracefully
            _competingConsumersLogger.warning('Error distributing message: $e');
          }
        },
        onError: (error) {
          // Handle stream errors gracefully using config provider
          final config = _configProvider.config;
          _competingConsumersLogger.warning(
            'Stream error in competing consumers: $error',
          );

          // Attempt to recover by restarting if still running
          if (_isRunning) {
            final retryDelay = config.retryDelay;
            Future.delayed(retryDelay, () {
              if (_isRunning) {
                _attemptStreamRecovery();
              }
            });
          }
        },
        onDone: () {
          // Handle stream completion
          stop();
        },
      );
    });
  }

  /// Stops all consumers
  Future<void> stop() async {
    return await _synchronizedLifecycleOperation(() async {
      if (!_isRunning) return;

      _isRunning = false;

      // Stop message subscription
      await _messageSubscription?.cancel();
      _messageSubscription = null;

      // Stop all subscriptions
      for (final subscription in _subscriptions.values) {
        try {
          await subscription.cancel();
        } catch (e) {
          // Log error but continue cleanup
          _competingConsumersLogger.warning('Error stopping subscription: $e');
        }
      }
      _subscriptions.clear();

      // Stop all consumers with error handling
      for (final consumer in _consumers) {
        if (consumer.isActive) {
          try {
            await consumer.stop();
          } catch (e) {
            // Log error but continue cleanup
            _competingConsumersLogger.warning(
              'Error stopping consumer ${consumer.consumerId}: $e',
            );
          }
        }
      }

      // Clear processing state
      _processingMessages.clear();
    });
  }

  /// Adds a new consumer dynamically
  Future<void> addConsumer(MessageConsumer consumer) async {
    return await _synchronizedLifecycleOperation(() async {
      if (_consumers.contains(consumer)) return;

      _consumers.add(consumer);
      _consumerStats[consumer.consumerId] = ConsumerStats(
        consumerId: consumer.consumerId,
        messagesProcessed: 0,
        messagesSucceeded: 0,
        messagesFailed: 0,
        totalProcessingTime: Duration.zero,
        averageProcessingTime: Duration.zero,
        messageTypesProcessed: {},
      );

      if (_isRunning) {
        await consumer.start();
      }
    });
  }

  /// Removes a consumer
  Future<void> removeConsumer(String consumerId) async {
    return await _synchronizedLifecycleOperation(() async {
      final consumer = _consumers.firstWhere(
        (c) => c.consumerId == consumerId,
        orElse: () => throw ArgumentError('Consumer not found: $consumerId'),
      );

      if (consumer.isActive) {
        await consumer.stop();
      }

      _consumers.remove(consumer);
      _consumerStats.remove(consumerId);

      // Cancel subscription if exists
      final subscription = _subscriptions.remove(consumerId);
      if (subscription != null) {
        await subscription.cancel();
      }

      // Consumer removal is handled by the single listener distribution
    });
  }

  /// Synchronize lifecycle operations to prevent race conditions
  Future<T> _synchronizedLifecycleOperation<T>(
    Future<T> Function() operation,
  ) async {
    // Wait for any ongoing lifecycle operation to complete
    while (_lifecycleOperationInProgress) {
      await Future.delayed(const Duration(milliseconds: 1));
    }

    _lifecycleOperationInProgress = true;
    try {
      return await operation();
    } finally {
      _lifecycleOperationInProgress = false;
    }
  }

  /// Gets overall statistics
  Map<String, dynamic> getOverallStats() {
    int totalProcessed = 0;
    int totalSucceeded = 0;
    int totalFailed = 0;
    Duration totalProcessingTime = Duration.zero;
    final messageTypes = <String, int>{};

    for (final stats in _consumerStats.values) {
      totalProcessed += stats.messagesProcessed;
      totalSucceeded += stats.messagesSucceeded;
      totalFailed += stats.messagesFailed;
      totalProcessingTime += stats.totalProcessingTime;

      stats.messageTypesProcessed.forEach((type, count) {
        messageTypes[type] = (messageTypes[type] ?? 0) + count;
      });
    }

    return {
      'totalConsumers': _consumers.length,
      'activeConsumers': _subscriptions.length,
      'totalMessagesProcessed': totalProcessed,
      'totalMessagesSucceeded': totalSucceeded,
      'totalMessagesFailed': totalFailed,
      'overallSuccessRate': totalProcessed > 0
          ? totalSucceeded / totalProcessed
          : 0.0,
      'averageProcessingTime': totalProcessed > 0
          ? totalProcessingTime ~/ totalProcessed
          : Duration.zero,
      'messageTypesProcessed': messageTypes,
      'consumerStats': _consumerStats.map(
        (id, stats) => MapEntry(id, {
          'messagesProcessed': stats.messagesProcessed,
          'successRate': stats.successRate,
          'averageProcessingTime': stats.averageProcessingTime,
          'lastActivity': stats.lastActivity,
        }),
      ),
    };
  }

  Future<void> _distributeMessageToConsumer(Message message) async {
    // Use message ID for deduplication (message.id is always non-null)
    final messageId = message.id;

    // Critical: Use synchronized access to prevent race conditions
    return await _synchronizedDistribution(message, messageId);
  }

  /// Distribution with backpressure management
  Future<void> _distributeMessageToConsumerWithBackpressure(
    Message message,
  ) async {
    // Wait for available slot if at capacity
    while (_currentConcurrentMessages >= _maxConcurrentMessages) {
      final completer = Completer<void>();
      _backpressureCompleter.add(completer);
      await completer.future;
    }

    _currentConcurrentMessages++;

    try {
      await _distributeMessageToConsumer(message);
    } finally {
      _currentConcurrentMessages--;

      // Release next waiting message if any
      if (_backpressureCompleter.isNotEmpty) {
        final nextCompleter = _backpressureCompleter.removeAt(0);
        nextCompleter.complete();
      }
    }
  }

  /// Attempts to recover from stream errors
  Future<void> _attemptStreamRecovery() async {
    try {
      // Cancel existing subscription if it exists
      await _messageSubscription?.cancel();
      _messageSubscription = null;

      // Wait a bit before reconnecting
      await Future.delayed(const Duration(milliseconds: 500));

      // If still running, recreate the subscription
      if (_isRunning) {
        _messageSubscription = _sourceChannel.receive().listen(
          (message) async {
            try {
              await _distributeMessageToConsumerWithBackpressure(message);
            } catch (e) {
              _competingConsumersLogger.warning(
                'Error distributing message during recovery: $e',
              );
            }
          },
          onError: (error) {
            _competingConsumersLogger.warning(
              'Stream error during recovery: $error',
            );
            // Try to recover again if still running
            if (_isRunning) {
              Future.delayed(const Duration(seconds: 2), () {
                if (_isRunning) {
                  _attemptStreamRecovery();
                }
              });
            }
          },
          onDone: () {
            stop();
          },
        );
      }
    } catch (e) {
      _competingConsumersLogger.warning('Failed to recover stream: $e');
    }
  }

  Future<void> _synchronizedDistribution(
    Message message,
    String messageId,
  ) async {
    // Atomic check and assignment using Dart's event loop guarantees
    final shouldProcess = await _atomicMessageCheck(messageId);
    if (!shouldProcess) {
      return; // Message already being processed
    }

    try {
      final availableConsumers = _consumers
          .where((consumer) => consumer.isActive && consumer.canHandle(message))
          .toList();

      if (availableConsumers.isEmpty) {
        // No consumer can handle this message - remove from processing set
        _processingMessages.remove(messageId);
        return;
      }

      // Select consumer based on strategy (this needs to be atomic too)
      final selectedConsumer = _selectConsumer(availableConsumers);

      if (selectedConsumer != null) {
        await _processMessageWithConsumer(message, selectedConsumer);
      }
    } finally {
      // Always remove from processing set when done
      _processingMessages.remove(messageId);
    }
  }

  Future<bool> _atomicMessageCheck(String messageId) async {
    return await Future(() {
      // Dart's event loop provides single-threaded execution guarantee
      // But we need to protect against async race conditions
      if (_processingMessages.contains(messageId)) {
        return false; // Already processing
      }
      _processingMessages.add(messageId);
      return true; // OK to process
    });
  }

  MessageConsumer? _selectConsumer(List<MessageConsumer> availableConsumers) {
    switch (_selectionStrategy) {
      case ConsumerSelectionStrategy.roundRobin:
        if (availableConsumers.isEmpty) return null;

        // Atomic increment for round-robin to prevent race conditions
        final currentIndex = _nextConsumerIndex;
        _nextConsumerIndex = (currentIndex + 1) % availableConsumers.length;

        return availableConsumers[currentIndex % availableConsumers.length];

      case ConsumerSelectionStrategy.random:
        if (availableConsumers.isEmpty) return null;
        return availableConsumers[_random.nextInt(availableConsumers.length)];

      case ConsumerSelectionStrategy.leastBusy:
        // Select consumer with least messages processed
        MessageConsumer? leastLoaded;
        int minMessages = -1;

        // Snapshot stats to avoid race conditions during iteration
        final statsSnapshot = Map<String, ConsumerStats>.from(_consumerStats);

        for (final consumer in availableConsumers) {
          final stats = statsSnapshot[consumer.consumerId];
          final messages = stats?.messagesProcessed ?? 0;
          if (minMessages == -1 || messages < minMessages) {
            minMessages = messages;
            leastLoaded = consumer;
          }
        }
        return leastLoaded;

      default:
        return availableConsumers.first;
    }
  }

  Future<void> _processMessageWithConsumer(
    Message message,
    MessageConsumer consumer,
  ) async {
    if (!consumer.canHandle(message)) return;

    final startTime = DateTime.now();
    MessageProcessingResult result;

    try {
      // Use config provider for timeout configuration
      final config = _configProvider.config;
      final effectiveTimeout = config.defaultConsumerTimeout;

      result = await consumer.processMessage(message).timeout(effectiveTimeout);
    } on TimeoutException catch (e) {
      result = MessageProcessingResult(
        originalMessage: message,
        success: false,
        result: null,
        processingTime: DateTime.now().difference(startTime),
        errorMessage: 'Consumer timeout: ${e.toString()}',
      );

      // Log timeout for monitoring
      _competingConsumersLogger.warning(
        'Consumer ${consumer.consumerId} timed out processing message: ${message.id}',
      );
    } catch (e, stackTrace) {
      result = MessageProcessingResult(
        originalMessage: message,
        success: false,
        result: null,
        processingTime: DateTime.now().difference(startTime),
        errorMessage: e.toString(),
      );

      // Log detailed error for debugging
      _competingConsumersLogger.severe(
        'Consumer ${consumer.consumerId} failed to process message: $e',
        e,
        stackTrace,
      );
    }

    // Update consumer statistics atomically
    try {
      _updateConsumerStats(consumer.consumerId, result, message);
    } catch (e) {
      _competingConsumersLogger.warning(
        'Error updating consumer stats for ${consumer.consumerId}: $e',
      );
    }
  }

  /// Atomically update consumer statistics
  void _updateConsumerStats(
    String consumerId,
    MessageProcessingResult result,
    Message message,
  ) {
    final currentStats = _consumerStats[consumerId];
    if (currentStats == null) {
      // Consumer was removed during processing
      _competingConsumersLogger.warning(
        'Consumer $consumerId not found in stats during update',
      );
      return;
    }

    final newMessagesProcessed = currentStats.messagesProcessed + 1;
    final newMessagesSucceeded =
        currentStats.messagesSucceeded + (result.success ? 1 : 0);
    final newMessagesFailed =
        currentStats.messagesFailed + (result.success ? 0 : 1);
    final newTotalProcessingTime =
        currentStats.totalProcessingTime + result.processingTime;
    final newAverageProcessingTime =
        newTotalProcessingTime ~/ newMessagesProcessed;

    final newMessageTypesProcessed = Map<String, int>.from(
      currentStats.messageTypesProcessed,
    );
    final messageType = _getMessageType(message);
    newMessageTypesProcessed[messageType] =
        (newMessageTypesProcessed[messageType] ?? 0) + 1;

    _consumerStats[consumerId] = ConsumerStats(
      consumerId: consumerId,
      messagesProcessed: newMessagesProcessed,
      messagesSucceeded: newMessagesSucceeded,
      messagesFailed: newMessagesFailed,
      totalProcessingTime: newTotalProcessingTime,
      averageProcessingTime: newAverageProcessingTime,
      messageTypesProcessed: newMessageTypesProcessed,
    );
  }

  String _getMessageType(Message message) {
    if (message.metadata.containsKey('messageType')) {
      return message.metadata['messageType'] as String;
    }
    return message.payload.runtimeType.toString();
  }
}

/// Consumer selection strategies
enum ConsumerSelectionStrategy { roundRobin, leastBusy, random, priorityBased }

/// Abstract base consumer implementation
abstract class BaseMessageConsumer implements MessageConsumer {
  @override
  final String consumerId;
  @override
  final Channel channel;

  StreamSubscription<Message>? _subscription;
  bool _isActive = false;

  final ConsumerStatsTracker _statsTracker;

  BaseMessageConsumer({required this.consumerId, required this.channel})
    : _statsTracker = ConsumerStatsTracker(consumerId);

  @override
  Future<void> start() async {
    if (_isActive) return;

    _isActive = true;
    _statsTracker.markStarted();
  }

  @override
  Future<void> stop() async {
    if (!_isActive) return;

    _isActive = false;
    await _subscription?.cancel();
    _subscription = null;
    _statsTracker.markStopped();
  }

  @override
  bool get isActive => _isActive;

  @override
  ConsumerStats getStats() => _statsTracker.getStats();

  /// Processes a message and records statistics
  @override
  Future<MessageProcessingResult> processMessage(Message message) async {
    final result = await doProcessMessage(message);
    _statsTracker.recordProcessing(result);
    return result;
  }

  /// Actual message processing implementation - to be implemented by subclasses
  Future<MessageProcessingResult> doProcessMessage(Message message);
}

/// Statistics tracker for individual consumers
class ConsumerStatsTracker {
  final String consumerId;
  int _messagesProcessed = 0;
  int _messagesSucceeded = 0;
  int _messagesFailed = 0;
  Duration _totalProcessingTime = Duration.zero;
  DateTime? _lastActivity;
  final Map<String, int> _messageTypesProcessed = {};

  ConsumerStatsTracker(this.consumerId);

  void markStarted() {
    _lastActivity = DateTime.now();
  }

  void markStopped() {
    _lastActivity = DateTime.now();
  }

  void recordProcessing(MessageProcessingResult result) {
    _messagesProcessed++;
    if (result.success) {
      _messagesSucceeded++;
    } else {
      _messagesFailed++;
    }

    _totalProcessingTime += result.processingTime;
    _lastActivity = result.processedAt;

    final messageType = _getMessageType(result.originalMessage);
    _messageTypesProcessed[messageType] =
        (_messageTypesProcessed[messageType] ?? 0) + 1;
  }

  ConsumerStats getStats() {
    final averageProcessingTime = _messagesProcessed > 0
        ? _totalProcessingTime ~/ _messagesProcessed
        : Duration.zero;

    return ConsumerStats(
      consumerId: consumerId,
      messagesProcessed: _messagesProcessed,
      messagesSucceeded: _messagesSucceeded,
      messagesFailed: _messagesFailed,
      totalProcessingTime: _totalProcessingTime,
      averageProcessingTime: averageProcessingTime,
      lastActivity: _lastActivity,
      messageTypesProcessed: Map.from(_messageTypesProcessed),
    );
  }

  String _getMessageType(Message message) {
    if (message.metadata.containsKey('messageType')) {
      return message.metadata['messageType'] as String;
    }
    return message.payload.runtimeType.toString();
  }
}

/// Predefined consumers for EDNet use cases

/// Vote processing consumer
class VoteProcessingConsumer extends BaseMessageConsumer {
  VoteProcessingConsumer({required String consumerId, required Channel channel})
    : super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) {
    return message.metadata['messageType'] == 'vote' ||
        message.metadata['messageType'] == 'vote_batch';
  }

  @override
  Future<MessageProcessingResult> doProcessMessage(Message message) async {
    final startTime = DateTime.now();

    try {
      // Simulate vote processing logic
      await Future.delayed(
        Duration(milliseconds: (message.payload.toString().length % 100) + 50),
      );

      final result = {
        'votesProcessed': _countVotes(message.payload),
        'validationStatus': 'valid',
        'processingNode': consumerId,
        'processedAt': DateTime.now().toIso8601String(),
      };

      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: true,
        result: result,
        processingTime: processingTime,
      );
    } catch (e) {
      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: false,
        result: null,
        processingTime: processingTime,
        errorMessage: e.toString(),
      );
    }
  }

  int _countVotes(dynamic payload) {
    if (payload is Map && payload.containsKey('votes')) {
      final votes = payload['votes'];
      if (votes is List) return votes.length;
    }
    return 1; // Single vote
  }
}

/// Proposal review consumer
class ProposalReviewConsumer extends BaseMessageConsumer {
  final CompetingConsumersBusinessLogicConfig _config;

  ProposalReviewConsumer({
    required String consumerId,
    required Channel channel,
    CompetingConsumersBusinessLogicConfig? config,
  }) : _config =
           config ?? CompetingConsumersBusinessLogicConfig.fromEnvironment(),
       super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) {
    return message.metadata['messageType'] == 'proposal' ||
        message.metadata['messageType'] == 'proposal_amendment';
  }

  @override
  Future<MessageProcessingResult> doProcessMessage(Message message) async {
    final startTime = DateTime.now();

    try {
      // Simulate proposal review logic
      await Future.delayed(
        Duration(milliseconds: (message.payload.toString().length % 200) + 100),
      );

      final review = {
        'proposalId': message.metadata['proposalId'],
        'reviewer': consumerId,
        'recommendation': _generateRecommendation(message.payload),
        'reviewScore': _calculateReviewScore(message.payload),
        'reviewedAt': DateTime.now().toIso8601String(),
      };

      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: true,
        result: review,
        processingTime: processingTime,
      );
    } catch (e) {
      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: false,
        result: null,
        processingTime: processingTime,
        errorMessage: e.toString(),
      );
    }
  }

  String _generateRecommendation(dynamic payload) {
    final recommendations = _config.recommendations;
    // Use hash of payload to select recommendation consistently
    final hash = payload.toString().hashCode.abs();
    return recommendations[hash % recommendations.length];
  }

  int _calculateReviewScore(dynamic payload) {
    // Simple scoring based on content length and complexity
    final length = payload.toString().length;
    return (length % 100) + 10; // Score between 10-109
  }
}

/// Deliberation processing consumer
class DeliberationProcessingConsumer extends BaseMessageConsumer {
  final CompetingConsumersBusinessLogicConfig _config;

  DeliberationProcessingConsumer({
    required String consumerId,
    required Channel channel,
    CompetingConsumersBusinessLogicConfig? config,
  }) : _config =
           config ?? CompetingConsumersBusinessLogicConfig.fromEnvironment(),
       super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) {
    return message.metadata['messageType'] == 'deliberation_message' ||
        message.metadata['messageType'] == 'citizen_input';
  }

  @override
  Future<MessageProcessingResult> doProcessMessage(Message message) async {
    final startTime = DateTime.now();

    try {
      // Simulate deliberation processing
      await Future.delayed(
        Duration(milliseconds: (message.payload.toString().length % 150) + 75),
      );

      final analysis = {
        'topicId': message.metadata['topicId'],
        'participantId': message.metadata['citizenId'],
        'sentiment': _analyzeSentiment(message.payload),
        'engagementLevel': _calculateEngagement(message.payload),
        'moderationStatus': 'approved',
        'processedBy': consumerId,
        'analyzedAt': DateTime.now().toIso8601String(),
      };

      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: true,
        result: analysis,
        processingTime: processingTime,
      );
    } catch (e) {
      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: false,
        result: null,
        processingTime: processingTime,
        errorMessage: e.toString(),
      );
    }
  }

  String _analyzeSentiment(dynamic payload) {
    final sentiments = _config.sentiments;
    final hash = payload.toString().hashCode.abs();
    return sentiments[hash % sentiments.length];
  }

  String _calculateEngagement(dynamic payload) {
    final engagementLevels = _config.engagementLevels;
    final hash = payload.toString().hashCode.abs();
    return engagementLevels[hash % engagementLevels.length];
  }
}

/// Audit processing consumer
class AuditProcessingConsumer extends BaseMessageConsumer {
  AuditProcessingConsumer({
    required String consumerId,
    required Channel channel,
  }) : super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) {
    return message.metadata['messageType'] == 'audit_event' ||
        message.metadata['requiresAudit'] == true;
  }

  @override
  Future<MessageProcessingResult> doProcessMessage(Message message) async {
    final startTime = DateTime.now();

    try {
      // Simulate audit processing
      await Future.delayed(
        Duration(milliseconds: (message.payload.toString().length % 120) + 60),
      );

      final audit = {
        'eventId': message.metadata['eventId'] ?? 'unknown',
        'auditTrailId': message.metadata['correlationId'],
        'complianceStatus': 'compliant',
        'auditor': consumerId,
        'auditTimestamp': DateTime.now().toIso8601String(),
        'findings': _generateAuditFindings(message.payload),
      };

      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: true,
        result: audit,
        processingTime: processingTime,
      );
    } catch (e) {
      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: false,
        result: null,
        processingTime: processingTime,
        errorMessage: e.toString(),
      );
    }
  }

  List<String> _generateAuditFindings(dynamic payload) {
    final findings = [
      'All required fields present',
      'Timestamp validation passed',
      'User authentication verified',
      'Data integrity confirmed',
    ];
    return findings
        .take((payload.toString().length % findings.length) + 1)
        .toList();
  }
}

/// Notification delivery consumer
class NotificationDeliveryConsumer extends BaseMessageConsumer {
  final CompetingConsumersBusinessLogicConfig _config;

  NotificationDeliveryConsumer({
    required String consumerId,
    required Channel channel,
    CompetingConsumersBusinessLogicConfig? config,
  }) : _config =
           config ?? CompetingConsumersBusinessLogicConfig.fromEnvironment(),
       super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) {
    return message.metadata['messageType'] == 'notification' ||
        message.metadata['deliverNotification'] == true;
  }

  @override
  Future<MessageProcessingResult> doProcessMessage(Message message) async {
    final startTime = DateTime.now();

    try {
      // Simulate notification delivery
      await Future.delayed(
        Duration(milliseconds: (message.payload.toString().length % 80) + 40),
      );

      final delivery = {
        'notificationId': message.metadata['notificationId'],
        'recipientId': message.metadata['citizenId'],
        'deliveryMethod': _selectDeliveryMethod(message.metadata),
        'deliveryStatus': 'delivered',
        'deliveredBy': consumerId,
        'deliveredAt': DateTime.now().toIso8601String(),
      };

      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: true,
        result: delivery,
        processingTime: processingTime,
      );
    } catch (e) {
      final processingTime = DateTime.now().difference(startTime);

      return MessageProcessingResult(
        originalMessage: message,
        success: false,
        result: null,
        processingTime: processingTime,
        errorMessage: e.toString(),
      );
    }
  }

  String _selectDeliveryMethod(Map<String, dynamic> metadata) {
    final preference = metadata['deliveryPreference'] as String?;
    final deliveryMethods = _config.deliveryMethods;

    // If preference is specified and available, use it
    if (preference != null && deliveryMethods.contains(preference)) {
      return preference;
    }

    // Otherwise use config-based selection
    final hash = metadata.toString().hashCode.abs();
    return deliveryMethods[hash % deliveryMethods.length];
  }
}
