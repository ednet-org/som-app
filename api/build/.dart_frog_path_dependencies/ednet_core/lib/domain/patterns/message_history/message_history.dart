part of ednet_core;

/// Types of events that can occur during message processing lifecycle
enum MessageEventType {
  /// Message was created/initialized
  created,

  /// Message was sent to a channel
  sent,

  /// Message processing has started
  processingStarted,

  /// Message processing completed successfully
  processingCompleted,

  /// Message processing failed
  processingFailed,

  /// Message was transformed/modified
  transformed,

  /// Message expired
  expired,

  /// Custom application-specific event
  custom,
}

/// Represents a single event in a message's processing history
class MessageEvent extends ValueObject {
  /// Unique identifier for this event
  final String eventId;

  /// ID of the message this event relates to
  final String messageId;

  /// Type of event that occurred
  final MessageEventType eventType;

  /// When this event occurred
  final DateTime timestamp;

  /// ID of the component that generated this event
  final String componentId;

  /// Type of the component that generated this event
  final String componentType;

  /// Sequence number for ordering events
  final int? sequenceNumber;

  /// Additional data specific to this event
  final Map<String, dynamic> eventData;

  /// Creates a new MessageEvent
  MessageEvent({
    required this.eventId,
    required this.messageId,
    required this.eventType,
    required this.timestamp,
    required this.componentId,
    required this.componentType,
    this.sequenceNumber,
    Map<String, dynamic>? eventData,
  }) : eventData = eventData ?? {} {
    validate();
  }

  /// Factory method to create an event from a message and basic info
  factory MessageEvent.fromMessage(
    Message message,
    MessageEventType eventType,
    String componentId,
    String componentType, {
    int? sequenceNumber,
    Map<String, dynamic>? eventData,
  }) {
    final now = DateTime.now();
    return MessageEvent(
      eventId:
          '${message.id}-${now.millisecondsSinceEpoch}-${sequenceNumber ?? 0}',
      messageId: message.id,
      eventType: eventType,
      timestamp: now,
      componentId: componentId,
      componentType: componentType,
      sequenceNumber: sequenceNumber,
      eventData: eventData,
    );
  }

  @override
  List<Object> get props => [
    eventId,
    messageId,
    eventType,
    timestamp,
    componentId,
    componentType,
    sequenceNumber ?? 0,
    eventData,
  ];

  @override
  MessageEvent copyWith({
    String? eventId,
    String? messageId,
    MessageEventType? eventType,
    DateTime? timestamp,
    String? componentId,
    String? componentType,
    int? sequenceNumber,
    Map<String, dynamic>? eventData,
  }) {
    return MessageEvent(
      eventId: eventId ?? this.eventId,
      messageId: messageId ?? this.messageId,
      eventType: eventType ?? this.eventType,
      timestamp: timestamp ?? this.timestamp,
      componentId: componentId ?? this.componentId,
      componentType: componentType ?? this.componentType,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      eventData: eventData ?? Map.from(this.eventData),
    );
  }
}

/// Represents the complete history of events for a single message
class MessageHistory extends ValueObject {
  /// ID of the message this history tracks
  final String messageId;

  /// List of events in chronological order
  final List<MessageEvent> events;

  /// Timestamp of the first event
  final DateTime firstEvent;

  /// Timestamp of the last event
  final DateTime lastEvent;

  /// Total lifetime of the message processing
  final Duration totalLifetime;

  /// Additional summary information
  final Map<String, dynamic> summary;

  /// Creates a new MessageHistory
  MessageHistory({
    required this.messageId,
    required this.events,
    required this.firstEvent,
    required this.lastEvent,
    required this.totalLifetime,
    Map<String, dynamic>? summary,
  }) : summary = summary ?? {} {
    validate();
  }

  /// Factory method to create history from events
  factory MessageHistory.fromEvents(List<MessageEvent> events) {
    if (events.isEmpty) {
      throw ArgumentError(
        'Cannot create MessageHistory from empty events list',
      );
    }

    final sortedEvents = List<MessageEvent>.from(events)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final first = sortedEvents.first.timestamp;
    final last = sortedEvents.last.timestamp;
    final lifetime = last.difference(first);

    return MessageHistory(
      messageId: events.first.messageId,
      events: sortedEvents,
      firstEvent: first,
      lastEvent: last,
      totalLifetime: lifetime,
      summary: _generateSummary(sortedEvents),
    );
  }

  /// Calculates the processing duration between start and completion events
  Duration? getProcessingDuration() {
    final startEvent = events.firstWhere(
      (e) => e.eventType == MessageEventType.processingStarted,
      orElse: () => events.first,
    );

    final endEvent = events.lastWhere(
      (e) =>
          e.eventType == MessageEventType.processingCompleted ||
          e.eventType == MessageEventType.processingFailed,
      orElse: () => events.last,
    );

    if (startEvent.eventType == MessageEventType.processingStarted &&
        (endEvent.eventType == MessageEventType.processingCompleted ||
            endEvent.eventType == MessageEventType.processingFailed)) {
      return endEvent.timestamp.difference(startEvent.timestamp);
    }

    return null;
  }

  /// Checks if the message processing was successful
  bool get wasSuccessful {
    return events.any(
      (e) => e.eventType == MessageEventType.processingCompleted,
    );
  }

  /// Gets the final disposition of the message
  MessageEventType? get finalDisposition {
    if (events.isEmpty) return null;
    final lastEvent = events.last;
    if (lastEvent.eventType == MessageEventType.processingCompleted ||
        lastEvent.eventType == MessageEventType.processingFailed ||
        lastEvent.eventType == MessageEventType.expired) {
      return lastEvent.eventType;
    }
    return null;
  }

  /// Gets all events of a specific type
  List<MessageEvent> getEventsOfType(MessageEventType type) {
    return events.where((e) => e.eventType == type).toList();
  }

  @override
  List<Object> get props => [
    messageId,
    events,
    firstEvent,
    lastEvent,
    totalLifetime,
    summary,
  ];

  @override
  MessageHistory copyWith() {
    return MessageHistory(
      messageId: messageId,
      events: List<MessageEvent>.from(events),
      firstEvent: firstEvent,
      lastEvent: lastEvent,
      totalLifetime: totalLifetime,
      summary: Map<String, dynamic>.from(summary),
    );
  }

  static Map<String, dynamic> _generateSummary(List<MessageEvent> events) {
    final summary = <String, dynamic>{};
    final eventCounts = <MessageEventType, int>{};

    for (final event in events) {
      eventCounts[event.eventType] = (eventCounts[event.eventType] ?? 0) + 1;
    }

    summary['eventCounts'] = eventCounts.map(
      (k, v) => MapEntry(k.toString(), v),
    );
    summary['totalEvents'] = events.length;
    summary['uniqueComponents'] = events
        .map((e) => e.componentId)
        .toSet()
        .length;

    return summary;
  }
}

/// Sort order for message history queries
enum MessageHistorySortOrder {
  /// Sort by timestamp ascending (oldest first)
  oldestFirst,

  /// Sort by timestamp descending (newest first)
  newestFirst,

  /// Sort by event type
  byEventType,

  /// Sort by component ID
  byComponent,
}

/// Query object for filtering and sorting message history
class MessageHistoryQuery extends ValueObject {
  /// Filter by start time (inclusive)
  final DateTime? fromTime;

  /// Filter by end time (inclusive)
  final DateTime? toTime;

  /// Filter by specific event types
  final List<MessageEventType>? eventTypes;

  /// Filter by specific component IDs
  final List<String>? componentIds;

  /// Maximum number of results to return
  final int? limit;

  /// How to sort the results
  final MessageHistorySortOrder sortOrder;

  /// Additional criteria for filtering
  final Map<String, dynamic>? messageCriteria;

  /// Creates a new MessageHistoryQuery
  MessageHistoryQuery({
    this.fromTime,
    this.toTime,
    this.eventTypes,
    this.componentIds,
    this.limit,
    this.messageCriteria,
    this.sortOrder = MessageHistorySortOrder.oldestFirst,
  }) {
    validate();
  }

  @override
  List<Object> get props => [
    fromTime ?? Object(),
    toTime ?? Object(),
    eventTypes ?? [],
    componentIds ?? [],
    limit ?? 0,
    sortOrder,
    messageCriteria ?? {},
  ];

  @override
  MessageHistoryQuery copyWith() {
    return MessageHistoryQuery(
      fromTime: fromTime,
      toTime: toTime,
      eventTypes: eventTypes != null
          ? List<MessageEventType>.from(eventTypes!)
          : null,
      componentIds: componentIds != null
          ? List<String>.from(componentIds!)
          : null,
      limit: limit,
      messageCriteria: messageCriteria != null
          ? Map<String, dynamic>.from(messageCriteria!)
          : null,
      sortOrder: sortOrder,
    );
  }
}

/// Statistics for message history tracking
class MessageHistoryStats extends ValueObject {
  /// Total number of messages tracked
  final int totalMessages;

  /// Total number of events recorded
  final int totalEvents;

  /// Count of events by type
  final Map<MessageEventType, int> eventsByType;

  /// Count of events by component
  final Map<String, int> eventsByComponent;

  /// Success rate (messages that completed successfully)
  final double successRate;

  /// Average processing time
  final Duration? averageProcessingTime;

  /// Creates a new MessageHistoryStats
  MessageHistoryStats({
    required this.totalMessages,
    required this.totalEvents,
    required this.eventsByType,
    required this.eventsByComponent,
    required this.successRate,
    this.averageProcessingTime,
  }) {
    validate();
  }

  @override
  List<Object> get props => [
    totalMessages,
    totalEvents,
    eventsByType,
    eventsByComponent,
    successRate,
    averageProcessingTime ?? Duration.zero,
  ];

  @override
  MessageHistoryStats copyWith() {
    return MessageHistoryStats(
      totalMessages: totalMessages,
      totalEvents: totalEvents,
      eventsByType: Map<MessageEventType, int>.from(eventsByType),
      eventsByComponent: Map<String, int>.from(eventsByComponent),
      successRate: successRate,
      averageProcessingTime: averageProcessingTime,
    );
  }
}

/// Core interface for tracking message history
abstract class MessageHistoryTracker {
  /// Records an event for a message
  Future<void> recordEvent(Message message, MessageEvent event);

  /// Gets the history of events for a specific message
  Future<List<MessageEvent>> getMessageHistory(String messageId);

  /// Gets message histories matching the query
  Future<List<MessageHistory>> getMessagesHistory(MessageHistoryQuery query);

  /// Gets statistics about tracked messages
  MessageHistoryStats getStats();

  /// Cleans up old history entries
  Future<int> cleanupHistory(Duration maxAge);

  /// Clears all history data
  Future<void> clear();
}

/// Basic in-memory implementation of MessageHistoryTracker
class BasicMessageHistoryTracker implements MessageHistoryTracker {
  final Map<String, List<MessageEvent>> _messageEvents = {};
  final Map<String, MessageHistory> _messageHistories = {};

  @override
  Future<void> recordEvent(Message message, MessageEvent event) async {
    _messageEvents.putIfAbsent(message.id, () => []).add(event);

    // Update or create message history
    final events = _messageEvents[message.id]!;
    _messageHistories[message.id] = MessageHistory.fromEvents(events);
  }

  @override
  Future<List<MessageEvent>> getMessageHistory(String messageId) async {
    final events = _messageEvents[messageId];
    if (events == null) return [];
    return List<MessageEvent>.from(events)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  Future<List<MessageHistory>> getMessagesHistory(
    MessageHistoryQuery query,
  ) async {
    final histories = <MessageHistory>[];

    for (final history in _messageHistories.values) {
      if (_matchesQuery(history, query)) {
        histories.add(history);
      }
    }

    // Apply sorting
    _sortHistories(histories, query.sortOrder);

    // Apply limit
    if (query.limit != null && histories.length > query.limit!) {
      histories.removeRange(query.limit!, histories.length);
    }

    return histories;
  }

  @override
  MessageHistoryStats getStats() {
    final eventsByType = <MessageEventType, int>{};
    final eventsByComponent = <String, int>{};
    var successfulMessages = 0;

    for (final history in _messageHistories.values) {
      if (history.wasSuccessful) {
        successfulMessages++;
      }

      for (final event in history.events) {
        eventsByType[event.eventType] =
            (eventsByType[event.eventType] ?? 0) + 1;
        eventsByComponent[event.componentId] =
            (eventsByComponent[event.componentId] ?? 0) + 1;
      }
    }

    final successRate = _messageHistories.isEmpty
        ? 0.0
        : successfulMessages / _messageHistories.length;

    return MessageHistoryStats(
      totalMessages: _messageHistories.length,
      totalEvents: _messageEvents.values.expand((e) => e).length,
      eventsByType: eventsByType,
      eventsByComponent: eventsByComponent,
      successRate: successRate,
    );
  }

  @override
  Future<int> cleanupHistory(Duration maxAge) async {
    final cutoffTime = DateTime.now().subtract(maxAge);
    var cleanedCount = 0;

    final toRemove = <String>[];

    for (final entry in _messageHistories.entries) {
      if (entry.value.lastEvent.isBefore(cutoffTime)) {
        toRemove.add(entry.key);
        cleanedCount++;
      }
    }

    for (final key in toRemove) {
      _messageEvents.remove(key);
      _messageHistories.remove(key);
    }

    return cleanedCount;
  }

  @override
  Future<void> clear() async {
    _messageEvents.clear();
    _messageHistories.clear();
  }

  bool _matchesQuery(MessageHistory history, MessageHistoryQuery query) {
    // Time filtering
    if (query.fromTime != null &&
        history.firstEvent.isBefore(query.fromTime!)) {
      return false;
    }
    if (query.toTime != null && history.lastEvent.isAfter(query.toTime!)) {
      return false;
    }

    // Event type filtering
    if (query.eventTypes != null && query.eventTypes!.isNotEmpty) {
      final hasMatchingEvent = history.events.any(
        (e) => query.eventTypes!.contains(e.eventType),
      );
      if (!hasMatchingEvent) return false;
    }

    // Component filtering
    if (query.componentIds != null && query.componentIds!.isNotEmpty) {
      final hasMatchingComponent = history.events.any(
        (e) => query.componentIds!.contains(e.componentId),
      );
      if (!hasMatchingComponent) return false;
    }

    return true;
  }

  void _sortHistories(
    List<MessageHistory> histories,
    MessageHistorySortOrder order,
  ) {
    switch (order) {
      case MessageHistorySortOrder.oldestFirst:
        histories.sort((a, b) => a.firstEvent.compareTo(b.firstEvent));
        break;
      case MessageHistorySortOrder.newestFirst:
        histories.sort((a, b) => b.firstEvent.compareTo(a.firstEvent));
        break;
      case MessageHistorySortOrder.byEventType:
        histories.sort((a, b) {
          if (a.events.isEmpty && b.events.isEmpty) return 0;
          if (a.events.isEmpty) return 1;
          if (b.events.isEmpty) return -1;
          return a.events.first.eventType.toString().compareTo(
            b.events.first.eventType.toString(),
          );
        });
        break;
      case MessageHistorySortOrder.byComponent:
        histories.sort((a, b) {
          if (a.events.isEmpty && b.events.isEmpty) return 0;
          if (a.events.isEmpty) return 1;
          if (b.events.isEmpty) return -1;
          return a.events.first.componentId.compareTo(
            b.events.first.componentId,
          );
        });
        break;
    }
  }
}

/// Intercepts message processing to automatically record history events
class MessageHistoryInterceptor {
  final MessageHistoryTracker _tracker;
  final String _componentId;
  final String _componentType;

  MessageHistoryInterceptor(
    this._tracker,
    this._componentId,
    this._componentType,
  );

  /// Intercepts message creation
  Future<Message> interceptCreation(Message message) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.created,
      _componentId,
      _componentType,
    );
    await _tracker.recordEvent(message, event);
    return message;
  }

  /// Intercepts message sending
  Future<void> interceptSending(Message message, Channel channel) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.sent,
      _componentId,
      _componentType,
      eventData: {'channelId': channel.id},
    );
    await _tracker.recordEvent(message, event);
  }

  /// Intercepts processing start
  Future<void> interceptProcessingStart(Message message) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.processingStarted,
      _componentId,
      _componentType,
    );
    await _tracker.recordEvent(message, event);
  }

  /// Intercepts processing completion
  Future<void> interceptProcessingCompletion(
    Message message,
    Map<String, dynamic>? result,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.processingCompleted,
      _componentId,
      _componentType,
      eventData: result,
    );
    await _tracker.recordEvent(message, event);
  }

  /// Intercepts message transformation
  Future<Message> interceptTransformation(
    Message originalMessage,
    Message transformedMessage,
  ) async {
    final event = MessageEvent.fromMessage(
      originalMessage,
      MessageEventType.transformed,
      _componentId,
      _componentType,
      eventData: {
        'originalPayload': originalMessage.payload,
        'transformedPayload': transformedMessage.payload,
      },
    );
    await _tracker.recordEvent(originalMessage, event);
    return transformedMessage;
  }
}

/// Domain-specific tracker for voting messages in EDNet
class VotingHistoryTracker extends BasicMessageHistoryTracker {
  /// Records a vote being cast
  Future<void> recordVoteCast(
    Message message,
    String citizenId,
    String electionId,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.created,
      'voting-system',
      'vote-casting',
      eventData: {'citizenId': citizenId, 'electionId': electionId},
    );
    await recordEvent(message, event);
  }

  /// Records vote validation
  Future<void> recordVoteValidation(
    Message message,
    bool isValid,
    String reason,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.transformed,
      'validation-service',
      'vote-validation',
      eventData: {'validationResult': isValid, 'validationReason': reason},
    );
    await recordEvent(message, event);
  }

  /// Records vote processing completion
  Future<void> recordVoteProcessingComplete(
    Message message,
    String transactionId,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.processingCompleted,
      'processing-engine',
      'vote-processing',
      eventData: {'transactionId': transactionId},
    );
    await recordEvent(message, event);
  }
}

/// Domain-specific tracker for proposal messages in EDNet
class ProposalHistoryTracker extends BasicMessageHistoryTracker {
  /// Records proposal creation
  Future<void> recordProposalCreated(
    Message message,
    String authorId,
    String proposalId,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.created,
      'proposal-system',
      'proposal-creation',
      eventData: {'authorId': authorId, 'proposalId': proposalId},
    );
    await recordEvent(message, event);
  }

  /// Records proposal amendment
  Future<void> recordProposalAmendment(
    Message originalMessage,
    Message amendedMessage,
    String amenderId,
  ) async {
    final event = MessageEvent.fromMessage(
      originalMessage,
      MessageEventType.transformed,
      'amendment-system',
      'proposal-amendment',
      eventData: {
        'amendmentAuthor': amenderId,
        'originalPayload': originalMessage.payload,
        'amendedPayload': amendedMessage.payload,
      },
    );
    await recordEvent(originalMessage, event);
  }

  /// Records proposal decision
  Future<void> recordProposalDecision(
    Message message,
    String decision,
    String reviewerId,
    String reason,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.processingCompleted,
      'review-system',
      'proposal-decision',
      eventData: {
        'decision': decision,
        'reviewerId': reviewerId,
        'reason': reason,
      },
    );
    await recordEvent(message, event);
  }
}

/// Domain-specific tracker for deliberation messages in EDNet
class DeliberationHistoryTracker extends BasicMessageHistoryTracker {
  /// Records deliberation message
  Future<void> recordDeliberationMessage(
    Message message,
    String citizenId,
    String topicId,
    String sessionId,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.created,
      'deliberation-system',
      'message-posting',
      eventData: {
        'citizenId': citizenId,
        'topicId': topicId,
        'sessionId': sessionId,
      },
    );
    await recordEvent(message, event);
  }

  /// Records sentiment analysis
  Future<void> recordSentimentAnalysis(
    Message message,
    String sentiment,
    double confidence,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.transformed,
      'sentiment-analyzer',
      'sentiment-analysis',
      eventData: {'sentiment': sentiment, 'confidence': confidence},
    );
    await recordEvent(message, event);
  }

  /// Records moderation action
  Future<void> recordModerationAction(
    Message message,
    String action,
    String moderatorId,
    String reason,
  ) async {
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.transformed,
      'moderation-system',
      'content-moderation',
      eventData: {
        'moderationAction': action,
        'moderatorId': moderatorId,
        'reason': reason,
      },
    );
    await recordEvent(message, event);
  }
}

/// Unified system for managing message history across all EDNet domains
class EDNetMessageHistorySystem {
  final Map<String, MessageHistoryTracker> _domainTrackers = {};
  final Map<String, MessageHistoryInterceptor> _interceptors = {};

  /// Initializes the system with domain-specific trackers
  void initialize() {
    _domainTrackers['voting'] = VotingHistoryTracker();
    _domainTrackers['proposals'] = ProposalHistoryTracker();
    _domainTrackers['deliberation'] = DeliberationHistoryTracker();
    _domainTrackers['general'] = BasicMessageHistoryTracker();
  }

  /// Gets the tracker for a specific domain
  MessageHistoryTracker getDomainTracker(String domain) {
    return _domainTrackers[domain] ?? _domainTrackers['general']!;
  }

  /// Creates an interceptor for a component
  MessageHistoryInterceptor createInterceptor(
    String componentId,
    String componentType, {
    String domain = 'general',
  }) {
    final tracker = getDomainTracker(domain);
    final interceptor = MessageHistoryInterceptor(
      tracker,
      componentId,
      componentType,
    );
    _interceptors[componentId] = interceptor;
    return interceptor;
  }

  /// Gets an existing interceptor
  MessageHistoryInterceptor? getInterceptor(String componentId) {
    return _interceptors[componentId];
  }

  /// Records a custom event
  Future<void> recordCustomEvent(
    Message message,
    String description, {
    Map<String, dynamic>? eventData,
    String domain = 'general',
  }) async {
    final tracker = getDomainTracker(domain);
    final event = MessageEvent.fromMessage(
      message,
      MessageEventType.custom,
      'system',
      'custom-event',
      eventData: {'description': description, ...?eventData},
    );
    await tracker.recordEvent(message, event);
  }

  /// Gets global message history across all domains
  Future<List<MessageHistory>> getGlobalMessageHistory(
    MessageHistoryQuery query,
  ) async {
    final allHistories = <MessageHistory>[];

    for (final tracker in _domainTrackers.values) {
      final histories = await tracker.getMessagesHistory(query);
      allHistories.addAll(histories);
    }

    // Sort globally
    allHistories.sort((a, b) => a.firstEvent.compareTo(b.firstEvent));

    // Apply global limit
    if (query.limit != null && allHistories.length > query.limit!) {
      allHistories.removeRange(query.limit!, allHistories.length);
    }

    return allHistories;
  }

  /// Gets system-wide statistics
  Map<String, MessageHistoryStats> getSystemStats() {
    final stats = <String, MessageHistoryStats>{};

    for (final entry in _domainTrackers.entries) {
      stats[entry.key] = entry.value.getStats();
    }

    return stats;
  }

  /// Cleans up old history across all domains
  Future<int> cleanupOldHistory(Duration maxAge) async {
    var totalCleaned = 0;

    for (final tracker in _domainTrackers.values) {
      totalCleaned += await tracker.cleanupHistory(maxAge);
    }

    return totalCleaned;
  }

  /// Clears all history data
  Future<void> clearAllHistory() async {
    for (final tracker in _domainTrackers.values) {
      await tracker.clear();
    }
  }
}
