part of ednet_core;

/// Central command execution infrastructure for EDNet Core applications.
///
/// The CommandBus is the primary entry point for executing commands in the
/// domain model. It provides a decoupled, extensible architecture for:
/// - Routing commands to appropriate handlers
/// - Validating commands before execution
/// - Executing pre/post-processing middleware
/// - Publishing events about command execution
/// - Handling errors gracefully
///
/// The CommandBus implements the Command pattern and serves as the foundation
/// for the Command-Event-Policy cycle described in Chapter 5 of the EDNet book.
///
/// Key capabilities:
/// - **Handler Registration**: Multiple handlers per command type
/// - **Validation Pipeline**: Pre-execution command validation
/// - **Middleware Support**: Extensible pre/post-execution hooks
/// - **Event Integration**: Automatic event publishing for command lifecycle
/// - **Error Handling**: Graceful handling of exceptions with meaningful results
/// - **Concurrent Execution**: Support for parallel handler execution
///
/// Example usage:
/// ```dart
/// // Setup
/// final commandBus = CommandBus();
/// final orderHandler = CreateOrderHandler(orderRepo, customerRepo);
/// commandBus.registerHandler<CreateOrderCommand>(orderHandler);
///
/// // Execution
/// final command = CreateOrderCommand(customerId: '123', items: [item1, item2]);
/// final result = await commandBus.execute(command);
///
/// if (result.isSuccess) {
///   print('Order created with ID: ${result.data}');
/// } else {
///   print('Order creation failed: ${result.errorMessage}');
/// }
/// ```
///
/// Integration with EDNet Core:
/// - Works seamlessly with [ApplicationService] for transaction management
/// - Integrates with [EventStore] and [EventPublisher] for event sourcing
/// - Supports [IPolicy] execution through event publishing
/// - Enables the Command-Event-Policy cycle for reactive domain logic
///
/// See also:
/// - [ICommandBusCommand] for command interface
/// - [ICommandHandler] for handler interface
/// - [CommandResult] for execution results
/// - [ApplicationService] for higher-level orchestration
class CommandBus with ObservabilityMixin {
  @override
  String get componentName => 'CommandBus';

  /// Registry of command handlers by command type
  final Map<Type, List<ICommandHandler>> _handlers = {};

  /// Registry of command validators by command type
  final Map<Type, Function> _validators = {};

  /// Pre-execution middleware functions
  final List<Future<void> Function(ICommandBusCommand)>
  _preExecutionMiddleware = [];

  /// Post-execution middleware functions
  final List<Future<void> Function(ICommandBusCommand, CommandResult)>
  _postExecutionMiddleware = [];

  /// Event publisher for command lifecycle events
  dynamic _eventPublisher;

  /// Creates a new CommandBus instance.
  CommandBus();

  /// Registers a command handler for a specific command type.
  ///
  /// Multiple handlers can be registered for the same command type, enabling
  /// patterns like:
  /// - Primary and fallback handlers
  /// - Audit handlers alongside business handlers
  /// - Event handlers that react to command execution
  ///
  /// Parameters:
  /// - [handler]: The command handler to register
  ///
  /// Example:
  /// ```dart
  /// final handler = CreateOrderHandler(orderRepo);
  /// commandBus.registerHandler<CreateOrderCommand>(handler);
  /// ```
  void registerHandler<TCommand extends ICommandBusCommand>(
    ICommandHandler<TCommand> handler,
  ) {
    final commandType = TCommand;
    _handlers.putIfAbsent(commandType, () => []);
    _handlers[commandType]!.add(handler);
  }

  /// Unregisters a specific command handler.
  ///
  /// Parameters:
  /// - [handler]: The command handler to remove
  void unregisterHandler<TCommand extends ICommandBusCommand>(
    ICommandHandler<TCommand> handler,
  ) {
    final commandType = TCommand;
    _handlers[commandType]?.remove(handler);
    if (_handlers[commandType]?.isEmpty ?? false) {
      _handlers.remove(commandType);
    }
  }

  /// Checks if any handlers are registered for a command type.
  ///
  /// Returns:
  /// `true` if handlers exist for the command type, `false` otherwise
  bool hasHandlerFor<TCommand extends ICommandBusCommand>() {
    final commandType = TCommand;
    return _handlers.containsKey(commandType) &&
        _handlers[commandType]!.isNotEmpty;
  }

  /// Gets all handlers registered for a command type.
  ///
  /// Returns:
  /// List of handlers for the command type, empty if none registered
  List<ICommandHandler> getHandlersFor<TCommand extends ICommandBusCommand>() {
    final commandType = TCommand;
    return List.unmodifiable(_handlers[commandType] ?? []);
  }

  /// Registers a validator for a specific command type.
  ///
  /// Validators are executed before command handlers and can prevent
  /// command execution if validation fails.
  ///
  /// Parameters:
  /// - [validator]: Function that validates the command and returns a result
  ///
  /// Example:
  /// ```dart
  /// commandBus.registerValidator<CreateOrderCommand>((command) {
  ///   return command.items.isNotEmpty
  ///     ? ValidationResult.success()
  ///     : ValidationResult.failure('Order must have items');
  /// });
  /// ```
  void registerValidator<TCommand extends ICommandBusCommand>(
    dynamic Function(TCommand) validator,
  ) {
    final commandType = TCommand;
    _validators[commandType] = validator;
  }

  /// Adds pre-execution middleware that runs before command handling.
  ///
  /// Pre-execution middleware can be used for:
  /// - Logging command execution
  /// - Authentication/authorization checks
  /// - Performance monitoring
  /// - Command transformation
  ///
  /// Parameters:
  /// - [middleware]: Function to execute before command handling
  void addPreExecutionMiddleware(
    Future<void> Function(ICommandBusCommand) middleware,
  ) {
    _preExecutionMiddleware.add(middleware);
  }

  /// Adds post-execution middleware that runs after command handling.
  ///
  /// Post-execution middleware can be used for:
  /// - Audit logging
  /// - Performance metrics
  /// - Cleanup operations
  /// - Result transformation
  ///
  /// Parameters:
  /// - [middleware]: Function to execute after command handling
  void addPostExecutionMiddleware(
    Future<void> Function(ICommandBusCommand, CommandResult) middleware,
  ) {
    _postExecutionMiddleware.add(middleware);
  }

  /// Sets the event publisher for command lifecycle events.
  ///
  /// The CommandBus publishes events for:
  /// - CommandExecuted: When a command completes successfully
  /// - CommandFailed: When a command execution fails
  /// - CommandValidationFailed: When command validation fails
  ///
  /// Parameters:
  /// - [eventPublisher]: Publisher that implements a `publish` method
  void setEventPublisher(dynamic eventPublisher) {
    _eventPublisher = eventPublisher;
  }

  /// Executes a command using the first available handler.
  ///
  /// Enhanced with detailed traceability for debugging test failures.
  ///
  /// This method:
  /// 1. Validates the command if validators are registered
  /// 2. Executes pre-execution middleware
  /// 3. Finds and executes the first matching handler
  /// 4. Executes post-execution middleware
  /// 5. Publishes lifecycle events
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns:
  /// A [Future] that resolves to the command execution result
  ///
  /// Throws:
  /// - [CommandHandlerNotFoundException]: If no handler is registered
  Future<CommandResult> execute(ICommandBusCommand command) async {
    final commandType = command.runtimeType;
    final commandId = command.id;

    // Enhanced traceability logging
    observabilityTrace('commandExecutionStarted', {
      'commandType': commandType.toString(),
      'commandId': commandId,
      'commandData': command.toJson(),
    });

    // Validate command first, similar to executeAll
    final validationResult = await _validateCommand(command);
    if (validationResult != null && !validationResult.isValid) {
      observabilityError(
        'commandValidationFailed',
        error: 'Validation failed: ${validationResult.errorMessage}',
        context: {
          'commandType': commandType.toString(),
          'commandId': commandId,
          'validationError': validationResult.errorMessage,
        },
      );
      final result = CommandResult.failure(validationResult.errorMessage!);
      await _publishEvent('CommandValidationFailed', command, result);
      return result;
    }

    await _executePreExecutionMiddleware(command);

    var handlers = _handlers[commandType];

    if (handlers == null || handlers.isEmpty) {
      observabilityError(
        'noHandlerFound',
        error: 'No handler registered for command type: $commandType',
        context: {
          'commandType': commandType.toString(),
          'commandId': commandId,
          'availableHandlerTypes': _handlers.keys
              .map((k) => k.toString())
              .toList(),
        },
      );
      return CommandResult.failure(
        'No handler registered for command type: $commandType',
      );
    }

    observabilityTrace('handlerExecutionStarted', {
      'commandType': commandType.toString(),
      'commandId': commandId,
      'handlerType': handlers.first.runtimeType.toString(),
      'handlerCount': handlers.length,
    });

    final result = await _executeHandler(handlers.first, command);

    observabilityTrace('handlerExecutionCompleted', {
      'commandType': commandType.toString(),
      'commandId': commandId,
      'handlerType': handlers.first.runtimeType.toString(),
      'success': result.isSuccess,
      'errorMessage': result.errorMessage,
      'resultData': result.data,
    });

    // Execute post-execution middleware
    await _executePostMiddleware(command, result);

    // Publish lifecycle event
    await _publishEvent(
      result.isSuccess ? 'CommandExecuted' : 'CommandFailed',
      command,
      result,
    );

    observabilityTrace('commandExecutionCompleted', {
      'commandType': commandType.toString(),
      'commandId': commandId,
      'success': result.isSuccess,
      'errorMessage': result.errorMessage,
    });

    return result;
  }

  /// Executes a command using all available handlers.
  ///
  /// This method executes all registered handlers for the command type
  /// and returns all results. Useful for scenarios where multiple
  /// handlers need to process the same command.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns:
  /// A [Future] that resolves to a list of all execution results
  Future<List<CommandResult>> executeAll(ICommandBusCommand command) async {
    try {
      // Validate command
      final validationResult = await _validateCommand(command);
      if (validationResult != null && !validationResult.isValid) {
        final result = CommandResult.failure(validationResult.errorMessage!);
        await _publishEvent('CommandValidationFailed', command, result);
        return [result];
      }

      // Execute pre-execution middleware
      await _executePreExecutionMiddleware(command);

      // Find and execute all handlers
      final handlers = _getHandlersForCommand(command);
      if (handlers.isEmpty) {
        throw CommandHandlerNotFoundException(command.runtimeType, command);
      }

      final results = <CommandResult>[];
      for (final handler in handlers) {
        final result = await _executeHandler(handler, command);
        results.add(result);
      }

      // Execute post-execution middleware for each result
      for (final result in results) {
        await _executePostMiddleware(command, result);
      }

      // Publish lifecycle events
      for (final result in results) {
        await _publishEvent(
          result.isSuccess ? 'CommandExecuted' : 'CommandFailed',
          command,
          result,
        );
      }

      return results;
    } catch (e) {
      final result = CommandResult.failure('Command execution failed: $e');
      await _publishEvent('CommandFailed', command, result);
      return [result];
    }
  }

  /// Validates a command using registered validators.
  Future<dynamic> _validateCommand(ICommandBusCommand command) async {
    final commandType = command.runtimeType;
    final validator = _validators[commandType];

    if (validator != null) {
      try {
        return validator(command);
      } catch (e) {
        // Return a failure result if validation throws
        return _createValidationResult(false, 'Validation error: $e');
      }
    }

    return null; // No validator registered
  }

  /// Creates a validation result object.
  dynamic _createValidationResult(bool isValid, String? errorMessage) {
    return _ValidationResult(isValid, errorMessage);
  }

  /// Executes pre-execution middleware.
  Future<void> _executePreExecutionMiddleware(
    ICommandBusCommand command,
  ) async {
    for (final middleware in _preExecutionMiddleware) {
      try {
        await middleware(command);
      } catch (e) {
        // Log middleware errors but don't stop execution
        observabilityError(
          'preExecutionMiddlewareFailed',
          error: e,
          context: {
            'commandType': command.runtimeType.toString(),
            'middlewareType': middleware.runtimeType.toString(),
          },
        );
      }
    }
  }

  /// Executes post-execution middleware.
  Future<void> _executePostMiddleware(
    ICommandBusCommand command,
    CommandResult result,
  ) async {
    for (final middleware in _postExecutionMiddleware) {
      try {
        await middleware(command, result);
      } catch (e) {
        // Log middleware errors but don't affect the result
        observabilityError(
          'postExecutionMiddlewareFailed',
          error: e,
          context: {
            'commandType': command.runtimeType.toString(),
            'middlewareType': middleware.runtimeType.toString(),
            'resultSuccess': result.isSuccess,
          },
        );
      }
    }
  }

  /// Gets handlers that can process the given command.
  List<ICommandHandler> _getHandlersForCommand(ICommandBusCommand command) {
    final handlers = <ICommandHandler>[];

    for (final handlerList in _handlers.values) {
      for (final handler in handlerList) {
        if (handler.canHandle(command)) {
          handlers.add(handler);
        }
      }
    }

    return handlers;
  }

  /// Executes a specific handler with error handling.
  Future<CommandResult> _executeHandler(
    ICommandHandler handler,
    ICommandBusCommand command,
  ) async {
    try {
      return await handler.handle(command);
    } catch (e) {
      return CommandResult.failure('Handler execution failed: $e');
    }
  }

  /// Publishes lifecycle events if an event publisher is configured.
  Future<void> _publishEvent(
    String eventName,
    ICommandBusCommand command,
    CommandResult result,
  ) async {
    if (_eventPublisher?.publish != null) {
      try {
        final event = _createLifecycleEvent(eventName, command, result);
        _eventPublisher.publish(event);
      } catch (e) {
        // Log event publishing errors but don't affect command execution
        observabilityError(
          'eventPublishingFailed',
          error: e,
          context: {
            'eventName': eventName,
            'commandType': command.runtimeType.toString(),
            'resultSuccess': result.isSuccess,
          },
        );
      }
    }
  }

  /// Creates a lifecycle event for command execution.
  IDomainEvent _createLifecycleEvent(
    String eventName,
    ICommandBusCommand command,
    CommandResult result,
  ) {
    return _CommandLifecycleEvent(
      name: eventName,
      commandId: command.id,
      commandType: command.runtimeType.toString(),
      result: result,
      timestamp: DateTime.now(),
    );
  }
}

/// Internal validation result class
class _ValidationResult {
  final bool isValid;
  final String? errorMessage;

  _ValidationResult(this.isValid, this.errorMessage);
}

/// Internal lifecycle event class
class _CommandLifecycleEvent extends DomainEvent {
  final String commandId;
  final String commandType;
  final CommandResult result;

  _CommandLifecycleEvent({
    required String name,
    required this.commandId,
    required this.commandType,
    required this.result,
    required DateTime timestamp,
  }) : super(
         name: name,
         aggregateId: commandId,
         aggregateType: 'Command',
         timestamp: timestamp,
       );

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'commandId': commandId,
      'commandType': commandType,
      'success': result.isSuccess,
      'message': result.isSuccess
          ? 'Command executed successfully'
          : result.errorMessage,
      'data': result.data,
    });
    return json;
  }
}
