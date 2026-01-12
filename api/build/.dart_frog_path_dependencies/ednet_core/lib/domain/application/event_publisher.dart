part of ednet_core;

/// Publishes domain events to subscribers.
///
/// The EventPublisher is responsible for:
/// - Distributing domain events to subscribers
/// - Managing the subscription lifecycle
/// - Providing event filtering capabilities
///
/// This is a key component of event-driven architecture that enables
/// loose coupling between event producers and consumers.
///
/// Example usage:
/// ```dart
/// final publisher = EventPublisher();
/// publisher.subscribe(orderCompletedHandler);
/// publisher.publish(orderCompletedEvent);
/// ```
class EventPublisher {
  /// The list of event subscribers
  final List<EventSubscriber> _subscribers = [];

  /// Subscribes to domain events.
  ///
  /// Parameters:
  /// - [subscriber]: The subscriber to add
  void subscribe(EventSubscriber subscriber) {
    _subscribers.add(subscriber);
  }

  /// Unsubscribes from domain events.
  ///
  /// Parameters:
  /// - [subscriber]: The subscriber to remove
  void unsubscribe(EventSubscriber subscriber) {
    _subscribers.remove(subscriber);
  }

  /// Publishes a domain event to all subscribers.
  ///
  /// Parameters:
  /// - [event]: The event to publish
  ///
  /// Returns:
  /// Future that completes when all subscribers have processed the event
  Future<void> publish(IDomainEvent event) async {
    for (final subscriber in _subscribers) {
      await subscriber.handleEvent(event);
    }
  }
}

/// Interface for domain event subscribers.
///
/// Event subscribers receive domain events from the EventPublisher
/// and perform actions in response to those events.
///
/// Example implementation:
/// ```dart
/// class OrderCompletedHandler implements EventSubscriber {
///   @override
///   Future<void> handleEvent(IDomainEvent event) async {
///     if (event.name == 'OrderCompleted') {
///       // Handle order completed event
///     }
///   }
/// }
/// ```
abstract class EventSubscriber {
  /// Handles a domain event.
  ///
  /// Parameters:
  /// - [event]: The event to handle
  ///
  /// Returns:
  /// Future that completes when the event has been handled
  Future<void> handleEvent(IDomainEvent event);
}
