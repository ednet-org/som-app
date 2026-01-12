part of ednet_core;

/// Base class for all domain events in the system
///
/// Domain events represent something significant that happened in the domain.
/// They are used for event sourcing and for notifying other parts of the system.
abstract class DomainEvent {
  /// The ID of the aggregate that produced this event
  String get aggregateId;

  /// The version of the aggregate when this event was produced
  int get version;

  /// The timestamp when this event was created
  DateTime get timestamp;

  /// Converts the event to a map for serialization
  Map<String, dynamic> toMap();
}
