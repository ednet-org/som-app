part of ednet_core;

/// Publish-Subscribe Channel Pattern
///
/// The Publish-Subscribe Channel pattern enables one-to-many communication where
/// publishers send messages to a channel and all subscribers to that channel
/// automatically receive the messages. This pattern provides loose coupling
/// between publishers and subscribers.
///
/// In EDNet/direct democracy contexts, publish-subscribe is crucial for:
/// * Broadcasting election announcements and voting deadlines to all citizens
/// * Publishing proposal updates and amendments to interested stakeholders
/// * Distributing voting results and election statistics in real-time
/// * Broadcasting deliberation session notifications and schedules
/// * Sending emergency alerts and important policy announcements
/// * Publishing citizen engagement metrics and participation statistics

/// Abstract interface for publish-subscribe channels
abstract class PublishSubscribeChannel extends Channel {
  /// Constructs a new publish-subscribe channel with the given id and optional name
  PublishSubscribeChannel({required super.id, super.name});

  /// Subscribes a consumer to receive messages from this channel
  StreamSubscription<Message> subscribe(MessageConsumer consumer);

  /// Unsubscribes a consumer from this channel
  Future<void> unsubscribe(MessageConsumer consumer);

  /// Gets the current number of subscribers
  int get subscriberCount;

  /// Gets list of subscriber IDs for monitoring
  List<String> get subscriberIds;

  /// Publishes a message to all subscribers
  @override
  Future<void> send(Message message);

  /// Checks if a consumer is subscribed to this channel
  bool isSubscribed(MessageConsumer consumer);

  /// Gets channel statistics
  PublishSubscribeStats getStats();
}

/// Statistics for publish-subscribe channels
class PublishSubscribeStats {
  final String channelId;
  final int subscriberCount;
  final int totalMessagesPublished;
  final int totalMessagesDelivered;
  final Map<String, int> messagesByType;
  final Map<String, int> subscribersByType;
  final DateTime createdAt;
  final DateTime lastActivity;

  PublishSubscribeStats({
    required this.channelId,
    required this.subscriberCount,
    required this.totalMessagesPublished,
    required this.totalMessagesDelivered,
    required this.messagesByType,
    required this.subscribersByType,
    required this.createdAt,
    DateTime? lastActivity,
  }) : lastActivity = lastActivity ?? DateTime.now();

  double get deliveryRate => totalMessagesPublished > 0
      ? totalMessagesDelivered / totalMessagesPublished
      : 0.0;

  @override
  String toString() {
    return 'PublishSubscribeStats{channel: $channelId, subscribers: $subscriberCount, '
        'published: $totalMessagesPublished, delivered: $totalMessagesDelivered, '
        'deliveryRate: ${(deliveryRate * 100).round()}%}';
  }
}

/// Topic-based publish-subscribe channel
class TopicBasedPublishSubscribeChannel extends Channel
    implements PublishSubscribeChannel {
  final String _topic;
  final StreamController<Message> _controller;
  final Map<String, StreamSubscription<Message>> _subscriptions = {};
  final Map<String, MessageConsumer> _consumers = {};
  final PublishSubscribeStatsTracker _statsTracker;

  TopicBasedPublishSubscribeChannel({
    required String id,
    required String topic,
    String? name,
  }) : _topic = topic,
       _controller = StreamController<Message>.broadcast(),
       _statsTracker = PublishSubscribeStatsTracker(id),
       super(id: id, name: name);

  String get topic => _topic;

  @override
  StreamSubscription<Message> subscribe(MessageConsumer consumer) {
    if (_consumers.containsKey(consumer.consumerId)) {
      throw StateError('Consumer ${consumer.consumerId} is already subscribed');
    }

    final subscription = _controller.stream.listen(
      (message) async {
        try {
          await consumer.processMessage(message);
          _statsTracker.recordSuccessfulDelivery(message);
        } catch (e) {
          _statsTracker.recordFailedDelivery(message);
          // Log error but continue processing other subscribers
        }
      },
      onError: (error) {
        // Handle stream errors
      },
      onDone: () {
        // Handle stream completion
        unsubscribe(consumer);
      },
    );

    _subscriptions[consumer.consumerId] = subscription;
    _consumers[consumer.consumerId] = consumer;
    _statsTracker.addSubscriber(consumer);

    return subscription;
  }

  @override
  Future<void> unsubscribe(MessageConsumer consumer) async {
    final subscription = _subscriptions.remove(consumer.consumerId);
    if (subscription != null) {
      await subscription.cancel();
    }
    _consumers.remove(consumer.consumerId);
    _statsTracker.removeSubscriber(consumer.consumerId);
  }

  @override
  bool isSubscribed(MessageConsumer consumer) {
    return _consumers.containsKey(consumer.consumerId);
  }

  @override
  int get subscriberCount => _consumers.length;

  @override
  List<String> get subscriberIds => _consumers.keys.toList();

  @override
  Future<void> send(Message message) async {
    if (_controller.isClosed) {
      throw StateError('Cannot send messages to a closed channel');
    }

    _statsTracker.recordMessagePublished(message);
    _controller.add(message);
  }

  @override
  Stream<Message> receive() {
    return _controller.stream;
  }

  @override
  Future<void> close() async {
    for (final subscription in _subscriptions.values) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    _consumers.clear();
    await _controller.close();
  }

  @override
  PublishSubscribeStats getStats() => _statsTracker.getStats();

  /// Gets all current subscribers
  List<MessageConsumer> getSubscribers() => _consumers.values.toList();
}

/// Statistics tracker for publish-subscribe operations
class PublishSubscribeStatsTracker {
  final String channelId;
  int _subscriberCount = 0;
  int _totalMessagesPublished = 0;
  int _totalMessagesDelivered = 0;
  final Map<String, int> _messagesByType = {};
  final Map<String, int> _subscribersByType = {};
  final DateTime _createdAt = DateTime.now();
  DateTime? _lastActivity;

  PublishSubscribeStatsTracker(this.channelId);

  void addSubscriber(MessageConsumer consumer) {
    _subscriberCount++;
    final consumerType = _getConsumerType(consumer);
    _subscribersByType[consumerType] =
        (_subscribersByType[consumerType] ?? 0) + 1;
    _lastActivity = DateTime.now();
  }

  void removeSubscriber(String consumerId) {
    _subscriberCount--;
    _lastActivity = DateTime.now();
  }

  void recordMessagePublished(Message message) {
    _totalMessagesPublished++;
    final messageType = _getMessageType(message);
    _messagesByType[messageType] = (_messagesByType[messageType] ?? 0) + 1;
    _lastActivity = DateTime.now();
  }

  void recordSuccessfulDelivery(Message message) {
    _totalMessagesDelivered++;
  }

  void recordFailedDelivery(Message message) {
    // Failed deliveries are tracked but don't increment successful count
  }

  PublishSubscribeStats getStats() {
    return PublishSubscribeStats(
      channelId: channelId,
      subscriberCount: _subscriberCount,
      totalMessagesPublished: _totalMessagesPublished,
      totalMessagesDelivered: _totalMessagesDelivered,
      messagesByType: Map.from(_messagesByType),
      subscribersByType: Map.from(_subscribersByType),
      createdAt: _createdAt,
      lastActivity: _lastActivity,
    );
  }

  String _getMessageType(Message message) {
    if (message.metadata.containsKey('messageType')) {
      return message.metadata['messageType'] as String;
    }
    return message.payload.runtimeType.toString();
  }

  String _getConsumerType(MessageConsumer consumer) {
    return consumer.runtimeType.toString();
  }
}

/// Durable subscriber for persistent subscriptions
class DurableSubscriber implements MessageConsumer {
  @override
  final String consumerId;
  @override
  final Channel channel;

  final String _subscriptionId;
  final Map<String, dynamic> _subscriptionMetadata;
  bool _isActive = false;

  /// Messages that were published while subscriber was offline
  final List<Message> _pendingMessages = [];

  DurableSubscriber({
    required this.consumerId,
    required this.channel,
    String? subscriptionId,
    Map<String, dynamic>? subscriptionMetadata,
  }) : _subscriptionId =
           subscriptionId ??
           'durable-$consumerId-${DateTime.now().millisecondsSinceEpoch}',
       _subscriptionMetadata = subscriptionMetadata ?? {};

  String get subscriptionId => _subscriptionId;
  Map<String, dynamic> get subscriptionMetadata => _subscriptionMetadata;

  @override
  Future<MessageProcessingResult> processMessage(Message message) async {
    final startTime = DateTime.now();

    try {
      // Simulate message processing
      await Future.delayed(const Duration(milliseconds: 10));

      final result = {
        'processed': true,
        'subscriptionId': _subscriptionId,
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

  @override
  bool canHandle(Message message) {
    // Durable subscribers can handle any message type
    return true;
  }

  @override
  Future<void> start() async {
    _isActive = true;
  }

  @override
  Future<void> stop() async {
    _isActive = false;
  }

  @override
  bool get isActive => _isActive;

  @override
  ConsumerStats getStats() {
    return ConsumerStats(
      consumerId: consumerId,
      messagesProcessed: 0, // Would be tracked in real implementation
      messagesSucceeded: 0,
      messagesFailed: 0,
      totalProcessingTime: Duration.zero,
      averageProcessingTime: Duration.zero,
      messageTypesProcessed: {},
    );
  }

  /// Adds a message to the pending queue (for when subscriber is offline)
  void addPendingMessage(Message message) {
    _pendingMessages.add(message);
  }

  /// Gets and clears pending messages
  List<Message> getAndClearPendingMessages() {
    final messages = List<Message>.from(_pendingMessages);
    _pendingMessages.clear();
    return messages;
  }

  /// Checks if there are pending messages
  bool hasPendingMessages() => _pendingMessages.isNotEmpty;
}

/// Selective subscriber that only processes certain message types
class SelectiveSubscriber implements MessageConsumer {
  @override
  final String consumerId;
  @override
  final Channel channel;

  final List<String> _subscribedMessageTypes;
  final Map<String, dynamic> _filterCriteria;
  bool _isActive = false;

  SelectiveSubscriber({
    required this.consumerId,
    required this.channel,
    required List<String> subscribedMessageTypes,
    Map<String, dynamic>? filterCriteria,
  }) : _subscribedMessageTypes = List.from(subscribedMessageTypes),
       _filterCriteria = filterCriteria ?? {};

  List<String> get subscribedMessageTypes => List.from(_subscribedMessageTypes);
  Map<String, dynamic> get filterCriteria => _filterCriteria;

  @override
  Future<MessageProcessingResult> processMessage(Message message) async {
    final startTime = DateTime.now();

    try {
      // Check if message passes filter criteria
      if (!_passesFilter(message)) {
        return MessageProcessingResult(
          originalMessage: message,
          success: false,
          result: {'filtered': true, 'reason': 'filter criteria not met'},
          processingTime: DateTime.now().difference(startTime),
          errorMessage: 'Message filtered out',
        );
      }

      // Simulate message processing
      await Future.delayed(const Duration(milliseconds: 15));

      final result = {
        'processed': true,
        'messageType': message.metadata['messageType'],
        'filterMatched': true,
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

  @override
  bool canHandle(Message message) {
    final messageType = message.metadata['messageType'] as String?;
    if (messageType == null) return false;

    return _subscribedMessageTypes.contains(messageType) &&
        _passesFilter(message);
  }

  @override
  Future<void> start() async {
    _isActive = true;
  }

  @override
  Future<void> stop() async {
    _isActive = false;
  }

  @override
  bool get isActive => _isActive;

  @override
  ConsumerStats getStats() {
    return ConsumerStats(
      consumerId: consumerId,
      messagesProcessed: 0,
      messagesSucceeded: 0,
      messagesFailed: 0,
      totalProcessingTime: Duration.zero,
      averageProcessingTime: Duration.zero,
      messageTypesProcessed: {},
    );
  }

  bool _passesFilter(Message message) {
    // Check message type filter
    final messageType = message.metadata['messageType'] as String?;
    if (messageType != null && !_subscribedMessageTypes.contains(messageType)) {
      return false;
    }

    // Check additional filter criteria
    for (final entry in _filterCriteria.entries) {
      final field = entry.key;
      final expectedValue = entry.value;

      dynamic actualValue;
      if (message.metadata.containsKey(field)) {
        actualValue = message.metadata[field];
      } else if (message.payload is Map<String, dynamic> &&
          (message.payload as Map<String, dynamic>).containsKey(field)) {
        actualValue = (message.payload as Map<String, dynamic>)[field];
      }

      if (actualValue != expectedValue) {
        return false;
      }
    }

    return true;
  }
}

/// Publish-subscribe broker for managing multiple channels
class PublishSubscribeBroker {
  final Map<String, PublishSubscribeChannel> _channels = {};
  final Map<String, Map<String, MessageConsumer>> _channelSubscriptions = {};
  final PublishSubscribeBrokerStats _stats = PublishSubscribeBrokerStats();

  /// Creates a new topic-based channel
  PublishSubscribeChannel createChannel({
    required String channelId,
    required String topic,
    String? name,
  }) {
    if (_channels.containsKey(channelId)) {
      throw ArgumentError('Channel with ID $channelId already exists');
    }

    final channel = TopicBasedPublishSubscribeChannel(
      id: channelId,
      topic: topic,
      name: name,
    );

    _channels[channelId] = channel;
    _channelSubscriptions[channelId] = {};
    _stats.recordChannelCreated(channelId, topic);

    return channel;
  }

  /// Gets an existing channel by ID
  PublishSubscribeChannel? getChannel(String channelId) {
    return _channels[channelId];
  }

  /// Subscribes a consumer to a channel
  StreamSubscription<Message> subscribeToChannel(
    String channelId,
    MessageConsumer consumer,
  ) {
    final channel = _channels[channelId];
    if (channel == null) {
      throw ArgumentError('Channel with ID $channelId does not exist');
    }

    final subscription = channel.subscribe(consumer);
    _channelSubscriptions[channelId]![consumer.consumerId] = consumer;
    _stats.recordSubscription(channelId, consumer.consumerId);

    return subscription;
  }

  /// Unsubscribes a consumer from a channel
  Future<void> unsubscribeFromChannel(
    String channelId,
    MessageConsumer consumer,
  ) async {
    final channel = _channels[channelId];
    if (channel != null) {
      await channel.unsubscribe(consumer);
      _channelSubscriptions[channelId]?.remove(consumer.consumerId);
      _stats.recordUnsubscription(channelId, consumer.consumerId);
    }
  }

  /// Publishes a message to a specific channel
  Future<void> publishToChannel(String channelId, Message message) async {
    final channel = _channels[channelId];
    if (channel == null) {
      throw ArgumentError('Channel with ID $channelId does not exist');
    }

    await channel.send(message);
    _stats.recordPublication(channelId, message);
  }

  /// Publishes a message to all channels with a specific topic
  Future<void> publishToTopic(String topic, Message message) async {
    final topicChannels = _channels.values.where(
      (channel) =>
          channel is TopicBasedPublishSubscribeChannel &&
          (channel).topic == topic,
    );

    for (final channel in topicChannels) {
      await channel.send(message);
      _stats.recordPublication(channel.id, message);
    }
  }

  /// Gets all available channels
  List<PublishSubscribeChannel> getChannels() {
    return _channels.values.toList();
  }

  /// Gets broker statistics
  PublishSubscribeBrokerStats getStats() => _stats;

  /// Closes all channels and cleans up resources
  Future<void> shutdown() async {
    for (final channel in _channels.values) {
      await channel.close();
    }
    _channels.clear();
    _channelSubscriptions.clear();
  }
}

/// Statistics for the publish-subscribe broker
class PublishSubscribeBrokerStats {
  final Map<String, String> _channelTopics = {};
  final Map<String, int> _channelSubscriptions = {};
  final Map<String, int> _channelPublications = {};
  final Map<String, DateTime> _channelCreationTimes = {};
  final Map<String, DateTime> _lastActivity = {};

  void recordChannelCreated(String channelId, String topic) {
    _channelTopics[channelId] = topic;
    _channelSubscriptions[channelId] = 0;
    _channelPublications[channelId] = 0;
    _channelCreationTimes[channelId] = DateTime.now();
    _lastActivity[channelId] = DateTime.now();
  }

  void recordSubscription(String channelId, String consumerId) {
    _channelSubscriptions[channelId] =
        (_channelSubscriptions[channelId] ?? 0) + 1;
    _lastActivity[channelId] = DateTime.now();
  }

  void recordUnsubscription(String channelId, String consumerId) {
    _channelSubscriptions[channelId] =
        (_channelSubscriptions[channelId] ?? 0) - 1;
    _lastActivity[channelId] = DateTime.now();
  }

  void recordPublication(String channelId, Message message) {
    _channelPublications[channelId] =
        (_channelPublications[channelId] ?? 0) + 1;
    _lastActivity[channelId] = DateTime.now();
  }

  Map<String, dynamic> getOverallStats() {
    int totalChannels = _channelTopics.length;
    int totalSubscriptions = _channelSubscriptions.values.fold(
      0,
      (sum, count) => sum + count,
    );
    int totalPublications = _channelPublications.values.fold(
      0,
      (sum, count) => sum + count,
    );

    return {
      'totalChannels': totalChannels,
      'totalSubscriptions': totalSubscriptions,
      'totalPublications': totalPublications,
      'channels': _channelTopics.map(
        (channelId, topic) => MapEntry(channelId, {
          'topic': topic,
          'subscriptions': _channelSubscriptions[channelId] ?? 0,
          'publications': _channelPublications[channelId] ?? 0,
          'createdAt': _channelCreationTimes[channelId]?.toIso8601String(),
          'lastActivity': _lastActivity[channelId]?.toIso8601String(),
        }),
      ),
    };
  }
}
