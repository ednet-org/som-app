part of ednet_core;

/// Request-Reply Pattern
///
/// The Request-Reply pattern enables synchronous communication where a sender
/// sends a request message and expects a reply message in response. This pattern
/// is essential for scenarios requiring immediate responses and confirmation.
///
/// In EDNet/direct democracy contexts, request-reply is crucial for:
/// * Vote casting with immediate confirmation and validation
/// * Proposal submission with instant feedback and validation
/// * Citizen authentication and authorization requests
/// * Real-time status queries and citizen support
/// * Synchronous validation of citizen actions and inputs
/// * Immediate feedback on deliberation participation

/// Abstract interface for request-reply communication
abstract class RequestReplyChannel {
  /// The channel for sending requests
  Channel get requestChannel;

  /// The channel for receiving replies
  Channel get replyChannel;

  /// Sends a request and waits for a reply
  Future<Message> sendRequest(Message request, {Duration? timeout});

  /// Sends a reply to a request
  Future<void> sendReply(Message reply, String correlationId);

  /// Starts listening for requests and handling replies
  Future<void> start();

  /// Stops listening for requests and handling replies
  Future<void> stop();

  /// Gets request-reply statistics
  RequestReplyStats getStats();
}

/// Request-reply statistics
class RequestReplyStats {
  final int totalRequests;
  final int totalReplies;
  final int successfulRequests;
  final int failedRequests;
  final int timedOutRequests;
  final Duration averageResponseTime;
  final Map<String, int> requestsByType;
  final DateTime lastActivity;

  RequestReplyStats({
    required this.totalRequests,
    required this.totalReplies,
    required this.successfulRequests,
    required this.failedRequests,
    required this.timedOutRequests,
    required this.averageResponseTime,
    required this.requestsByType,
    DateTime? lastActivity,
  }) : lastActivity = lastActivity ?? DateTime.now();

  double get successRate =>
      totalRequests > 0 ? successfulRequests / totalRequests : 0.0;

  double get replyRate =>
      totalRequests > 0 ? totalReplies / totalRequests : 0.0;

  @override
  String toString() {
    return 'RequestReplyStats{requests: $totalRequests, replies: $totalReplies, '
        'success: ${(successRate * 100).round()}%, avgTime: $averageResponseTime}';
  }
}

/// Request message with reply expectations
class RequestMessage extends Message {
  final String replyToChannel;
  final Duration? timeout;
  final Map<String, dynamic> requestMetadata;

  RequestMessage({
    required dynamic payload,
    required this.replyToChannel,
    Map<String, dynamic>? metadata,
    this.timeout,
    Map<String, dynamic>? requestMetadata,
  }) : requestMetadata = requestMetadata ?? {},
       super(
         payload: payload,
         metadata: {
           ...?metadata,
           if (!(metadata?.containsKey('messageType') ?? false))
             'messageType': 'request',
           'replyTo': replyToChannel,
           'timestamp': DateTime.now().toIso8601String(),
           if (timeout != null) 'timeout': timeout.inMilliseconds,
         },
       );

  /// Creates a reply message for this request
  ReplyMessage createReply(
    dynamic replyPayload, {
    Map<String, dynamic>? replyMetadata,
  }) {
    return ReplyMessage(
      payload: replyPayload,
      originalRequestId: id,
      replyMetadata: replyMetadata,
    );
  }
}

/// Reply message correlated to a request
class ReplyMessage extends Message {
  final String originalRequestId;

  ReplyMessage({
    required dynamic payload,
    required this.originalRequestId,
    Map<String, dynamic>? metadata,
    Map<String, dynamic>? replyMetadata,
  }) : super(
         payload: payload,
         metadata: {
           ...?metadata,
           'messageType': 'reply',
           'originalRequestId': originalRequestId,
           'timestamp': DateTime.now().toIso8601String(),
           if (replyMetadata != null) ...replyMetadata,
         },
       );
}

/// Request handler interface
abstract class RequestHandler {
  /// Handles a request and returns a reply
  Future<Message> handleRequest(Message request);

  /// Checks if this handler can process the given request
  bool canHandle(Message request);

  /// Gets handler statistics
  RequestHandlerStats getStats();
}

/// Request handler statistics
class RequestHandlerStats {
  final int requestsHandled;
  final int successfulReplies;
  final int failedReplies;
  final Duration averageProcessingTime;
  final Map<String, int> requestsByType;

  RequestHandlerStats({
    required this.requestsHandled,
    required this.successfulReplies,
    required this.failedReplies,
    required this.averageProcessingTime,
    required this.requestsByType,
  });

  double get successRate =>
      requestsHandled > 0 ? successfulReplies / requestsHandled : 0.0;
}

/// Basic request-reply channel implementation
class BasicRequestReplyChannel implements RequestReplyChannel {
  final Channel _requestChannel;
  final Channel _replyChannel;
  final Map<String, Completer<Message>> _pendingRequests = {};
  final RequestReplyStatsTracker _statsTracker;
  StreamSubscription<Message>? _replySubscription;

  BasicRequestReplyChannel(this._requestChannel, this._replyChannel)
    : _statsTracker = RequestReplyStatsTracker();

  @override
  Channel get requestChannel => _requestChannel;

  @override
  Channel get replyChannel => _replyChannel;

  @override
  Future<Message> sendRequest(Message request, {Duration? timeout}) async {
    if (request is! RequestMessage) {
      throw ArgumentError('Request must be a RequestMessage');
    }

    final completer = Completer<Message>();
    final correlationId = request.id;

    _pendingRequests[correlationId] = completer;
    _statsTracker.recordRequest(request);

    try {
      await _requestChannel.send(request);

      final effectiveTimeout =
          timeout ?? request.timeout ?? const Duration(seconds: 30);
      final reply = await completer.future.timeout(effectiveTimeout);

      _statsTracker.recordSuccessfulReply(reply);
      return reply;
    } catch (e) {
      _statsTracker.recordFailedRequest();
      _pendingRequests.remove(correlationId);
      rethrow;
    }
  }

  @override
  Future<void> sendReply(Message reply, String correlationId) async {
    if (reply is! ReplyMessage) {
      throw ArgumentError('Reply must be a ReplyMessage');
    }

    final completer = _pendingRequests.remove(correlationId);
    if (completer != null && !completer.isCompleted) {
      completer.complete(reply);
    }

    await _replyChannel.send(reply);
    _statsTracker.recordReply(reply);
  }

  @override
  Future<void> start() async {
    _replySubscription = _replyChannel.receive().listen(
      (message) {
        if (message is ReplyMessage) {
          final completer = _pendingRequests.remove(message.originalRequestId);
          if (completer != null && !completer.isCompleted) {
            completer.complete(message);
            _statsTracker.recordSuccessfulReply(message);
          }
        }
      },
      onError: (error) {
        // Handle stream errors
      },
      onDone: () {
        // Handle stream completion
      },
    );
  }

  @override
  Future<void> stop() async {
    await _replySubscription?.cancel();
    _replySubscription = null;

    // Complete all pending requests with timeout
    for (final completer in _pendingRequests.values) {
      if (!completer.isCompleted) {
        completer.completeError(TimeoutException('Channel stopped'));
      }
    }
    _pendingRequests.clear();
  }

  @override
  RequestReplyStats getStats() => _statsTracker.getStats();
}

/// Statistics tracker for request-reply operations
class RequestReplyStatsTracker {
  int _totalRequests = 0;
  int _totalReplies = 0;
  int _successfulRequests = 0;
  int _failedRequests = 0;
  int _timedOutRequests = 0;
  final List<Duration> _responseTimes = [];
  final Map<String, int> _requestsByType = {};
  DateTime? _lastActivity;

  void recordRequest(Message request) {
    _totalRequests++;
    _lastActivity = DateTime.now();

    final messageType = request.metadata['messageType'] as String? ?? 'unknown';
    _requestsByType[messageType] = (_requestsByType[messageType] ?? 0) + 1;
  }

  void recordReply(Message reply) {
    _totalReplies++;
    _lastActivity = DateTime.now();
  }

  void recordSuccessfulReply(Message reply) {
    _successfulRequests++;
  }

  void recordFailedRequest() {
    _failedRequests++;
  }

  void recordTimeout() {
    _timedOutRequests++;
  }

  void recordResponseTime(Duration time) {
    _responseTimes.add(time);
  }

  RequestReplyStats getStats() {
    final averageResponseTime = _responseTimes.isNotEmpty
        ? _responseTimes.reduce((a, b) => a + b) ~/ _responseTimes.length
        : Duration.zero;

    return RequestReplyStats(
      totalRequests: _totalRequests,
      totalReplies: _totalReplies,
      successfulRequests: _successfulRequests,
      failedRequests: _failedRequests,
      timedOutRequests: _timedOutRequests,
      averageResponseTime: averageResponseTime,
      requestsByType: Map.from(_requestsByType),
      lastActivity: _lastActivity,
    );
  }
}

/// Request-reply handler that processes requests and generates replies
class RequestReplyHandler {
  final List<RequestHandler> _handlers;
  final RequestReplyStatsTracker _statsTracker;

  RequestReplyHandler(this._handlers)
    : _statsTracker = RequestReplyStatsTracker();

  /// Processes a request and returns a reply
  Future<Message> processRequest(Message request) async {
    final startTime = DateTime.now();

    try {
      for (final handler in _handlers) {
        if (handler.canHandle(request)) {
          final reply = await handler.handleRequest(request);
          final processingTime = DateTime.now().difference(startTime);

          _statsTracker.recordRequest(request);
          _statsTracker.recordSuccessfulReply(reply);
          _statsTracker.recordResponseTime(processingTime);

          return reply;
        }
      }

      // No handler found
      _statsTracker.recordRequest(request);
      _statsTracker.recordFailedRequest();

      throw ArgumentError('No handler found for request: ${request.metadata}');
    } catch (e) {
      final processingTime = DateTime.now().difference(startTime);
      _statsTracker.recordRequest(request);
      _statsTracker.recordFailedRequest();
      _statsTracker.recordResponseTime(processingTime);

      rethrow;
    }
  }

  /// Adds a request handler
  void addHandler(RequestHandler handler) {
    _handlers.add(handler);
  }

  /// Removes a request handler
  void removeHandler(RequestHandler handler) {
    _handlers.remove(handler);
  }

  /// Gets handler statistics
  Map<String, dynamic> getStats() {
    final overallStats = _statsTracker.getStats();
    final handlerStats = <String, RequestHandlerStats>{};

    for (final handler in _handlers) {
      handlerStats[handler.runtimeType.toString()] = handler.getStats();
    }

    return {
      'overall': {
        'totalRequests': overallStats.totalRequests,
        'successfulRequests': overallStats.successfulRequests,
        'failedRequests': overallStats.failedRequests,
        'averageResponseTime': overallStats.averageResponseTime.inMilliseconds,
        'successRate': overallStats.successRate,
      },
      'handlers': handlerStats,
    };
  }
}

/// Base request handler implementation
abstract class BaseRequestHandler implements RequestHandler {
  final RequestHandlerStatsTracker _statsTracker = RequestHandlerStatsTracker();

  @override
  Future<Message> handleRequest(Message request) async {
    final startTime = DateTime.now();

    try {
      final reply = await processRequest(request);
      final processingTime = DateTime.now().difference(startTime);

      _statsTracker.recordSuccessfulReply(processingTime);
      return reply;
    } catch (e) {
      final processingTime = DateTime.now().difference(startTime);
      _statsTracker.recordFailedReply(processingTime);
      rethrow;
    }
  }

  /// Processes the request - to be implemented by subclasses
  Future<Message> processRequest(Message request);

  @override
  RequestHandlerStats getStats() => _statsTracker.getStats();
}

/// Statistics tracker for individual request handlers
class RequestHandlerStatsTracker {
  int _requestsHandled = 0;
  int _successfulReplies = 0;
  int _failedReplies = 0;
  final List<Duration> _processingTimes = [];
  final Map<String, int> _requestsByType = {};

  void recordSuccessfulReply(Duration processingTime) {
    _requestsHandled++;
    _successfulReplies++;
    _processingTimes.add(processingTime);
  }

  void recordFailedReply(Duration processingTime) {
    _requestsHandled++;
    _failedReplies++;
    _processingTimes.add(processingTime);
  }

  RequestHandlerStats getStats() {
    final averageProcessingTime = _processingTimes.isNotEmpty
        ? _processingTimes.reduce((a, b) => a + b) ~/ _processingTimes.length
        : Duration.zero;

    return RequestHandlerStats(
      requestsHandled: _requestsHandled,
      successfulReplies: _successfulReplies,
      failedReplies: _failedReplies,
      averageProcessingTime: averageProcessingTime,
      requestsByType: Map.from(_requestsByType),
    );
  }
}

/// Predefined request handlers for EDNet use cases

/// Vote request handler
class VoteRequestHandler extends BaseRequestHandler {
  @override
  bool canHandle(Message request) {
    return request.metadata['messageType'] == 'vote_request';
  }

  @override
  Future<Message> processRequest(Message request) async {
    // Simulate vote processing
    await Future.delayed(const Duration(milliseconds: 50));

    final voteData = request.payload as Map<String, dynamic>;
    final voterId = voteData['voterId'] as String?;
    final candidate = voteData['candidate'] as String?;

    // Validate vote
    final isValid = await _validateVote(voterId ?? '', candidate ?? '');

    return ReplyMessage(
      payload: {
        'status': isValid ? 'confirmed' : 'rejected',
        'voterId': voterId,
        'candidate': candidate,
        'timestamp': DateTime.now().toIso8601String(),
        'transactionId': 'vote-${DateTime.now().millisecondsSinceEpoch}',
      },
      originalRequestId: request.id,
      replyMetadata: {
        'validation': {
          'passed': isValid,
          'reason': isValid ? 'Vote accepted' : 'Invalid voter or candidate',
        },
      },
    );
  }

  Future<bool> _validateVote(String voterId, String candidate) async {
    // Simulate validation logic
    await Future.delayed(const Duration(milliseconds: 20));
    return voterId.isNotEmpty && candidate.isNotEmpty;
  }
}

/// Authentication request handler
class AuthenticationRequestHandler extends BaseRequestHandler {
  @override
  bool canHandle(Message request) {
    return request.metadata['messageType'] == 'auth_request';
  }

  @override
  Future<Message> processRequest(Message request) async {
    // Simulate authentication processing
    await Future.delayed(const Duration(milliseconds: 30));

    final authData = request.payload as Map<String, dynamic>;
    final citizenId = authData['citizenId'];
    final credentials = authData['credentials'];

    // Validate credentials
    final isAuthenticated = await _validateCredentials(citizenId, credentials);

    return ReplyMessage(
      payload: {
        'authenticated': isAuthenticated,
        'citizenId': citizenId,
        'sessionToken': isAuthenticated ? _generateSessionToken() : null,
        'timestamp': DateTime.now().toIso8601String(),
        'permissions': isAuthenticated ? ['vote', 'propose', 'deliberate'] : [],
      },
      originalRequestId: request.id,
      replyMetadata: {
        'authentication': {
          'method': 'credentials',
          'success': isAuthenticated,
          'sessionCreated': isAuthenticated,
        },
      },
    );
  }

  Future<bool> _validateCredentials(
    String citizenId,
    Map<String, dynamic> credentials,
  ) async {
    // Simulate credential validation
    await Future.delayed(const Duration(milliseconds: 15));
    return citizenId.isNotEmpty && credentials.containsKey('password');
  }

  String _generateSessionToken() {
    return 'session-${DateTime.now().millisecondsSinceEpoch}-${DateTime.now().microsecondsSinceEpoch}';
  }
}

/// Proposal validation request handler
class ProposalValidationRequestHandler extends BaseRequestHandler {
  @override
  bool canHandle(Message request) {
    return request.metadata['messageType'] == 'proposal_validation_request';
  }

  @override
  Future<Message> processRequest(Message request) async {
    // Simulate proposal validation processing
    await Future.delayed(const Duration(milliseconds: 100));

    final proposalData = request.payload as Map<String, dynamic>;
    final proposalId = proposalData['proposalId'];
    final content = proposalData['content'];

    // Validate proposal
    final validation = await _validateProposal(proposalId, content);

    return ReplyMessage(
      payload: {
        'proposalId': proposalId,
        'validation': validation,
        'timestamp': DateTime.now().toIso8601String(),
        'validationId': 'val-${DateTime.now().millisecondsSinceEpoch}',
      },
      originalRequestId: request.id,
      replyMetadata: {
        'validation': {
          'passed': validation['passed'],
          'checks': validation['checks'],
          'warnings': validation['warnings'],
        },
      },
    );
  }

  Future<Map<String, dynamic>> _validateProposal(
    String proposalId,
    String content,
  ) async {
    // Simulate validation logic
    await Future.delayed(const Duration(milliseconds: 50));

    final checks = [
      {'name': 'content_length', 'passed': content.length > 10},
      {'name': 'proposal_id_format', 'passed': proposalId.startsWith('prop-')},
      {'name': 'content_safety', 'passed': !content.contains('inappropriate')},
    ];

    final passed = checks.every((check) => check['passed'] as bool);
    final warnings = passed ? [] : ['Some validation checks failed'];

    return {'passed': passed, 'checks': checks, 'warnings': warnings};
  }
}

/// Status query request handler
class StatusQueryRequestHandler extends BaseRequestHandler {
  @override
  bool canHandle(Message request) {
    return request.metadata['messageType'] == 'status_query';
  }

  @override
  Future<Message> processRequest(Message request) async {
    // Simulate status query processing
    await Future.delayed(const Duration(milliseconds: 25));

    final queryData = request.payload as Map<String, dynamic>;
    final queryType = queryData['queryType'];

    // Get status based on query type
    final status = await _getStatus(queryType);

    return ReplyMessage(
      payload: {
        'queryType': queryType,
        'status': status,
        'timestamp': DateTime.now().toIso8601String(),
        'responseId': 'status-${DateTime.now().millisecondsSinceEpoch}',
      },
      originalRequestId: request.id,
      replyMetadata: {
        'query': {
          'type': queryType,
          'responseTime': DateTime.now().toIso8601String(),
        },
      },
    );
  }

  Future<Map<String, dynamic>> _getStatus(String queryType) async {
    // Simulate status retrieval
    await Future.delayed(const Duration(milliseconds: 10));

    switch (queryType) {
      case 'election':
        return {
          'status': 'active',
          'currentPhase': 'voting',
          'timeRemaining': '2 hours 30 minutes',
          'totalVotes': 15420,
          'turnout': 68.5,
        };
      case 'system':
        return {
          'status': 'healthy',
          'uptime': '99.9%',
          'activeUsers': 1250,
          'responseTime': '45ms',
        };
      case 'proposal':
        return {
          'status': 'processing',
          'pendingProposals': 23,
          'approvedToday': 5,
          'averageProcessingTime': '2.3 hours',
        };
      default:
        return {
          'status': 'unknown',
          'message': 'Unknown query type: $queryType',
        };
    }
  }
}

/// Support request handler
class SupportRequestHandler extends BaseRequestHandler {
  @override
  bool canHandle(Message request) {
    return request.metadata['messageType'] == 'support_request';
  }

  @override
  Future<Message> processRequest(Message request) async {
    // Simulate support request processing
    await Future.delayed(const Duration(milliseconds: 75));

    final supportData = request.payload as Map<String, dynamic>;
    final citizenId = supportData['citizenId'];
    final issue = supportData['issue'];

    // Process support request
    final supportResponse = await _processSupportRequest(citizenId, issue);

    return ReplyMessage(
      payload: {
        'citizenId': citizenId,
        'issue': issue,
        'supportResponse': supportResponse,
        'timestamp': DateTime.now().toIso8601String(),
        'ticketId': 'support-${DateTime.now().millisecondsSinceEpoch}',
      },
      originalRequestId: request.id,
      replyMetadata: {
        'support': {
          'category': supportResponse['category'],
          'priority': supportResponse['priority'],
          'estimatedResponseTime': supportResponse['estimatedResponseTime'],
        },
      },
    );
  }

  Future<Map<String, dynamic>> _processSupportRequest(
    String citizenId,
    String issue,
  ) async {
    // Simulate support processing
    await Future.delayed(const Duration(milliseconds: 40));

    // Categorize the issue
    String category;
    String priority;
    String estimatedResponseTime;

    if (issue.contains('vote') || issue.contains('election')) {
      category = 'voting';
      priority = 'high';
      estimatedResponseTime = '30 minutes';
    } else if (issue.contains('proposal')) {
      category = 'proposal';
      priority = 'medium';
      estimatedResponseTime = '2 hours';
    } else if (issue.contains('technical') || issue.contains('login')) {
      category = 'technical';
      priority = 'high';
      estimatedResponseTime = '1 hour';
    } else {
      category = 'general';
      priority = 'low';
      estimatedResponseTime = '4 hours';
    }

    return {
      'category': category,
      'priority': priority,
      'estimatedResponseTime': estimatedResponseTime,
      'message':
          'Your support request has been received and is being processed.',
      'nextSteps': [
        'Check your citizen dashboard for updates',
        'You will receive an email confirmation',
        'Our support team will contact you within the estimated time',
      ],
    };
  }
}

/// EDNet Democracy Request-Reply System
class EDNetRequestReplySystem {
  final RequestReplyHandler _handler;
  final Map<String, BasicRequestReplyChannel> _channels = {};

  EDNetRequestReplySystem() : _handler = RequestReplyHandler([]) {
    _initializeHandlers();
  }

  void _initializeHandlers() {
    _handler.addHandler(VoteRequestHandler());
    _handler.addHandler(AuthenticationRequestHandler());
    _handler.addHandler(ProposalValidationRequestHandler());
    _handler.addHandler(StatusQueryRequestHandler());
    _handler.addHandler(SupportRequestHandler());
  }

  /// Creates a request-reply channel for a specific service
  BasicRequestReplyChannel createChannel(String serviceName) {
    final requestChannel = InMemoryChannel(
      id: '$serviceName-requests',
      broadcast: true,
    );
    final replyChannel = InMemoryChannel(
      id: '$serviceName-replies',
      broadcast: true,
    );

    final channel = BasicRequestReplyChannel(requestChannel, replyChannel);
    _channels[serviceName] = channel;

    return channel;
  }

  /// Gets an existing channel
  BasicRequestReplyChannel? getChannel(String serviceName) {
    return _channels[serviceName];
  }

  /// Processes a request through the handler system
  Future<Message> processRequest(Message request) async {
    return _handler.processRequest(request);
  }

  /// Sends a vote request
  Future<Message> sendVoteRequest(
    String voterId,
    String candidate, {
    Duration? timeout,
  }) async {
    final request = Message(
      payload: {
        'voterId': voterId,
        'candidate': candidate,
        'timestamp': DateTime.now().toIso8601String(),
      },
      metadata: {'messageType': 'vote_request'},
    );

    return _handler.processRequest(request);
  }

  /// Sends an authentication request
  Future<Message> sendAuthenticationRequest(
    String citizenId,
    Map<String, dynamic> credentials, {
    Duration? timeout,
  }) async {
    final request = Message(
      payload: {
        'citizenId': citizenId,
        'credentials': credentials,
        'timestamp': DateTime.now().toIso8601String(),
      },
      metadata: {'messageType': 'auth_request'},
    );

    return _handler.processRequest(request);
  }

  /// Sends a proposal validation request
  Future<Message> sendProposalValidationRequest(
    String proposalId,
    String content, {
    Duration? timeout,
  }) async {
    final request = Message(
      payload: {
        'proposalId': proposalId,
        'content': content,
        'timestamp': DateTime.now().toIso8601String(),
      },
      metadata: {'messageType': 'proposal_validation_request'},
    );

    return _handler.processRequest(request);
  }

  /// Sends a status query request
  Future<Message> sendStatusQueryRequest(
    String queryType, {
    Duration? timeout,
  }) async {
    final request = Message(
      payload: {
        'queryType': queryType,
        'timestamp': DateTime.now().toIso8601String(),
      },
      metadata: {'messageType': 'status_query'},
    );

    return _handler.processRequest(request);
  }

  /// Sends a support request
  Future<Message> sendSupportRequest(
    String citizenId,
    String issue, {
    Duration? timeout,
  }) async {
    final request = Message(
      payload: {
        'citizenId': citizenId,
        'issue': issue,
        'timestamp': DateTime.now().toIso8601String(),
      },
      metadata: {'messageType': 'support_request'},
    );

    return _handler.processRequest(request);
  }

  /// Gets system statistics
  Map<String, dynamic> getSystemStats() {
    return {
      'handlers': _handler.getStats(),
      'channels': <String, dynamic>{}, // No channels in simplified architecture
    };
  }

  /// Shuts down all channels
  Future<void> shutdown() async {
    for (final channel in _channels.values) {
      await channel.stop();
    }
    _channels.clear();
  }
}
