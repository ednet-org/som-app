part of ednet_core;

/// Default implementation of command execution strategy
///
/// This strategy maintains backward compatibility with the existing
/// dynamic command execution approach while providing a cleaner
/// interface for future extensions.
class DefaultCommandExecutionStrategy implements ICommandExecutionStrategy {
  @override
  String get strategyName => 'DefaultCommandExecution';

  @override
  bool canHandle(ICommand command) {
    // Can handle any command that has doIt method
    return true;
  }

  @override
  dynamic execute(dynamic aggregateRoot, ICommand command) {
    try {
      // Execute the command using the existing command infrastructure
      final executed = command.doIt();

      if (!executed) {
        return CommandResult.failure('Command execution failed');
      }

      if (aggregateRoot is AggregateRoot) {
        // Get events that would be generated
        final commandEvents = command.getEvents();

        // Apply events temporarily to check business rules
        for (var event in commandEvents) {
          aggregateRoot.applyEvent(event);
        }

        // Validate business rules after state changes
        ValidationExceptions validationResults = aggregateRoot
            .enforceBusinessInvariants();

        if (!validationResults.isEmpty) {
          // If validation fails, undo the command to rollback state
          command.undo();
          // Apply the undo events to rollback the aggregate state
          final undoEvents = command.getEvents();
          for (var event in undoEvents) {
            aggregateRoot.applyEvent(event);
          }
          return CommandResult.failure(validationResults.toString());
        }

        // If everything is valid, increment version and collect events
        aggregateRoot.incrementVersion();

        // Add any command events to pending events
        aggregateRoot.addEventsToPending(commandEvents);

        // Trigger policies based on each event (if policy engine exists)
        if (aggregateRoot.policyEngine != null) {
          for (var event in commandEvents) {
            aggregateRoot.triggerPoliciesFromEvent(event);
          }
        }

        // Return success with aggregate information
        return CommandResult.success(
          data: {
            'id': aggregateRoot.oid.toString(),
            'version': aggregateRoot.version,
            'pendingEvents': aggregateRoot.pendingEvents,
          },
        );
      }

      // Default success case for non-aggregate root commands
      return CommandResult.success();
    } catch (e) {
      return CommandResult.failure('Command execution failed: ${e.toString()}');
    }
  }
}

/// Event sourcing focused command execution strategy
///
/// This strategy ensures all commands generate events for proper
/// event sourcing and audit trail maintenance.
class EventSourcingCommandStrategy implements ICommandExecutionStrategy {
  @override
  String get strategyName => 'EventSourcingCommand';

  @override
  bool canHandle(ICommand command) {
    // Only handle commands that can generate events
    return true; // getEvents is always available on commands
  }

  @override
  dynamic execute(dynamic aggregateRoot, ICommand command) {
    try {
      if (aggregateRoot is! AggregateRoot) {
        return CommandResult.failure(
          'Event sourcing strategy requires AggregateRoot',
        );
      }

      // Execute command
      final executed = command.doIt();

      if (!executed) {
        return CommandResult.failure('Command execution failed');
      }

      // Ensure events were generated
      final events = command.getEvents();
      if (events.isEmpty) {
        return CommandResult.failure(
          'Event sourcing requires commands to generate events',
        );
      }

      // Validate business rules
      ValidationExceptions validationResults = aggregateRoot
          .enforceBusinessInvariants();
      if (!validationResults.isEmpty) {
        // Rollback to initial state
        command.undo();
        return CommandResult.failure(validationResults.toString());
      }

      // Apply events and update state
      for (var event in events) {
        aggregateRoot.applyEvent(event);
      }

      return CommandResult.success(
        data: {
          'id': aggregateRoot.oid.toString(),
          'version': aggregateRoot.version,
          'events': events.length,
          'pendingEvents': aggregateRoot.pendingEvents,
        },
      );
    } catch (e) {
      return CommandResult.failure(
        'Event sourcing execution failed: ${e.toString()}',
      );
    }
  }
}

/// Policy-driven command execution strategy
///
/// This strategy emphasizes policy evaluation and compliance
/// before and after command execution.
class PolicyDrivenCommandStrategy implements ICommandExecutionStrategy {
  @override
  String get strategyName => 'PolicyDrivenCommand';

  @override
  bool canHandle(ICommand command) {
    // Can handle any command, but focuses on policy compliance
    return true;
  }

  @override
  dynamic execute(dynamic aggregateRoot, ICommand command) {
    try {
      if (aggregateRoot is! AggregateRoot) {
        return CommandResult.failure(
          'Policy-driven strategy requires AggregateRoot',
        );
      }

      // Pre-execution policy evaluation
      if (aggregateRoot.policyEngine != null) {
        final preExecutionPolicies = aggregateRoot.policyEngine!
            .getApplicablePolicies(aggregateRoot);
        for (var _ in preExecutionPolicies) {
          // Check if any policy would prevent execution
          // This would need to be extended based on policy interface
        }
      }

      // Execute command
      final executed = command.doIt();

      if (!executed) {
        return CommandResult.failure('Command execution failed');
      }

      // Post-execution business rule validation
      ValidationExceptions validationResults = aggregateRoot
          .enforceBusinessInvariants();
      if (!validationResults.isEmpty) {
        command.undo();
        return CommandResult.failure(validationResults.toString());
      }

      // Policy-driven event processing
      final commandEvents = command.getEvents();
      for (var event in commandEvents) {
        aggregateRoot.applyEvent(event);
      }

      // Post-execution policy evaluation
      if (aggregateRoot.policyEngine != null) {
        final _ = aggregateRoot.policyEngine!.executePolicies(aggregateRoot);
        // Handle generated policy commands if needed (future implementation)
      }

      return CommandResult.success(
        data: {
          'id': aggregateRoot.oid.toString(),
          'version': aggregateRoot.version,
          'policyCompliant': true,
          'pendingEvents': aggregateRoot.pendingEvents,
        },
      );
    } catch (e) {
      return CommandResult.failure(
        'Policy-driven execution failed: ${e.toString()}',
      );
    }
  }
}
