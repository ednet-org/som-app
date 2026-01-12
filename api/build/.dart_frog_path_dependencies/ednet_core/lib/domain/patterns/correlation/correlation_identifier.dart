part of ednet_core;

/// Correlation Identifier Pattern
///
/// The Correlation Identifier pattern establishes relationships between messages
/// that are part of the same conversation, workflow, or business process. This
/// pattern is essential for maintaining context across distributed systems and
/// ensuring that related messages can be properly associated and processed together.
///
/// In EDNet/direct democracy contexts, correlation identifiers are crucial for:
/// * Linking voting session messages with ballot submissions and results
/// * Tracking proposal amendments and their relationships to original proposals
/// * Maintaining conversation threads in citizen deliberations
/// * Correlating audit trail messages with their originating actions
/// * Associating multi-step approval processes and workflow states
/// * Linking citizen feedback with specific governance decisions

/// Abstract interface for correlation management
abstract class CorrelationManager {
  /// Generates a new correlation ID
  String generateCorrelationId();

  /// Associates a message with a correlation ID
  Message correlateMessage(Message message, String correlationId);

  /// Extracts correlation ID from a message
  String? getCorrelationId(Message message);

  /// Finds all messages with a given correlation ID
  Future<List<Message>> findCorrelatedMessages(String correlationId);

  /// Creates a correlated response to an original message
  Message createCorrelatedResponse(
    Message originalMessage,
    dynamic responsePayload,
  );

  /// Checks if two messages are correlated
  bool areCorrelated(Message message1, Message message2);

  /// Gets correlation statistics
  CorrelationStats getStats();
}

/// Correlation statistics
class CorrelationStats {
  final int totalCorrelations;
  final int activeCorrelations;
  final Map<String, int> correlationsByType;
  final DateTime lastActivity;

  CorrelationStats({
    required this.totalCorrelations,
    required this.activeCorrelations,
    required this.correlationsByType,
    DateTime? lastActivity,
  }) : lastActivity = lastActivity ?? DateTime.now();

  @override
  String toString() {
    return 'CorrelationStats{correlations: $totalCorrelations, active: $activeCorrelations, types: ${correlationsByType.length}}';
  }
}

/// Correlation context for maintaining state across related operations
class CorrelationContext {
  final String correlationId;
  final String contextType;
  final Map<String, dynamic> properties;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final List<String> relatedMessageIds;
  final Map<String, dynamic> metadata;

  CorrelationContext({
    required this.correlationId,
    required this.contextType,
    this.properties = const {},
    DateTime? createdAt,
    DateTime? lastUpdated,
    this.relatedMessageIds = const [],
    this.metadata = const {},
  }) : createdAt = createdAt ?? DateTime.now(),
       lastUpdated = lastUpdated ?? DateTime.now();

  /// Creates a copy with updated properties
  CorrelationContext copyWith({
    String? correlationId,
    String? contextType,
    Map<String, dynamic>? properties,
    DateTime? lastUpdated,
    List<String>? relatedMessageIds,
    Map<String, dynamic>? metadata,
  }) {
    return CorrelationContext(
      correlationId: correlationId ?? this.correlationId,
      contextType: contextType ?? this.contextType,
      properties: properties ?? this.properties,
      createdAt: createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
      relatedMessageIds: relatedMessageIds ?? this.relatedMessageIds,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Adds a related message ID
  CorrelationContext addRelatedMessage(String messageId) {
    return copyWith(relatedMessageIds: [...relatedMessageIds, messageId]);
  }

  /// Checks if context is expired based on time-to-live
  bool isExpired(Duration ttl) {
    return DateTime.now().difference(createdAt) > ttl;
  }
}

/// Basic correlation manager implementation
class BasicCorrelationManager implements CorrelationManager {
  final Map<String, CorrelationContext> _contexts = {};
  final Map<String, List<Message>> _correlatedMessages = {};
  final String _correlationIdPrefix;
  int _nextId = 1;

  BasicCorrelationManager({String correlationIdPrefix = 'corr'})
    : _correlationIdPrefix = correlationIdPrefix;

  @override
  String generateCorrelationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final sequence = _nextId++;
    return '$_correlationIdPrefix-$timestamp-$sequence';
  }

  @override
  Message correlateMessage(Message message, String correlationId) {
    final correlatedMetadata = Map<String, dynamic>.from(message.metadata);
    correlatedMetadata['correlationId'] = correlationId;
    correlatedMetadata['correlatedAt'] = DateTime.now().toIso8601String();

    final correlatedMessage = Message(
      payload: message.payload,
      metadata: correlatedMetadata,
      id: message.id,
    );

    // Store the correlated message
    _correlatedMessages
        .putIfAbsent(correlationId, () => [])
        .add(correlatedMessage);

    // Update or create correlation context
    final context =
        _contexts[correlationId] ??
        CorrelationContext(correlationId: correlationId, contextType: 'basic');

    final updatedContext = context.addRelatedMessage(message.id);
    _contexts[correlationId] = updatedContext;

    return correlatedMessage;
  }

  @override
  String? getCorrelationId(Message message) {
    return message.metadata['correlationId'] as String?;
  }

  @override
  Future<List<Message>> findCorrelatedMessages(String correlationId) async {
    return _correlatedMessages[correlationId] ?? [];
  }

  @override
  Message createCorrelatedResponse(
    Message originalMessage,
    dynamic responsePayload,
  ) {
    final originalCorrelationId = getCorrelationId(originalMessage);
    if (originalCorrelationId == null) {
      throw ArgumentError('Original message must have a correlation ID');
    }

    final responseMetadata = Map<String, dynamic>.from(
      originalMessage.metadata,
    );
    responseMetadata['correlationId'] = originalCorrelationId;
    responseMetadata['isResponse'] = true;
    responseMetadata['originalMessageId'] = originalMessage.id;
    responseMetadata['responseAt'] = DateTime.now().toIso8601String();

    final responseMessage = Message(
      payload: responsePayload,
      metadata: responseMetadata,
    );

    // Store the response message
    _correlatedMessages
        .putIfAbsent(originalCorrelationId, () => [])
        .add(responseMessage);

    // Update correlation context
    final context = _contexts[originalCorrelationId];
    if (context != null) {
      final updatedContext = context.addRelatedMessage(responseMessage.id);
      _contexts[originalCorrelationId] = updatedContext;
    }

    return responseMessage;
  }

  @override
  bool areCorrelated(Message message1, Message message2) {
    final correlationId1 = getCorrelationId(message1);
    final correlationId2 = getCorrelationId(message2);

    if (correlationId1 == null || correlationId2 == null) {
      return false;
    }

    return correlationId1 == correlationId2;
  }

  @override
  CorrelationStats getStats() {
    final correlationsByType = <String, int>{};

    for (final context in _contexts.values) {
      final type = context.contextType;
      correlationsByType[type] = (correlationsByType[type] ?? 0) + 1;
    }

    return CorrelationStats(
      totalCorrelations: _contexts.length,
      activeCorrelations: _contexts.length,
      correlationsByType: correlationsByType,
      lastActivity: _contexts.values.isNotEmpty
          ? _contexts.values
                .map((c) => c.lastUpdated)
                .reduce((a, b) => a.isAfter(b) ? a : b)
          : DateTime.now(),
    );
  }

  /// Gets correlation context by ID
  CorrelationContext? getContext(String correlationId) {
    return _contexts[correlationId];
  }

  /// Lists all correlation IDs
  List<String> getCorrelationIds() {
    return _contexts.keys.toList();
  }

  /// Removes a correlation context and its messages
  void removeCorrelation(String correlationId) {
    _contexts.remove(correlationId);
    _correlatedMessages.remove(correlationId);
  }

  /// Cleans up expired correlations
  void cleanupExpired(Duration ttl) {
    final expiredIds = <String>[];

    for (final entry in _contexts.entries) {
      if (entry.value.isExpired(ttl)) {
        expiredIds.add(entry.key);
      }
    }

    for (final id in expiredIds) {
      removeCorrelation(id);
    }
  }
}

/// Correlation identifier generator with different strategies
abstract class CorrelationIdGenerator {
  String generate();
}

/// Timestamp-based correlation ID generator
class TimestampCorrelationIdGenerator implements CorrelationIdGenerator {
  final String prefix;

  TimestampCorrelationIdGenerator({this.prefix = 'corr'});

  @override
  String generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$prefix-$timestamp';
  }
}

/// UUID-based correlation ID generator
class UuidCorrelationIdGenerator implements CorrelationIdGenerator {
  final String prefix;

  UuidCorrelationIdGenerator({this.prefix = 'uuid'});

  @override
  String generate() {
    // Simple UUID-like generation (in a real implementation, use a proper UUID library)
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch % 1000000;
    return '$prefix-${timestamp.toRadixString(16)}-${random.toRadixString(16)}';
  }
}

/// Business context-based correlation ID generator
class BusinessContextCorrelationIdGenerator implements CorrelationIdGenerator {
  final String businessDomain;
  final String entityType;

  BusinessContextCorrelationIdGenerator({
    required this.businessDomain,
    required this.entityType,
  });

  @override
  String generate() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$businessDomain-$entityType-$timestamp';
  }
}

/// Message correlation enricher for automatic correlation
class MessageCorrelationEnricher {
  final CorrelationManager correlationManager;
  final CorrelationIdGenerator idGenerator;

  MessageCorrelationEnricher({
    required this.correlationManager,
    required this.idGenerator,
  });

  /// Enriches a message with correlation information
  Message enrichMessage(Message message, {String? correlationId}) {
    final id = correlationId ?? idGenerator.generate();
    return correlationManager.correlateMessage(message, id);
  }

  /// Enriches a response message with correlation to the original
  Message enrichResponse(Message originalMessage, dynamic responsePayload) {
    return correlationManager.createCorrelatedResponse(
      originalMessage,
      responsePayload,
    );
  }

  /// Checks if a message is part of a correlation
  bool isCorrelated(Message message) {
    return correlationManager.getCorrelationId(message) != null;
  }

  /// Gets the correlation context for a message
  CorrelationContext? getCorrelationContext(Message message) {
    final correlationId = correlationManager.getCorrelationId(message);
    if (correlationId == null) return null;

    // This would need to be implemented in the correlation manager
    // For now, return null
    return null;
  }
}

/// Correlation-based message filter
class CorrelationMessageFilter {
  final CorrelationManager correlationManager;
  final Set<String> allowedCorrelationIds;

  CorrelationMessageFilter({
    required this.correlationManager,
    Set<String>? allowedCorrelationIds,
  }) : allowedCorrelationIds = allowedCorrelationIds ?? {};

  /// Filters messages based on correlation ID
  bool shouldProcess(Message message) {
    final correlationId = correlationManager.getCorrelationId(message);

    if (correlationId == null) {
      return false; // No correlation ID
    }

    if (allowedCorrelationIds.isEmpty) {
      return true; // Allow all correlated messages
    }

    return allowedCorrelationIds.contains(correlationId);
  }

  /// Adds an allowed correlation ID
  void allowCorrelation(String correlationId) {
    allowedCorrelationIds.add(correlationId);
  }

  /// Removes an allowed correlation ID
  void disallowCorrelation(String correlationId) {
    allowedCorrelationIds.remove(correlationId);
  }
}

/// Correlation-aware channel processor
class CorrelationChannelProcessor {
  final Channel sourceChannel;
  final Channel targetChannel;
  final CorrelationManager correlationManager;
  final CorrelationMessageFilter? filter;
  StreamSubscription<Message>? _subscription;

  CorrelationChannelProcessor({
    required this.sourceChannel,
    required this.targetChannel,
    required this.correlationManager,
    this.filter,
  });

  /// Starts processing messages with correlation awareness
  Future<void> start() async {
    _subscription = sourceChannel.receive().listen(
      (message) async {
        try {
          // Apply correlation filter if provided
          if (filter != null && !filter!.shouldProcess(message)) {
            return; // Skip message
          }

          // Process correlated message
          final correlationId = correlationManager.getCorrelationId(message);
          if (correlationId != null) {
            // Add correlation metadata for tracking
            final enrichedMetadata = Map<String, dynamic>.from(
              message.metadata,
            );
            enrichedMetadata['processedByCorrelationProcessor'] = true;
            enrichedMetadata['processingTimestamp'] = DateTime.now()
                .toIso8601String();

            final enrichedMessage = Message(
              payload: message.payload,
              metadata: enrichedMetadata,
              id: message.id,
            );

            await targetChannel.send(enrichedMessage);
          } else {
            // Send message as-is if no correlation
            await targetChannel.send(message);
          }
        } catch (e) {
          // Handle processing errors
          // In a real implementation, you'd have proper error handling
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

  /// Stops processing messages
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  /// Checks if the processor is currently active
  bool get isActive => _subscription != null;
}

/// Predefined correlation managers for EDNet use cases

/// Voting session correlation manager
class VotingSessionCorrelationManager extends BasicCorrelationManager {
  VotingSessionCorrelationManager()
    : super(correlationIdPrefix: 'vote-session');

  /// Starts a new voting session
  String startVotingSession(String electionId, String sessionType) {
    final correlationId = generateCorrelationId();

    final context = CorrelationContext(
      correlationId: correlationId,
      contextType: 'voting-session',
      properties: {
        'electionId': electionId,
        'sessionType': sessionType,
        'status': 'active',
      },
      metadata: {'startedAt': DateTime.now().toIso8601String()},
    );

    _contexts[correlationId] = context;
    return correlationId;
  }

  /// Correlates a vote with a voting session
  Message correlateVote(Message voteMessage, String sessionId) {
    final correlatedMessage = correlateMessage(voteMessage, sessionId);

    // Update session context
    final context = _contexts[sessionId];
    if (context != null) {
      final updatedProperties = Map<String, dynamic>.from(context.properties);
      updatedProperties['voteCount'] =
          (updatedProperties['voteCount'] ?? 0) + 1;

      final updatedContext = context.copyWith(properties: updatedProperties);
      _contexts[sessionId] = updatedContext;
    }

    return correlatedMessage;
  }
}

/// Proposal correlation manager
class ProposalCorrelationManager extends BasicCorrelationManager {
  ProposalCorrelationManager() : super(correlationIdPrefix: 'proposal');

  /// Starts a new proposal workflow
  String startProposalWorkflow(String proposalId, String authorId) {
    final correlationId = generateCorrelationId();

    final context = CorrelationContext(
      correlationId: correlationId,
      contextType: 'proposal-workflow',
      properties: {
        'proposalId': proposalId,
        'authorId': authorId,
        'status': 'draft',
        'amendmentCount': 0,
        'reviewCount': 0,
      },
      metadata: {'createdAt': DateTime.now().toIso8601String()},
    );

    _contexts[correlationId] = context;
    return correlationId;
  }

  /// Correlates an amendment with a proposal
  Message correlateAmendment(
    Message amendmentMessage,
    String proposalWorkflowId,
  ) {
    final correlatedMessage = correlateMessage(
      amendmentMessage,
      proposalWorkflowId,
    );

    // Update proposal context
    final context = _contexts[proposalWorkflowId];
    if (context != null) {
      final updatedProperties = Map<String, dynamic>.from(context.properties);
      updatedProperties['amendmentCount'] =
          (updatedProperties['amendmentCount'] ?? 0) + 1;
      updatedProperties['lastAmendmentAt'] = DateTime.now().toIso8601String();

      final updatedContext = context.copyWith(properties: updatedProperties);
      _contexts[proposalWorkflowId] = updatedContext;
    }

    return correlatedMessage;
  }
}

/// Deliberation correlation manager
class DeliberationCorrelationManager extends BasicCorrelationManager {
  DeliberationCorrelationManager() : super(correlationIdPrefix: 'deliberation');

  /// Starts a new deliberation thread
  String startDeliberationThread(String topicId, String initiatorId) {
    final correlationId = generateCorrelationId();

    final context = CorrelationContext(
      correlationId: correlationId,
      contextType: 'deliberation-thread',
      properties: {
        'topicId': topicId,
        'initiatorId': initiatorId,
        'participantCount': 1,
        'messageCount': 0,
        'status': 'active',
      },
      metadata: {'startedAt': DateTime.now().toIso8601String()},
    );

    _contexts[correlationId] = context;
    return correlationId;
  }

  /// Correlates a deliberation message with a thread
  Message correlateDeliberationMessage(Message message, String threadId) {
    final correlatedMessage = correlateMessage(message, threadId);

    // Update thread context
    final context = _contexts[threadId];
    if (context != null) {
      final updatedProperties = Map<String, dynamic>.from(context.properties);
      updatedProperties['messageCount'] =
          (updatedProperties['messageCount'] ?? 0) + 1;

      // Track unique participants
      final participantId = message.metadata['citizenId'] as String?;
      if (participantId != null) {
        final currentParticipants =
            (updatedProperties['participants'] as List<String>?) ?? [];
        if (!currentParticipants.contains(participantId)) {
          currentParticipants.add(participantId);
        }
        updatedProperties['participantCount'] = currentParticipants.length;
        updatedProperties['participants'] = currentParticipants;
      }

      final updatedContext = context.copyWith(properties: updatedProperties);
      _contexts[threadId] = updatedContext;
    }

    return correlatedMessage;
  }
}

/// Audit trail correlation manager
class AuditTrailCorrelationManager extends BasicCorrelationManager {
  AuditTrailCorrelationManager() : super(correlationIdPrefix: 'audit');

  /// Starts an audit trail for a governance action
  String startAuditTrail(String actionType, String actorId, String targetId) {
    final correlationId = generateCorrelationId();

    final context = CorrelationContext(
      correlationId: correlationId,
      contextType: 'audit-trail',
      properties: {
        'actionType': actionType,
        'actorId': actorId,
        'targetId': targetId,
        'eventCount': 0,
        'status': 'active',
      },
      metadata: {'startedAt': DateTime.now().toIso8601String()},
    );

    _contexts[correlationId] = context;
    return correlationId;
  }

  /// Correlates an audit event with a trail
  Message correlateAuditEvent(Message auditMessage, String trailId) {
    final correlatedMessage = correlateMessage(auditMessage, trailId);

    // Update audit context
    final context = _contexts[trailId];
    if (context != null) {
      final updatedProperties = Map<String, dynamic>.from(context.properties);
      updatedProperties['eventCount'] =
          (updatedProperties['eventCount'] ?? 0) + 1;
      updatedProperties['lastEventAt'] = DateTime.now().toIso8601String();

      final updatedContext = context.copyWith(properties: updatedProperties);
      _contexts[trailId] = updatedContext;
    }

    return correlatedMessage;
  }
}
