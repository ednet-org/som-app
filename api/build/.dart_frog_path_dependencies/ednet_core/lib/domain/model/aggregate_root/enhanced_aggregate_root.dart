part of ednet_core;

/// Enhanced AggregateRoot that implements complete event sourcing capabilities
/// as described in Chapter 6 of the EDNet book.
///
/// This enhanced version provides:
/// - Complete event sourcing pattern implementation
/// - Immutable event handling with proper state reconstruction
/// - Integration with the Enhanced Application Service
/// - Snapshot support for performance optimization
/// - Optimistic concurrency control through versioning
/// - Command execution with full event sourcing cycle
///
/// Key improvements over the base AggregateRoot:
/// - **Event Immutability**: Events are treated as immutable facts that have already occurred
/// - **State Reconstruction**: Complete state rebuild from event history
/// - **Performance Optimization**: Snapshot support for aggregates with long event histories
/// - **Concurrency Control**: Version-based optimistic locking prevents lost updates
/// - **Command Integration**: Seamless integration with CommandBus and Enhanced Application Service
/// - **Event Publishing**: Proper coordination with EventBus for reactive workflows
///
/// Example usage:
/// ```dart
/// class Order extends EnhancedAggregateRoot<Order> {
///   String? customerId;
///   List<OrderLine> lines = [];
///   String status = 'Draft';
///
///   Order() {
///     concept = OrderConcept();
///   }
///
///   // Command: Place the order
///   CommandResult place() {
///     if (status != 'Draft') {
///       return CommandResult.failure('Order already placed');
///     }
///
///     // Record what happened as an immutable fact
///     recordEvent(
///       'OrderPlaced',
///       'Order was placed by customer',
///       ['OrderFulfillmentHandler', 'NotificationHandler'],
///       data: {
///         'customerId': customerId,
///         'orderTotal': calculateTotal(),
///         'lineCount': lines.length
///       }
///     );
///
///     return CommandResult.success(data: {'orderId': oid.toString()});
///   }
///
///   // Apply events to update state (both for new events and replay)
///   @override
///   void applyEvent(dynamic event) {
///     switch (event.name) {
///       case 'OrderPlaced':
///         status = 'Placed';
///         break;
///       case 'OrderShipped':
///         status = 'Shipped';
///         break;
///     }
///   }
/// }
/// ```
///
/// Integration with Enhanced Application Service:
/// ```dart
/// final result = await applicationService.executeCommandOnAggregate(
///   placeOrderCommand,
///   orderId,
///   orderRepository,
/// );
/// ```
///
/// Event sourcing workflow:
/// 1. Command is executed on aggregate
/// 2. Events are recorded as immutable facts
/// 3. State is updated by applying events
/// 4. Events are persisted to event store
/// 5. Events are published to EventBus for reactive processing
/// 6. Policies can generate new commands based on events
///
/// See also:
/// - [AggregateRoot] for the base aggregate implementation
/// - [EnhancedApplicationService] for command orchestration
/// - [EventStore] for event persistence
/// - [EventBus] for event publishing and policy triggering
abstract class EnhancedAggregateRoot<T extends Entity<T>>
    extends AggregateRoot<T> {
  /// Creates a new enhanced aggregate root
  EnhancedAggregateRoot() : super();

  /// Records a domain event (interface method from IEventSourced)
  ///
  /// This method implements the IEventSourced interface contract
  /// for recording domain events in a type-safe manner
  @override
  void recordEvent(IDomainEvent event) {
    // Add to pending events for persistence
    _pendingEvents.add(event);

    // Apply event to update current state
    applyEvent(event);

    // Update aggregate metadata
    if (event.aggregateId.isEmpty) {
      event.aggregateId = oid.toString();
    }
    if (event.aggregateType.isEmpty) {
      event.aggregateType = runtimeType.toString();
    }
    if (event.aggregateVersion == 0) {
      event.aggregateVersion = _version + 1;
    }

    // Increment version
    _version++;

    // Trigger policies if available
    if (_policyEngine != null) {
      _triggerPoliciesFromEvent(event);
    }
  }

  /// Records a domain event and adds it to pending events (legacy method)
  /// Also triggers policy evaluation if a policy engine is attached
  ///
  /// @deprecated Use recordEvent(IDomainEvent) for type safety
  dynamic recordEventLegacy(
    String name,
    String description,
    List<String> handlers, {
    Map<String, dynamic> data = const {},
  }) {
    // Create immutable domain event
    final domainEvent = EnhancedDomainEventImpl(
      name: name,
      aggregateId: oid.toString(),
      aggregateType: runtimeType.toString(),
      aggregateVersion: _version + 1,
      entity: this,
      data: data,
    );

    // Use the new interface method
    recordEvent(domainEvent);
    return domainEvent;
  }

  /// Rebuilds the aggregate's state from its complete event history.
  ///
  /// This is the core of event sourcing - instead of loading current state,
  /// we replay all events that have occurred to reconstruct the state.
  /// This provides complete audit trail and temporal query capabilities.
  ///
  /// The method:
  /// 1. Resets the aggregate to initial state
  /// 2. Applies each event in chronological order
  /// 3. Updates version to match the final event
  /// 4. Ensures state consistency
  ///
  /// Parameters:
  /// - [eventHistory]: Ordered list of events from the event store
  @override
  void rehydrateFromEventHistory(List<dynamic> eventHistory) {
    // Reset to initial state
    _reset();

    // Apply each event in order to rebuild state
    for (var event in eventHistory) {
      applyEvent(event);

      // Update version to match event version
      if (event is IDomainEvent) {
        _version = event.aggregateVersion;
      } else {
        _version++;
      }
    }

    // Clear pending events after rehydration
    _pendingEvents.clear();
  }

  /// Rehydrates aggregate state from a snapshot and subsequent events.
  ///
  /// For performance optimization with aggregates that have long event histories,
  /// this method loads state from a snapshot (capturing state at a specific version)
  /// and then applies only the events that occurred after the snapshot.
  ///
  /// This dramatically improves loading performance for aggregates with
  /// hundreds or thousands of events.
  ///
  /// Parameters:
  /// - [snapshot]: State snapshot from a specific version
  /// - [eventsAfterSnapshot]: Events that occurred after the snapshot
  void rehydrateFromSnapshot(
    AggregateSnapshot<T> snapshot,
    List<dynamic> eventsAfterSnapshot,
  ) {
    // Restore state from snapshot
    restoreFromSnapshot(snapshot);
    _version = snapshot.version;

    // Apply events that occurred after the snapshot
    for (var event in eventsAfterSnapshot) {
      applyEvent(event);

      if (event is IDomainEvent) {
        _version = event.aggregateVersion;
      } else {
        _version++;
      }
    }

    // Clear pending events after rehydration
    _pendingEvents.clear();
  }

  /// Executes a command with full event sourcing integration.
  ///
  /// This enhanced version provides:
  /// - Command validation before execution
  /// - Business rule enforcement
  /// - Event generation and application
  /// - Version management
  /// - Result tracking with detailed information
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns:
  /// A detailed CommandResult with execution information
  CommandResult executeCommandWithEventSourcing(dynamic command) {
    try {
      // Validate that this is a proper aggregate root
      enforceAggregateRootInvariants();

      // Store initial version for concurrency control
      final initialVersion = _version;

      // Execute the command directly without using base executeCommand
      // (which also increments version and creates unnecessary overhead)
      bool commandSucceeded = false;

      if (command.doIt != null && command.doIt is Function) {
        commandSucceeded = command.doIt();
      } else {
        return CommandResult.failure(
          'Command does not have a valid doIt method',
        );
      }

      // Check if the command action succeeded
      if (commandSucceeded) {
        // Validate business rules after command execution
        final validationResults = enforceBusinessInvariants();

        if (!validationResults.isEmpty) {
          // If validation fails, rollback by undoing the command if possible
          if (command.undo != null && command.undo is Function) {
            command.undo();
          }
          return CommandResult.failure(
            'Business rule validation failed: ${validationResults.toString()}',
          );
        }

        // Return success with aggregate information
        return CommandResult.success(
          data: {
            'aggregateId': oid.toString(),
            'aggregateType': runtimeType.toString(),
            'version': _version,
            'pendingEvents': pendingEvents.length,
            'eventsGenerated': _version - initialVersion,
          },
        );
      } else {
        // Command execution failed - try to get the actual error message
        String errorMessage = 'Command execution failed';

        // If the command has a lastResult property and it's a CommandResult with an error message
        if (command.lastResult != null &&
            command.lastResult.isFailure != null &&
            command.lastResult.isFailure &&
            command.lastResult.errorMessage != null) {
          errorMessage = command.lastResult.errorMessage;
        }

        return CommandResult.failure(errorMessage);
      }
    } catch (e) {
      return CommandResult.failure(
        'Command execution failed with exception: ${e.toString()}',
      );
    }
  }

  /// Creates a snapshot of the current aggregate state
  AggregateSnapshot<T> createSnapshot() {
    return AggregateSnapshot<T>(
      aggregateId: oid.toString(),
      aggregateType: runtimeType.toString(),
      version: _version,
      timestamp: DateTime.now(),
      stateData: toJson(), // This returns String from Entity.toJson()
    );
  }

  /// Restores aggregate state from a snapshot
  void restoreFromSnapshot(AggregateSnapshot<T> snapshot) {
    // Entity.fromJson expects a String
    fromJson<T>(snapshot.stateData);
    _version = snapshot.version;
    // Clear pending events since we're restoring from a snapshot
    _pendingEvents.clear();
  }

  /// Applies an event to update the aggregate's state.
  ///
  /// This method is called both when:
  /// 1. Recording new events (during command execution)
  /// 2. Replaying events (during state reconstruction)
  ///
  /// This ensures that state changes happen identically whether we're
  /// processing new events or rebuilding from history.
  ///
  /// Subclasses must override this method to implement domain-specific
  /// state changes for each event type.
  ///
  /// Parameters:
  /// - [event]: The event to apply (can be Event or IDomainEvent)
  @override
  void applyEvent(dynamic event) {
    // Subclasses must implement domain-specific event application logic
    // Example:
    // switch (event.name) {
    //   case 'OrderPlaced':
    //     status = 'Placed';
    //     orderDate = event.timestamp;
    //     break;
    //   case 'OrderShipped':
    //     status = 'Shipped';
    //     shippedDate = event.timestamp;
    //     break;
    // }
  }

  /// Checks if the aggregate has uncommitted events.
  ///
  /// Returns:
  /// True if there are pending events that need to be persisted
  bool get hasUncommittedEvents => _pendingEvents.isNotEmpty;

  /// Gets the number of uncommitted events.
  ///
  /// Returns:
  /// Count of pending events
  int get uncommittedEventCount => _pendingEvents.length;

  /// Gets the expected version for optimistic concurrency control.
  ///
  /// This is used by repositories to prevent lost updates when
  /// multiple instances modify the same aggregate concurrently.
  ///
  /// Returns:
  /// The current version of the aggregate
  int get expectedVersion => _version;

  /// Validates that the aggregate can be saved with the given expected version.
  ///
  /// This implements optimistic concurrency control to prevent lost updates.
  ///
  /// Parameters:
  /// - [expectedVersion]: The version expected by the caller
  ///
  /// Throws:
  /// ConcurrencyException if versions don't match
  void validateVersion(int expectedVersion) {
    if (_version != expectedVersion) {
      throw ConcurrencyException(expectedVersion, _version);
    }
  }

  /// Resets the aggregate to its initial state.
  ///
  /// This is used during rehydration to ensure clean state reconstruction.
  /// Subclasses should override this method to reset their domain-specific state.
  void _reset() {
    // Reset version and clear events
    _version = 0;
    _pendingEvents.clear();

    // Call the overridable reset method for subclass-specific state
    resetDomainState();
  }

  /// Resets domain-specific state. Subclasses should override this method.
  ///
  /// This method is called during rehydration to reset the aggregate's
  /// domain-specific state to its initial values.
  ///
  /// Example implementation:
  /// ```dart
  /// @override
  /// void resetDomainState() {
  ///   status = 'Draft';
  ///   lines.clear();
  ///   customerId = null;
  /// }
  /// ```
  void resetDomainState() {
    // Default implementation does nothing
    // Subclasses should override to reset their specific state
  }

  /// Creates an enhanced graph representation including event sourcing information.
  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['eventSourcingEnabled'] = true;
    graph['version'] = _version;
    graph['pendingEventCount'] = _pendingEvents.length;
    graph['hasUncommittedEvents'] = hasUncommittedEvents;
    graph['canCreateSnapshot'] = _version > 0;

    // Add event sourcing metadata
    graph['eventSourcing'] = {
      'currentVersion': _version,
      'uncommittedEvents': uncommittedEventCount,
      'lastEventTimestamp': _pendingEvents.isNotEmpty
          ? _pendingEvents.last.timestamp?.toIso8601String()
          : null,
    };

    return graph;
  }
}

/// Represents a snapshot of aggregate state at a specific version.
///
/// Snapshots are used to optimize performance for aggregates with long
/// event histories by capturing the complete state at a point in time.
class AggregateSnapshot<T extends Entity<T>> {
  /// The unique identifier of the aggregate
  final String aggregateId;

  /// The type of the aggregate
  final String aggregateType;

  /// The version at which this snapshot was taken
  final int version;

  /// When this snapshot was created
  final DateTime timestamp;

  /// The serialized state data of the aggregate
  final String stateData;

  /// Creates a new aggregate snapshot
  AggregateSnapshot({
    required this.aggregateId,
    required this.aggregateType,
    required this.version,
    required this.timestamp,
    required this.stateData,
  });

  /// Creates a snapshot from JSON data
  factory AggregateSnapshot.fromJson(Map<String, dynamic> json) {
    return AggregateSnapshot(
      aggregateId: json['aggregateId'],
      aggregateType: json['aggregateType'],
      version: json['version'],
      timestamp: DateTime.parse(json['timestamp']),
      stateData: json['stateData'],
    );
  }

  /// Converts the snapshot to JSON
  Map<String, dynamic> toJson() {
    return {
      'aggregateId': aggregateId,
      'aggregateType': aggregateType,
      'version': version,
      'timestamp': timestamp.toIso8601String(),
      'stateData': stateData,
    };
  }
}

/// Implementation of IDomainEvent for enhanced aggregate root internal use
class EnhancedDomainEventImpl implements IDomainEvent {
  @override
  final String id;

  @override
  final String name;

  @override
  final DateTime timestamp;

  String _aggregateId;
  String _aggregateType;
  int _aggregateVersion;

  @override
  Entity? entity;

  /// Event-specific data payload
  final Map<String, dynamic> data;

  @override
  Map<String, dynamic> get eventData => data;

  EnhancedDomainEventImpl({
    required this.name,
    required String aggregateId,
    required String aggregateType,
    required int aggregateVersion,
    this.entity,
    String? id,
    DateTime? timestamp,
    this.data = const {},
  }) : id = id ?? Oid().toString(),
       timestamp = timestamp ?? DateTime.now(),
       _aggregateId = aggregateId,
       _aggregateType = aggregateType,
       _aggregateVersion = aggregateVersion;

  // Required implementations for IDomainEvent
  @override
  String get aggregateId => _aggregateId;

  @override
  set aggregateId(String value) => _aggregateId = value;

  @override
  String get aggregateType => _aggregateType;

  @override
  set aggregateType(String value) => _aggregateType = value;

  @override
  int get aggregateVersion => _aggregateVersion;

  @override
  set aggregateVersion(int value) => _aggregateVersion = value;

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'timestamp': timestamp.toIso8601String(),
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'data': data,
  };

  @override
  Event toBaseEvent() => Event(name, 'Domain event: $name', [], entity, data);
}
