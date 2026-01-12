import 'dart:convert';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Comprehensive tests for EventStore
/// Tests all aspects of event storage, retrieval, and publishing

void main() {
  group('EventStore Tests', () {
    late MockEDNetDatabase mockDb;
    late MockEventPublisher mockPublisher;
    late EventStore eventStore;

    setUp(() {
      // Create mock database and publisher
      mockDb = MockEDNetDatabase();
      mockPublisher = MockEventPublisher();
      eventStore = EventStore(mockDb, mockPublisher);
    });

    group('Event Storage', () {
      test('store should persist single event and publish it', () async {
        final event = TestDomainEvent(
          aggregateId: 'test-123',
          aggregateType: 'TestAggregate',
          name: 'TestEvent',
        );

        await eventStore.store(event);

        expect(mockDb.insertedEvents, contains(event));
        expect(mockPublisher.publishedEvents, contains(event));
      });

      test('storeAll should persist multiple events in transaction', () async {
        final events = [
          TestDomainEvent(
            aggregateId: 'test-1',
            aggregateType: 'TestAggregate',
            name: 'Event1',
          ),
          TestDomainEvent(
            aggregateId: 'test-1',
            aggregateType: 'TestAggregate',
            name: 'Event2',
          ),
          TestDomainEvent(
            aggregateId: 'test-1',
            aggregateType: 'TestAggregate',
            name: 'Event3',
          ),
        ];

        await eventStore.storeAll(events);

        expect(mockDb.insertedEvents.length, equals(3));
        expect(mockPublisher.publishedEvents.length, equals(3));
        expect(mockDb.transactionCount, equals(1));
      });

      test('storeAll with empty list should do nothing', () async {
        await eventStore.storeAll([]);

        expect(mockDb.insertedEvents, isEmpty);
        expect(mockPublisher.publishedEvents, isEmpty);
        expect(mockDb.transactionCount, equals(0));
      });

      test('store should assign sequential sequence numbers', () async {
        final events = [
          TestDomainEvent(
            aggregateId: 'test-seq',
            aggregateType: 'TestAggregate',
            name: 'Event1',
          ),
          TestDomainEvent(
            aggregateId: 'test-seq',
            aggregateType: 'TestAggregate',
            name: 'Event2',
          ),
          TestDomainEvent(
            aggregateId: 'test-seq',
            aggregateType: 'TestAggregate',
            name: 'Event3',
          ),
        ];

        for (final event in events) {
          await eventStore.store(event);
        }

        final storedEvents = mockDb.insertedEvents;
        expect(storedEvents[0].sequenceNumber, equals(1));
        expect(storedEvents[1].sequenceNumber, equals(2));
        expect(storedEvents[2].sequenceNumber, equals(3));
      });

      test('store should wrap in transaction for atomicity', () async {
        final event = TestDomainEvent(
          aggregateId: 'test-txn',
          aggregateType: 'TestAggregate',
          name: 'TestEvent',
        );

        await eventStore.store(event);

        expect(mockDb.transactionCount, equals(1));
      });
    });

    group('Event Retrieval', () {
      test(
        'getEventsForAggregate should return events in chronological order',
        () async {
          // Setup: Store events in specific order
          final events = [
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'Event1',
            ),
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'Event2',
            ),
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'Event3',
            ),
          ];

          await eventStore.storeAll(events);

          // Test: Retrieve events
          final retrieved = await eventStore.getEventsForAggregate(
            'TestAggregate',
            'agg-1',
          );

          expect(retrieved.length, equals(3));
          expect(retrieved[0].name, equals('Event1'));
          expect(retrieved[1].name, equals('Event2'));
          expect(retrieved[2].name, equals('Event3'));
        },
      );

      test(
        'getEventsForAggregate should only return events for specific aggregate',
        () async {
          await eventStore.storeAll([
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'Event1',
            ),
            TestDomainEvent(
              aggregateId: 'agg-2',
              aggregateType: 'TestAggregate',
              name: 'Event2',
            ),
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'Event3',
            ),
          ]);

          final retrieved = await eventStore.getEventsForAggregate(
            'TestAggregate',
            'agg-1',
          );

          expect(retrieved.length, equals(2));
          expect(retrieved.every((e) => e.aggregateId == 'agg-1'), isTrue);
        },
      );

      test(
        'getEventsForAggregate should return empty list for unknown aggregate',
        () async {
          final retrieved = await eventStore.getEventsForAggregate(
            'UnknownAggregate',
            'unknown-id',
          );

          expect(retrieved, isEmpty);
        },
      );

      test(
        'getEventsByType should return all events of specific type',
        () async {
          await eventStore.storeAll([
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'TypeA',
            ),
            TestDomainEvent(
              aggregateId: 'agg-2',
              aggregateType: 'TestAggregate',
              name: 'TypeB',
            ),
            TestDomainEvent(
              aggregateId: 'agg-3',
              aggregateType: 'TestAggregate',
              name: 'TypeA',
            ),
          ]);

          final retrieved = await eventStore.getEventsByType('TypeA');

          expect(retrieved.length, equals(2));
          expect(retrieved.every((e) => e.name == 'TypeA'), isTrue);
        },
      );

      test(
        'getEventsByType with since parameter should filter by timestamp',
        () async {
          final now = DateTime.now();
          final past = now.subtract(Duration(hours: 1));
          final future = now.add(Duration(hours: 2));

          // Normalize timestamps to milliseconds to match database precision
          final nowMs = DateTime.fromMillisecondsSinceEpoch(
            now.millisecondsSinceEpoch,
          );
          final pastMs = DateTime.fromMillisecondsSinceEpoch(
            past.millisecondsSinceEpoch,
          );
          final futureMs = DateTime.fromMillisecondsSinceEpoch(
            future.millisecondsSinceEpoch,
          );

          // Store events with different timestamps
          final event1 = TestDomainEvent(
            aggregateId: 'agg-1',
            aggregateType: 'TestAggregate',
            name: 'TypeA',
            timestamp: pastMs,
          );
          final event2 = TestDomainEvent(
            aggregateId: 'agg-2',
            aggregateType: 'TestAggregate',
            name: 'TypeA',
            timestamp: nowMs,
          );
          final event3 = TestDomainEvent(
            aggregateId: 'agg-3',
            aggregateType: 'TestAggregate',
            name: 'TypeA',
            timestamp: futureMs,
          );

          await eventStore.storeAll([event1, event2, event3]);

          final retrieved = await eventStore.getEventsByType(
            'TypeA',
            since: nowMs,
          );

          expect(retrieved.length, greaterThanOrEqualTo(2));
          expect(
            retrieved.every(
              (e) =>
                  e.timestamp.isAfter(nowMs) ||
                  e.timestamp.isAtSameMomentAs(nowMs),
            ),
            isTrue,
          );
        },
      );

      test(
        'getEventsByType should return empty list for unknown type',
        () async {
          final retrieved = await eventStore.getEventsByType('UnknownType');

          expect(retrieved, isEmpty);
        },
      );
    });

    group('Event Type Registry', () {
      test('registerType should allow creating events from JSON', () {
        EventTypeRegistry.registerType(
          'CustomEvent',
          (json) => TestDomainEvent.fromJson(json),
        );

        final json = {
          'id': 'test-id',
          'name': 'CustomEvent',
          'aggregateId': 'agg-1',
          'aggregateType': 'TestAggregate',
          'timestamp': DateTime.now().toIso8601String(),
          'aggregateVersion': 1,
        };

        final event = EventTypeRegistry.createEvent('CustomEvent', json);

        expect(event, isA<TestDomainEvent>());
        expect(event.name, equals('CustomEvent'));
        expect(event.aggregateId, equals('agg-1'));
      });

      test(
        'createEvent should fallback to generic DomainEvent for unregistered types',
        () {
          final json = {
            'id': 'test-id',
            'name': 'UnregisteredEvent',
            'aggregateId': 'agg-1',
            'aggregateType': 'TestAggregate',
            'timestamp': DateTime.now().toIso8601String(),
            'aggregateVersion': 1,
          };

          final event = EventTypeRegistry.createEvent(
            'UnregisteredEvent',
            json,
          );

          expect(event, isA<DomainEvent>());
          expect(event.name, equals('UnregisteredEvent'));
        },
      );
    });

    group('Database Table Creation', () {
      test(
        'ensureEventSourcingTables should create necessary tables',
        () async {
          await eventStore.ensureEventSourcingTables();

          expect(mockDb.tablesCreated, contains('domain_events'));
          expect(
            mockDb.indicesCreated,
            contains('idx_domain_events_aggregate'),
          );
          expect(mockDb.indicesCreated, contains('idx_domain_events_type'));
        },
      );
    });

    group('Transaction Handling', () {
      test('store should rollback on publisher failure', () async {
        mockPublisher.shouldFail = true;

        final event = TestDomainEvent(
          aggregateId: 'test-fail',
          aggregateType: 'TestAggregate',
          name: 'TestEvent',
        );

        try {
          await eventStore.store(event);
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e, isA<Exception>());
        }

        expect(mockDb.rolledBack, isTrue);
      });

      test(
        'storeAll should rollback all events if any storage fails',
        () async {
          mockDb.shouldFailOnThirdInsert = true;

          final events = [
            TestDomainEvent(
              aggregateId: 'test-1',
              aggregateType: 'TestAggregate',
              name: 'Event1',
            ),
            TestDomainEvent(
              aggregateId: 'test-1',
              aggregateType: 'TestAggregate',
              name: 'Event2',
            ),
            TestDomainEvent(
              aggregateId: 'test-1',
              aggregateType: 'TestAggregate',
              name: 'Event3',
            ),
          ];

          try {
            await eventStore.storeAll(events);
            fail('Should have thrown an exception');
          } catch (e) {
            expect(e, isA<Exception>());
          }

          expect(mockDb.rolledBack, isTrue);
        },
      );
    });

    group('Sequence Number Generation', () {
      test('first event for aggregate should have sequence number 1', () async {
        final event = TestDomainEvent(
          aggregateId: 'new-agg',
          aggregateType: 'TestAggregate',
          name: 'FirstEvent',
        );

        await eventStore.store(event);

        expect(mockDb.insertedEvents.first.sequenceNumber, equals(1));
      });

      test('subsequent events should increment sequence number', () async {
        final aggregateId = 'seq-test';

        for (var i = 1; i <= 5; i++) {
          final event = TestDomainEvent(
            aggregateId: aggregateId,
            aggregateType: 'TestAggregate',
            name: 'Event$i',
          );
          await eventStore.store(event);
        }

        final events = mockDb.insertedEvents
            .where((e) => e.aggregateId == aggregateId)
            .toList();

        for (var i = 0; i < events.length; i++) {
          expect(events[i].sequenceNumber, equals(i + 1));
        }
      });

      test(
        'different aggregates should have independent sequence numbers',
        () async {
          await eventStore.store(
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'Event1',
            ),
          );
          await eventStore.store(
            TestDomainEvent(
              aggregateId: 'agg-2',
              aggregateType: 'TestAggregate',
              name: 'Event1',
            ),
          );
          await eventStore.store(
            TestDomainEvent(
              aggregateId: 'agg-1',
              aggregateType: 'TestAggregate',
              name: 'Event2',
            ),
          );

          final agg1Events = mockDb.insertedEvents
              .where((e) => e.aggregateId == 'agg-1')
              .toList();
          final agg2Events = mockDb.insertedEvents
              .where((e) => e.aggregateId == 'agg-2')
              .toList();

          expect(agg1Events[0].sequenceNumber, equals(1));
          expect(agg1Events[1].sequenceNumber, equals(2));
          expect(agg2Events[0].sequenceNumber, equals(1));
        },
      );
    });
  });
}

/// Test implementation of domain event
class TestDomainEvent implements IDomainEvent {
  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime timestamp;
  @override
  String aggregateId;
  @override
  String aggregateType;
  @override
  int aggregateVersion;
  @override
  Entity? entity;

  int? sequenceNumber;

  TestDomainEvent({
    String? id,
    required this.name,
    DateTime? timestamp,
    required this.aggregateId,
    required this.aggregateType,
    this.aggregateVersion = 1,
    this.entity,
    this.sequenceNumber,
  }) : id = id ?? Oid().toString(),
       timestamp = timestamp ?? DateTime.now();

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'timestamp': timestamp.toIso8601String(),
    'aggregateId': aggregateId,
    'aggregateType': aggregateType,
    'aggregateVersion': aggregateVersion,
    'sequenceNumber': sequenceNumber,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestDomainEvent &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          aggregateId == other.aggregateId &&
          aggregateType == other.aggregateType;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      aggregateId.hashCode ^
      aggregateType.hashCode;

  @override
  Map<String, dynamic> get eventData => toJson();

  @override
  Event toBaseEvent() => Event(name, 'Test event', [], entity, eventData);

  factory TestDomainEvent.fromJson(Map<String, dynamic> json) {
    return TestDomainEvent(
      id: json['id'],
      name: json['name'],
      timestamp: DateTime.parse(json['timestamp']),
      aggregateId: json['aggregateId'],
      aggregateType: json['aggregateType'],
      aggregateVersion: json['aggregateVersion'] ?? 1,
    );
  }
}

/// Mock database for testing
class MockEDNetDatabase implements EDNetDatabase {
  final List<TestDomainEvent> insertedEvents = [];
  final List<String> tablesCreated = [];
  final List<String> indicesCreated = [];
  int transactionCount = 0;
  bool rolledBack = false;
  bool shouldFailOnThirdInsert = false;
  int insertCount = 0;
  Map<String, int> sequenceNumbers = {};

  @override
  Future<T> transaction<T>(Future<T> Function() action) async {
    transactionCount++;
    try {
      final result = await action();
      // Don't reset rolledBack to false - only set it to true on rollback
      return result;
    } catch (e) {
      rolledBack = true;
      rethrow;
    }
  }

  @override
  Future<int> customInsert(String query, {List<Variable>? variables}) async {
    insertCount++;

    if (shouldFailOnThirdInsert && insertCount == 3) {
      throw Exception('Insert failed');
    }

    // Parse aggregate info from variables
    final aggregateType = variables![2].value as String;
    final aggregateId = variables[3].value as String;
    final key = '$aggregateType:$aggregateId';

    // Get or create sequence number
    if (!sequenceNumbers.containsKey(key)) {
      sequenceNumbers[key] = 0;
    }
    sequenceNumbers[key] = sequenceNumbers[key]! + 1;

    final event = TestDomainEvent(
      id: variables[0].value as String,
      name: variables[1].value as String,
      aggregateType: aggregateType,
      aggregateId: aggregateId,
      timestamp: DateTime.fromMillisecondsSinceEpoch(variables[4].value as int),
      sequenceNumber: sequenceNumbers[key],
    );

    insertedEvents.add(event);
    return 1;
  }

  @override
  Future<QueryResult> customSelect(
    String query, {
    List<Variable>? variables,
  }) async {
    // Mock select query results
    return MockQueryResult(
      query: query,
      variables: variables ?? [],
      insertedEvents: insertedEvents,
    );
  }

  @override
  Future<void> customStatement(String query) async {
    if (query.contains('CREATE TABLE')) {
      if (query.contains('domain_events')) {
        tablesCreated.add('domain_events');
      }
    } else if (query.contains('CREATE INDEX')) {
      if (query.contains('idx_domain_events_aggregate')) {
        indicesCreated.add('idx_domain_events_aggregate');
      } else if (query.contains('idx_domain_events_type')) {
        indicesCreated.add('idx_domain_events_type');
      }
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Mock custom select result
class MockQueryResult implements QueryResult {
  final String query;
  final List<Variable> variables;
  final List<TestDomainEvent> insertedEvents;

  MockQueryResult({
    required this.query,
    required this.variables,
    required this.insertedEvents,
  });

  @override
  Future<List<QueryRow>> get() async {
    // Handle different query types
    if (query.contains('MAX(sequence_number)')) {
      // Sequence number query
      final aggregateType = variables[0].value as String;
      final aggregateId = variables[1].value as String;

      final events = insertedEvents
          .where(
            (e) =>
                e.aggregateType == aggregateType &&
                e.aggregateId == aggregateId,
          )
          .toList();

      if (events.isEmpty) {
        return [];
      }

      return [
        MockQueryRow({
          'max_seq': events
              .map((e) => e.sequenceNumber)
              .reduce((a, b) => (a! > b!) ? a : b),
        }),
      ];
    } else if (query.contains('aggregate_type') &&
        query.contains('aggregate_id')) {
      // Get events for aggregate
      final aggregateType = variables[0].value as String;
      final aggregateId = variables[1].value as String;

      return insertedEvents
          .where(
            (e) =>
                e.aggregateType == aggregateType &&
                e.aggregateId == aggregateId,
          )
          .map(
            (e) => MockQueryRow({
              'event_id': e.id,
              'event_type': e.name,
              'aggregate_type': e.aggregateType,
              'aggregate_id': e.aggregateId,
              'timestamp': e.timestamp.millisecondsSinceEpoch,
              'payload': jsonEncode(e.toJson()),
              'sequence_number': e.sequenceNumber,
            }),
          )
          .toList();
    } else if (query.contains('event_type')) {
      // Get events by type
      final eventType = variables[0].value as String;

      DateTime? since;
      if (variables.length > 1) {
        since = DateTime.fromMillisecondsSinceEpoch(variables[1].value as int);
      }

      var events = insertedEvents.where((e) => e.name == eventType);

      if (since != null) {
        events = events.where(
          (e) =>
              e.timestamp.isAfter(since!) ||
              e.timestamp.isAtSameMomentAs(since),
        );
      }

      return events
          .map(
            (e) => MockQueryRow({
              'event_id': e.id,
              'event_type': e.name,
              'aggregate_type': e.aggregateType,
              'aggregate_id': e.aggregateId,
              'timestamp': e.timestamp.millisecondsSinceEpoch,
              'payload': jsonEncode(e.toJson()),
              'sequence_number': e.sequenceNumber,
            }),
          )
          .toList();
    }

    return [];
  }

  @override
  Future<QueryRow?> getSingleOrNull() async {
    final rows = await get();
    return rows.isEmpty ? null : rows.first;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Mock query row
class MockQueryRow implements QueryRow {
  final Map<String, dynamic> data;

  MockQueryRow(this.data);

  @override
  T read<T>(String column) {
    return data[column] as T;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Mock event publisher
class MockEventPublisher implements EventPublisher {
  final List<IDomainEvent> publishedEvents = [];
  bool shouldFail = false;

  @override
  Future<void> publish(IDomainEvent event) async {
    if (shouldFail) {
      throw Exception('Publisher failed');
    }
    publishedEvents.add(event);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
