import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../test_helpers/async_test_helpers.dart';

void main() {
  group('Content Enricher Pattern', () {
    late InMemoryEnrichmentSource profileSource;
    late InMemoryEnrichmentSource topicSource;
    late BasicContentEnricher enricher;

    setUp(() {
      profileSource = InMemoryEnrichmentSource('user-profile', {
        'userId': {
          'fullName': 'Alice Johnson',
          'memberSince': '2020-03-15',
          'participationLevel': 'active',
          'expertiseAreas': ['environment', 'education'],
        },
        'citizenId': {
          'age': 28,
          'region': 'North District',
          'votingHistory': ['election-2022', 'election-2023'],
        },
      });

      topicSource = InMemoryEnrichmentSource('topic-info', {
        'topic': {
          'category': 'Policy',
          'priority': 'High',
          'relatedTopics': ['economy', 'social'],
          'activeProposals': 5,
        },
      });

      enricher = BasicContentEnricher('test-enricher', [
        profileSource,
        topicSource,
      ]);
    });

    tearDown(() {
      ObservabilityExtension.clearAllObservabilityHandlers();
    });

    test('InMemoryEnrichmentSource enriches data correctly', () async {
      final inputData = {'userId': 'user123', 'action': 'vote'};
      final enriched = await profileSource.enrichData(inputData);

      expect(enriched['userId'], equals('user123'));
      expect(enriched['action'], equals('vote'));
      expect(enriched['fullName'], equals('Alice Johnson'));
      expect(enriched['memberSince'], equals('2020-03-15'));
      expect(enriched['participationLevel'], equals('active'));
    });

    test('InMemoryEnrichmentSource handles multiple enrichment keys', () async {
      final inputData = {'userId': 'user123', 'citizenId': 'cit456'};
      final enriched = await profileSource.enrichData(inputData);

      expect(enriched['fullName'], equals('Alice Johnson'));
      expect(enriched['age'], equals(28));
      expect(enriched['region'], equals('North District'));
      expect(enriched['votingHistory'], contains('election-2022'));
    });

    test('InMemoryEnrichmentSource preserves original data', () async {
      final inputData = {'userId': 'user123', 'customField': 'customValue'};
      final enriched = await profileSource.enrichData(inputData);

      expect(enriched['userId'], equals('user123'));
      expect(enriched['customField'], equals('customValue'));
      expect(enriched['fullName'], equals('Alice Johnson'));
    });

    test('InMemoryEnrichmentSource canEnrich check works correctly', () async {
      expect(profileSource.canEnrich({'userId': 'user123'}), isTrue);
      expect(profileSource.canEnrich({'citizenId': 'cit456'}), isTrue);
      expect(profileSource.canEnrich({'unknownId': 'unknown'}), isFalse);
      expect(profileSource.canEnrich({}), isFalse);
    });

    test(
      'DatabaseEnrichmentSource enriches data with lookup function',
      () async {
        final lookupCalls = <String>[];
        final dbSource = DatabaseEnrichmentSource('test-db', (key) async {
          lookupCalls.add(key);
          return {'dbField': 'dbValue_$key', 'status': 'found'};
        });

        final inputData = {'proposalId': 'prop123', 'action': 'view'};
        final enriched = await dbSource.enrichData(inputData);

        expect(lookupCalls, contains('prop123'));
        expect(enriched['dbField'], equals('dbValue_prop123'));
        expect(enriched['status'], equals('found'));
        expect(enriched['action'], equals('view'));
      },
    );

    test(
      'DatabaseEnrichmentSource handles lookup failures gracefully',
      () async {
        final dbSource = DatabaseEnrichmentSource('test-db', (key) async {
          throw Exception('Database error');
        });

        final inputData = {'proposalId': 'prop123'};
        final enriched = await dbSource.enrichData(inputData);

        // Should still contain original data even if enrichment fails
        expect(enriched['proposalId'], equals('prop123'));
      },
    );

    test('ApiEnrichmentSource enriches data via API call', () async {
      final apiSource = ApiEnrichmentSource('test-api', (data) async {
        return {
          'apiResult': 'processed_${data['input']}',
          'timestamp': DateTime.now().toIso8601String(),
        };
      });

      final inputData = {'input': 'test-data', 'type': 'enrichment'};
      final enriched = await apiSource.enrichData(inputData);

      expect(enriched['input'], equals('test-data'));
      expect(enriched['type'], equals('enrichment'));
      expect(enriched['apiResult'], equals('processed_test-data'));
      expect(enriched['timestamp'], isNotNull);
    });

    test('BasicContentEnricher enriches messages correctly', () async {
      final message = Message(
        payload: {'userId': 'user123', 'topic': 'environment'},
        metadata: {'source': 'web'},
      );

      final enrichedMessage = await enricher.enrich(message);

      // Check enriched payload
      final payload = enrichedMessage.payload as Map<String, dynamic>;
      expect(payload['userId'], equals('user123'));
      expect(payload['topic'], equals('environment'));
      expect(payload['fullName'], equals('Alice Johnson'));
      expect(payload['category'], equals('Policy'));
      expect(payload['priority'], equals('High'));

      // Check enrichment metadata
      final metadata = enrichedMessage.metadata;
      expect(metadata['enrichedBy'], equals('test-enricher'));
      expect(metadata['enrichedAt'], isNotNull);
      expect(metadata['enrichment'], isNotNull);

      final enrichmentInfo = metadata['enrichment'] as Map<String, dynamic>;
      expect(enrichmentInfo['user-profile']['enriched'], isTrue);
      expect(enrichmentInfo['topic-info']['enriched'], isTrue);
    });

    test('BasicContentEnricher handles enrichment failures', () async {
      final failingSource = ApiEnrichmentSource('failing-api', (data) async {
        throw Exception('API unavailable');
      });

      final failingEnricher = BasicContentEnricher('failing-enricher', [
        failingSource,
      ]);

      final message = Message(payload: {'data': 'test'});
      final enrichedMessage = await failingEnricher.enrich(message);

      final metadata = enrichedMessage.metadata;
      final enrichmentInfo = metadata['enrichment'] as Map<String, dynamic>;
      expect(enrichmentInfo['failing-api']['enriched'], isFalse);
      expect(
        enrichmentInfo['failing-api']['error'],
        contains('API unavailable'),
      );
    });

    test('BasicContentEnricher canEnrich check works correctly', () async {
      // Can enrich message with matching keys
      final enrichableMessage = Message(payload: {'userId': 'user123'});
      expect(enricher.canEnrich(enrichableMessage), isTrue);

      // Cannot enrich message with non-matching keys
      final nonEnrichableMessage = Message(payload: {'unknownKey': 'value'});
      expect(enricher.canEnrich(nonEnrichableMessage), isFalse);

      // Cannot enrich message with non-map payload
      final stringMessage = Message(payload: 'string payload');
      expect(enricher.canEnrich(stringMessage), isFalse);
    });

    test('CompositeContentEnricher combines multiple enrichers', () async {
      final enricher1 = BasicContentEnricher('enricher1', [profileSource]);
      final enricher2 = BasicContentEnricher('enricher2', [topicSource]);

      final composite = CompositeContentEnricher([
        enricher1,
        enricher2,
      ], EnrichmentStrategy.mergeOverride);

      final message = Message(
        payload: {'userId': 'user123', 'topic': 'environment'},
      );

      final enrichedMessage = await composite.enrich(message);
      final payload = enrichedMessage.payload as Map<String, dynamic>;

      // Should have enrichment from both sources
      expect(payload['fullName'], equals('Alice Johnson'));
      expect(payload['category'], equals('Policy'));
      expect(payload['priority'], equals('High'));
    });

    test(
      'ContentEnricherChannelProcessor processes messages through channels',
      () async {
        final sourceChannel = InMemoryChannel(id: 'source');
        final targetChannel = InMemoryChannel(id: 'target');

        final processor = ContentEnricherChannelProcessor(
          enricher: enricher,
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
        );

        try {
          // Start processing
          await processor.start();

          // Send message through processor
          final originalMessage = Message(
            payload: {'userId': 'user123', 'topic': 'environment'},
            metadata: {'source': 'input'},
          );

          // Use deterministic async helper for enrichment process
          final enrichedMessage = await AsyncTestHelpers.subscribeBeforeAction(
            targetChannel.receive(),
            () => sourceChannel.send(originalMessage),
            timeout: const Duration(seconds: 3),
            description: 'content enricher processing',
          );

          // Verify enrichment
          expect(enrichedMessage, isNotNull);
          final payload = enrichedMessage.payload as Map<String, dynamic>;

          expect(payload['fullName'], equals('Alice Johnson'));
          expect(payload['category'], equals('Policy'));
          expect(
            enrichedMessage.metadata['enrichedBy'],
            equals('test-enricher'),
          );
        } finally {
          await processor.stop();
          await sourceChannel.close();
          await targetChannel.close();
        }
      },
    );

    test('Enrichment sources list is correctly reported', () {
      expect(enricher.enrichmentSources, contains('user-profile'));
      expect(enricher.enrichmentSources, contains('topic-info'));
    });
  });
}
