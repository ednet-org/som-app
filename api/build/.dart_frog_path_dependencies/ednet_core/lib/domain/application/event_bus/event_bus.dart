part of ednet_core;

/// Central event distribution infrastructure for EDNet Core applications.
///
/// The EventBus is the cornerstone of event-driven architecture in EDNet Core,
/// enabling the Command-Event-Policy cycle described in Chapter 5 of the EDNet book.
/// It provides a sophisticated, scalable platform for:
/// - Distributing domain events to registered handlers
/// - Triggering event-based policies and business rules
/// - Integrating with event stores for persistence
/// - Generating commands from policy reactions
/// - Supporting middleware and event filtering
///
/// The EventBus serves as the "Event" component in the Command-Event-Policy cycle:
/// ```
/// Commands → Events → Policies → Commands (cycle continues)
/// ```
///
/// Key capabilities:
/// - **Handler Management**: Registration and lifecycle management of event handlers
/// - **Policy Integration**: Automatic policy triggering based on events
/// - **Command Generation**: Support for policies to generate new commands
/// - **Event Persistence**: Integration with event stores for audit and replay
/// - **Middleware Pipeline**: Extensible pre/post-processing hooks
/// - **Error Resilience**: Graceful handling of handler failures
/// - **Event Filtering**: Support for conditional event processing
///
/// Example usage:
/// ```dart
/// // Setup event bus with integrations
/// final eventBus = EventBus();
/// final commandBus = CommandBus();
/// final eventStore = EventStore(database, eventPublisher);
///
/// // Configure integrations
/// eventBus.setCommandBus(commandBus);
/// eventBus.setEventStore(eventStore);
///
/// // Register handlers and policies
/// eventBus.registerHandler<OrderCreatedEvent>(orderConfirmationHandler);
/// eventBus.registerPolicy(inventoryReservationPolicy);
///
/// // Events are published by aggregate roots or application services
/// await eventBus.publish(orderCreatedEvent);
/// ```
///
/// Integration with EDNet Core:
/// - Works with [AggregateRoot] for event generation
/// - Integrates with [CommandBus] for policy-generated commands
/// - Uses [EventStore] for event persistence and replay
/// - Triggers [IEventTriggeredPolicy] instances automatically
/// - Supports [ApplicationService] orchestration patterns
///
/// See also:
/// - [IEventHandler] for event handler interface
/// - [IDomainEvent] for event interface
/// - [CommandBus] for command processing
/// - [IEventTriggeredPolicy] for reactive policies
/// - [EventStore] for event persistence
class EventBus with ObservabilityMixin {
  @override
  String get componentName => 'EventBus';

  /// Registry of event handlers by event type
  final Map<Type, List<IEventHandler>> _handlers = {};

  /// Registry of event-triggered policies
  final List<IEventTriggeredPolicy> _policies = [];

  /// Registry of saga factories by event type (reserved for future use)
  // final Map<Type, List<Function>> _sagaFactories = {};

  /// List of active saga instances (reserved for future use)
  // final List<IProcessManager> _sagas = [];

  /// Pre-publishing middleware functions
  final List<Future<void> Function(IDomainEvent)> _prePublishingMiddleware = [];

  /// Post-publishing middleware functions
  final List<Future<void> Function(IDomainEvent)> _postPublishingMiddleware =
      [];

  /// Command bus for dispatching policy-generated commands
  CommandBus? _commandBus;

  /// Event store for persisting events
  dynamic _eventStore;

  /// Creates a new EventBus instance.
  EventBus();

  /// Registers an event handler for a specific event type.
  ///
  /// Multiple handlers can be registered for the same event type, enabling
  /// patterns like:
  /// - Primary processing and audit handlers
  /// - Conditional handlers based on event data
  /// - Read model updates and external integrations
  /// - Notification and logging handlers
  ///
  /// Parameters:
  /// - [handler]: The event handler to register
  ///
  /// Example:
  /// ```dart
  /// final confirmationHandler = OrderConfirmationHandler(emailService);
  /// eventBus.registerHandler<OrderCreatedEvent>(confirmationHandler);
  /// ```
  void registerHandler<TEvent extends IDomainEvent>(
    IEventHandler<TEvent> handler,
  ) {
    final eventType = TEvent;
    _handlers.putIfAbsent(eventType, () => []);
    _handlers[eventType]!.add(handler);

    observabilityInfo(
      'handlerRegistered',
      context: {
        'eventName': eventType.toString(),
        'handlerType': handler.runtimeType.toString(),
        'totalHandlers': _handlers[eventType]!.length,
      },
    );
  }

  /// Unregisters a specific event handler.
  ///
  /// Parameters:
  /// - [handler]: The event handler to remove
  void unregisterHandler<TEvent extends IDomainEvent>(
    IEventHandler<TEvent> handler,
  ) {
    final eventType = TEvent;
    _handlers[eventType]?.remove(handler);
    if (_handlers[eventType]?.isEmpty ?? false) {
      _handlers.remove(eventType);
    }

    observabilityInfo(
      'handlerUnregistered',
      context: {
        'eventName': eventType.toString(),
        'handlerType': handler.runtimeType.toString(),
        'totalHandlers': _handlers[eventType]?.length ?? 0,
      },
    );
  }

  /// Checks if any handlers are registered for an event type.
  ///
  /// Returns:
  /// `true` if handlers exist for the event type, `false` otherwise
  bool hasHandlerFor<TEvent extends IDomainEvent>() {
    final eventType = TEvent;
    return _handlers.containsKey(eventType) && _handlers[eventType]!.isNotEmpty;
  }

  /// Gets all handlers registered for an event type.
  ///
  /// Returns:
  /// List of handlers for the event type, empty if none registered
  List<IEventHandler> getHandlersFor<TEvent extends IDomainEvent>() {
    final eventType = TEvent;
    return List.unmodifiable(_handlers[eventType] ?? []);
  }

  /// Registers an event-triggered policy.
  ///
  /// Event-triggered policies are automatically evaluated when events are
  /// published. Policies that match the event will execute their actions
  /// and may generate commands that continue the Command-Event-Policy cycle.
  ///
  /// Parameters:
  /// - [policy]: The event-triggered policy to register
  ///
  /// Example:
  /// ```dart
  /// final inventoryPolicy = InventoryReservationPolicy();
  /// eventBus.registerPolicy(inventoryPolicy);
  /// ```
  void registerPolicy(IEventTriggeredPolicy policy) {
    _policies.add(policy);

    observabilityInfo(
      'policyRegistered',
      context: {'policyName': policy.name, 'totalPolicies': _policies.length},
    );
  }

  /// Unregisters an event-triggered policy.
  ///
  /// Parameters:
  /// - [policy]: The policy to remove
  void unregisterPolicy(IEventTriggeredPolicy policy) {
    _policies.remove(policy);

    observabilityInfo(
      'policyUnregistered',
      context: {'policyName': policy.name, 'totalPolicies': _policies.length},
    );
  }

  /// Sets the command bus for dispatching policy-generated commands.
  ///
  /// When policies generate commands in response to events, those commands
  /// are automatically dispatched through the configured command bus,
  /// completing the Command-Event-Policy cycle.
  ///
  /// Parameters:
  /// - [commandBus]: The command bus to use for command dispatch
  void setCommandBus(CommandBus commandBus) {
    _commandBus = commandBus;
  }

  /// Sets the event store for persisting events.
  ///
  /// When an event store is configured, all published events are automatically
  /// persisted, enabling event sourcing, audit trails, and event replay.
  ///
  /// Parameters:
  /// - [eventStore]: The event store to use for persistence
  void setEventStore(dynamic eventStore) {
    _eventStore = eventStore;
  }

  /// Adds pre-publishing middleware that runs before event distribution.
  ///
  /// Pre-publishing middleware can be used for:
  /// - Event validation and enrichment
  /// - Logging and audit trails
  /// - Performance monitoring
  /// - Security checks
  /// - Event transformation
  ///
  /// Parameters:
  /// - [middleware]: Function to execute before event publishing
  void addPrePublishingMiddleware(
    Future<void> Function(IDomainEvent) middleware,
  ) {
    _prePublishingMiddleware.add(middleware);

    observabilityInfo(
      'prePublishMiddlewareAdded',
      context: {'totalPreMiddleware': _prePublishingMiddleware.length},
    );
  }

  /// Adds post-publishing middleware that runs after event distribution.
  ///
  /// Post-publishing middleware can be used for:
  /// - Cleanup operations
  /// - Performance metrics collection
  /// - Success confirmations
  /// - Final logging and reporting
  ///
  /// Parameters:
  /// - [middleware]: Function to execute after event publishing
  void addPostPublishingMiddleware(
    Future<void> Function(IDomainEvent) middleware,
  ) {
    _postPublishingMiddleware.add(middleware);

    observabilityInfo(
      'postPublishMiddlewareAdded',
      context: {'totalPostMiddleware': _postPublishingMiddleware.length},
    );
  }

  /// Publishes a domain event to all registered handlers and policies.
  ///
  /// This method orchestrates the complete event processing pipeline:
  /// 1. Executes pre-publishing middleware
  /// 2. Persists the event to the event store (if configured)
  /// 3. Distributes the event to registered handlers
  /// 4. Triggers applicable event-driven policies
  /// 5. Executes commands generated by policies
  /// 6. Executes post-publishing middleware
  ///
  /// The method is designed to be resilient - handler failures don't prevent
  /// other handlers from processing the event, and policy failures don't
  /// stop the overall event processing pipeline.
  ///
  /// Parameters:
  /// - [event]: The domain event to publish
  ///
  /// Returns:
  /// A [Future] that completes when all event processing is finished
  Future<void> publish(IDomainEvent event) async {
    return traceExecutionAsync('publish', () async {
      observabilityInfo(
        'eventPublishing',
        context: {
          'eventName': event.name,
          'eventId': event.id,
          'entityType': event.entity?.concept.code,
          'hasHandlers': _handlers.containsKey(event.runtimeType),
          'handlerCount': _handlers[event.runtimeType]?.length ?? 0,
          'policyCount': _policies.length,
        },
      );

      try {
        // Execute pre-publishing middleware
        await _executePrePublishingMiddleware(event);

        // Persist the event if an event store is configured
        await _persistEvent(event);

        // Distribute to registered event handlers
        await _distributeToHandlers(event);

        // Trigger event-driven policies
        await _triggerPolicies(event);

        // Execute post-publishing middleware
        await _executePostPublishingMiddleware(event);

        observabilityInfo(
          'eventPublished',
          context: {'eventName': event.name, 'success': true},
        );
      } catch (e) {
        // Log the error but don't propagate it to prevent breaking the caller
        observabilityError(
          'eventPublishingFailed',
          error: e,
          context: {'eventName': event.name},
        );
      }
    }, context: {'eventName': event.name});
  }

  /// Publishes multiple domain events in sequence.
  ///
  /// This method publishes each event through the standard publish pipeline,
  /// maintaining order and ensuring all events are processed even if some fail.
  ///
  /// Parameters:
  /// - [events]: The list of domain events to publish
  ///
  /// Returns:
  /// A [Future] that completes when all events have been processed
  Future<void> publishAll(List<IDomainEvent> events) async {
    return traceExecutionAsync('publishAll', () async {
      observabilityInfo(
        'publishingMultipleEvents',
        context: {
          'eventCount': events.length,
          'eventNames': events.map((e) => e.name).toList(),
        },
      );

      for (final event in events) {
        await publish(event);
      }

      observabilityInfo(
        'allEventsPublished',
        context: {'eventCount': events.length, 'success': true},
      );
    }, context: {'eventCount': events.length});
  }

  /// Executes pre-publishing middleware.
  Future<void> _executePrePublishingMiddleware(IDomainEvent event) async {
    return traceExecutionAsync(
      'executePrePublishingMiddleware',
      () async {
        for (final middleware in _prePublishingMiddleware) {
          try {
            observabilityTrace('prePublishMiddlewareExecuting', {
              'eventName': event.name,
              'middlewareType': middleware.runtimeType.toString(),
            });

            await middleware(event);

            observabilityTrace('prePublishMiddlewareCompleted', {
              'eventName': event.name,
              'middlewareType': middleware.runtimeType.toString(),
            });
          } catch (error) {
            observabilityError(
              'prePublishMiddlewareFailed',
              error: error,
              context: {
                'eventName': event.name,
                'middlewareType': middleware.runtimeType.toString(),
              },
            );
            // Continue with other middleware
          }
        }
      },
      context: {
        'eventName': event.name,
        'middlewareCount': _prePublishingMiddleware.length,
      },
    );
  }

  /// Executes post-publishing middleware.
  Future<void> _executePostPublishingMiddleware(IDomainEvent event) async {
    return traceExecutionAsync(
      'executePostPublishingMiddleware',
      () async {
        for (final middleware in _postPublishingMiddleware) {
          try {
            observabilityTrace('postPublishMiddlewareExecuting', {
              'eventName': event.name,
              'middlewareType': middleware.runtimeType.toString(),
            });

            await middleware(event);

            observabilityTrace('postPublishMiddlewareCompleted', {
              'eventName': event.name,
              'middlewareType': middleware.runtimeType.toString(),
            });
          } catch (error) {
            observabilityError(
              'postPublishMiddlewareFailed',
              error: error,
              context: {
                'eventName': event.name,
                'middlewareType': middleware.runtimeType.toString(),
              },
            );
            // Continue with other middleware
          }
        }
      },
      context: {
        'eventName': event.name,
        'middlewareCount': _postPublishingMiddleware.length,
      },
    );
  }

  /// Persists the event to the event store if configured.
  Future<void> _persistEvent(IDomainEvent event) async {
    if (_eventStore?.store != null) {
      try {
        await _eventStore.store(event);
      } catch (e) {
        // Log persistence errors but don't stop event processing
        observabilityError(
          'eventPersistenceFailed',
          error: e,
          context: {'eventName': event.name},
        );
      }
    }
  }

  /// Distributes the event to all matching handlers.
  Future<void> _distributeToHandlers(IDomainEvent event) async {
    final matchingHandlers = _getMatchingHandlers(event);

    return traceExecutionAsync(
      'distributeToHandlers',
      () async {
        observabilityDebug('publishingToHandlers', {
          'eventName': event.name,
          'handlerCount': matchingHandlers.length,
        });

        for (final handler in matchingHandlers) {
          try {
            observabilityTrace('eventHandlerExecuting', {
              'eventName': event.name,
              'handlerType': handler.runtimeType.toString(),
            });

            await handler.handle(event);

            observabilityTrace('eventHandlerCompleted', {
              'eventName': event.name,
              'handlerType': handler.runtimeType.toString(),
            });
          } catch (error) {
            observabilityError(
              'eventHandlerFailed',
              error: error,
              context: {
                'eventName': event.name,
                'handlerType': handler.runtimeType.toString(),
              },
            );
            // Continue with other handlers
          }
        }
      },
      context: {
        'eventName': event.name,
        'handlerCount': matchingHandlers.length,
      },
    );
  }

  /// Gets all handlers that can process the given event.
  List<IEventHandler> _getMatchingHandlers(IDomainEvent event) {
    final matchingHandlers = <IEventHandler>[];
    final seenHandlers = <IEventHandler>{};

    for (final handlerList in _handlers.values) {
      for (final handler in handlerList) {
        // Only add each handler instance once, even if it's registered for multiple event types
        if (!seenHandlers.contains(handler) && handler.canHandle(event)) {
          matchingHandlers.add(handler);
          seenHandlers.add(handler);
        }
      }
    }

    return matchingHandlers;
  }

  /// Triggers event-driven policies and executes generated commands.
  Future<void> _triggerPolicies(IDomainEvent event) async {
    return traceExecutionAsync(
      'executePolicies',
      () async {
        observabilityDebug('executingPolicies', {
          'eventName': event.name,
          'policyCount': _policies.length,
        });

        for (final policy in _policies) {
          try {
            observabilityTrace('policyEvaluating', {
              'eventName': event.name,
              'policyName': policy.name,
              'policyType': policy.runtimeType.toString(),
            });

            if (policy.shouldTriggerOnEvent(event)) {
              // Get the entity associated with the event for policy evaluation
              final entity = event.entity;

              // For policies that can work without entities or when entity evaluation passes
              if (entity == null || policy.evaluate(entity)) {
                // Execute policy actions (pass entity even if null - policy handles it)
                policy.executeActions(entity, event);

                // Generate and dispatch commands
                final commands = policy.generateCommands(entity, event);
                await _dispatchGeneratedCommands(commands);

                observabilityDebug('policyEvaluated', {
                  'eventName': event.name,
                  'policyName': policy.name,
                  'commandsGenerated': commands.length,
                  'commands': commands
                      .map((c) => c.runtimeType.toString())
                      .toList(),
                });
              } else {
                observabilityDebug('policyEvaluated', {
                  'eventName': event.name,
                  'policyName': policy.name,
                  'commandsGenerated': 0,
                  'commands': <String>[],
                  'skipped': 'entity evaluation failed',
                });
              }
            } else {
              observabilityDebug('policyEvaluated', {
                'eventName': event.name,
                'policyName': policy.name,
                'commandsGenerated': 0,
                'commands': <String>[],
                'skipped': 'shouldTriggerOnEvent returned false',
              });
            }
          } catch (error) {
            observabilityError(
              'policyEvaluationFailed',
              error: error,
              context: {
                'eventName': event.name,
                'policyName': policy.name,
                'policyType': policy.runtimeType.toString(),
              },
            );
            // Continue with other policies
          }
        }
      },
      context: {'eventName': event.name, 'policyCount': _policies.length},
    );
  }

  /// Dispatches commands generated by policies.
  Future<void> _dispatchGeneratedCommands(
    List<ICommandBusCommand> commands,
  ) async {
    if (_commandBus != null) {
      return traceExecutionAsync('dispatchGeneratedCommands', () async {
        observabilityTrace('executingCommands', {
          'commandCount': commands.length,
          'commandTypes': commands
              .map((c) => c.runtimeType.toString())
              .toList(),
          'commandIds': commands.map((c) => c.id).toList(),
        });

        for (final command in commands) {
          try {
            observabilityTrace('policyCommandExecuting', {
              'commandType': command.runtimeType.toString(),
              'commandId': command.id,
              'commandData': command.toJson(),
            });

            final result = await _commandBus!.execute(command);

            observabilityTrace('policyCommandCompleted', {
              'commandType': command.runtimeType.toString(),
              'commandId': command.id,
              'success': result.isSuccess,
              'errorMessage': result.errorMessage,
              'resultData': result.data,
            });
          } catch (error) {
            observabilityError(
              'policyCommandFailed',
              error: error,
              context: {
                'commandType': command.runtimeType.toString(),
                'commandId': command.id,
              },
            );
            // Continue with other commands
          }
        }
      }, context: {'commandCount': commands.length});
    } else {
      if (commands.isNotEmpty) {
        observabilityError(
          'commandsGeneratedButNoCommandBusConfigured',
          error: 'Commands generated by policies but no CommandBus configured',
          context: {
            'commandCount': commands.length,
            'commandTypes': commands
                .map((c) => c.runtimeType.toString())
                .toList(),
          },
        );
      }
    }
  }

  /// Registers a saga (process manager) with the event bus.
  ///
  /// Sagas are automatically triggered when events occur that match their workflow steps.
  /// The event bus will correlate events to existing saga instances or create new ones
  /// as appropriate based on the saga's configuration.
  ///
  /// Parameters:
  /// - [saga]: The saga to register
  void registerSaga<T extends ProcessManager>(T Function() sagaFactory) {
    // Create a prototype saga to get event mappings
    final prototypeSaga = sagaFactory();

    // Configure the saga with event bus infrastructure
    prototypeSaga.setEventBus(this);
    if (_commandBus != null) {
      prototypeSaga.setCommandBus(_commandBus!);
    }

    // Register event handlers for all events the saga handles
    final sagaEventHandler = SagaEventHandler<T>(sagaFactory, this);

    // Register the saga's event handler once for each event type it handles
    // but only add it to the handler list once per event type (not multiple times)
    for (final eventType in prototypeSaga.eventStepMappings.keys) {
      _handlers.putIfAbsent(eventType, () => []);

      // Check if this saga handler is already registered for this event type
      final alreadyRegistered = _handlers[eventType]!.any(
        (handler) =>
            handler is SagaEventHandler<T> &&
            handler.sagaType == prototypeSaga.sagaType,
      );

      if (!alreadyRegistered) {
        _handlers[eventType]!.add(sagaEventHandler);
      }
    }

    observabilityInfo(
      'sagaRegistered',
      context: {'sagaType': prototypeSaga.sagaType},
    );
  }

  /// Unregisters a saga from the event bus.
  ///
  /// Parameters:
  /// - [sagaType]: The type name of the saga to unregister
  void unregisterSaga(String sagaType) {
    // Remove saga handlers from all event type collections
    for (final handlerList in _handlers.values) {
      handlerList.removeWhere((handler) {
        if (handler is SagaEventHandler) {
          return handler.sagaType == sagaType;
        }
        return false;
      });
    }

    observabilityInfo('sagaUnregistered', context: {'sagaType': sagaType});
  }
}

/// Event handler that manages saga (process manager) lifecycle and event dispatching.
///
/// This handler is responsible for:
/// - Creating new saga instances when starting events occur
/// - Correlating events to existing saga instances
/// - Managing saga state persistence
/// - Handling saga completion and compensation
class SagaEventHandler<T extends ProcessManager>
    with ObservabilityMixin
    implements IEventHandler<IDomainEvent> {
  @override
  String get componentName => 'SagaEventHandler<$sagaType>';

  /// Factory function to create new saga instances
  final T Function() _sagaFactory;

  /// Event bus for publishing saga events
  final EventBus _eventBus;

  /// In-memory saga instances (in production, use persistent repository)
  final Map<String, T> _activeSagas = {};

  /// The saga type this handler manages
  late String sagaType;

  /// Creates a new saga event handler
  SagaEventHandler(this._sagaFactory, this._eventBus) {
    // Get saga type from prototype
    final prototype = _sagaFactory();
    sagaType = prototype.sagaType;
  }

  @override
  Future<void> handle(IDomainEvent event) async {
    return traceExecutionAsync(
      'handle',
      () async {
        try {
          observabilityTrace('sagaHandlerStarted', {
            'sagaType': sagaType,
            'eventType': event.runtimeType.toString(),
            'eventName': event.name,
            'activeSagaCount': _activeSagas.length,
          });

          // Find or create saga instance for this event
          final saga = await _findOrCreateSagaForEvent(event);

          if (saga != null) {
            observabilityTrace('sagaFoundOrCreated', {
              'sagaType': sagaType,
              'sagaId': saga.sagaId,
              'eventType': event.runtimeType.toString(),
              'eventName': event.name,
              'isNewSaga': !_activeSagas.containsKey(saga.sagaId),
            });

            // Configure saga with event bus infrastructure
            saga.setEventBus(_eventBus);
            if (_eventBus._commandBus != null) {
              saga.setCommandBus(_eventBus._commandBus!);
            }

            // Handle the event
            observabilityTrace('sagaHandlingEvent', {
              'sagaType': sagaType,
              'sagaId': saga.sagaId,
              'eventType': event.runtimeType.toString(),
              'eventName': event.name,
            });

            await saga.handleEvent(event);

            observabilityTrace('sagaEventHandled', {
              'sagaType': sagaType,
              'sagaId': saga.sagaId,
              'eventType': event.runtimeType.toString(),
              'eventName': event.name,
              'sagaCompleted': saga.isCompleted,
              'sagaFailed': saga.hasFailed,
            });

            // Clean up completed or failed sagas
            if (saga.isCompleted || saga.hasFailed) {
              _activeSagas.remove(saga.sagaId);
              observabilityTrace('sagaCleanedUp', {
                'sagaType': sagaType,
                'sagaId': saga.sagaId,
                'reason': saga.isCompleted ? 'completed' : 'failed',
              });
            }
          } else {
            observabilityTrace('sagaNotFoundOrCreated', {
              'sagaType': sagaType,
              'eventType': event.runtimeType.toString(),
              'eventName': event.name,
              'reason': 'No correlation and not a starting event',
            });
          }
        } catch (error) {
          observabilityError(
            'sagaHandlerFailed',
            error: error,
            context: {
              'sagaType': sagaType,
              'eventType': event.runtimeType.toString(),
              'eventName': event.name,
            },
          );
        }
      },
      context: {
        'sagaType': sagaType,
        'eventType': event.runtimeType.toString(),
      },
    );
  }

  @override
  bool canHandle(IDomainEvent event) {
    // Create prototype to check if it can handle this event type
    final prototype = _sagaFactory();

    // Check if any active saga can handle this event
    for (var saga in _activeSagas.values) {
      if (saga.eventStepMappings.containsKey(event.runtimeType)) {
        return true;
      }
    }

    // Check if this event can start a new saga
    return prototype.eventStepMappings.containsKey(event.runtimeType);
  }

  @override
  String get handlerName => 'SagaEventHandler<$sagaType>';

  /// Finds an existing saga or creates a new one for the given event
  Future<T?> _findOrCreateSagaForEvent(IDomainEvent event) async {
    // First try to find existing saga by correlation
    for (var saga in _activeSagas.values) {
      if (await saga.correlateEvent(event)) {
        return saga;
      }
    }

    // Check if this event can start a new saga
    final prototype = _sagaFactory();
    if (prototype.eventStepMappings.containsKey(event.runtimeType)) {
      // Check if it's a starting event
      final stepName = prototype.eventStepMappings[event.runtimeType];
      final step = prototype.steps[stepName];

      if (step?.isStartingStep == true) {
        // Create new saga instance
        final newSaga = _sagaFactory();
        _activeSagas[newSaga.sagaId] = newSaga;
        return newSaga;
      }
    }

    return null;
  }
}
