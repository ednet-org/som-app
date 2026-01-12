part of ednet_core;

final Logger _eventLogger = Logger('ednet_core.event');

/// Represents a domain event that can be triggered within the system.
///
/// An event is a record of something significant that happened in the domain.
/// It contains information about what happened, who it happened to, and any
/// additional data associated with the event.
///
/// Example usage:
/// ```dart
/// final event = Event(
///   'UserCreated',
///   'A new user has been created in the system',
///   ['SendWelcomeEmail', 'UpdateUserCount'],
///   userEntity,
///   {'email': 'user@example.com'},
/// );
/// ```
class Event implements IDomainEvent {
  /// The name of the event (e.g., 'UserCreated', 'OrderPlaced').
  @override
  final String name;

  /// A human-readable description of what the event represents.
  final String description;

  /// List of handler names that should process this event when triggered.
  final List<String> handlers;

  /// The entity associated with this event, if any.
  @override
  final Entity? entity;

  /// Additional data associated with the event.
  final Map<String, dynamic> data;

  @override
  Map<String, dynamic> get eventData => data;

  /// The unique identifier for this event.
  @override
  final String id;

  /// The timestamp when this event occurred.
  @override
  final DateTime timestamp;

  /// The ID of the aggregate that emitted this event.
  @override
  String aggregateId;

  /// The type of the aggregate that emitted this event.
  @override
  String aggregateType;

  /// The version of the aggregate when this event was emitted.
  @override
  int aggregateVersion;

  /// Creates a new [Event] instance.
  ///
  /// [name] is the identifier for the event.
  /// [description] provides context about what happened.
  /// [handlers] are the names of handlers that should process this event.
  /// [entity] is the related domain entity, if any.
  /// [data] is an optional map of additional event data.
  Event(
    this.name,
    this.description,
    this.handlers,
    this.entity, [
    this.data = const {},
  ]) : id = Oid().toString(),
       timestamp = DateTime.now(),
       aggregateId = entity?.oid.toString() ?? '',
       aggregateType = entity?.runtimeType.toString() ?? '',
       aggregateVersion = 0;

  /// Creates a new success [Event] instance.
  ///
  /// This constructor is specifically for events that represent successful operations.
  /// It has the same parameters as the default constructor.
  Event.SuccessEvent(
    this.name,
    this.description,
    this.handlers,
    this.entity, [
    this.data = const {},
  ]) : id = Oid().toString(),
       timestamp = DateTime.now(),
       aggregateId = entity?.oid.toString() ?? '',
       aggregateType = entity?.runtimeType.toString() ?? '',
       aggregateVersion = 0;

  /// Creates a new failure [Event] instance.
  ///
  /// This constructor is specifically for events that represent failed operations.
  /// It has the same parameters as the default constructor.
  Event.FailureEvent(
    this.name,
    this.description,
    this.handlers,
    this.entity, [
    this.data = const {},
  ]) : id = Oid().toString(),
       timestamp = DateTime.now(),
       aggregateId = entity?.oid.toString() ?? '',
       aggregateType = entity?.runtimeType.toString() ?? '',
       aggregateVersion = 0;

  /// Converts this event to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'name': name,
      'description': description,
      'handlers': handlers,
      'entity': entity?.toJson(),
      'data': data,
      'aggregateId': aggregateId,
      'aggregateType': aggregateType,
      'aggregateVersion': aggregateVersion,
    };
  }

  /// Converts this domain event to the base Event type.
  ///
  /// This method provides compatibility with the domain model layer.
  ///
  /// Returns:
  /// An [Event] representation of this domain event
  @override
  Event toBaseEvent() {
    return this; // Already an Event, so return self
  }

  /// Triggers the event handlers associated with this event.
  ///
  /// [session] is the domain session in which the event is being triggered.
  /// This method will execute all registered handlers for this event.
  ///
  /// Note: Currently, the actual handler execution is commented out and only
  /// prints a debug message. This should be implemented based on the specific
  /// requirements of the system.
  void trigger(DomainSession session) {
    if (handlers.isEmpty) return;

    // The event model currently stores handler *names* only (strings), while the
    // execution API expects concrete `ICommand` instances. Until a registry
    // exists to map handler names → ICommand factories, triggering is a no-op.
    _eventLogger.fine(
      'Event.trigger skipped (no handler registry): '
      'name=$name, handlers=${handlers.length}',
    );
  }
}
