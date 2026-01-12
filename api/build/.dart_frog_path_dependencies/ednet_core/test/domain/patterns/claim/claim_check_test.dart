import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../test_helpers/async_test_helpers.dart';

void main() {
  group('Claim Check Pattern', () {
    late InMemoryClaimStore claimStore;

    setUp(() {
      claimStore = InMemoryClaimStore();
    });

    tearDown(() {
      ObservabilityExtension.clearAllObservabilityHandlers();
    });

    test(
      'InMemoryClaimStore stores and retrieves payloads correctly',
      () async {
        final testPayload = {'data': 'large content', 'size': 1024};

        // Store payload
        final claimCheckId = await claimStore.storePayload(testPayload);
        expect(claimCheckId, startsWith('claim_'));

        // Verify payload exists
        expect(await claimStore.hasPayload(claimCheckId), isTrue);

        // Retrieve payload
        final retrievedPayload = await claimStore.retrievePayload(claimCheckId);
        expect(retrievedPayload, equals(testPayload));
      },
    );

    test('InMemoryClaimStore handles different payload types', () async {
      // Test string payload
      final stringId = await claimStore.storePayload('Large text content');
      final retrievedString = await claimStore.retrievePayload(stringId);
      expect(retrievedString, equals('Large text content'));

      // Test list payload
      final listId = await claimStore.storePayload([1, 2, 3, 4, 5]);
      final retrievedList = await claimStore.retrievePayload(listId);
      expect(retrievedList, equals([1, 2, 3, 4, 5]));

      // Test map payload
      final mapId = await claimStore.storePayload({
        'key': 'value',
        'number': 42,
      });
      final retrievedMap = await claimStore.retrievePayload(mapId);
      expect(retrievedMap, equals({'key': 'value', 'number': 42}));
    });

    test(
      'InMemoryClaimStore throws exception for non-existent claim check',
      () async {
        expect(
          () async => await claimStore.retrievePayload('non-existent'),
          throwsA(isA<ClaimCheckException>()),
        );
      },
    );

    test('InMemoryClaimStore removes payloads correctly', () async {
      const testPayload = 'Data to be removed';
      final claimCheckId = await claimStore.storePayload(testPayload);

      // Verify it exists
      expect(await claimStore.hasPayload(claimCheckId), isTrue);

      // Remove it
      await claimStore.removePayload(claimCheckId);

      // Verify it's gone
      expect(await claimStore.hasPayload(claimCheckId), isFalse);
      expect(
        () async => await claimStore.retrievePayload(claimCheckId),
        throwsA(isA<ClaimCheckException>()),
      );
    });

    test('InMemoryClaimStore provides statistics', () async {
      // Initially empty
      var stats = await claimStore.getStats();
      expect(stats['totalPayloads'], equals(0));
      expect(stats['totalSizeBytes'], equals(0));

      // Add some payloads
      await claimStore.storePayload('Small payload');
      await claimStore.storePayload('Larger payload with more content');

      stats = await claimStore.getStats();
      expect(stats['totalPayloads'], equals(2));
      expect(stats['totalSizeBytes'], greaterThan(0));
      expect(stats['newestPayload'], isNotNull);
      expect(stats['oldestPayload'], isNotNull);
      if (stats['newestPayload'] != null && stats['oldestPayload'] != null) {
        expect(stats['newestPayload'].isAfter(stats['oldestPayload']), isTrue);
      }
    });

    test('InMemoryClaimStore lists claim checks', () async {
      final ids = <String>[];

      ids.add(await claimStore.storePayload('Payload 1'));
      ids.add(await claimStore.storePayload('Payload 2'));
      ids.add(await claimStore.storePayload('Payload 3'));

      final listedIds = await claimStore.listClaimChecks();
      expect(listedIds.length, equals(3));
      expect(listedIds, containsAll(ids));
    });

    test('ClaimCheckMessage stores and retrieves claim check data', () async {
      const testPayload = 'Large proposal document content';
      final claimCheckId = await claimStore.storePayload(testPayload);

      final message = ClaimCheckMessage(
        payload: 'Claim Check Reference',
        claimCheckId: claimCheckId,
        claimStore: claimStore,
        metadata: {'type': 'proposal', 'version': '1.0'},
        payloadMetadata: {'size': 'large', 'format': 'text'},
      );

      expect(message.claimCheckId, equals(claimCheckId));
      expect(message.payloadMetadata?['size'], equals('large'));

      // Test payload retrieval
      final fullPayload = await message.retrieveFullPayload();
      expect(fullPayload, equals(testPayload));

      // Test payload availability
      expect(await message.isPayloadAvailable(), isTrue);
    });

    test('ClaimCheckMessage handles unavailable payloads', () async {
      final message = ClaimCheckMessage(
        payload: 'Reference',
        claimCheckId: 'non-existent-id',
        claimStore: claimStore,
      );

      expect(await message.isPayloadAvailable(), isFalse);

      expect(
        () async => await message.retrieveFullPayload(),
        throwsA(isA<ClaimCheckException>()),
      );
    });

    test('ClaimCheckManager processes small payloads inline', () async {
      final manager = ClaimCheckManager(
        claimStore: claimStore,
        maxInlinePayloadSize: 100, // Small threshold
      );

      final smallMessage = Message(
        payload: 'Small content',
        metadata: {'type': 'small'},
      );

      final processedMessage = await manager.processMessage(smallMessage);

      // Should remain as regular message
      expect(processedMessage is ClaimCheckMessage, isFalse);
      expect(processedMessage.payload, equals('Small content'));
    });

    test('ClaimCheckManager converts large payloads to claim checks', () async {
      final manager = ClaimCheckManager(
        claimStore: claimStore,
        maxInlinePayloadSize: 10, // Very small threshold
      );

      const largePayload =
          'This is a very large payload that exceeds the threshold';
      final largeMessage = Message(
        payload: largePayload,
        metadata: {'type': 'large', 'priority': 'high'},
      );

      final processedMessage = await manager.processMessage(largeMessage);

      // Should be converted to claim check message
      expect(processedMessage is ClaimCheckMessage, isTrue);

      final claimCheckMessage = processedMessage as ClaimCheckMessage;
      expect(claimCheckMessage.metadata['hasClaimCheck'], isTrue);
      expect(
        claimCheckMessage.metadata['originalPayloadSize'],
        greaterThan(10),
      );

      // Verify we can retrieve the original payload
      final retrievedPayload = await manager.retrievePayload(claimCheckMessage);
      expect(retrievedPayload, equals(largePayload));
    });

    test('ClaimCheckManager handles claim check detection', () async {
      final manager = ClaimCheckManager(claimStore: claimStore);

      // Regular message
      final regularMessage = Message(payload: 'Regular content');
      expect(manager.hasClaimCheck(regularMessage), isFalse);

      // Claim check message
      final claimCheckId = await claimStore.storePayload('Large content');
      final claimCheckMessage = ClaimCheckMessage(
        payload: 'Claim check',
        claimCheckId: claimCheckId,
        claimStore: claimStore,
      );
      expect(manager.hasClaimCheck(claimCheckMessage), isTrue);
    });

    test(
      'ClaimCheckChannelProcessor processes messages through channels',
      () async {
        final sourceChannel = InMemoryChannel(id: 'source');
        final targetChannel = InMemoryChannel(id: 'target');

        final manager = ClaimCheckManager(
          claimStore: claimStore,
          maxInlinePayloadSize: 10,
        );

        final processor = ClaimCheckChannelProcessor(
          manager,
          sourceChannel,
          targetChannel,
        );

        try {
          // Start processing
          await processor.start();

          // Send messages through the processor
          final smallMessage = Message(
            payload: 'Small',
            metadata: {'type': 'small'},
          );

          final largeMessage = Message(
            payload:
                'This is a very large message that should be converted to a claim check',
            metadata: {'type': 'large'},
          );

          // Use deterministic async helper to subscribe and then send messages
          final messagesFuture = AsyncTestHelpers.waitForMultipleResults(
            targetChannel.receive(),
            2,
            timeout: const Duration(seconds: 3),
            description: 'claim check processor messages',
          );

          // Small delay to ensure subscription is active
          await Future.delayed(const Duration(milliseconds: 1));

          // Now send messages
          await sourceChannel.send(smallMessage);
          await sourceChannel.send(largeMessage);

          // Wait for results
          final processedMessages = await messagesFuture;

          // Verify processing
          expect(processedMessages.length, equals(2));

          // First message should be small (inline)
          expect(processedMessages[0] is ClaimCheckMessage, isFalse);
          expect(processedMessages[0].payload, equals('Small'));

          // Second message should be large (claim check)
          expect(processedMessages[1] is ClaimCheckMessage, isTrue);

          final claimCheckMsg = processedMessages[1] as ClaimCheckMessage;
          final retrievedPayload = await manager.retrievePayload(claimCheckMsg);
          expect(
            retrievedPayload,
            equals(
              'This is a very large message that should be converted to a claim check',
            ),
          );
        } finally {
          await processor.stop();
          await sourceChannel.close();
          await targetChannel.close();
        }
      },
    );

    test('Direct democracy use case - proposal document storage', () async {
      final manager = ClaimCheckManager(
        claimStore: claimStore,
        maxInlinePayloadSize: 100,
      );

      // Simulate a large proposal document
      final largeProposal = {
        'title': 'Comprehensive Housing Policy Reform',
        'content':
            'This is a very detailed proposal document with extensive content '
                'covering multiple aspects of housing policy including affordability, '
                'sustainability, community impact, and implementation strategies. ' *
            20,
        'authors': ['Citizen A', 'Citizen B', 'Expert C'],
        'references': List.generate(50, (i) => 'Reference ${i + 1}'),
        'attachments': List.generate(
          10,
          (i) => 'Attachment data ${i + 1}' * 100,
        ),
      };

      final proposalMessage = Message(
        payload: largeProposal,
        metadata: {
          'type': 'proposal',
          'topic': 'housing',
          'submittedBy': 'citizen-123',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // Process the proposal
      final processedMessage = await manager.processMessage(proposalMessage);

      // Verify it was converted to claim check
      expect(processedMessage is ClaimCheckMessage, isTrue);

      final claimCheckMessage = processedMessage as ClaimCheckMessage;
      expect(claimCheckMessage.metadata['type'], equals('proposal'));
      expect(claimCheckMessage.metadata['topic'], equals('housing'));
      expect(claimCheckMessage.metadata['hasClaimCheck'], isTrue);

      // Verify we can retrieve the full proposal
      final retrievedProposal = await manager.retrievePayload(
        claimCheckMessage,
      );
      expect(retrievedProposal, equals(largeProposal));
      expect(
        retrievedProposal['title'],
        equals('Comprehensive Housing Policy Reform'),
      );
      expect(retrievedProposal['authors'].length, equals(3));
    });

    test('Direct democracy use case - voting data management', () async {
      final manager = ClaimCheckManager(
        claimStore: claimStore,
        maxInlinePayloadSize: 500,
      );

      // Simulate comprehensive voting data
      final votingData = {
        'electionId': 'election-2024-001',
        'votingPeriod': {
          'start': '2024-01-01T00:00:00Z',
          'end': '2024-01-31T23:59:59Z',
        },
        'ballots': List.generate(
          1000,
          (i) => {
            'ballotId': 'ballot-${i + 1}',
            'voterId': 'voter-${i + 1}',
            'timestamp': DateTime.now()
                .subtract(Duration(minutes: i))
                .toIso8601String(),
            'choices': {
              'president': 'Candidate ${(i % 3) + 1}',
              'policyA': i % 2 == 0 ? 'Yes' : 'No',
              'policyB': i % 2 == 1 ? 'Yes' : 'No',
            },
            'verificationCode': 'VERIFY-${i + 1}',
          },
        ),
        'metadata': {
          'totalVoters': 1000,
          'turnoutPercentage': 78.5,
          'securityHash': 'sha256-hash-of-all-ballots',
        },
      };

      final votingMessage = Message(
        payload: votingData,
        metadata: {
          'type': 'voting_results',
          'election': 'election-2024-001',
          'jurisdiction': 'national',
        },
      );

      // Process the voting data
      final processedMessage = await manager.processMessage(votingMessage);

      // Should be converted to claim check due to size
      expect(processedMessage is ClaimCheckMessage, isTrue);

      final claimCheckMessage = processedMessage as ClaimCheckMessage;
      expect(claimCheckMessage.metadata['type'], equals('voting_results'));
      expect(
        claimCheckMessage.metadata['election'],
        equals('election-2024-001'),
      );

      // Verify full data retrieval
      final retrievedData = await manager.retrievePayload(claimCheckMessage);
      expect(retrievedData, equals(votingData));
      expect(retrievedData['ballots'].length, equals(1000));
      expect(retrievedData['metadata']['totalVoters'], equals(1000));
    });

    test('Claim check storage statistics and management', () async {
      // Store multiple payloads of different sizes
      final payloads = [
        'Small payload',
        'Medium payload with more content here',
        'Large payload ' * 100, // Much larger
      ];

      final claimCheckIds = <String>[];
      for (final payload in payloads) {
        claimCheckIds.add(await claimStore.storePayload(payload));
      }

      // Verify all payloads are stored
      final stats = await claimStore.getStats();
      expect(stats['totalPayloads'], equals(3));
      expect(stats['totalSizeBytes'], greaterThan(0));

      // Test listing
      final listedIds = await claimStore.listClaimChecks();
      expect(listedIds.length, equals(3));
      expect(listedIds, containsAll(claimCheckIds));

      // Test selective removal
      await claimStore.removePayload(claimCheckIds[1]);
      expect(await claimStore.hasPayload(claimCheckIds[1]), isFalse);
      expect(await claimStore.hasPayload(claimCheckIds[0]), isTrue);
      expect(await claimStore.hasPayload(claimCheckIds[2]), isTrue);

      // Verify updated stats
      final updatedStats = await claimStore.getStats();
      expect(updatedStats['totalPayloads'], equals(2));
    });
  });
}
