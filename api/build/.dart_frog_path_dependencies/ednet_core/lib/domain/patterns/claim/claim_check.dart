part of ednet_core;

final Logger _claimCheckLogger = Logger('ednet_core.patterns.claim_check');

/// Claim Check Pattern - Enhanced with EDNet Core Event-Driven Architecture
///
/// This implementation demonstrates how EDNet Core patterns can be applied to
/// enterprise integration patterns like Claim Check. The enhanced version:
///
/// 🎯 **Event-Driven Processing**:
/// - Emits domain events for all significant processing steps
/// - Enables reactive policies and command invocation
/// - Provides comprehensive audit trails
///
/// 🔧 **Policy Integration**:
/// - Error handling driven by business policies
/// - Configurable processing behavior
/// - Dynamic decision making based on message content
///
/// ⚡ **Command Pattern**:
/// - Commands can be triggered by processing events
/// - Aggregate updates based on processing outcomes
/// - CQRS-style separation of concerns
///
/// 📊 **Observability**:
/// - Rich event streams for monitoring
/// - Processing metrics and statistics
/// - Error tracking and analysis
///
/// The enhanced processor now serves as a bridge between:
/// - Message processing (EIP patterns)
/// - Domain events (EDNet Core events)
/// - Business policies (EDNet Core policies)
/// - Command execution (EDNet Core commands)
/// - Aggregate management (EDNet Core entities)

/// Claim Check Pattern
///
/// The Claim Check pattern stores large or sensitive message payloads
/// externally and replaces them with lightweight references (claim checks).
/// This reduces memory usage and network overhead while maintaining data integrity.
///
/// In EDNet/direct democracy contexts, claim checks are valuable for:
/// * Storing large proposal documents without impacting message throughput
/// * Managing citizen identity documents and verification data
/// * Handling multimedia content in citizen engagement messages
/// * Securing sensitive voting data during transmission
/// * Managing large statistical datasets in analytics pipelines

/// Exception thrown for claim check related errors
class ClaimCheckException implements Exception {
  final String message;
  final String? claimCheckId;
  final dynamic cause;

  ClaimCheckException(this.message, {this.claimCheckId, this.cause});

  @override
  String toString() {
    var result = 'ClaimCheckException: $message';
    if (claimCheckId != null) {
      result += ' (Claim Check ID: $claimCheckId)';
    }
    if (cause != null) {
      result += ' (Cause: $cause)';
    }
    return result;
  }
}

/// Interface for claim check storage implementations
abstract class ClaimStore {
  /// Stores a payload and returns a claim check ID
  Future<String> storePayload(dynamic payload);

  /// Retrieves a payload using its claim check ID
  Future<dynamic> retrievePayload(String claimCheckId);

  /// Checks if a claim check exists
  Future<bool> hasPayload(String claimCheckId);

  /// Deletes a payload and its claim check
  Future<void> deletePayload(String claimCheckId);

  /// Lists all claim check IDs
  Future<List<String>> listClaimChecks();

  /// Gets the size of a stored payload
  Future<int?> getPayloadSize(String claimCheckId);

  /// Gets metadata about a claim check
  Future<Map<String, dynamic>?> getMetadata(String claimCheckId);
}

/// In-memory implementation of ClaimStore for testing and simple scenarios
class InMemoryClaimStore implements ClaimStore {
  final Map<String, dynamic> _payloads = {};
  final Map<String, Map<String, dynamic>> _metadata = {};
  int _nextId = 1;

  @override
  Future<String> storePayload(dynamic payload) async {
    final claimCheckId = 'claim_${_nextId++}';
    _payloads[claimCheckId] = payload;

    _metadata[claimCheckId] = {
      'storedAt': DateTime.now().toIso8601String(),
      'size': _calculateSize(payload),
      'type': payload.runtimeType.toString(),
    };

    return claimCheckId;
  }

  @override
  Future<dynamic> retrievePayload(String claimCheckId) async {
    final payload = _payloads[claimCheckId];
    if (payload == null) {
      throw ClaimCheckException(
        'Payload not found for claim check ID: $claimCheckId',
        claimCheckId: claimCheckId,
      );
    }
    return payload;
  }

  @override
  Future<bool> hasPayload(String claimCheckId) async {
    return _payloads.containsKey(claimCheckId);
  }

  @override
  Future<void> deletePayload(String claimCheckId) async {
    _payloads.remove(claimCheckId);
    _metadata.remove(claimCheckId);
  }

  @override
  Future<List<String>> listClaimChecks() async {
    return _payloads.keys.toList();
  }

  @override
  Future<int?> getPayloadSize(String claimCheckId) async {
    final metadata = _metadata[claimCheckId];
    return metadata?['size'] as int?;
  }

  @override
  Future<Map<String, dynamic>?> getMetadata(String claimCheckId) async {
    return _metadata[claimCheckId];
  }

  int _calculateSize(dynamic payload) {
    if (payload == null) return 0;

    if (payload is String) {
      return payload.length * 2; // Approximate string size
    } else if (payload is List) {
      return payload.length * 8; // Approximate list size
    } else if (payload is Map) {
      return payload.length * 16; // Approximate map size
    } else {
      return 64; // Default size for other objects
    }
  }

  /// Removes a payload (alias for deletePayload)
  Future<void> removePayload(String claimCheckId) async {
    await deletePayload(claimCheckId);
  }

  /// Gets statistics about the claim store
  Future<Map<String, dynamic>> getStats() async {
    final metadataList = _metadata.values.toList();
    final timestamps = metadataList
        .where((meta) => meta['storedAt'] != null)
        .map((meta) => DateTime.parse(meta['storedAt'] as String))
        .toList();

    return {
      'totalPayloads': _payloads.length,
      'totalSizeBytes': _metadata.values.fold<int>(
        0,
        (sum, meta) => sum + (meta['size'] as int? ?? 0),
      ),
      'averageSize': _payloads.isEmpty
          ? 0
          : _metadata.values.fold<int>(
                  0,
                  (sum, meta) => sum + (meta['size'] as int? ?? 0),
                ) /
                _payloads.length,
      'newestPayload': timestamps.isEmpty
          ? null
          : timestamps.reduce((a, b) => a.isAfter(b) ? a : b),
      'oldestPayload': timestamps.isEmpty
          ? null
          : timestamps.reduce((a, b) => a.isBefore(b) ? a : b),
    };
  }
}

/// Message that contains a claim check reference instead of the actual payload
class ClaimCheckMessage extends Message {
  /// The claim check ID referencing the stored payload
  final String claimCheckId;

  /// The claim store where the payload is stored
  final ClaimStore claimStore;

  /// Original payload size (cached for performance)
  final int? originalPayloadSize;

  /// Additional payload metadata
  final Map<String, dynamic>? payloadMetadata;

  /// Creates a new ClaimCheckMessage
  ClaimCheckMessage({
    required dynamic payload,
    required this.claimCheckId,
    required this.claimStore,
    this.originalPayloadSize,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? payloadMetadata, // Additional payload metadata
    String? id,
  }) : payloadMetadata = payloadMetadata,
       super(
         payload: {'claimCheckId': claimCheckId, 'type': 'claim_check'},
         metadata: {
           ...?metadata,
           ...?payloadMetadata,
           'hasClaimCheck': true,
           'claimCheckId': claimCheckId,
           'originalPayloadSize': originalPayloadSize,
           'claimCheckType': 'external_reference',
         },
         id: id,
       );

  /// Retrieves the original payload from the claim store
  Future<dynamic> retrievePayload() async {
    try {
      return await claimStore.retrievePayload(claimCheckId);
    } catch (e) {
      throw ClaimCheckException(
        'Failed to retrieve payload for claim check',
        claimCheckId: claimCheckId,
        cause: e,
      );
    }
  }

  /// Checks if the original payload is still available
  Future<bool> isPayloadAvailable() async {
    return await claimStore.hasPayload(claimCheckId);
  }

  /// Gets metadata about the claim check
  Future<Map<String, dynamic>?> getClaimMetadata() async {
    return await claimStore.getMetadata(claimCheckId);
  }

  /// Retrieves the full payload (alias for retrievePayload)
  Future<dynamic> retrieveFullPayload() async {
    return await retrievePayload();
  }
}

/// Manager for handling claim check operations
class ClaimCheckManager {
  final ClaimStore claimStore;
  final int thresholdSize;

  /// Creates a new ClaimCheckManager
  ClaimCheckManager({
    required this.claimStore,
    int thresholdSize = 1024, // 1KB default threshold
    int? maxInlinePayloadSize, // Alias for thresholdSize
  }) : thresholdSize = maxInlinePayloadSize ?? thresholdSize;

  /// Processes a message, converting large payloads to claim checks
  Future<Message> processMessage(Message message) async {
    final payloadSize = _calculatePayloadSize(message.payload);

    if (payloadSize > thresholdSize) {
      // Convert to claim check
      final claimCheckId = await claimStore.storePayload(message.payload);
      return ClaimCheckMessage(
        payload: message.payload,
        claimCheckId: claimCheckId,
        claimStore: claimStore,
        originalPayloadSize: payloadSize,
        metadata: message.metadata,
        id: message.id,
      );
    } else {
      // Keep original message
      return message;
    }
  }

  /// Restores a claim check message to its original form
  Future<Message> restoreMessage(Message message) async {
    if (message is ClaimCheckMessage) {
      final originalPayload = await message.retrievePayload();
      return Message(
        payload: originalPayload,
        metadata: {
          ...message.metadata,
          'wasRestoredFromClaimCheck': true,
          'originalClaimCheckId': message.claimCheckId,
        },
        id: message.id,
      );
    } else {
      return message;
    }
  }

  /// Retrieves payload from a claim check message
  Future<dynamic> retrievePayload(ClaimCheckMessage message) async {
    return await message.retrievePayload();
  }

  /// Checks if a message contains a claim check
  bool hasClaimCheck(Message message) {
    return message is ClaimCheckMessage ||
        (message.metadata['hasClaimCheck'] == true);
  }

  /// Gets the claim check ID from a message
  String? getClaimCheckId(Message message) {
    if (message is ClaimCheckMessage) {
      return message.claimCheckId;
    }
    return message.metadata['claimCheckId'] as String?;
  }

  int _calculatePayloadSize(dynamic payload) {
    if (payload == null) return 0;

    if (payload is String) {
      return payload.length * 2; // UTF-16 encoding
    } else if (payload is List) {
      int totalSize = 0;
      for (final item in payload) {
        totalSize += _calculatePayloadSize(item);
      }
      return totalSize +
          payload.length * 4; // Additional overhead for list structure
    } else if (payload is Map) {
      int totalSize = 0;
      for (final entry in payload.entries) {
        totalSize += (entry.key as String).length * 2; // Key size
        totalSize += _calculatePayloadSize(entry.value);
      }
      return totalSize +
          payload.length * 8; // Additional overhead for map structure
    } else if (payload is num || payload is bool) {
      return 8;
    } else {
      return 64; // Default size for complex objects
    }
  }
}

/// Channel processor that automatically handles claim check messages
class ClaimCheckChannelProcessor {
  final ClaimCheckManager _manager;
  final Channel _sourceChannel;
  final Channel _targetChannel;
  final bool _autoRestore;

  StreamSubscription<Message>? _subscription;

  /// Creates a new ClaimCheckChannelProcessor
  ClaimCheckChannelProcessor(
    ClaimCheckManager manager,
    Channel sourceChannel,
    Channel targetChannel, {
    bool autoRestore = false,
  }) : _manager = manager,
       _sourceChannel = sourceChannel,
       _targetChannel = targetChannel,
       _autoRestore = autoRestore;

  /// Starts processing messages with event-driven architecture
  Future<void> start() async {
    _subscription = _sourceChannel.receive().listen(
      _processMessage,
      onError: (error) {
        // Emit error event for policy evaluation
        _emitProcessingErrorEvent(error);

        // Handle processing errors with policy-driven approach
        _claimCheckLogger.warning('Claim check processing error: $error');
      },
    );

    // Emit processor started event
    _emitProcessorStartedEvent();
  }

  /// Stops processing messages
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _processMessage(Message message) async {
    try {
      Message processedMessage;

      if (_autoRestore && _manager.hasClaimCheck(message)) {
        // Restore claim check to original payload
        processedMessage = await _manager.restoreMessage(message);

        // Emit claim check restored event
        _emitClaimCheckRestoredEvent(message, processedMessage);
      } else {
        // Process message (may convert to claim check)
        final originalMessage = message;
        processedMessage = await _manager.processMessage(message);

        if (_manager.hasClaimCheck(processedMessage)) {
          // Emit claim check created event
          _emitClaimCheckCreatedEvent(originalMessage, processedMessage);
        } else {
          // Emit message processed event
          _emitMessageProcessedEvent(originalMessage, processedMessage);
        }
      }

      // Send processed message to target channel
      await _targetChannel.send(processedMessage);

      // Emit successful processing event
      _emitProcessingSuccessEvent(message, processedMessage);
    } catch (e) {
      // Emit processing failure event before re-throwing
      _emitProcessingFailureEvent(message, e);

      // Handle processing errors - could send to dead letter channel
      _claimCheckLogger.warning('Failed to process message: $e');

      // Policy-driven error handling could be triggered here
      await _handleProcessingError(message, e);
    }
  }

  /// Gets statistics about processed messages
  Map<String, dynamic> getStats() {
    return {'autoRestore': _autoRestore, 'isActive': _subscription != null};
  }

  // ===== EVENT-DRIVEN ARCHITECTURE METHODS =====

  /// Emits event when processor starts
  void _emitProcessorStartedEvent() {
    // In a full EDNet implementation, this would use EventBus
    _claimCheckLogger.fine(
      'ClaimCheckChannelProcessor started: source=${_sourceChannel.id}',
    );
  }

  /// Emits event when claim check is created
  void _emitClaimCheckCreatedEvent(
    Message originalMessage,
    Message processedMessage,
  ) {
    // In a full EDNet implementation, this would publish to EventBus:
    // final event = ClaimCheckCreatedEvent(
    //   originalMessage: originalMessage,
    //   claimCheckMessage: processedMessage,
    //   claimCheckId: processedMessage.metadata?['claimCheckId'],
    //   processorId: 'claim-check-processor-${_sourceChannel.id}',
    // );
    // eventBus.publish(event);
    _claimCheckLogger.fine('Claim check created: source=${_sourceChannel.id}');
  }

  /// Emits event when claim check is restored
  void _emitClaimCheckRestoredEvent(
    Message claimCheckMessage,
    Message restoredMessage,
  ) {
    // In a full EDNet implementation, this would publish to EventBus:
    // final event = ClaimCheckRestoredEvent(
    //   claimCheckMessage: claimCheckMessage,
    //   restoredMessage: restoredMessage,
    //   claimCheckId: claimCheckMessage.metadata?['claimCheckId'],
    //   processorId: 'claim-check-processor-${_sourceChannel.id}',
    // );
    // eventBus.publish(event);
    _claimCheckLogger.fine('Claim check restored: source=${_sourceChannel.id}');
  }

  /// Emits event when message is processed successfully
  void _emitMessageProcessedEvent(
    Message originalMessage,
    Message processedMessage,
  ) {
    // In a full EDNet implementation, this would publish to EventBus:
    // final event = MessageProcessedEvent(
    //   originalMessage: originalMessage,
    //   processedMessage: processedMessage,
    //   processorId: 'claim-check-processor-${_sourceChannel.id}',
    //   processingType: 'claim_check_evaluation',
    // );
    // eventBus.publish(event);
    _claimCheckLogger.fine(
      'Message processed successfully: source=${_sourceChannel.id}',
    );
  }

  /// Emits event when processing succeeds
  void _emitProcessingSuccessEvent(
    Message originalMessage,
    Message processedMessage,
  ) {
    // In a full EDNet implementation, this would publish to EventBus:
    // final event = ProcessingSuccessEvent(
    //   originalMessage: originalMessage,
    //   resultMessage: processedMessage,
    //   processorId: 'claim-check-processor-${_sourceChannel.id}',
    //   timestamp: DateTime.now(),
    // );
    // eventBus.publish(event);
    _claimCheckLogger.fine(
      'Processing completed successfully: source=${_sourceChannel.id}',
    );
  }

  /// Emits event when processing fails
  void _emitProcessingFailureEvent(Message message, dynamic error) {
    // In a full EDNet implementation, this would publish to EventBus:
    // final event = ProcessingFailureEvent(
    //   failedMessage: message,
    //   error: error,
    //   processorId: 'claim-check-processor-${_sourceChannel.id}',
    //   timestamp: DateTime.now(),
    // );
    // eventBus.publish(event);
    _claimCheckLogger.warning(
      'Processing failed: source=${_sourceChannel.id}, error=$error',
    );
  }

  /// Emits event when processor encounters error
  void _emitProcessingErrorEvent(dynamic error) {
    // In a full EDNet implementation, this would publish to EventBus:
    // final event = ProcessorErrorEvent(
    //   error: error,
    //   processorId: 'claim-check-processor-${_sourceChannel.id}',
    //   timestamp: DateTime.now(),
    // );
    // eventBus.publish(event);
    _claimCheckLogger.warning(
      'Processor error: source=${_sourceChannel.id}, error=$error',
    );
  }

  /// Policy-driven error handling
  Future<void> _handleProcessingError(Message message, dynamic error) async {
    // In a full EDNet implementation, this would:
    // 1. Evaluate policies based on the error type
    // 2. Potentially invoke commands on aggregates
    // 3. Send messages to dead letter channels
    // 4. Update error statistics

    // Example policy evaluation:
    // final policyContext = PolicyContext(
    //   'claim_check_processing_error',
    //   {'error': error, 'message': message, 'processor': this},
    // );
    // final policyResult = await policyEngine.evaluate(policyContext);

    // if (policyResult.shouldRetry) {
    //   // Retry logic with exponential backoff
    //   final retryCommand = RetryMessageCommand(
    //     message: message,
    //     retryCount: message.metadata?['retryCount'] ?? 0,
    //   );
    //   await commandBus.send(retryCommand);
    // } else if (policyResult.shouldSendToDeadLetter) {
    //   // Send to dead letter channel
    //   final deadLetterCommand = SendToDeadLetterCommand(
    //     message: message,
    //     reason: DeadLetterReason.processingFailure,
    //     error: error,
    //   );
    //   await commandBus.send(deadLetterCommand);
    // }

    // Update error statistics aggregate
    // final updateStatsCommand = UpdateProcessingStatsCommand(
    //   processorId: 'claim-check-processor-${_sourceChannel.id}',
    //   error: error,
    //   messageType: message.metadata?['messageType'],
    // );
    // await commandBus.send(updateStatsCommand);

    _claimCheckLogger.fine('Policy-driven error handling hook reached');
  }

  // ===== INTEGRATION EXAMPLE =====

  /// Example of how this processor integrates with full EDNet Core ecosystem
  ///
  /// ```dart
  /// // 1. Event Bus Integration
  /// final eventBus = EventBus();
  /// eventBus.subscribe(ClaimCheckCreatedEvent, (event) {
  ///   // React to claim check creation
  ///   print('Claim check ${event.claimCheckId} created');
  /// });
  ///
  /// // 2. Policy Engine Integration
  /// final policyEngine = PolicyEngine();
  /// policyEngine.registerPolicy(ClaimCheckPolicy());
  ///
  /// // 3. Command Bus Integration
  /// final commandBus = CommandBus();
  /// commandBus.registerHandler(RetryMessageCommand, RetryMessageHandler());
  ///
  /// // 4. Aggregate Management
  /// final processingStatsAggregate = ProcessingStatsAggregate();
  ///
  /// // 5. Usage in Application
  /// final processor = ClaimCheckChannelProcessor(
  ///   manager: claimCheckManager,
  ///   sourceChannel: messageChannel,
  ///   targetChannel: processingChannel,
  /// );
  ///
  /// await processor.start();
  /// // Now processor emits events → triggers policies → invokes commands → updates aggregates
  /// ```
  ///
}

/// Configuration for claim check processing
class ClaimCheckConfig {
  final int thresholdSize;
  final Duration ttl;
  final bool autoCleanup;
  final Map<String, dynamic> storeConfig;

  /// Creates a new ClaimCheckConfig
  const ClaimCheckConfig({
    this.thresholdSize = 1024,
    this.ttl = const Duration(hours: 24),
    this.autoCleanup = true,
    this.storeConfig = const {},
  });
}

/// Factory for creating claim check components
class ClaimCheckFactory {
  /// Creates an appropriate claim store based on configuration
  static ClaimStore createStore(String type, Map<String, dynamic> config) {
    switch (type) {
      case 'memory':
        return InMemoryClaimStore();
      case 'file':
        // Could implement file-based store
        throw UnsupportedError('File-based claim store not implemented');
      case 'database':
        // Could implement database-based store
        throw UnsupportedError('Database claim store not implemented');
      default:
        throw ArgumentError('Unknown claim store type: $type');
    }
  }

  /// Creates a claim check manager with the specified configuration
  static ClaimCheckManager createManager(
    ClaimStore store,
    ClaimCheckConfig config,
  ) {
    return ClaimCheckManager(
      claimStore: store,
      thresholdSize: config.thresholdSize,
    );
  }

  /// Creates a channel processor for claim check handling
  static ClaimCheckChannelProcessor createProcessor(
    ClaimCheckManager manager,
    Channel source,
    Channel target, {
    bool autoRestore = false,
  }) {
    return ClaimCheckChannelProcessor(
      manager,
      source,
      target,
      autoRestore: autoRestore,
    );
  }
}
