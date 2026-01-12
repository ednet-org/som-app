part of ednet_core;

/// Interface for event handlers in the EDNet Core event bus system.
///
/// Event handlers are responsible for processing domain events and implementing
/// reactive behavior in response to significant domain occurrences. They serve
/// as the primary mechanism for implementing event-driven architectures and
/// enabling loose coupling between domain components.
///
/// Key responsibilities of event handlers:
/// - **Event Processing**: React to specific types of domain events
/// - **Side Effects**: Perform actions in response to events (logging, notifications, etc.)
/// - **Integration**: Connect domain events to external systems
/// - **Projection Updates**: Update read models and projections
/// - **Policy Execution**: Trigger business rules and policies
///
/// Event handlers are registered with an [EventBus] and invoked automatically
/// when matching events are published.
///
/// Example implementation:
/// ```dart
/// class OrderConfirmationHandler implements IEventHandler<OrderCreatedEvent> {
///   final EmailService _emailService;
///   final NotificationService _notificationService;
///
///   OrderConfirmationHandler(this._emailService, this._notificationService);
///
///   @override
///   Future<void> handle(OrderCreatedEvent event) async {
///     // Send confirmation email
///     await _emailService.sendOrderConfirmation(
///       event.customerId,
///       event.orderId,
///     );
///
///     // Send push notification
///     await _notificationService.notifyOrderCreated(
///       event.customerId,
///       event.orderId,
///     );
///   }
///
///   @override
///   bool canHandle(IDomainEvent event) => event is OrderCreatedEvent;
///
///   @override
///   String get handlerName => 'OrderConfirmationHandler';
/// }
/// ```
///
/// See also:
/// - [EventBus] for event distribution
/// - [IDomainEvent] for event interface
/// - [IEventTriggeredPolicy] for policy-based event handling
/// - [EventPublisher] for basic event publishing
abstract class IEventHandler<TEvent extends IDomainEvent> {
  /// Handles the processing of a domain event.
  ///
  /// This method contains the core logic for responding to the event.
  /// It should:
  /// 1. Process the event data
  /// 2. Perform any required side effects
  /// 3. Update read models or projections if applicable
  /// 4. Integrate with external systems as needed
  ///
  /// The method is asynchronous to support operations that require:
  /// - Database access for updating projections
  /// - External service calls (email, notifications, APIs)
  /// - File I/O operations
  /// - Network requests
  ///
  /// Parameters:
  /// - [event]: The domain event to be processed
  ///
  /// Returns:
  /// A [Future] that completes when the event has been processed
  ///
  /// Throws:
  /// - Should handle all exceptions internally and not propagate them
  /// - Critical failures should be logged but not break the event processing pipeline
  Future<void> handle(TEvent event);

  /// Determines if this handler can process the given event.
  ///
  /// This method is used by the [EventBus] to route events to appropriate
  /// handlers. Multiple handlers can process the same event type, enabling
  /// patterns like:
  /// - Primary and audit handlers
  /// - Different handlers for different event conditions
  /// - Conditional event processing based on event data
  ///
  /// The method should check both the event type and any additional criteria:
  /// ```dart
  /// @override
  /// bool canHandle(IDomainEvent event) {
  ///   return event is OrderCreatedEvent &&
  ///          event.orderTotal > 100.0; // Only handle large orders
  /// }
  /// ```
  ///
  /// Parameters:
  /// - [event]: The event to check
  ///
  /// Returns:
  /// `true` if this handler can process the event, `false` otherwise
  bool canHandle(IDomainEvent event);

  /// Gets the name of this event handler.
  ///
  /// This name is used for:
  /// - Logging and debugging
  /// - Handler identification in metrics
  /// - Error reporting and diagnostics
  /// - Handler registration tracking
  ///
  /// Should return a descriptive name that identifies the handler's purpose.
  ///
  /// Returns:
  /// A descriptive name for this handler
  String get handlerName;
}
