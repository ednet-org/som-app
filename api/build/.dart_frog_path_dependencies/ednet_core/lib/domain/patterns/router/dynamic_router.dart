part of ednet_core;

/// Dynamic Router Pattern
///
/// The Dynamic Router pattern routes messages to different destinations based on
/// changing conditions or rules that can be modified at runtime. Unlike static
/// routers, dynamic routers can have their routing logic updated without restarting
/// the system.
///
/// In EDNet/direct democracy contexts, dynamic routing is crucial for:
/// * Routing citizen inputs to appropriate deliberation forums based on current topics
/// * Directing proposals to relevant expert committees as topics evolve
/// * Adapting voting routes based on real-time participation levels
/// * Routing notifications to citizens based on changing interests and preferences
/// * Dynamic load balancing across distributed democracy infrastructure

/// Abstract interface for dynamic routing
abstract class DynamicRouter {
  /// The channel from which messages are received for routing
  Channel get sourceChannel;

  /// Routes a message to the appropriate destination(s)
  Future<RouteResult> route(Message message);

  /// Adds a routing rule
  void addRule(RoutingRule rule);

  /// Removes a routing rule
  void removeRule(String ruleId);

  /// Updates an existing routing rule
  void updateRule(RoutingRule rule);

  /// Gets all current routing rules
  List<RoutingRule> getRules();

  /// Gets routing statistics
  RoutingStats getStats();

  /// Clears all routing rules
  void clearRules();
}

/// Result of a routing operation
class RouteResult {
  final Message originalMessage;
  final List<RoutedMessage> routedMessages;
  final List<String> failedDestinations;
  final DateTime timestamp;

  RouteResult({
    required this.originalMessage,
    required this.routedMessages,
    this.failedDestinations = const [],
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get success => failedDestinations.isEmpty;
  int get routedCount => routedMessages.length;
}

/// A message that has been routed to a destination
class RoutedMessage {
  final Message message;
  final Channel destination;
  final String ruleId;
  final Map<String, dynamic> routingMetadata;

  RoutedMessage({
    required this.message,
    required this.destination,
    required this.ruleId,
    this.routingMetadata = const {},
  });
}

/// Routing statistics
class RoutingStats {
  final int totalMessages;
  final int successfullyRouted;
  final int failedRoutes;
  final Map<String, int> routesByRule;
  final Map<String, int> routesByDestination;
  final DateTime lastActivity;

  RoutingStats({
    required this.totalMessages,
    required this.successfullyRouted,
    required this.failedRoutes,
    required this.routesByRule,
    required this.routesByDestination,
    DateTime? lastActivity,
  }) : lastActivity = lastActivity ?? DateTime.now();

  double get successRate =>
      totalMessages > 0 ? successfullyRouted / totalMessages : 0.0;
}

/// Abstract routing rule
abstract class RoutingRule {
  final String id;
  final String description;
  final bool enabled;

  RoutingRule({
    required this.id,
    required this.description,
    this.enabled = true,
  });

  /// Evaluates whether this rule applies to the given message
  bool evaluate(Message message);

  /// Gets the destination channels for this rule
  List<Channel> getDestinations();

  /// Gets rule metadata for tracking/debugging
  Map<String, dynamic> getMetadata();
}

/// Content-based routing rule
class ContentBasedRoutingRule extends RoutingRule {
  final List<RoutingCondition> conditions;
  final List<Channel> destinations;
  final RoutingStrategy strategy;

  ContentBasedRoutingRule({
    required String id,
    required String description,
    required this.destinations,
    this.conditions = const [],
    this.strategy = RoutingStrategy.allMatch,
    bool enabled = true,
  }) : super(id: id, description: description, enabled: enabled);

  @override
  bool evaluate(Message message) {
    if (!enabled) return false;
    if (conditions.isEmpty) return true;

    switch (strategy) {
      case RoutingStrategy.allMatch:
        return conditions.every((condition) => condition.matches(message));
      case RoutingStrategy.anyMatch:
        return conditions.any((condition) => condition.matches(message));
      case RoutingStrategy.noneMatch:
        return !conditions.any((condition) => condition.matches(message));
    }
  }

  @override
  List<Channel> getDestinations() => destinations;

  @override
  Map<String, dynamic> getMetadata() {
    return {
      'type': 'content-based',
      'strategy': strategy.toString(),
      'conditionCount': conditions.length,
      'destinationCount': destinations.length,
    };
  }
}

/// Header-based routing rule
class HeaderBasedRoutingRule extends RoutingRule {
  final Map<String, dynamic> headerCriteria;
  final List<Channel> destinations;

  HeaderBasedRoutingRule({
    required String id,
    required String description,
    required this.headerCriteria,
    required this.destinations,
    bool enabled = true,
  }) : super(id: id, description: description, enabled: enabled);

  @override
  bool evaluate(Message message) {
    if (!enabled) return false;

    return headerCriteria.entries.every((entry) {
      final headerValue = message.metadata[entry.key];
      return headerValue == entry.value;
    });
  }

  @override
  List<Channel> getDestinations() => destinations;

  @override
  Map<String, dynamic> getMetadata() {
    return {
      'type': 'header-based',
      'criteriaCount': headerCriteria.length,
      'destinationCount': destinations.length,
    };
  }
}

/// Script-based routing rule that uses dynamic evaluation
class ScriptBasedRoutingRule extends RoutingRule {
  final String script;
  final List<Channel> destinations;
  final Map<String, dynamic> scriptContext;

  ScriptBasedRoutingRule({
    required String id,
    required String description,
    required this.script,
    required this.destinations,
    this.scriptContext = const {},
    bool enabled = true,
  }) : super(id: id, description: description, enabled: enabled);

  @override
  bool evaluate(Message message) {
    if (!enabled) return false;

    // In a real implementation, this would use a script engine
    // For now, we'll use simple string matching
    try {
      // This is a simplified implementation
      // In production, you'd use a proper scripting engine
      final context = {
        ...scriptContext,
        'message': message.payload,
        'metadata': message.metadata,
        'messageType': message.payload.runtimeType.toString(),
      };

      return _evaluateScript(script, context);
    } catch (e) {
      return false;
    }
  }

  @override
  List<Channel> getDestinations() => destinations;

  @override
  Map<String, dynamic> getMetadata() {
    return {
      'type': 'script-based',
      'scriptLength': script.length,
      'destinationCount': destinations.length,
    };
  }

  bool _evaluateScript(String script, Map<String, dynamic> context) {
    // Generic script evaluation - supports simple property comparisons
    // Format: propertyPath == "value" or propertyPath != "value"

    try {
      // Parse simple comparison expressions like 'payload.type == "vote"'
      final parts = script.split('==').map((s) => s.trim()).toList();
      if (parts.length == 2) {
        final propertyPath = parts[0];
        final expectedValue = parts[1].replaceAll('"', '').replaceAll("'", '');

        final actualValue = _resolvePropertyPath(propertyPath, context);
        return actualValue == expectedValue;
      }

      // Support != operator
      final notEqualParts = script.split('!=').map((s) => s.trim()).toList();
      if (notEqualParts.length == 2) {
        final propertyPath = notEqualParts[0];
        final expectedValue = notEqualParts[1]
            .replaceAll('"', '')
            .replaceAll("'", '');

        final actualValue = _resolvePropertyPath(propertyPath, context);
        return actualValue != expectedValue;
      }

      // If no recognized pattern, return false
      return false;
    } catch (e) {
      // On any evaluation error, return false for safety
      return false;
    }
  }

  /// Resolves a property path like 'payload.type' or 'metadata.priority' from context
  dynamic _resolvePropertyPath(String path, Map<String, dynamic> context) {
    final segments = path.split('.');
    if (segments.isEmpty) return null;

    dynamic current = context[segments[0]];
    for (int i = 1; i < segments.length; i++) {
      if (current is Map<String, dynamic>) {
        current = current[segments[i]];
      } else {
        return null; // Cannot navigate further
      }
    }
    return current;
  }
}

/// Routing condition for content-based rules
class RoutingCondition {
  final String field;
  final RoutingOperator operator;
  final dynamic value;

  RoutingCondition({required this.field, required this.operator, this.value});

  bool matches(Message message) {
    dynamic fieldValue;
    bool fieldExists = false;

    // Extract field value from message
    if (message.metadata.containsKey(field)) {
      fieldValue = message.metadata[field];
      fieldExists = true;
    } else if (message.payload is Map<String, dynamic> &&
        (message.payload as Map<String, dynamic>).containsKey(field)) {
      fieldValue = (message.payload as Map<String, dynamic>)[field];
      fieldExists = true;
    }

    // Apply operator
    switch (operator) {
      case RoutingOperator.equals:
        return fieldExists && fieldValue == value;
      case RoutingOperator.notEquals:
        return fieldExists && fieldValue != value;
      case RoutingOperator.contains:
        if (!fieldExists) return false;
        if (fieldValue is String && value is String) {
          return fieldValue.contains(value);
        }
        if (fieldValue is List) {
          return fieldValue.contains(value);
        }
        return false;
      case RoutingOperator.greaterThan:
        if (!fieldExists) return false;
        if (fieldValue is num && value is num) {
          return fieldValue > value;
        }
        return false;
      case RoutingOperator.lessThan:
        if (!fieldExists) return false;
        if (fieldValue is num && value is num) {
          return fieldValue < value;
        }
        return false;
      case RoutingOperator.exists:
        return fieldExists && fieldValue != null;
      case RoutingOperator.notExists:
        return !fieldExists || fieldValue == null;
      case RoutingOperator.regex:
        if (!fieldExists) return false;
        if (fieldValue is String && value is String) {
          return RegExp(value).hasMatch(fieldValue);
        }
        return false;
    }
  }
}

/// Routing operators
enum RoutingOperator {
  equals,
  notEquals,
  contains,
  greaterThan,
  lessThan,
  exists,
  notExists,
  regex,
}

/// Routing strategies
enum RoutingStrategy {
  allMatch, // All conditions must match (AND)
  anyMatch, // At least one condition must match (OR)
  noneMatch, // No conditions must match (NOT)
}

/// Basic dynamic router implementation
class BasicDynamicRouter implements DynamicRouter {
  final Channel _sourceChannel;
  final List<RoutingRule> _rules = [];
  final RoutingStatsTracker _statsTracker = RoutingStatsTracker();

  BasicDynamicRouter(this._sourceChannel);

  @override
  Channel get sourceChannel => _sourceChannel;

  @override
  Future<RouteResult> route(Message message) async {
    _statsTracker.recordMessage();

    final routedMessages = <RoutedMessage>[];
    final failedDestinations = <String>[];

    for (final rule in _rules.where((r) => r.enabled)) {
      if (rule.evaluate(message)) {
        final destinations = rule.getDestinations();

        for (final destination in destinations) {
          try {
            final routedMessage = RoutedMessage(
              message: message,
              destination: destination,
              ruleId: rule.id,
              routingMetadata: {
                'routedAt': DateTime.now().toIso8601String(),
                'ruleDescription': rule.description,
              },
            );

            await destination.send(message);
            routedMessages.add(routedMessage);
            _statsTracker.recordSuccessfulRoute(rule.id, destination.id);
          } catch (e) {
            failedDestinations.add('${destination.id}: $e');
            _statsTracker.recordFailedRoute();
          }
        }
      }
    }

    return RouteResult(
      originalMessage: message,
      routedMessages: routedMessages,
      failedDestinations: failedDestinations,
    );
  }

  @override
  void addRule(RoutingRule rule) {
    // Remove existing rule with same ID if it exists
    _rules.removeWhere((r) => r.id == rule.id);
    _rules.add(rule);
  }

  @override
  void removeRule(String ruleId) {
    _rules.removeWhere((r) => r.id == ruleId);
  }

  @override
  void updateRule(RoutingRule rule) {
    final index = _rules.indexWhere((r) => r.id == rule.id);
    if (index != -1) {
      _rules[index] = rule;
    }
  }

  @override
  List<RoutingRule> getRules() => List.unmodifiable(_rules);

  @override
  RoutingStats getStats() => _statsTracker.getStats();

  @override
  void clearRules() => _rules.clear();
}

/// Statistics tracker for routing operations
class RoutingStatsTracker {
  int _totalMessages = 0;
  int _successfullyRouted = 0;
  int _failedRoutes = 0;
  final Map<String, int> _routesByRule = {};
  final Map<String, int> _routesByDestination = {};
  DateTime? _lastActivity;

  void recordMessage() {
    _totalMessages++;
    _lastActivity = DateTime.now();
  }

  void recordSuccessfulRoute(String ruleId, String destinationId) {
    _successfullyRouted++;
    _routesByRule[ruleId] = (_routesByRule[ruleId] ?? 0) + 1;
    _routesByDestination[destinationId] =
        (_routesByDestination[destinationId] ?? 0) + 1;
  }

  void recordFailedRoute() {
    _failedRoutes++;
  }

  RoutingStats getStats() {
    return RoutingStats(
      totalMessages: _totalMessages,
      successfullyRouted: _successfullyRouted,
      failedRoutes: _failedRoutes,
      routesByRule: Map.from(_routesByRule),
      routesByDestination: Map.from(_routesByDestination),
      lastActivity: _lastActivity,
    );
  }
}

/// Router channel processor that automatically routes messages
class DynamicRouterChannelProcessor {
  final DynamicRouter router;
  final Channel sourceChannel;
  final Channel? deadLetterChannel;
  StreamSubscription<Message>? _subscription;

  DynamicRouterChannelProcessor({
    required this.router,
    required this.sourceChannel,
    this.deadLetterChannel,
  });

  /// Starts processing messages from the source channel
  Future<void> start() async {
    _subscription = sourceChannel.receive().listen(
      (message) async {
        try {
          final result = await router.route(message);

          if (!result.success && deadLetterChannel != null) {
            // Send to dead letter channel if routing failed
            final errorMessage = Message(
              payload: message.payload,
              metadata: {
                ...message.metadata,
                'routingFailed': true,
                'failedDestinations': result.failedDestinations,
                'routingTimestamp': DateTime.now().toIso8601String(),
              },
              id: message.id,
            );
            await deadLetterChannel!.send(errorMessage);
          }
        } catch (e) {
          // Handle routing errors
          if (deadLetterChannel != null) {
            final errorMessage = Message(
              payload: message.payload,
              metadata: {
                ...message.metadata,
                'routingError': e.toString(),
                'errorTimestamp': DateTime.now().toIso8601String(),
              },
              id: message.id,
            );
            await deadLetterChannel!.send(errorMessage);
          }
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

/// Predefined dynamic routers for common use cases

/// Topic-based router - routes messages based on discussion topics
class TopicBasedRouter extends BasicDynamicRouter {
  TopicBasedRouter(Channel sourceChannel) : super(sourceChannel);

  /// Adds a topic routing rule
  void addTopicRule(String topic, Channel destination) {
    addRule(
      ContentBasedRoutingRule(
        id: 'topic-$topic',
        description: 'Routes messages for topic: $topic',
        conditions: [
          RoutingCondition(
            field: 'topic',
            operator: RoutingOperator.equals,
            value: topic,
          ),
        ],
        destinations: [destination],
      ),
    );
  }

  /// Updates topic routing
  void updateTopicDestination(String topic, Channel newDestination) {
    final rule = getRules().firstWhere(
      (r) => r.id == 'topic-$topic',
      orElse: () => throw ArgumentError('Topic rule not found: $topic'),
    );

    if (rule is ContentBasedRoutingRule) {
      final updatedRule = ContentBasedRoutingRule(
        id: rule.id,
        description: rule.description,
        destinations: [newDestination],
        conditions: rule.conditions,
        strategy: rule.strategy,
        enabled: rule.enabled,
      );
      updateRule(updatedRule);
    }
  }
}

/// Geographic router - routes messages based on location/jurisdiction
class GeographicRouter extends BasicDynamicRouter {
  GeographicRouter(Channel sourceChannel) : super(sourceChannel);

  /// Adds a geographic routing rule
  void addGeographicRule(String region, Channel destination) {
    addRule(
      ContentBasedRoutingRule(
        id: 'region-$region',
        description: 'Routes messages for region: $region',
        conditions: [
          RoutingCondition(
            field: 'region',
            operator: RoutingOperator.equals,
            value: region,
          ),
        ],
        destinations: [destination],
      ),
    );
  }

  /// Adds a jurisdiction-based rule
  void addJurisdictionRule(String jurisdiction, Channel destination) {
    addRule(
      ContentBasedRoutingRule(
        id: 'jurisdiction-$jurisdiction',
        description: 'Routes messages for jurisdiction: $jurisdiction',
        conditions: [
          RoutingCondition(
            field: 'jurisdiction',
            operator: RoutingOperator.equals,
            value: jurisdiction,
          ),
          RoutingCondition(
            field: 'citizenId',
            operator: RoutingOperator.exists,
          ),
        ],
        destinations: [destination],
        strategy: RoutingStrategy.allMatch,
      ),
    );
  }
}

/// Priority-based router for handling message urgency
class PriorityBasedRouter extends BasicDynamicRouter {
  PriorityBasedRouter(Channel sourceChannel) : super(sourceChannel) {
    _setupPriorityRules();
  }

  void _setupPriorityRules() {
    // Critical messages get highest priority routing
    addRule(
      HeaderBasedRoutingRule(
        id: 'critical-priority',
        description: 'Routes critical messages to immediate processing',
        headerCriteria: {'priority': 'critical'},
        destinations: [_createChannel('critical-processing')],
      ),
    );

    // High priority messages
    addRule(
      HeaderBasedRoutingRule(
        id: 'high-priority',
        description: 'Routes high priority messages',
        headerCriteria: {'priority': 'high'},
        destinations: [_createChannel('high-priority-queue')],
      ),
    );

    // Normal priority (default)
    addRule(
      HeaderBasedRoutingRule(
        id: 'normal-priority',
        description: 'Routes normal priority messages',
        headerCriteria: {'priority': 'normal'},
        destinations: [_createChannel('normal-queue')],
      ),
    );
  }

  Channel _createChannel(String id) {
    return InMemoryChannel(id: id, broadcast: true);
  }
}
