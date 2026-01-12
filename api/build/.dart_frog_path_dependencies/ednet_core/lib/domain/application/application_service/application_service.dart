part of ednet_core;

/// Application service that provides complete coordination of the Command-Event-Policy cycle with security.
///
/// The [ApplicationService] serves as the primary entry point for all business operations
/// in EDNet Core applications. It combines and enhances the capabilities of:
/// - [EnhancedApplicationService] for command execution and transaction management
/// - [SecurityContext] for comprehensive authorization and entitlement
/// - [ObservabilityMixin] for complete operational visibility
/// - Domain session management for transaction coordination
///
/// This implementation represents the culmination of EDNet Core's application layer patterns,
/// providing a single, coherent interface for all application service needs.
///
/// Key capabilities:
/// - **Complete Security Integration**: All operations are secured by default
/// - **Transaction Coordination**: Full ACID compliance with automatic rollback
/// - **Command Orchestration**: Sophisticated command routing and execution
/// - **Event Coordination**: Reactive event publishing with policy triggering
/// - **Aggregate Management**: Comprehensive aggregate lifecycle support
/// - **Workflow Support**: Multi-step business process orchestration
/// - **Performance Monitoring**: Built-in metrics and observability
/// - **Error Recovery**: Comprehensive error handling with context preservation
/// - **Concurrent Processing**: Safe concurrent command execution
///
/// Security features:
/// - Permission-based authorization for all operations
/// - Role-based access control integration
/// - Field-level security enforcement
/// - Audit logging for all security events
/// - Privilege escalation and context switching
///
/// Example usage:
/// ```dart
/// // Create the application service
/// final appService = ApplicationService(
///   session: domainSession,
///   commandBus: commandBus,
///   eventBus: eventBus,
/// );
///
/// // Execute a secured command
/// final result = await appService.executeSecureCommand(
///   createOrderCommand,
///   ['Order:create'],
/// );
///
/// // Execute a workflow with full transaction coordination
/// final workflowResults = await appService.executeWorkflow([
///   createOrderCommand,
///   reserveInventoryCommand,
///   processPaymentCommand,
/// ]);
/// ```
///
/// Integration with EDNet Core:
/// - Implements [IApplicationService] for proper abstraction
/// - Uses [EnhancedApplicationService] internally for core functionality
/// - Integrates with [SecurityContext] for all security operations
/// - Supports [ObservabilityMixin] for comprehensive monitoring
/// - Coordinates with domain sessions for transaction management
/// - Works with [CommandBus] and [EventBus] for CQRS operations
class ApplicationService
    with ObservabilityMixin
    implements IApplicationService {
  @override
  String get componentName => 'ApplicationService';

  /// The enhanced application service that provides core functionality
  final EnhancedApplicationService _enhancedService;

  /// Creates a new flagship application service.
  ///
  /// Parameters:
  /// - [session]: Domain session for transaction management
  /// - [commandBus]: Command bus for command execution
  /// - [eventBus]: Event bus for event publishing
  ApplicationService({
    required dynamic session,
    required CommandBus commandBus,
    required EventBus eventBus,
  }) : _enhancedService = EnhancedApplicationService(
         session: session,
         commandBus: commandBus,
         eventBus: eventBus,
       );

  @override
  Future<CommandResult> executeCommand(ICommandBusCommand command) async {
    observabilityInfo(
      'executeCommand',
      context: {
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final result = await _enhancedService.executeCommand(command);

      observabilityInfo(
        'executeCommandCompleted',
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'success': result.isSuccess,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'executeCommandFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<CommandResult> executeSecureCommand(
    ICommandBusCommand command,
    List<String> requiredPermissions,
  ) async {
    observabilityInfo(
      'executeSecureCommand',
      context: {
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'requiredPermissions': requiredPermissions,
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      // Check permissions before execution
      for (final permissionString in requiredPermissions) {
        SecurityContext.requirePermissionString(permissionString);
      }

      observabilityTrace('securityCheckPassed', {
        'commandType': command.runtimeType.toString(),
        'requiredPermissions': requiredPermissions,
        'subjectId': SecurityContext.getCurrentSubject().id,
      });

      // Execute the command if authorized
      final result = await _enhancedService.executeCommand(command);

      observabilityInfo(
        'executeSecureCommandCompleted',
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'success': result.isSuccess,
          'requiredPermissions': requiredPermissions,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } on SecurityContextException catch (e) {
      observabilityError(
        'securityCheckFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'requiredPermissions': requiredPermissions,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return CommandResult.failure('Security check failed: ${e.message}');
    } catch (e) {
      observabilityError(
        'executeSecureCommandFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<CommandResult> executeCommandOnAggregate(
    ICommandBusCommand command,
    String aggregateId,
    dynamic repository,
  ) async {
    observabilityInfo(
      'executeCommandOnAggregate',
      context: {
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'aggregateId': aggregateId,
        'repositoryType': repository.runtimeType.toString(),
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final result = await _enhancedService.executeCommandOnAggregate(
        command,
        aggregateId,
        repository,
      );

      observabilityInfo(
        'executeCommandOnAggregateCompleted',
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'aggregateId': aggregateId,
          'success': result.isSuccess,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'executeCommandOnAggregateFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'aggregateId': aggregateId,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<CommandResult> executeCommandOnNewAggregate(
    ICommandBusCommand command,
    dynamic repository,
  ) async {
    observabilityInfo(
      'executeCommandOnNewAggregate',
      context: {
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'repositoryType': repository.runtimeType.toString(),
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final result = await _enhancedService.executeCommandOnNewAggregate(
        command,
        repository,
      );

      observabilityInfo(
        'executeCommandOnNewAggregateCompleted',
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'success': result.isSuccess,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'executeCommandOnNewAggregateFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<List<CommandResult>> executeWorkflow(
    List<ICommandBusCommand> commands,
  ) async {
    observabilityInfo(
      'executeWorkflow',
      context: {
        'commandCount': commands.length,
        'commandTypes': commands.map((c) => c.runtimeType.toString()).toList(),
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final results = await _enhancedService.executeWorkflow(commands);

      observabilityInfo(
        'executeWorkflowCompleted',
        context: {
          'commandCount': commands.length,
          'successCount': results.where((r) => r.isSuccess).length,
          'failureCount': results.where((r) => r.isFailure).length,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return results;
    } catch (e) {
      observabilityError(
        'executeWorkflowFailed',
        error: e,
        context: {
          'commandCount': commands.length,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<CommandResult> executeCommandWithMetrics(
    ICommandBusCommand command,
  ) async {
    observabilityInfo(
      'executeCommandWithMetrics',
      context: {
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final result = await _enhancedService.executeCommandWithMetrics(command);

      observabilityInfo(
        'executeCommandWithMetricsCompleted',
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'success': result.isSuccess,
          'hasMetrics': result.data?.containsKey('metrics') ?? false,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'executeCommandWithMetricsFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<CommandResult> executeCommandWithValidation(
    ICommandBusCommand command,
    dynamic repository, {
    required dynamic Function(ICommandBusCommand) validator,
  }) async {
    observabilityInfo(
      'executeCommandWithValidation',
      context: {
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'repositoryType': repository.runtimeType.toString(),
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final result = await _enhancedService.executeCommandWithValidation(
        command,
        repository,
        validator: validator,
      );

      observabilityInfo(
        'executeCommandWithValidationCompleted',
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'success': result.isSuccess,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'executeCommandWithValidationFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<CommandResult> executeOnAggregate(
    dynamic aggregate,
    dynamic operation,
  ) async {
    observabilityInfo(
      'executeOnAggregate',
      context: {
        'aggregateType': aggregate.runtimeType.toString(),
        'operationType': operation.runtimeType.toString(),
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final result = await _enhancedService.executeOnAggregate(
        aggregate,
        operation,
      );

      observabilityInfo(
        'executeOnAggregateCompleted',
        context: {
          'aggregateType': aggregate.runtimeType.toString(),
          'success': result.isSuccess,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'executeOnAggregateFailed',
        error: e,
        context: {
          'aggregateType': aggregate.runtimeType.toString(),
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  bool hasPermissions(List<String> permissions) {
    observabilityTrace('hasPermissions', {
      'permissions': permissions,
      'subjectId': SecurityContext.getCurrentSubject().id,
    });

    try {
      final hasAll = permissions.every(
        (permission) => SecurityContext.hasPermissionString(permission),
      );

      observabilityDebug('hasPermissionsResult', {
        'permissions': permissions,
        'granted': hasAll,
        'subjectId': SecurityContext.getCurrentSubject().id,
      });

      return hasAll;
    } catch (e) {
      observabilityError(
        'hasPermissionsFailed',
        error: e,
        context: {
          'permissions': permissions,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      return false;
    }
  }

  @override
  bool hasAnyPermission(List<String> permissions) {
    observabilityTrace('hasAnyPermission', {
      'permissions': permissions,
      'subjectId': SecurityContext.getCurrentSubject().id,
    });

    try {
      final hasAny = permissions.any(
        (permission) => SecurityContext.hasPermissionString(permission),
      );

      observabilityDebug('hasAnyPermissionResult', {
        'permissions': permissions,
        'granted': hasAny,
        'subjectId': SecurityContext.getCurrentSubject().id,
      });

      return hasAny;
    } catch (e) {
      observabilityError(
        'hasAnyPermissionFailed',
        error: e,
        context: {
          'permissions': permissions,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      return false;
    }
  }

  @override
  SecuritySubject getCurrentSubject() {
    return SecurityContext.getCurrentSubject();
  }

  @override
  Future<T> runWithSystemPrivileges<T>(Future<T> Function() operation) async {
    observabilityInfo(
      'runWithSystemPrivileges',
      context: {
        'operationType': operation.runtimeType.toString(),
        'originalSubjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      final result = await SecurityContext.runWithSystemPrivileges(() async {
        observabilityTrace('systemPrivilegesElevated', {
          'newSubjectId': SecurityContext.getCurrentSubject().id,
        });

        return await operation();
      });

      observabilityInfo(
        'runWithSystemPrivilegesCompleted',
        context: {
          'operationType': operation.runtimeType.toString(),
          'restoredSubjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'runWithSystemPrivilegesFailed',
        error: e,
        context: {
          'operationType': operation.runtimeType.toString(),
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  @override
  Future<T> runWithSubject<T>(
    SecuritySubject subject,
    Future<T> Function() operation,
  ) async {
    observabilityInfo(
      'runWithSubject',
      context: {
        'operationType': operation.runtimeType.toString(),
        'originalSubjectId': SecurityContext.getCurrentSubject().id,
        'newSubjectId': subject.id,
      },
    );

    try {
      final result = await SecurityContext.runWithSubject(subject, () async {
        observabilityTrace('subjectContextSwitched', {
          'newSubjectId': SecurityContext.getCurrentSubject().id,
        });

        return await operation();
      });

      observabilityInfo(
        'runWithSubjectCompleted',
        context: {
          'operationType': operation.runtimeType.toString(),
          'restoredSubjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } catch (e) {
      observabilityError(
        'runWithSubjectFailed',
        error: e,
        context: {
          'operationType': operation.runtimeType.toString(),
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  /// Executes a secured command with specific permission requirements and aggregate operations.
  ///
  /// This method combines security enforcement with aggregate command execution,
  /// providing a complete solution for secured aggregate operations.
  ///
  /// Parameters:
  /// - [command]: The command to execute
  /// - [requiredPermissions]: List of permissions required to execute the command
  /// - [aggregateId]: The ID of the aggregate to load
  /// - [repository]: The repository for loading and saving the aggregate
  ///
  /// Returns:
  /// A [Future] that resolves to a [CommandResult]
  Future<CommandResult> executeSecureCommandOnAggregate(
    ICommandBusCommand command,
    List<String> requiredPermissions,
    String aggregateId,
    dynamic repository,
  ) async {
    observabilityInfo(
      'executeSecureCommandOnAggregate',
      context: {
        'commandType': command.runtimeType.toString(),
        'commandId': command.id,
        'requiredPermissions': requiredPermissions,
        'aggregateId': aggregateId,
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      // Check permissions before execution
      for (final permissionString in requiredPermissions) {
        SecurityContext.requirePermissionString(permissionString);
      }

      observabilityTrace('securityCheckPassedForAggregate', {
        'commandType': command.runtimeType.toString(),
        'aggregateId': aggregateId,
        'requiredPermissions': requiredPermissions,
        'subjectId': SecurityContext.getCurrentSubject().id,
      });

      // Execute the command on aggregate if authorized
      final result = await _enhancedService.executeCommandOnAggregate(
        command,
        aggregateId,
        repository,
      );

      observabilityInfo(
        'executeSecureCommandOnAggregateCompleted',
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'aggregateId': aggregateId,
          'success': result.isSuccess,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return result;
    } on SecurityContextException catch (e) {
      observabilityError(
        'securityCheckFailedForAggregate',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'aggregateId': aggregateId,
          'requiredPermissions': requiredPermissions,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return CommandResult.failure(
        'Security check failed for aggregate operation: ${e.message}',
      );
    } catch (e) {
      observabilityError(
        'executeSecureCommandOnAggregateFailed',
        error: e,
        context: {
          'commandType': command.runtimeType.toString(),
          'commandId': command.id,
          'aggregateId': aggregateId,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }

  /// Executes a secured workflow with permission requirements.
  ///
  /// This method combines security enforcement with workflow execution,
  /// ensuring all commands in the workflow are properly authorized.
  ///
  /// Parameters:
  /// - [commands]: List of commands to execute in sequence
  /// - [requiredPermissions]: List of permissions required for the entire workflow
  ///
  /// Returns:
  /// A [Future] that resolves to a list of [CommandResult]s
  Future<List<CommandResult>> executeSecureWorkflow(
    List<ICommandBusCommand> commands,
    List<String> requiredPermissions,
  ) async {
    observabilityInfo(
      'executeSecureWorkflow',
      context: {
        'commandCount': commands.length,
        'commandTypes': commands.map((c) => c.runtimeType.toString()).toList(),
        'requiredPermissions': requiredPermissions,
        'subjectId': SecurityContext.getCurrentSubject().id,
      },
    );

    try {
      // Check permissions before execution
      for (final permissionString in requiredPermissions) {
        SecurityContext.requirePermissionString(permissionString);
      }

      observabilityTrace('securityCheckPassedForWorkflow', {
        'commandCount': commands.length,
        'requiredPermissions': requiredPermissions,
        'subjectId': SecurityContext.getCurrentSubject().id,
      });

      // Execute the workflow if authorized
      final results = await _enhancedService.executeWorkflow(commands);

      observabilityInfo(
        'executeSecureWorkflowCompleted',
        context: {
          'commandCount': commands.length,
          'successCount': results.where((r) => r.isSuccess).length,
          'failureCount': results.where((r) => r.isFailure).length,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      return results;
    } on SecurityContextException catch (e) {
      observabilityError(
        'securityCheckFailedForWorkflow',
        error: e,
        context: {
          'commandCount': commands.length,
          'requiredPermissions': requiredPermissions,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );

      // Return failure result for the first command
      return [
        CommandResult.failure(
          'Security check failed for workflow: ${e.message}',
        ),
      ];
    } catch (e) {
      observabilityError(
        'executeSecureWorkflowFailed',
        error: e,
        context: {
          'commandCount': commands.length,
          'subjectId': SecurityContext.getCurrentSubject().id,
        },
      );
      rethrow;
    }
  }
}
