part of ednet_core;

/// AggregateRoot represents a DDD tactical pattern that serves as the entry point and consistency boundary
/// for a graph of objects that represent a cohesive domain concept.
///
/// An AggregateRoot is responsible for:
/// 1. Enforcing invariants across the entire aggregate
/// 2. Ensuring transactional consistency
/// 3. Protecting the internal state of the aggregate
/// 4. Providing a single entry point into the aggregate
/// 5. Being the only object within the aggregate that outside objects can reference
///
/// In ednet_core, an AggregateRoot is built on top of the existing Entity framework
/// and connected to concepts where entry = true.
///
/// AggregateRoot now implements focused SOLID interfaces for better separation of concerns
abstract class AggregateRoot<T extends Entity<T>> extends Entity<T>
    implements
        IEventSourced,
        IVersioned,
        IBusinessRuleEnforcer,
        IPolicyDriven,
        ITransactional {
  /// List of pending events that occurred but haven't been processed yet
  final List<dynamic> _pendingEvents = [];

  /// The domain session this aggregate operates within
  IDomainSession? _session;

  /// Policy engine for handling policy enforcement and triggering
  IPolicyEngine? _policyEngine;

  /// Command execution strategy for handling different types of command execution
  ICommandExecutionStrategy _commandExecutionStrategy =
      DefaultCommandExecutionStrategy();

  /// Stores the current state/version of the aggregate
  int _version = 0;

  /// State snapshot for rollback capabilities
  String? _stateSnapshot;
  int _snapshotVersion = 0;
  List<dynamic> _snapshotPendingEvents = [];

  /// Create a new aggregate root
  AggregateRoot() : super();

  /// Get the current version of the aggregate
  int get version => _version;

  /// Get the domain session this aggregate operates within
  @override
  IDomainSession? get session => _session;

  /// Set the domain session for this aggregate
  @override
  set session(IDomainSession? session) {
    _session = session;
    if (session != null && _policyEngine == null) {
      _policyEngine = PolicyEngine(session);
    }
  }

  /// Get the policy engine for this aggregate
  @override
  IPolicyEngine? get policyEngine => _policyEngine;

  /// Set the policy engine for this aggregate
  @override
  set policyEngine(IPolicyEngine? engine) {
    _policyEngine = engine;
  }

  /// Get the command execution strategy for this aggregate
  ICommandExecutionStrategy get commandExecutionStrategy =>
      _commandExecutionStrategy;

  /// Set the command execution strategy for this aggregate
  set commandExecutionStrategy(ICommandExecutionStrategy strategy) {
    _commandExecutionStrategy = strategy;
  }

  /// Get pending events that need to be processed
  List<dynamic> get pendingEvents => List.unmodifiable(_pendingEvents);

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

  /// Gets uncommitted events (interface method from IEventSourced)
  ///
  /// Returns:
  /// List of domain events that haven't been committed yet
  List<IDomainEvent> get uncommittedEvents {
    // Convert pending events to IDomainEvent interface
    // For now, we'll cast them - this may need refinement based on actual event types
    return _pendingEvents.cast<IDomainEvent>();
  }

  /// Marks all events as committed (interface method from IEventSourced)
  ///
  /// This method clears the pending events list, indicating that all
  /// events have been successfully persisted to the event store
  void markEventsAsCommitted() {
    _pendingEvents.clear();
  }

  /// Creates a state snapshot for rollback capabilities
  /// This should be called before executing commands that might need rollback
  void _createStateSnapshot() {
    _stateSnapshot = toJson();
    _snapshotVersion = _version;
    _snapshotPendingEvents = List.from(_pendingEvents);
  }

  /// Rolls back the aggregate to the last created snapshot
  /// This restores the state, version, and pending events
  void _rollbackToSnapshot() {
    if (_stateSnapshot != null) {
      fromJson<T>(_stateSnapshot!);
      _version = _snapshotVersion;
      _pendingEvents.clear();
      _pendingEvents.addAll(_snapshotPendingEvents);
    }
  }

  /// Clears the state snapshot after successful command execution
  void _clearSnapshot() {
    _stateSnapshot = null;
    _snapshotVersion = 0;
    _snapshotPendingEvents.clear();
  }

  /// Marks all pending events as processed
  void markEventsAsProcessed() {
    _pendingEvents.clear();
  }

  /// Increments the aggregate version (used by command execution strategies)
  void incrementVersion() {
    _version++;
  }

  /// Adds events to pending events list (used by command execution strategies)
  void addEventsToPending(List<dynamic> events) {
    _pendingEvents.addAll(events);
  }

  /// Triggers policies from an event (used by command execution strategies)
  void triggerPoliciesFromEvent(dynamic event) {
    _triggerPoliciesFromEvent(event);
  }

  /// Creates a state snapshot for rollback (used by command execution strategies)
  void createStateSnapshot() {
    _createStateSnapshot();
  }

  /// Rolls back to the last snapshot (used by command execution strategies)
  void rollbackToSnapshot() {
    _rollbackToSnapshot();
  }

  /// Clears the current snapshot (used by command execution strategies)
  void clearSnapshot() {
    _clearSnapshot();
  }

  /// Records a domain event (interface method from IEventSourced)
  ///
  /// This method implements the IEventSourced interface contract
  /// for recording domain events in a type-safe manner
  void recordEvent(IDomainEvent event) {
    _pendingEvents.add(event);

    // Apply the event to update aggregate state
    applyEvent(event);

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
    final event = Event(name, description, handlers, this, data);
    recordEvent(event); // Delegate to the new interface method
    return event;
  }

  /// Checks if this Entity's concept is marked as an entry point
  bool get isAggregateRoot => concept.entry;

  /// Validates that this entity can function as an aggregate root
  void enforceAggregateRootInvariants() {
    if (!isAggregateRoot) {
      throw ValidationException(
        'entry',
        'AggregateRoot must be applied to entry concepts only.',
        entity: this,
      );
    }
  }

  /// Protects the aggregate by enforcing its business rules and invariants
  /// Should be overridden by concrete implementations to express domain-specific rules
  ValidationExceptions enforceBusinessInvariants() {
    final exceptions = ValidationExceptions();
    // Domain-specific business rules should be implemented here by subclasses
    // Example:
    // if (election.registeredVoters < election.minimumRequiredVoters) {
    //   exceptions.add(ValidationException(
    //     'registeredVoters',
    //     'Insufficient voters for election',
    //     entity: election
    //   ));
    // }
    return exceptions;
  }

  /// Executes a command against this aggregate root using the configured strategy
  /// This is the new SOLID-compliant approach
  dynamic executeCommandWithStrategy(ICommand command) {
    // Validate that this is a proper aggregate root
    enforceAggregateRootInvariants();

    // Use the strategy pattern for command execution
    return _commandExecutionStrategy.execute(this, command);
  }

  /// Executes a command against this aggregate root, ensuring all business rules are satisfied
  /// Returns a CommandResult indicating success or failure
  ///
  /// Note: This method maintains backward compatibility but is being refactored
  /// to use the strategy pattern for better SOLID compliance
  dynamic executeCommand(dynamic command) {
    // If the command implements ICommand, use the new strategy-based approach
    if (command is ICommand) {
      return executeCommandWithStrategy(command);
    }

    // Otherwise, use the legacy approach for backward compatibility
    return _executeCommandLegacy(command);
  }

  /// Legacy command execution for backward compatibility
  /// This will be deprecated in future versions
  dynamic _executeCommandLegacy(dynamic command) {
    // Validate that this is a proper aggregate root
    enforceAggregateRootInvariants();

    // Begin transaction
    try {
      // Execute the command using the existing command infrastructure
      bool executed = false;

      if (command.doIt != null && command.doIt is Function) {
        executed = command.doIt();
      }

      if (!executed) {
        return {'isSuccess': false, 'errorMessage': 'Command execution failed'};
      }

      // Validate business rules after command execution
      ValidationExceptions validationResults = enforceBusinessInvariants();

      if (!validationResults.isEmpty) {
        // If validation fails, try to undo the command
        if (command.undo != null && command.undo is Function) {
          command.undo();
        }
        return {
          'isSuccess': false,
          'errorMessage': validationResults.toString(),
        };
      }

      // If everything is valid, increment version and collect events
      _version++;

      // Add any command events to our pending events
      if (command.getEvents != null && command.getEvents is Function) {
        final commandEvents = command.getEvents();
        _pendingEvents.addAll(commandEvents);

        // Apply each event to update state
        for (var event in commandEvents) {
          applyEvent(event);
        }

        // Trigger policies based on each event
        if (_policyEngine != null) {
          for (var event in commandEvents) {
            _triggerPoliciesFromEvent(event);
          }
        }
      }

      // Return success with aggregate information
      return {
        'isSuccess': true,
        'data': {
          'id': oid.toString(),
          'version': _version,
          'pendingEvents': pendingEvents,
        },
      };
    } catch (e) {
      // If any domain rule is violated, reject the command
      return {
        'isSuccess': false,
        'errorMessage': 'Command execution failed: ${e.toString()}',
      };
    }
  }

  /// Creates a transaction for this aggregate root
  @override
  dynamic beginTransaction(String name, IDomainSession session) {
    this.session = session;
    return Transaction(name, session as DomainSession);
  }

  /// Registers a policy with this aggregate
  @override
  void registerPolicy(IPolicy policy) {
    if (_policyEngine == null) {
      _policyEngine = PolicyEngine(session!);
    }
    _policyEngine!.addPolicy(policy);
  }

  /// Trigger policies based on an event
  void _triggerPoliciesFromEvent(dynamic event) {
    if (_policyEngine == null) return;

    // First, evaluate which policies apply to this entity
    final applicablePolicies = _policyEngine!.getApplicablePolicies(this);

    // For each applicable policy, check if it should trigger on this event
    for (var policy in applicablePolicies) {
      if (_isEventTriggeredPolicy(policy)) {
        dynamic dynamicPolicy = policy;
        if (dynamicPolicy.shouldTriggerOnEvent(event)) {
          // Policy is triggered by this event, execute its actions
          dynamicPolicy.executeActions(this, event);

          // If the policy generates commands, execute them
          final commands = dynamicPolicy.generateCommands(this, event);
          for (var command in commands) {
            if (command.doIt != null && command.doIt is Function) {
              // Link the command to this aggregate's session if not already set
              if (_isSessionAware(command) && session != null) {
                (command as dynamic).setSession(session);
              }

              // Execute the command
              executeCommand(command);
            }
          }
        }
      }
    }
  }

  /// Helper method to check if an object implements IEventTriggeredPolicy
  bool _isEventTriggeredPolicy(dynamic obj) {
    return obj != null &&
        obj.shouldTriggerOnEvent is Function &&
        obj.executeActions is Function &&
        obj.generateCommands is Function;
  }

  /// Helper method to check if an object implements SessionAware
  bool _isSessionAware(dynamic obj) {
    return obj != null && obj.setSession is Function;
  }

  /// Reconstructs the aggregate's state from its event history
  /// Used in event sourcing scenarios
  void rehydrateFromEventHistory(List<dynamic> eventHistory) {
    for (var event in eventHistory) {
      applyEvent(event);
      _version++;
    }
  }

  // NOTE: Implement semantic Concept-based execution strategy to reduce specialization.
  /// Applies a single event to update the aggregate's state
  /// Should be overridden by concrete implementations with domain-specific logic
  void applyEvent(dynamic event) {
    // Each specific AggregateRoot should override this with domain-specific logic
    // Example:
    // if (event.name == 'VoteCast') {
    //   _recordVote(event.data['voterId'], event.data['candidateId']);
    // } else if (event.name == 'CandidateRegistered') {
    //   _registerCandidate(event.data['candidateId'], event.data['candidateName']);
    // }
  }

  /// Ensures that domain relationships maintain the aggregate's consistency boundaries
  /// This helps address the validation warnings by maintaining proper domain relationships
  ValidationExceptions maintainRelationshipIntegrity() {
    final exceptions = ValidationExceptions();

    // To be implemented by concrete classes for their specific relationship rules
    // Example:
    // for (var ballot in ballots) {
    //   if (ballot.election != this) {
    //     try {
    //       // Use existing command infrastructure to set parent
    //       var setParentCmd = SetParentCommand(session, ballot, 'election', this);
    //       setParentCmd.doIt();
    //     } catch (e) {
    //       exceptions.add(ValidationException(
    //         'relationship',
    //         e.toString(),
    //         entity: ballot
    //       ));
    //     }
    //   }
    // }

    return exceptions;
  }

  /// Validates the entire aggregate against domain rules
  ValidationExceptions validateAggregate() {
    // Start with relationship integrity checks
    ValidationExceptions exceptions = maintainRelationshipIntegrity();

    // Then add business rule validations
    ValidationExceptions businessRuleExceptions = enforceBusinessInvariants();
    var iterator = businessRuleExceptions.iterator;
    while (iterator.moveNext()) {
      exceptions.add(iterator.current);
    }

    return exceptions;
  }

  /// Creates a graph representation of the entire aggregate
  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['isAggregateRoot'] = true;
    graph['version'] = _version;
    graph['pendingEventCount'] = _pendingEvents.length;
    graph['hasUncommittedEvents'] = hasUncommittedEvents;
    graph['uncommittedEventCount'] = uncommittedEventCount;
    return graph;
  }
}

/// Interface for objects that can be associated with a domain session
abstract class SessionAware {
  /// Sets the domain session for this object
  void setSession(dynamic session);
}

/// Base class for all aggregate domain events in the system
abstract class AggregateDomainEvent {
  final String aggregateId;
  final int version;
  final DateTime timestamp;

  AggregateDomainEvent(this.aggregateId, this.version)
    : timestamp = DateTime.now();

  Map<String, dynamic> toMap();
}

/// Base class for all commands in the system
abstract class Command {
  void execute(AggregateRoot aggregateRoot);
}

/// Exception specifically for domain validation failures
class DomainValidationException implements Exception {
  final String message;
  final Entity? entity;

  DomainValidationException(this.message, {this.entity});

  @override
  String toString() =>
      'Domain Validation Error: $message${entity != null ? ' in ${entity.runtimeType}' : ''}';
}
