part of ednet_core;

/// Business Primitives Implementation
/// Simple concrete implementations for business concepts used in testing
/// and as foundation for mathematical category theory

/// Simple business command implementation
class SimpleBusinessCommand implements BusinessCommand {
  @override
  final String name;
  @override
  final String description;
  @override
  final String? aggregate;
  @override
  final String? actor;
  @override
  final Map<String, dynamic> parameters;
  @override
  final Map<String, dynamic> businessLogic;

  final DomainState sourceState;
  final DomainState targetState;

  const SimpleBusinessCommand(
    this.name,
    this.sourceState,
    this.targetState, {
    this.description = '',
    this.aggregate,
    this.actor,
    this.parameters = const {},
    this.businessLogic = const {},
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleBusinessCommand && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() =>
      'BusinessCommand($name: ${sourceState.name} → ${targetState.name})';
}

/// Simple business policy implementation
class SimpleBusinessPolicy implements BusinessPolicy {
  @override
  final String name;
  @override
  final String description;
  @override
  final List<String> triggerEvents;
  @override
  final List<String> resultingCommands;
  @override
  final Map<String, dynamic> rules;

  final SimpleDomainEvent triggerEvent;
  final SimpleBusinessCommand resultCommand;

  const SimpleBusinessPolicy(
    this.name,
    this.triggerEvent,
    this.resultCommand, {
    this.description = '',
    this.triggerEvents = const [],
    this.resultingCommands = const [],
    this.rules = const {},
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SimpleBusinessPolicy && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'BusinessPolicy($name)';
}

/// Mathematical workflow result for monadic composition
class MathematicalWorkflowResult {
  final bool isCompleted;
  final String currentStep;
  final List<String> completedSteps;
  final Map<String, dynamic> context;
  final String? errorMessage;

  const MathematicalWorkflowResult({
    required this.isCompleted,
    required this.currentStep,
    required this.completedSteps,
    required this.context,
    this.errorMessage,
  });

  @override
  String toString() =>
      'MathematicalWorkflowResult(completed: $isCompleted, step: $currentStep)';
}

/// Mathematical message domain context for testing
class MathematicalMessageDomainContext {
  final String name;
  final Map<String, dynamic> _context = {};

  MathematicalMessageDomainContext(this.name);

  void set(String key, dynamic value) {
    _context[key] = value;
  }

  T? get<T>(String key) {
    return _context[key] as T?;
  }

  @override
  String toString() => 'MathematicalMessageDomainContext($name)';
}
