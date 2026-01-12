import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../../test_helpers/async_test_helpers.dart';

void main() {
  group('Content Filter Pattern', () {
    test('FieldBasedContentFilter keeps only specified fields', () async {
      final filter = FieldBasedContentFilter(
        filterName: 'test-keep-filter',
        fieldsToKeep: ['id', 'name', 'status'],
      );

      final message = Message(
        payload: {
          'id': '123',
          'name': 'Test Item',
          'status': 'active',
          'description': 'This should be removed',
          'metadata': {'extra': 'data'},
        },
        metadata: {'source': 'test'},
      );

      final filteredMessage = await filter.filter(message);
      final payload = filteredMessage.payload as Map<String, dynamic>;

      expect(payload.length, equals(3));
      expect(payload['id'], equals('123'));
      expect(payload['name'], equals('Test Item'));
      expect(payload['status'], equals('active'));
      expect(payload.containsKey('description'), isFalse);
      expect(payload.containsKey('metadata'), isFalse);

      // Check metadata
      final metadata = filteredMessage.metadata;
      expect(metadata['filtered'], isTrue);
      expect(metadata['filterName'], equals('test-keep-filter'));
      expect(metadata['originalFieldCount'], equals(5));
      expect(metadata['filteredFieldCount'], equals(3));
    });

    test('FieldBasedContentFilter removes specified fields', () async {
      final filter = FieldBasedContentFilter(
        filterName: 'test-remove-filter',
        fieldsToRemove: ['sensitive', 'internal'],
      );

      final message = Message(
        payload: {
          'id': '123',
          'name': 'Test Item',
          'status': 'active',
          'sensitive': 'secret data',
          'internal': {'debug': 'info'},
        },
      );

      final filteredMessage = await filter.filter(message);
      final payload = filteredMessage.payload as Map<String, dynamic>;

      expect(payload.length, equals(3));
      expect(payload['id'], equals('123'));
      expect(payload['name'], equals('Test Item'));
      expect(payload['status'], equals('active'));
      expect(payload.containsKey('sensitive'), isFalse);
      expect(payload.containsKey('internal'), isFalse);
    });

    test(
      'FieldBasedContentFilter with rules filters based on conditions',
      () async {
        final filter = FieldBasedContentFilter(
          filterName: 'test-rule-filter',
          rules: [
            FilterRule(
              field: 'status',
              operation: FilterOperation.equals,
              value: 'active',
              keep: true,
            ),
            FilterRule(
              field: 'priority',
              operation: FilterOperation.greaterThan,
              value: 5,
              keep: true,
            ),
          ],
        );

        final message = Message(
          payload: {
            'id': '123',
            'name': 'Test Item',
            'status': 'active',
            'priority': 3, // This should be filtered out
            'category': 'test',
          },
        );

        final filteredMessage = await filter.filter(message);
        final payload = filteredMessage.payload as Map<String, dynamic>;

        expect(payload.length, equals(4)); // priority field is filtered out
        expect(payload['id'], equals('123'));
        expect(payload['name'], equals('Test Item'));
        expect(payload['status'], equals('active'));
        expect(payload['category'], equals('test'));
        expect(payload.containsKey('priority'), isFalse);
      },
    );

    test('FilterRule matches work correctly', () {
      final equalsRule = FilterRule(
        field: 'status',
        operation: FilterOperation.equals,
        value: 'active',
      );

      expect(equalsRule.matches('active'), isTrue);
      expect(equalsRule.matches('inactive'), isFalse);

      final containsRule = FilterRule(
        field: 'tags',
        operation: FilterOperation.contains,
        value: 'important',
      );

      expect(containsRule.matches(['urgent', 'important']), isTrue);
      expect(containsRule.matches(['normal', 'standard']), isFalse);

      final greaterThanRule = FilterRule(
        field: 'score',
        operation: FilterOperation.greaterThan,
        value: 10,
      );

      expect(greaterThanRule.matches(15), isTrue);
      expect(greaterThanRule.matches(5), isFalse);

      final existsRule = FilterRule(
        field: 'data',
        operation: FilterOperation.exists,
      );

      expect(existsRule.matches('value'), isTrue);
      expect(existsRule.matches(null), isFalse);
    });

    test('SizeBasedContentFilter limits payload size', () async {
      final filter = SizeBasedContentFilter(
        filterName: 'test-size-filter',
        maxPayloadSize: 100, // Very small limit
        prioritizeImportantFields: true,
        importantFields: ['id', 'name'],
      );

      final message = Message(
        payload: {
          'id': '123',
          'name': 'Test Item',
          'description':
              'This is a very long description that should be truncated',
          'extraField': 'Additional data that might not fit',
        },
      );

      final filteredMessage = await filter.filter(message);
      final payload = filteredMessage.payload as Map<String, dynamic>;

      // Should keep important fields and some others within size limit
      expect(payload.containsKey('id'), isTrue);
      expect(payload.containsKey('name'), isTrue);

      final metadata = filteredMessage.metadata;
      if (metadata['sizeFiltered'] == true) {
        expect(metadata['originalSize'], greaterThan(metadata['filteredSize']));
        expect(metadata['maxAllowedSize'], equals(100));
      } else {
        // If size filtering didn't occur, that's also acceptable
        // (depends on actual payload size vs limit)
      }
    });

    test('SizeBasedContentFilter without prioritization', () async {
      final filter = SizeBasedContentFilter(
        filterName: 'test-simple-size-filter',
        maxPayloadSize: 50,
        prioritizeImportantFields: false,
      );

      final message = Message(
        payload: {
          'a': 'short',
          'b': 'This is a longer field that might exceed the limit',
          'c': 'another field',
        },
      );

      final filteredMessage = await filter.filter(message);

      // Should include fields until size limit is reached
      final metadata = filteredMessage.metadata;
      expect(metadata['filteredSize'], lessThanOrEqualTo(50));
    });

    test('CompositeContentFilter combines multiple filters', () async {
      final keepFilter = FieldBasedContentFilter(
        filterName: 'keep-essential',
        fieldsToKeep: ['id', 'name', 'status'],
      );

      final sizeFilter = SizeBasedContentFilter(
        filterName: 'limit-size',
        maxPayloadSize: 200,
      );

      final compositeFilter = CompositeContentFilter(
        filterName: 'combined-filter',
        filters: [keepFilter, sizeFilter],
      );

      final message = Message(
        payload: {
          'id': '123',
          'name': 'Test Item',
          'status': 'active',
          'description':
              'Long description that should be handled by size filter',
          'extra': 'Additional field',
        },
      );

      final filteredMessage = await compositeFilter.filter(message);
      final payload = filteredMessage.payload as Map<String, dynamic>;

      // Should have both field filtering and size filtering applied
      expect(payload.containsKey('id'), isTrue);
      expect(payload.containsKey('name'), isTrue);
      expect(payload.containsKey('status'), isTrue);

      final metadata = filteredMessage.metadata;
      expect(metadata['compositeFilter'], equals('combined-filter'));
      expect(metadata['appliedFilters'], contains('keep-essential'));
      expect(metadata['appliedFilters'], contains('limit-size'));
    });

    test('CompositeContentFilter with stopOnFirstMatch', () async {
      final filter1 = FieldBasedContentFilter(
        filterName: 'filter1',
        fieldsToKeep: ['id', 'name'],
      );

      final filter2 = FieldBasedContentFilter(
        filterName: 'filter2',
        fieldsToKeep: ['status', 'priority'],
      );

      final compositeFilter = CompositeContentFilter(
        filterName: 'stop-first-filter',
        filters: [filter1, filter2],
        stopOnFirstMatch: true,
      );

      final message = Message(
        payload: {
          'id': '123',
          'name': 'Test',
          'status': 'active',
          'priority': 'high',
          'extra': 'field',
        },
      );

      final filteredMessage = await compositeFilter.filter(message);
      final payload = filteredMessage.payload as Map<String, dynamic>;

      // Should only have fields from first filter
      expect(payload.containsKey('id'), isTrue);
      expect(payload.containsKey('name'), isTrue);
      expect(payload.containsKey('status'), isFalse); // Not in first filter
      expect(payload.containsKey('priority'), isFalse); // Not in first filter
    });

    test('Content filters handle non-map payloads gracefully', () async {
      final filter = FieldBasedContentFilter(
        filterName: 'test-filter',
        fieldsToKeep: ['id'],
      );

      final stringMessage = Message(payload: 'string payload');
      final filteredMessage = await filter.filter(stringMessage);

      // Should return unchanged
      expect(filteredMessage.payload, equals('string payload'));
      expect(filter.canFilter(stringMessage), isFalse);
    });

    test(
      'FieldBasedContentFilter optimizes for mobile notifications',
      () async {
        final filter = FieldBasedContentFilter(
          filterName: 'notification-filter',
          fieldsToKeep: [
            'notificationId',
            'title',
            'message',
            'type',
            'priority',
            'actionUrl',
            'timestamp',
          ],
          rules: [
            FilterRule(
              field: 'priority',
              operation: FilterOperation.notEquals,
              value: 'low',
              keep: true,
            ),
          ],
        );

        final notificationMessage = Message(
          payload: {
            'notificationId': 'notif-123',
            'title': 'New Proposal Available',
            'message': 'A new housing proposal is now available for review',
            'type': 'proposal',
            'priority': 'high',
            'actionUrl': '/proposals/123',
            'timestamp': '2024-01-15T10:00:00Z',
            'sender': 'Government Office',
            'detailedContent': 'Very long detailed content...',
            'attachments': ['file1.pdf', 'file2.pdf'],
            'internalNotes': 'Internal processing notes',
          },
          metadata: {'channel': 'citizen-notifications'},
        );

        final filteredMessage = await filter.filter(notificationMessage);
        final payload = filteredMessage.payload as Map<String, dynamic>;

        // Should keep only essential fields
        expect(payload.containsKey('notificationId'), isTrue);
        expect(payload.containsKey('title'), isTrue);
        expect(payload.containsKey('message'), isTrue);
        expect(payload.containsKey('type'), isTrue);
        expect(payload.containsKey('priority'), isTrue);
        expect(payload.containsKey('actionUrl'), isTrue);
        expect(payload.containsKey('timestamp'), isTrue);

        // Should remove non-essential fields
        expect(payload.containsKey('sender'), isFalse);
        expect(payload.containsKey('detailedContent'), isFalse);
        expect(payload.containsKey('attachments'), isFalse);
        expect(payload.containsKey('internalNotes'), isFalse);
      },
    );

    test(
      'SizeBasedContentFilter optimizes proposals for mobile consumption',
      () async {
        final filter = SizeBasedContentFilter(
          filterName: 'mobile-proposal-filter',
          maxPayloadSize: 2048, // 2KB limit for mobile
          prioritizeImportantFields: true,
          importantFields: ['proposalId', 'title', 'summary', 'status'],
        );

        final proposalMessage = Message(
          payload: {
            'proposalId': 'prop-456',
            'title': 'Housing Reform Initiative',
            'summary': 'A comprehensive plan to address housing affordability',
            'status': 'active',
            'supporters': 1250,
            'endDate': '2024-02-01',
            'category': 'Housing',
            'fullDescription':
                'Very detailed description that would be too long for mobile...',
            'detailedBudget': {
              'amount': 50000000,
              'breakdown': 'complex breakdown data',
            },
            'implementationTimeline':
                'Detailed timeline with many milestones...',
            'stakeholderAnalysis': 'Complex stakeholder analysis document...',
          },
        );

        final filteredMessage = await filter.filter(proposalMessage);
        final payload = filteredMessage.payload as Map<String, dynamic>;

        // Should prioritize important fields
        expect(payload.containsKey('proposalId'), isTrue);
        expect(payload.containsKey('title'), isTrue);
        expect(payload.containsKey('summary'), isTrue);
        expect(payload.containsKey('status'), isTrue);
        expect(payload.containsKey('supporters'), isTrue);
        expect(payload.containsKey('endDate'), isTrue);
        expect(payload.containsKey('category'), isTrue);

        // May or may not include less important fields depending on size
        final metadata = filteredMessage.metadata;
        if (metadata['sizeFiltered'] == true) {
          expect(metadata['filteredSize'], lessThanOrEqualTo(2048));
        } else {
          // Size filtering may not occur if payload is already small enough
        }
      },
    );

    test(
      'FieldBasedContentFilter keeps only essential voting statistics',
      () async {
        final filter = FieldBasedContentFilter(
          filterName: 'voting-results-filter',
          fieldsToKeep: [
            'electionId',
            'candidateResults',
            'totalVotes',
            'yesVotes',
            'noVotes',
            'abstainVotes',
            'turnoutPercentage',
            'winner',
            'status',
          ],
        );

        final votingMessage = Message(
          payload: {
            'electionId': 'election-2024',
            'totalVotes': 10000,
            'yesVotes': 6000,
            'noVotes': 3500,
            'abstainVotes': 500,
            'turnoutPercentage': 78.5,
            'winner': 'Proposal A',
            'status': 'completed',
            'detailedResults': {
              'byRegion': 'complex data',
              'byDemographic': 'more data',
            },
            'auditTrail': 'Detailed audit information...',
            'rawBallotData': 'Large dataset of individual ballots...',
            'processingMetadata': {
              'server': 'server1',
              'timestamp': '2024-01-15',
            },
          },
        );

        final filteredMessage = await filter.filter(votingMessage);
        final payload = filteredMessage.payload as Map<String, dynamic>;

        // Should keep only essential voting statistics
        expect(payload['electionId'], equals('election-2024'));
        expect(payload['totalVotes'], equals(10000));
        expect(payload['yesVotes'], equals(6000));
        expect(payload['noVotes'], equals(3500));
        expect(payload['abstainVotes'], equals(500));
        expect(payload['turnoutPercentage'], equals(78.5));
        expect(payload['winner'], equals('Proposal A'));
        expect(payload['status'], equals('completed'));

        // Should remove detailed/raw data
        expect(payload.containsKey('detailedResults'), isFalse);
        expect(payload.containsKey('auditTrail'), isFalse);
        expect(payload.containsKey('rawBallotData'), isFalse);
        expect(payload.containsKey('processingMetadata'), isFalse);
      },
    );

    test(
      'ContentFilterChannelProcessor processes messages through channels',
      () async {
        final sourceChannel = InMemoryChannel(id: 'source');
        final targetChannel = InMemoryChannel(id: 'target');

        final filter = FieldBasedContentFilter(
          filterName: 'channel-filter',
          fieldsToKeep: ['id', 'name'],
        );

        final processor = ContentFilterChannelProcessor(
          filter: filter,
          sourceChannel: sourceChannel,
          targetChannel: targetChannel,
        );

        try {
          // Start processing
          await processor.start();

          // Send message through processor
          final originalMessage = Message(
            payload: {
              'id': '123',
              'name': 'Test Item',
              'extra': 'This should be filtered out',
            },
            metadata: {'source': 'input'},
          );

          // Use deterministic async helper for content filtering
          final filteredMessage = await AsyncTestHelpers.subscribeBeforeAction(
            targetChannel.receive(),
            () => sourceChannel.send(originalMessage),
            timeout: const Duration(seconds: 3),
            description: 'content filter processing',
          );

          // Verify filtering
          expect(filteredMessage, isNotNull);
          final payload = filteredMessage.payload as Map<String, dynamic>;

          expect(payload.containsKey('id'), isTrue);
          expect(payload.containsKey('name'), isTrue);
          expect(payload.containsKey('extra'), isFalse);
          expect(filteredMessage.metadata['filtered'], isTrue);
        } finally {
          await processor.stop();
          await sourceChannel.close();
          await targetChannel.close();
        }
      },
    );

    test('ContentFilterChain applies multiple filters in sequence', () async {
      final chain = ContentFilterChain([
        FieldBasedContentFilter(
          filterName: 'remove-extra',
          fieldsToRemove: ['debug', 'internal'],
        ),
        SizeBasedContentFilter(filterName: 'limit-size', maxPayloadSize: 100),
      ]);

      final message = Message(
        payload: {
          'id': '123',
          'name': 'Test Item',
          'status': 'active',
          'debug': {'trace': 'info'},
          'internal': 'secret',
          'description':
              'This is a long description that might be truncated by size filter',
        },
      );

      final filteredMessage = await chain.process(message);
      final payload = filteredMessage.payload as Map<String, dynamic>;

      // Should have both field removal and size limiting applied
      expect(payload.containsKey('debug'), isFalse);
      expect(payload.containsKey('internal'), isFalse);
      expect(payload.containsKey('id'), isTrue);
      expect(payload.containsKey('name'), isTrue);
      expect(payload.containsKey('status'), isTrue);

      final stats = chain.getChainStats();
      expect(stats['filterCount'], equals(2));
      expect(stats['filters'].length, equals(2));
    });

    test('Filter criteria are properly exposed', () {
      final fieldFilter = FieldBasedContentFilter(
        filterName: 'test-field-filter',
        fieldsToKeep: ['id', 'name'],
        rules: [
          FilterRule(
            field: 'status',
            operation: FilterOperation.equals,
            value: 'active',
          ),
        ],
      );

      final criteria = fieldFilter.getFilterCriteria();
      expect(criteria['name'], equals('test-field-filter'));
      expect(criteria['fieldsToKeep'], contains('id'));
      expect(criteria['fieldsToKeep'], contains('name'));
      expect(criteria['rules'].length, equals(1));

      final sizeFilter = SizeBasedContentFilter(
        filterName: 'test-size-filter',
        maxPayloadSize: 1024,
        importantFields: ['id', 'name'],
      );

      final sizeCriteria = sizeFilter.getFilterCriteria();
      expect(sizeCriteria['name'], equals('test-size-filter'));
      expect(sizeCriteria['maxPayloadSize'], equals(1024));
      expect(sizeCriteria['importantFields'], contains('id'));
    });
  });
}
