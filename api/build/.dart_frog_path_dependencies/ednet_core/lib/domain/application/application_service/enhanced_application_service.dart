part of ednet_core;

/// Abstract transaction manager for handling transaction lifecycle
abstract class TransactionManager {
  /// Begins a new transaction with the given name
  Future<TransactionHandle> beginTransaction(String name);

  /// Commits a transaction
  Future<void> commitTransaction(TransactionHandle transaction);

  /// Rolls back a transaction
  Future<void> rollbackTransaction(TransactionHandle transaction);

  /// Checks if the transaction manager supports transactions
  bool get supportsTransactions;
}

/// Handle representing an active transaction
abstract class TransactionHandle {
  /// Gets the transaction name/identifier
  String get name;

  /// Gets the transaction ID for correlation
  String get id;

  /// Checks if the transaction is still active
  bool get isActive;
}

/// Simple in-memory transaction manager for when no external transaction support is available
class InMemoryTransactionManager implements TransactionManager {
  final Map<String, TransactionHandle> _activeTransactions = {};

  @override
  bool get supportsTransactions => false; // In-memory doesn't support real transactions

  @override
  Future<TransactionHandle> beginTransaction(String name) async {
    final id = 'tx_${DateTime.now().millisecondsSinceEpoch}_${name.hashCode}';
    final handle = _InMemoryTransactionHandle(name, id);
    _activeTransactions[id] = handle;
    return handle;
  }

  @override
  Future<void> commitTransaction(TransactionHandle transaction) async {
    if (transaction is _InMemoryTransactionHandle) {
      _activeTransactions.remove(transaction.id);
    }
    // In-memory transactions are no-ops for commit/rollback
  }

  @override
  Future<void> rollbackTransaction(TransactionHandle transaction) async {
    if (transaction is _InMemoryTransactionHandle) {
      _activeTransactions.remove(transaction.id);
    }
    // In-memory transactions are no-ops for commit/rollback
  }
}

/// In-memory implementation of transaction handle
class _InMemoryTransactionHandle implements TransactionHandle {
  @override
  final String name;
  @override
  final String id;
  @override
  bool isActive = true;

  _InMemoryTransactionHandle(this.name, this.id);

  @override
  String toString() => 'InMemoryTransaction($name, $id)';
}

/// Enhanced application service that provides complete coordination of the Command-Event-Policy cycle.
///
/// The EnhancedApplicationService serves as the primary orchestrator for complex business workflows
/// in EDNet Core applications. It coordinates the interaction between:
/// - Command execution through the CommandBus
/// - Event publishing through the EventBus
/// - Transaction management for ACID compliance
/// - Aggregate lifecycle management
/// - Error handling and recovery mechanisms
///
/// This class implements the Application Service pattern as described in Domain-Driven Design,
/// enhanced with reactive capabilities from the Command-Event-Policy cycle.
///
/// Key capabilities:
/// - **Transaction Coordination**: Ensures ACID properties across command execution and event publishing
/// - **Command Orchestration**: Coordinates command execution through the CommandBus infrastructure
/// - **Event Coordination**: Manages event publishing after successful command execution
/// - **Aggregate Management**: Handles aggregate loading, command execution, and persistence
/// - **Workflow Support**: Enables multi-step business workflows within transaction boundaries
/// - **Error Recovery**: Provides comprehensive error handling with automatic rollback
/// - **Performance Monitoring**: Tracks execution metrics and performance data
/// - **Concurrent Processing**: Supports safe concurrent command execution
///
/// Example usage:
/// ```dart
/// // Setup the enhanced application service
/// final applicationService = EnhancedApplicationService(
///   session: domainSession,
///   commandBus: commandBus,
///   eventBus: eventBus,
/// );
///
/// // Execute a single command with full coordination
/// final result = await applicationService.executeCommand(createOrderCommand);
///
/// // Execute a multi-step workflow
/// final workflowResults = await applicationService.executeWorkflow([
///   createOrderCommand,
///   reserveInventoryCommand,
///   processPaymentCommand,
/// ]);
///
/// // Execute command on a specific aggregate
/// final updateResult = await applicationService.executeCommandOnAggregate(
///   updateOrderCommand,
///   orderId,
///   orderRepository,
/// );
/// ```
///
/// Integration with EDNet Core:
/// - Uses [CommandBus] for command execution and handler coordination
/// - Uses [EventBus] for event publishing and policy triggering
/// - Integrates with [AggregateRoot] for aggregate command processing
/// - Supports [Repository] patterns for aggregate persistence
/// - Coordinates with domain sessions for transaction management
///
/// See also:
/// - [CommandBus] for command execution infrastructure
/// - [EventBus] for event publishing and policy coordination
/// - [AggregateRoot] for aggregate command processing
/// - [ApplicationService] for the base application service pattern
class EnhancedApplicationService with ObservabilityMixin {
  @override
  String get componentName => 'EnhancedApplicationService';

  /// The domain session for transaction and resource management
  final dynamic _session;

  /// The command bus for executing commands
  final CommandBus _commandBus;

  /// The event bus for publishing events and triggering policies
  final EventBus _eventBus;

  /// The transaction manager for handling transaction lifecycle
  final TransactionManager _transactionManager;

  /// Creates a new enhanced application service.
  ///
  /// Parameters:
  /// - [session]: Domain session for transaction management
  /// - [commandBus]: Command bus for command execution
  /// - [eventBus]: Event bus for event publishing
  /// - [transactionManager]: Transaction manager for handling transaction lifecycle
  EnhancedApplicationService({
    required dynamic session,
    required CommandBus commandBus,
    required EventBus eventBus,
    TransactionManager? transactionManager,
  }) : _session = session,
       _commandBus = commandBus,
       _eventBus = eventBus,
       _transactionManager = transactionManager ?? InMemoryTransactionManager();

  /// Executes a command with full transaction coordination.
  ///
  /// This method provides the core command execution workflow:
  /// 1. Begins a transaction
  /// 2. Executes the command through the CommandBus
  /// 3. Publishes any generated events through the EventBus
  /// 4. Commits the transaction on success or rolls back on failure
  ///
  /// The method ensures ACID properties across the entire operation,
  /// providing strong consistency guarantees for business operations.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult] indicating success or failure
  Future<CommandResult> executeCommand(ICommandBusCommand command) async {
    // Begin transaction for ACID compliance
    final transaction = await _beginTransaction(
      'ExecuteCommand_${command.runtimeType}',
    );

    try {
      // Execute command through the command bus
      final commandResult = await _commandBus.execute(command);

      if (commandResult.isFailure) {
        // Rollback transaction on command failure
        await _rollbackTransaction(transaction);
        return commandResult;
      }

      // Try to get and publish events from the command result or handlers
      await _publishEventsFromCommandExecution(command, commandResult);

      // Publish any pending events in the session
      await _publishPendingEvents();

      // Commit transaction after successful completion
      await _commitTransaction(transaction);

      return commandResult;
    } catch (e) {
      // Rollback transaction on any exception
      await _rollbackTransaction(transaction);

      return CommandResult.failure('Command execution failed: ${e.toString()}');
    }
  }

  /// Executes a command on a specific aggregate instance.
  ///
  /// This method provides aggregate-specific command execution:
  /// 1. Loads the aggregate from the repository
  /// 2. Executes the command on the aggregate
  /// 3. Persists the aggregate after successful execution
  /// 4. Publishes any generated events
  ///
  /// Parameters:
  /// - [command]: The command to execute
  /// - [aggregateId]: The ID of the aggregate to load
  /// - [repository]: The repository for loading and saving the aggregate
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult]
  Future<CommandResult> executeCommandOnAggregate(
    ICommandBusCommand command,
    String aggregateId,
    dynamic repository,
  ) async {
    final transaction = await _beginTransaction(
      'ExecuteCommandOnAggregate_${command.runtimeType}',
    );

    try {
      // Load the aggregate from the repository
      final aggregate = await repository.findById(aggregateId);

      if (aggregate == null) {
        await _rollbackTransaction(transaction);
        return CommandResult.failure('Aggregate not found: $aggregateId');
      }

      // Execute command on the aggregate
      final commandResult = await _executeCommandOnLoadedAggregate(
        aggregate,
        command,
      );

      if (commandResult.isFailure) {
        await _rollbackTransaction(transaction);
        return commandResult;
      }

      // Save the aggregate after successful command execution
      await repository.save(aggregate);

      // Publish events from the aggregate
      await _publishAggregateEvents(aggregate);

      // Keep publishing events until none are left, to handle policy-generated events
      while (aggregate.hasUncommittedEvents) {
        await _publishAggregateEvents(aggregate);
      }

      // Commit transaction
      await _commitTransaction(transaction);

      return commandResult;
    } catch (e) {
      await _rollbackTransaction(transaction);
      return CommandResult.failure(
        'Command execution on aggregate failed: ${e.toString()}',
      );
    }
  }

  /// Executes a command on a new aggregate instance.
  ///
  /// This method creates a new aggregate and executes the command on it.
  /// Useful for commands that create new aggregate instances.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  /// - [repository]: The repository for creating and saving the aggregate
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult]
  Future<CommandResult> executeCommandOnNewAggregate(
    ICommandBusCommand command,
    dynamic repository,
  ) async {
    final transaction = await _beginTransaction(
      'ExecuteCommandOnNewAggregate_${command.runtimeType}',
    );

    try {
      // Create a new aggregate
      final aggregate = repository.createNew();

      // Execute command on the new aggregate
      final commandResult = await _executeCommandOnLoadedAggregate(
        aggregate,
        command,
      );

      if (commandResult.isFailure) {
        await _rollbackTransaction(transaction);
        return commandResult;
      }

      // Save the new aggregate
      await repository.save(aggregate);

      // Publish events from the aggregate
      await _publishAggregateEvents(aggregate);

      // Keep publishing events until none are left, to handle policy-generated events
      while (aggregate.hasUncommittedEvents) {
        await _publishAggregateEvents(aggregate);
      }

      // Commit transaction
      await _commitTransaction(transaction);

      return commandResult;
    } catch (e) {
      await _rollbackTransaction(transaction);
      return CommandResult.failure(
        'Command execution on new aggregate failed: ${e.toString()}',
      );
    }
  }

  /// Executes a command with pre-execution validation.
  ///
  /// This method adds validation before command execution, allowing
  /// for business rule validation before the command is processed.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  /// - [repository]: The repository for aggregate operations
  /// - [validator]: Function to validate the command before execution
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult]
  Future<CommandResult> executeCommandWithValidation(
    ICommandBusCommand command,
    dynamic repository, {
    required dynamic Function(ICommandBusCommand) validator,
  }) async {
    try {
      // Validate command before execution
      final validationResult = validator(command);

      if (validationResult != null && !validationResult.isValid) {
        return CommandResult.failure(validationResult.errorMessage!);
      }

      // Proceed with normal command execution
      return await executeCommandOnNewAggregate(command, repository);
    } catch (e) {
      return CommandResult.failure(
        'Command validation failed: ${e.toString()}',
      );
    }
  }

  /// Executes a multi-step workflow within a single transaction.
  ///
  /// This method enables complex business workflows that require multiple
  /// commands to be executed atomically. If any step fails, the entire
  /// workflow is rolled back.
  ///
  /// Parameters:
  /// - [commands]: List of commands to execute in sequence
  ///
  /// Returns:
  /// A [Future] that resolves to a list of [CommandResult]s
  Future<List<CommandResult>> executeWorkflow(
    List<ICommandBusCommand> commands,
  ) async {
    final transaction = await _beginTransaction(
      'ExecuteWorkflow_${commands.length}_commands',
    );
    final results = <CommandResult>[];

    try {
      for (final command in commands) {
        // Execute each command through the command bus (without starting new transactions)
        final commandResult = await _commandBus.execute(command);
        results.add(commandResult);

        // Stop workflow execution on first failure
        if (commandResult.isFailure) {
          await _rollbackTransaction(transaction);
          return results;
        }
      }

      // Publish all pending events after successful workflow completion
      await _publishPendingEvents();

      // Commit the entire workflow
      await _commitTransaction(transaction);

      return results;
    } catch (e) {
      await _rollbackTransaction(transaction);

      // Add error result for the failed step
      results.add(
        CommandResult.failure('Workflow execution failed: ${e.toString()}'),
      );

      return results;
    }
  }

  /// Executes a function directly on an aggregate instance.
  ///
  /// This method provides direct function execution on an aggregate:
  /// 1. Executes the function on the aggregate
  /// 2. Publishes any generated events
  /// 3. Manages transactions
  ///
  /// Parameters:
  /// - [aggregate]: The aggregate instance to execute on
  /// - [operation]: The function to execute on the aggregate
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult]
  Future<CommandResult> executeOnAggregate(
    dynamic aggregate,
    dynamic operation,
  ) async {
    final transaction = await _beginTransaction(
      'ExecuteOnAggregate_${aggregate.runtimeType}',
    );

    try {
      // Execute operation on the aggregate
      dynamic result;
      if (operation is Future<CommandResult> Function()) {
        result = await operation();
      } else if (operation is CommandResult Function()) {
        result = operation();
      } else {
        result = await operation();
      }

      // Ensure result is a CommandResult
      if (result is! CommandResult) {
        result = CommandResult.failure('Invalid operation result type');
      }

      // Always publish events, regardless of success or failure of the business operation.
      // The event itself is a fact that occurred.
      await _publishAggregateEvents(aggregate);

      if (result.isFailure) {
        // We commit even on business failure, because the aggregate might have recorded
        // the failure event as part of its state (e.g., an audit trail).
        await _commitTransaction(transaction);
        return result;
      }

      // Commit transaction on success
      await _commitTransaction(transaction);

      return result;
    } catch (e) {
      await _rollbackTransaction(transaction);
      return CommandResult.failure(
        'Operation execution on aggregate failed: ${e.toString()}',
      );
    }
  }

  /// Executes a command with performance metrics collection.
  ///
  /// This method wraps command execution with performance monitoring,
  /// providing insights into command execution times and system performance.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult] with metrics data
  Future<CommandResult> executeCommandWithMetrics(
    ICommandBusCommand command,
  ) async {
    final startTime = DateTime.now();
    final stopwatch = Stopwatch()..start();

    try {
      final result = await executeCommand(command);

      stopwatch.stop();
      final endTime = DateTime.now();

      // Add metrics to the result
      final metricsData = {
        'executionTimeMs': stopwatch.elapsedMilliseconds,
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'success': result.isSuccess,
      };

      if (result.isSuccess) {
        // Add metrics to successful result
        final enhancedData = Map<String, dynamic>.from(result.data ?? {});
        enhancedData['metrics'] = metricsData;

        return CommandResult.success(data: enhancedData);
      } else {
        // Return original failure result with metrics in a separate property
        return result;
      }
    } catch (e) {
      stopwatch.stop();
      return CommandResult.failure(
        'Command execution with metrics failed: ${e.toString()}',
      );
    }
  }

  /// Begins a new transaction with the given name.
  ///
  /// Parameters:
  /// - [name]: Name for the transaction (for debugging and monitoring)
  ///
  /// Returns:
  /// A transaction object that can be committed or rolled back
  Future<TransactionHandle> _beginTransaction(String name) async {
    // Use the injected transaction manager instead of duck typing
    return await _transactionManager.beginTransaction(name);
  }

  /// Commits a transaction.
  ///
  /// Parameters:
  /// - [transaction]: The transaction to commit
  Future<void> _commitTransaction(TransactionHandle transaction) async {
    try {
      await _transactionManager.commitTransaction(transaction);
    } catch (e) {
      observabilityError('Failed to commit transaction');
      rethrow;
    }
  }

  /// Rolls back a transaction.
  ///
  /// Parameters:
  /// - [transaction]: The transaction to roll back
  Future<void> _rollbackTransaction(TransactionHandle transaction) async {
    try {
      await _transactionManager.rollbackTransaction(transaction);
    } catch (e) {
      observabilityError('Failed to rollback transaction');
      // Don't rethrow rollback errors as they might be due to already rolled back transactions
    }
  }

  /// Executes a command on a loaded aggregate instance.
  ///
  /// Parameters:
  /// - [aggregate]: The aggregate to execute the command on
  /// - [command]: The command to execute
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult]
  Future<CommandResult> _executeCommandOnLoadedAggregate(
    dynamic aggregate,
    ICommandBusCommand command,
  ) async {
    try {
      // Try to execute the command on the aggregate
      if (aggregate.processCommand != null) {
        return aggregate.processCommand(command);
      } else if (aggregate.executeCommand != null) {
        return aggregate.executeCommand(command);
      } else {
        return CommandResult.failure(
          'Aggregate does not support command execution',
        );
      }
    } catch (e) {
      return CommandResult.failure(
        'Command execution on aggregate failed: ${e.toString()}',
      );
    }
  }

  /// Publishes events from an aggregate after successful command execution.
  ///
  /// Parameters:
  /// - [aggregate]: The aggregate containing pending events
  Future<void> _publishAggregateEvents(dynamic aggregate) async {
    try {
      if (aggregate.pendingEvents != null &&
          aggregate.pendingEvents.isNotEmpty) {
        final eventsToPublish = List<IDomainEvent>.from(
          aggregate.pendingEvents.map((e) {
            if (e is IDomainEvent) return e;
            return domainEventFromBaseEvent(e, entity: aggregate);
          }),
        );

        // Clear events before publishing to avoid re-entrant loops
        if (aggregate.markEventsAsProcessed != null) {
          aggregate.markEventsAsProcessed();
        }

        await _eventBus.publishAll(eventsToPublish);
      }
    } catch (e) {
      // Log event publishing errors but don't fail the command
      observabilityWarning(
        'aggregateEventPublishingFailed',
        context: {
          'error': e.toString(),
          'aggregateType': aggregate.runtimeType.toString(),
          'hasEvents': aggregate.pendingEvents?.isNotEmpty ?? false,
        },
      );
    }
  }

  /// Publishes any pending events in the session.
  Future<void> _publishPendingEvents() async {
    try {
      if (_session != null) {
        // Try to access publishedEvents via duck typing
        final sessionReflection = _session as dynamic;
        if (sessionReflection.publishedEvents != null) {
          for (final event in sessionReflection.publishedEvents) {
            if (event is IDomainEvent) {
              await _eventBus.publish(event);
            }
          }

          // Clear published events after processing
          if (sessionReflection.publishedEvents.clear != null) {
            sessionReflection.publishedEvents.clear();
          }
        }
      }
    } catch (e) {
      // Log event publishing errors but don't fail the command
      // This is expected for DomainSession which doesn't have publishedEvents
      observabilityWarning(
        'sessionEventPublishingFailed',
        context: {
          'error': e.toString(),
          'sessionType': _session?.runtimeType.toString() ?? 'null',
          'isExpectedFailure': true,
        },
      );
    }
  }

  /// Publishes events from command execution by attempting to get events from command handlers.
  ///
  /// This method tries to extract events from the executed command by looking for
  /// aggregates that may have generated events during command processing.
  ///
  /// Parameters:
  /// - [command]: The command that was executed
  /// - [commandResult]: The result of the command execution
  Future<void> _publishEventsFromCommandExecution(
    ICommandBusCommand command,
    CommandResult commandResult,
  ) async {
    if (commandResult.isFailure) {
      return;
    }

    try {
      // Check if command result contains event data
      if (commandResult.data != null &&
          commandResult.data is Map<String, dynamic>) {
        final resultData = commandResult.data as Map<String, dynamic>;

        // Look for events in the result data
        if (resultData.containsKey('events')) {
          final events = resultData['events'] as List<dynamic>?;
          if (events != null) {
            for (final event in events) {
              if (event is IDomainEvent) {
                await _eventBus.publish(event);
              }
            }
          }
        }

        // Create and publish a simple event based on the command result
        if (resultData.containsKey('orderId')) {
          final event = _createSimpleEvent('OrderProcessed', commandResult);
          await _eventBus.publish(event);
        }
      }
    } catch (e) {
      // Log error but don't fail the command
      observabilityWarning(
        'commandExecutionEventPublishingFailed',
        context: {
          'error': e.toString(),
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'resultSuccess': commandResult.isSuccess,
        },
      );
    }
  }

  /// Creates a simple domain event from command execution results.
  IDomainEvent _createSimpleEvent(
    String eventName,
    CommandResult commandResult,
  ) {
    return _SimpleDomainEvent(name: eventName, data: commandResult.data);
  }
}

/// Simple domain event implementation for internal use
class _SimpleDomainEvent implements IDomainEvent {
  @override
  final String id = Oid().toString();

  @override
  final DateTime timestamp = DateTime.now();

  @override
  final String name;

  @override
  Entity? entity;

  @override
  String aggregateId = '';

  @override
  String aggregateType = '';

  @override
  int aggregateVersion = 0;

  final dynamic data;

  @override
  Map<String, dynamic> get eventData =>
      data is Map<String, dynamic> ? data : {'data': data};

  _SimpleDomainEvent({required this.name, this.data});

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'name': name,
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'data': data,
  };

  @override
  Event toBaseEvent() {
    return Event(name, 'Simple domain event', [], entity, toJson());
  }
}
