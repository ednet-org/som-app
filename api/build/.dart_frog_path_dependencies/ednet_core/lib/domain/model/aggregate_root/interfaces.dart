part of ednet_core;

/// Interface for command execution strategies
abstract class ICommandExecutionStrategy {
  /// Executes a command against an aggregate root
  /// Returns the existing CommandResult type for compatibility
  dynamic execute(dynamic aggregateRoot, ICommand command);

  /// Gets the strategy name
  String get strategyName;

  /// Checks if this strategy can handle the given command type
  bool canHandle(ICommand command);
}

/// Interface for event sourcing capabilities
abstract class IEventSourced {
  /// Gets uncommitted events
  List<IDomainEvent> get uncommittedEvents;

  /// Records a new event
  void recordEvent(IDomainEvent event);

  /// Marks all events as committed
  void markEventsAsCommitted();

  /// Checks if there are uncommitted events
  bool get hasUncommittedEvents;

  /// Gets the count of uncommitted events
  int get uncommittedEventCount;
}

/// Interface for versioning capabilities
abstract class IVersioned {
  /// Gets the current version
  int get version;

  /// Increments the version
  void incrementVersion();
}

/// Interface for business rule enforcement
abstract class IBusinessRuleEnforcer {
  /// Enforces business rules and returns any violations
  ValidationExceptions enforceBusinessInvariants();
}

/// Interface for policy-driven behavior
abstract class IPolicyDriven {
  /// Gets the policy engine
  IPolicyEngine? get policyEngine;

  /// Sets the policy engine
  set policyEngine(IPolicyEngine? engine);

  /// Registers a policy
  void registerPolicy(IPolicy policy);
}

/// Interface for transactional behavior
abstract class ITransactional {
  /// Begins a new transaction
  dynamic beginTransaction(String name, IDomainSession session);

  /// Gets the current session
  IDomainSession? get session;

  /// Sets the session
  set session(IDomainSession? session);
}
