part of ednet_core;

/// Interface for application services that coordinate the Command-Event-Policy cycle.
///
/// The [IApplicationService] interface defines the contract for application services
/// in EDNet Core applications. It provides the foundational methods for:
/// - Command execution with transaction coordination
/// - Event publishing and policy triggering
/// - Security and authorization enforcement
/// - Aggregate lifecycle management
/// - Workflow orchestration
/// - Performance monitoring and observability
///
/// Application services serve as the primary entry point for business operations,
/// coordinating between the domain layer, infrastructure, and presentation layers.
/// They implement the Application Service pattern from Domain-Driven Design,
/// enhanced with reactive capabilities and security enforcement.
///
/// Key responsibilities:
/// - **Transaction Management**: Ensure ACID properties across operations
/// - **Security Enforcement**: Check permissions before executing operations
/// - **Command Coordination**: Route commands to appropriate handlers
/// - **Event Publishing**: Publish domain events to trigger policies and reactions
/// - **Aggregate Management**: Load, modify, and persist aggregates safely
/// - **Workflow Support**: Enable multi-step business processes
/// - **Error Handling**: Provide consistent error handling and recovery
/// - **Observability**: Track performance and business metrics
///
/// Example implementation:
/// ```dart
/// class OrderApplicationService implements IApplicationService {
///   // Implement required methods...
///
///   Future<CommandResult> createOrder(CreateOrderCommand command) {
///     return executeSecureCommand(command, ['Order:create']);
///   }
/// }
/// ```
///
/// Integration with EDNet Core:
/// - Uses [CommandBus] for command execution
/// - Uses [EventBus] for event publishing and policy triggering
/// - Integrates with [SecurityContext] for authorization
/// - Coordinates with domain sessions for transaction management
/// - Supports [ObservabilityMixin] for comprehensive monitoring
abstract class IApplicationService {
  /// Executes a command with full transaction and security coordination.
  ///
  /// This is the primary method for executing business operations. It provides:
  /// 1. Security authorization checks
  /// 2. Transaction management
  /// 3. Command execution through the CommandBus
  /// 4. Event publishing through the EventBus
  /// 5. Error handling and rollback
  ///
  /// Parameters:
  /// - [command]: The command to execute
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult] indicating success or failure
  Future<CommandResult> executeCommand(ICommandBusCommand command);

  /// Executes a command with explicit permission requirements.
  ///
  /// This method adds security enforcement to command execution by requiring
  /// specific permissions before allowing the command to proceed.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  /// - [requiredPermissions]: List of permissions required to execute the command
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult]
  ///
  /// Throws:
  /// [SecurityContextException] if the current subject lacks required permissions
  Future<CommandResult> executeSecureCommand(
    ICommandBusCommand command,
    List<String> requiredPermissions,
  );

  /// Executes a command on a specific aggregate instance.
  ///
  /// This method provides aggregate-specific command execution with:
  /// - Aggregate loading from repository
  /// - Command execution on the loaded aggregate
  /// - Aggregate persistence after successful execution
  /// - Event publishing from the aggregate
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
  );

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
  );

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
  );

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
  Future<CommandResult> executeCommandWithMetrics(ICommandBusCommand command);

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
  });

  /// Executes a function directly on an aggregate instance.
  ///
  /// This method provides direct function execution on an aggregate with
  /// full transaction management and event publishing.
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
  );

  /// Checks if the current security context has the required permissions.
  ///
  /// This method provides a way to check permissions without executing commands,
  /// useful for UI authorization and conditional logic.
  ///
  /// Parameters:
  /// - [permissions]: List of permission strings to check
  ///
  /// Returns:
  /// True if the current subject has all the required permissions
  bool hasPermissions(List<String> permissions);

  /// Checks if the current security context has any of the specified permissions.
  ///
  /// Parameters:
  /// - [permissions]: List of permission strings to check
  ///
  /// Returns:
  /// True if the current subject has any of the permissions
  bool hasAnyPermission(List<String> permissions);

  /// Gets the current security subject.
  ///
  /// Returns:
  /// The current [SecuritySubject] from the security context
  SecuritySubject getCurrentSubject();

  /// Runs an operation with elevated system privileges.
  ///
  /// This method temporarily elevates the security context to system privileges,
  /// runs the specified operation, and then restores the original context.
  ///
  /// Parameters:
  /// - [operation]: The operation to run with system privileges
  ///
  /// Returns:
  /// The result of the operation
  Future<T> runWithSystemPrivileges<T>(Future<T> Function() operation);

  /// Runs an operation within a specific security context.
  ///
  /// This method allows running operations with a different security subject
  /// than the current context.
  ///
  /// Parameters:
  /// - [subject]: The security subject to use for the operation
  /// - [operation]: The operation to run with the specified subject
  ///
  /// Returns:
  /// The result of the operation
  Future<T> runWithSubject<T>(
    SecuritySubject subject,
    Future<T> Function() operation,
  );
}
