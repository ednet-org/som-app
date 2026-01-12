part of ednet_core;

/// Interface for commands that can be processed by the CommandBus.
///
/// Commands represent the intent to perform an action or change the state
/// of the domain model. They are the primary way external actors (like UI,
/// APIs, or other systems) communicate with the domain.
///
/// Key characteristics of commands in EDNet Core:
/// - **Imperative**: Commands express an intent to perform an action
/// - **Identified**: Each command has a unique identifier for tracking
/// - **Serializable**: Commands can be serialized for persistence or transmission
/// - **Self-Contained**: Commands contain all data needed for execution
/// - **Immutable**: Once created, commands should not be modified
///
/// Example implementations:
/// ```dart
/// class CreateOrderCommand implements ICommandBusCommand {
///   @override
///   final String id;
///   final String customerId;
///   final List<OrderItemDto> items;
///
///   CreateOrderCommand({
///     required this.customerId,
///     required this.items,
///   }) : id = Oid().toString();
///
///   @override
///   Map<String, dynamic> toJson() => {
///     'id': id,
///     'customerId': customerId,
///     'items': items.map((item) => item.toJson()).toList(),
///   };
/// }
/// ```
///
/// See also:
/// - [CommandBus] for command execution
/// - [ICommandHandler] for command handling
/// - [CommandResult] for execution results
abstract class ICommandBusCommand {
  /// Unique identifier for this command instance.
  ///
  /// This identifier is used for:
  /// - Tracking command execution across the system
  /// - Correlating commands with their results and events
  /// - Debugging and auditing command processing
  /// - Deduplication of command processing
  String get id;

  /// Serializes the command to a JSON representation.
  ///
  /// This method enables:
  /// - Persistence of commands for audit trails
  /// - Transmission of commands across network boundaries
  /// - Replay of commands for testing or debugging
  /// - Integration with external systems
  ///
  /// Returns:
  /// A [Map] containing the serialized command data
  Map<String, dynamic> toJson();
}
