part of ednet_core;

/// Event Store for persisting and publishing domain events.
///
/// The EventStore acts as a central repository for domain events, providing:
/// - Persistent storage of all domain events
/// - Event publishing to event handlers and subscribers
/// - Event replay capabilities for aggregate reconstitution
/// - Temporal querying of domain history
///
/// This is a key component of event sourcing architecture that maintains
/// the complete history of domain changes.
///
/// Example usage:
/// ```dart
/// final eventStore = EventStore(database, eventPublisher);
/// await eventStore.store(orderCreatedEvent);
/// final events = await eventStore.getEventsForAggregate('Order', '12345');
/// ```
class EventStore {
  /// The database for persistent storage
  final EDNetDatabase _db;

  /// The event publisher for distributing events
  final EventPublisher _publisher;

  /// Creates a new EventStore with the specified database and publisher.
  ///
  /// Parameters:
  /// - [db]: Database for event persistence
  /// - [publisher]: Publisher for event distribution
  EventStore(this._db, this._publisher);

  /// Stores and publishes a domain event.
  ///
  /// This method:
  /// 1. Persists the event to the database
  /// 2. Publishes the event to all subscribers
  ///
  /// The operation is wrapped in a transaction to ensure consistency.
  ///
  /// Parameters:
  /// - [event]: The domain event to store
  ///
  /// Returns:
  /// Future that completes when the event is stored and published
  Future<void> store(IDomainEvent event) async {
    await _db.transaction(() async {
      await _storeEvent(event);
      await _publisher.publish(event);
    });
  }

  /// Stores multiple domain events in a single transaction.
  ///
  /// This method:
  /// 1. Persists all events to the database in a single transaction
  /// 2. Publishes all events to subscribers
  ///
  /// Parameters:
  /// - [events]: List of domain events to store
  ///
  /// Returns:
  /// Future that completes when all events are stored and published
  Future<void> storeAll(List<IDomainEvent> events) async {
    if (events.isEmpty) return;

    await _db.transaction(() async {
      for (final event in events) {
        await _storeEvent(event);
      }

      for (final event in events) {
        await _publisher.publish(event);
      }
    });
  }

  /// Retrieves events for a specific aggregate instance.
  ///
  /// This method returns all events for the specified aggregate instance
  /// in chronological order, allowing for aggregate reconstitution.
  ///
  /// Parameters:
  /// - [aggregateType]: The type of aggregate (e.g., 'Order')
  /// - [aggregateId]: The ID of the aggregate instance
  ///
  /// Returns:
  /// List of domain events for the aggregate in chronological order
  Future<List<IDomainEvent>> getEventsForAggregate(
    String aggregateType,
    String aggregateId,
  ) async {
    final queryResult = await _db.customSelect(
      '''
      SELECT * FROM domain_events
      WHERE aggregate_type = ? AND aggregate_id = ?
      ORDER BY sequence_number ASC
      ''',
      variables: [Variable(aggregateType), Variable(aggregateId)],
    );
    final rows = await queryResult.get();

    return rows.map(_rowToEvent).toList();
  }

  /// Retrieves events of a specific type.
  ///
  /// This method returns events of the specified type in chronological order,
  /// useful for event handlers that process specific event types.
  ///
  /// Parameters:
  /// - [eventType]: The type of event to retrieve
  /// - [since]: Optional timestamp to retrieve events after a specific time
  ///
  /// Returns:
  /// List of domain events of the specified type
  Future<List<IDomainEvent>> getEventsByType(
    String eventType, {
    DateTime? since,
  }) async {
    String query = '''
      SELECT * FROM domain_events
      WHERE event_type = ?
    ''';

    final variables = [Variable(eventType)];

    if (since != null) {
      query += ' AND timestamp >= ?';
      variables.add(Variable(since.millisecondsSinceEpoch));
    }

    query += ' ORDER BY timestamp ASC';

    final queryResult = await _db.customSelect(query, variables: variables);
    final rows = await queryResult.get();

    return rows.map(_rowToEvent).toList();
  }

  /// Private method to store an event in the database.
  ///
  /// Parameters:
  /// - [event]: The domain event to store
  ///
  /// Returns:
  /// Future that completes when the event is stored
  Future<void> _storeEvent(IDomainEvent event) async {
    await _db.customInsert(
      '''
      INSERT INTO domain_events (
        event_id,
        event_type,
        aggregate_type,
        aggregate_id,
        timestamp,
        payload,
        sequence_number
      ) VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
      variables: [
        Variable(event.id),
        Variable(event.name),
        Variable(event.aggregateType),
        Variable(event.aggregateId),
        Variable(event.timestamp.millisecondsSinceEpoch),
        Variable(jsonEncode(event.toJson())),
        Variable(
          await _getNextSequenceNumber(event.aggregateType, event.aggregateId),
        ),
      ],
    );
  }

  /// Gets the next sequence number for an aggregate instance.
  ///
  /// This ensures events are ordered correctly for each aggregate.
  ///
  /// Parameters:
  /// - [aggregateType]: The type of aggregate
  /// - [aggregateId]: The ID of the aggregate instance
  ///
  /// Returns:
  /// The next sequence number for the aggregate
  Future<int> _getNextSequenceNumber(
    String aggregateType,
    String aggregateId,
  ) async {
    final queryResult = await _db.customSelect(
      '''
      SELECT MAX(sequence_number) as max_seq
      FROM domain_events
      WHERE aggregate_type = ? AND aggregate_id = ?
      ''',
      variables: [Variable(aggregateType), Variable(aggregateId)],
    );
    final result = await queryResult.getSingleOrNull();

    if (result == null || result.read<int?>('max_seq') == null) {
      return 1;
    }

    return result.read<int>('max_seq') + 1;
  }

  /// Converts a database row to a domain event.
  ///
  /// This uses a registry of event types to create the appropriate event instance.
  ///
  /// Parameters:
  /// - [row]: The database row
  ///
  /// Returns:
  /// The reconstituted domain event
  IDomainEvent _rowToEvent(QueryRow row) {
    final eventType = row.read<String>('event_type');
    final payload = jsonDecode(row.read<String>('payload'));

    // Use the event registry to create the appropriate event type
    return EventTypeRegistry.createEvent(eventType, payload);
  }

  /// Ensures that the necessary database tables exist
  ///
  /// This method creates the domain_events table if it doesn't exist
  ///
  /// Returns:
  /// Future that completes when the tables are created
  Future<void> ensureEventSourcingTables() async {
    await _db.customStatement('''
      CREATE TABLE IF NOT EXISTS domain_events (
        event_id TEXT PRIMARY KEY,
        event_type TEXT NOT NULL,
        aggregate_type TEXT NOT NULL,
        aggregate_id TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        payload TEXT NOT NULL,
        sequence_number INTEGER NOT NULL
      )
    ''');

    await _db.customStatement('''
      CREATE INDEX IF NOT EXISTS idx_domain_events_aggregate ON domain_events (aggregate_type, aggregate_id)
    ''');

    await _db.customStatement('''
      CREATE INDEX IF NOT EXISTS idx_domain_events_type ON domain_events (event_type)
    ''');
  }
}

/// Registry for creating domain events from their serialized form
///
/// This class maintains a mapping of event type names to factory functions
/// that can create instances of those event types from JSON data.
class EventTypeRegistry {
  /// Map of event type names to factory functions
  static final Map<String, IDomainEvent Function(Map<String, dynamic>)>
  _factories = {};

  /// Registers a factory function for an event type
  ///
  /// Parameters:
  /// - [eventType]: The name of the event type
  /// - [factory]: Function that creates an event from JSON
  static void registerType(
    String eventType,
    IDomainEvent Function(Map<String, dynamic> json) factory,
  ) {
    _factories[eventType] = factory;
  }

  /// Creates an event from JSON data
  ///
  /// Parameters:
  /// - [eventType]: The type of event to create
  /// - [json]: The JSON data for the event
  ///
  /// Returns:
  /// The created domain event
  static IDomainEvent createEvent(String eventType, Map<String, dynamic> json) {
    final factory = _factories[eventType];

    if (factory != null) {
      return factory(json);
    }

    // Fall back to a generic domain event if no specific factory is registered
    return DomainEvent(
      name: eventType,
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      aggregateId: json['aggregateId'],
      aggregateType: json['aggregateType'],
      aggregateVersion: json['aggregateVersion'],
    );
  }
}
