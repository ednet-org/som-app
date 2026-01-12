part of ednet_core;

/// Interface for command handlers in the EDNet Core command bus system.
///
/// Command handlers are responsible for executing the business logic associated
/// with specific command types. They bridge the gap between commands (intent)
/// and the domain model (implementation).
///
/// Key responsibilities of command handlers:
/// - **Command Processing**: Execute the business logic for a specific command type
/// - **Validation**: Ensure the command and domain state are valid for execution
/// - **Transaction Management**: Coordinate with application services for transactions
/// - **Event Generation**: Trigger domain events as a result of command execution
/// - **Error Handling**: Provide meaningful error messages for failures
///
/// Command handlers are typically registered with a [CommandBus] and invoked
/// automatically when matching commands are executed.
///
/// Example implementation:
/// ```dart
/// class CreateOrderHandler implements ICommandHandler<CreateOrderCommand> {
///   final OrderRepository _orderRepository;
///   final CustomerRepository _customerRepository;
///
///   CreateOrderHandler(this._orderRepository, this._customerRepository);
///
///   @override
///   Future<CommandResult> handle(CreateOrderCommand command) async {
///     // 1. Validate the command
///     final customer = await _customerRepository.findById(command.customerId);
///     if (customer == null) {
///       return CommandResult.failure('Customer not found');
///     }
///
///     // 2. Execute domain logic
///     final order = Order.create(command.customerId, command.items);
///
///     // 3. Persist changes
///     await _orderRepository.save(order);
///
///     // 4. Return success result
///     return CommandResult.success(data: order.id);
///   }
///
///   @override
///   bool canHandle(dynamic command) => command is CreateOrderCommand;
/// }
/// ```
///
/// See also:
/// - [CommandBus] for command execution orchestration
/// - [ICommandBusCommand] for command interface
/// - [CommandResult] for execution results
/// - [ApplicationService] for transaction coordination
abstract class ICommandHandler<TCommand extends ICommandBusCommand> {
  /// Handles the execution of a command.
  ///
  /// This method contains the core business logic for processing the command.
  /// It should:
  /// 1. Validate the command and current domain state
  /// 2. Execute the required business operations
  /// 3. Persist any state changes
  /// 4. Return a result indicating success or failure
  ///
  /// The method is asynchronous to support operations that require:
  /// - Database access for validation or persistence
  /// - External service calls
  /// - Complex computations
  /// - Event publishing
  ///
  /// Parameters:
  /// - [command]: The command to be executed
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult] indicating the outcome
  ///
  /// Throws:
  /// - Should not throw exceptions; all errors should be captured in [CommandResult]
  /// - The [CommandBus] will catch any exceptions and convert them to failure results
  Future<CommandResult> handle(TCommand command);

  /// Determines if this handler can process the given command.
  ///
  /// This method is used by the [CommandBus] to route commands to appropriate
  /// handlers. Multiple handlers can handle the same command type if needed.
  ///
  /// The default implementation should check the command type:
  /// ```dart
  /// @override
  /// bool canHandle(dynamic command) => command is MyCommandType;
  /// ```
  ///
  /// Parameters:
  /// - [command]: The command to check
  ///
  /// Returns:
  /// `true` if this handler can process the command, `false` otherwise
  bool canHandle(dynamic command);
}

/// Exception thrown when no command handler is found for a command.
///
/// This exception is thrown by the [CommandBus] when attempting to execute
/// a command for which no registered handler exists.
class CommandHandlerNotFoundException implements Exception {
  /// The type of command that could not be handled.
  final Type commandType;

  /// The command instance that could not be handled.
  final ICommandBusCommand command;

  /// Creates a new [CommandHandlerNotFoundException].
  ///
  /// Parameters:
  /// - [commandType]: The type of the command
  /// - [command]: The command instance
  CommandHandlerNotFoundException(this.commandType, this.command);

  @override
  String toString() {
    return 'CommandHandlerNotFoundException: No handler registered for command type $commandType (Command ID: ${command.id})';
  }
}
