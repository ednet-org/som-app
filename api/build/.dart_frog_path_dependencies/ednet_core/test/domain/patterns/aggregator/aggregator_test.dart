import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../test_helpers/async_test_helpers.dart';

void main() {
  group('Message Aggregator Pattern', () {
    late InMemoryChannel inputChannel;
    late InMemoryChannel outputChannel;

    setUp(() {
      final uniqueId =
          '${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().hashCode}';
      inputChannel = InMemoryChannel(id: 'input_$uniqueId', broadcast: true);
      outputChannel = InMemoryChannel(id: 'output_$uniqueId', broadcast: true);
    });

    tearDown(() async {
      await inputChannel.close();
      await outputChannel.close();
      ObservabilityExtension.clearAllObservabilityHandlers();
    });

    test('CountBasedAggregator aggregates messages by correlation ID', () {
      final aggregator = CountBasedAggregator<Map<String, dynamic>>(
        expectedCount: 3,
        correlationIdExtractor: (msg) => msg.metadata['correlationId'],
        resultBuilder: (messages) => {
          'correlationId': messages.first.metadata['correlationId'],
          'count': messages.length,
          'payloads': messages.map((m) => m.payload).toList(),
        },
      );

      // Add messages with the same correlation ID
      final message1 = Message(
        payload: 'Vote 1',
        metadata: {'correlationId': 'election-123', 'voterId': 'voter1'},
      );

      final message2 = Message(
        payload: 'Vote 2',
        metadata: {'correlationId': 'election-123', 'voterId': 'voter2'},
      );

      final message3 = Message(
        payload: 'Vote 3',
        metadata: {'correlationId': 'election-123', 'voterId': 'voter3'},
      );

      aggregator.addMessage(message1);
      expect(aggregator.isComplete(), isFalse);

      aggregator.addMessage(message2);
      expect(aggregator.isComplete(), isFalse);

      aggregator.addMessage(message3);
      expect(aggregator.isComplete(), isTrue);

      final result = aggregator.getAggregatedResult();
      expect(result['correlationId'], equals('election-123'));
      expect(result['count'], equals(3));
      expect(result['payloads'], containsAll(['Vote 1', 'Vote 2', 'Vote 3']));
    });

    test('CountBasedAggregator handles multiple correlation groups', () {
      final aggregator = CountBasedAggregator<List<String>>(
        expectedCount: 2,
        correlationIdExtractor: (msg) => msg.metadata['group'],
        resultBuilder: (messages) =>
            messages.map((m) => m.payload as String).toList(),
      );

      // Add messages for group A
      aggregator.addMessage(Message(payload: 'A1', metadata: {'group': 'A'}));

      aggregator.addMessage(Message(payload: 'A2', metadata: {'group': 'A'}));

      // Add messages for group B
      aggregator.addMessage(Message(payload: 'B1', metadata: {'group': 'B'}));

      expect(aggregator.isComplete(), isTrue);

      final result = aggregator.getAggregatedResult();
      expect(result, contains('A1'));
      expect(result, contains('A2'));
      expect(result.length, equals(2));
    });

    test(
      'CountBasedAggregator throws error when accessing incomplete result',
      () {
        final aggregator = CountBasedAggregator<String>(
          expectedCount: 2,
          correlationIdExtractor: (msg) => msg.metadata['id'],
          resultBuilder: (messages) => messages.first.payload as String,
        );

        aggregator.addMessage(
          Message(payload: 'Test', metadata: {'id': 'test'}),
        );

        expect(aggregator.isComplete(), isFalse);
        expect(() => aggregator.getAggregatedResult(), throwsStateError);
      },
    );

    test('CountBasedAggregator resets properly', () {
      final aggregator = CountBasedAggregator<String>(
        expectedCount: 1,
        correlationIdExtractor: (msg) => msg.metadata['id'],
        resultBuilder: (messages) => messages.first.payload as String,
      );

      aggregator.addMessage(Message(payload: 'Test', metadata: {'id': 'test'}));

      expect(aggregator.isComplete(), isTrue);
      expect(aggregator.getAggregatedResult(), equals('Test'));

      aggregator.reset();
      expect(aggregator.isComplete(), isFalse);
      expect(() => aggregator.getAggregatedResult(), throwsStateError);
    });

    test('TimeBasedAggregator completes after timeout', () async {
      final aggregator = TimeBasedAggregator<Map<String, dynamic>>(
        timeout: const Duration(milliseconds: 100),
        correlationIdExtractor: (msg) => msg.metadata['correlationId'],
        resultBuilder: (messages) => {
          'correlationId': messages.first.metadata['correlationId'],
          'count': messages.length,
          'payloads': messages.map((m) => m.payload).toList(),
        },
      );

      // Add a message
      final message = Message(
        payload: 'Delayed message',
        metadata: {'correlationId': 'delayed-123'},
      );

      aggregator.addMessage(message);
      expect(aggregator.isComplete(), isFalse);

      // Wait for timeout using deterministic helper
      await AsyncTestHelpers.waitForCondition(
        () => aggregator.isComplete(),
        timeout: const Duration(seconds: 1),
        description: 'waiting for aggregator timeout completion',
      );

      final result = aggregator.getAggregatedResult();
      expect(result['correlationId'], equals('delayed-123'));
      expect(result['count'], equals(1));
      expect(result['payloads'], contains('Delayed message'));

      aggregator.dispose();
    });

    test(
      'TimeBasedAggregator handles multiple messages before timeout',
      () async {
        final aggregator = TimeBasedAggregator<Map<String, dynamic>>(
          timeout: const Duration(milliseconds: 200),
          correlationIdExtractor: (msg) => msg.metadata['correlationId'],
          resultBuilder: (messages) => {
            'correlationId': messages.first.metadata['correlationId'],
            'count': messages.length,
            'payloads': messages.map((m) => m.payload).toList(),
          },
        );

        // Add multiple messages for the same correlation ID
        aggregator.addMessage(
          Message(
            payload: 'Message 1',
            metadata: {'correlationId': 'batch-123'},
          ),
        );

        aggregator.addMessage(
          Message(
            payload: 'Message 2',
            metadata: {'correlationId': 'batch-123'},
          ),
        );

        aggregator.addMessage(
          Message(
            payload: 'Message 3',
            metadata: {'correlationId': 'batch-123'},
          ),
        );

        expect(aggregator.isComplete(), isFalse);

        // Wait for timeout using deterministic helper
        await AsyncTestHelpers.waitForCondition(
          () => aggregator.isComplete(),
          timeout: const Duration(seconds: 1),
          description:
              'waiting for multiple messages aggregator timeout completion',
        );

        final result = aggregator.getAggregatedResult();
        expect(result['correlationId'], equals('batch-123'));
        expect(result['count'], equals(3));
        expect(
          result['payloads'],
          containsAll(['Message 1', 'Message 2', 'Message 3']),
        );

        aggregator.dispose();
      },
    );

    test('TimeBasedAggregator ignores messages for completed groups', () async {
      final aggregator = TimeBasedAggregator<List<String>>(
        timeout: const Duration(milliseconds: 50),
        correlationIdExtractor: (msg) => msg.metadata['correlationId'],
        resultBuilder: (messages) =>
            messages.map((m) => m.payload as String).toList(),
      );

      // Add initial message
      aggregator.addMessage(
        Message(payload: 'Initial', metadata: {'correlationId': 'test-group'}),
      );

      // Wait for timeout to complete using deterministic helper
      await AsyncTestHelpers.waitForCondition(
        () => aggregator.isComplete(),
        timeout: const Duration(seconds: 1),
        description: 'waiting for late message aggregator timeout completion',
      );

      // Try to add more messages - should be ignored
      aggregator.addMessage(
        Message(
          payload: 'Late message',
          metadata: {'correlationId': 'test-group'},
        ),
      );

      final result = aggregator.getAggregatedResult();
      expect(result.length, equals(1));
      expect(result, contains('Initial'));
      expect(result, isNot(contains('Late message')));

      aggregator.dispose();
    });

    test('TimeBasedAggregator resets properly', () async {
      final aggregator = TimeBasedAggregator<String>(
        timeout: const Duration(milliseconds: 50),
        correlationIdExtractor: (msg) => msg.metadata['correlationId'],
        resultBuilder: (messages) => messages.first.payload as String,
      );

      aggregator.addMessage(
        Message(payload: 'Test', metadata: {'correlationId': 'test'}),
      );

      await AsyncTestHelpers.waitForCondition(
        () => aggregator.isComplete(),
        timeout: const Duration(seconds: 1),
        description: 'waiting for aggregator reset timeout completion',
      );
      expect(aggregator.getAggregatedResult(), equals('Test'));

      aggregator.reset();
      expect(aggregator.isComplete(), isFalse);

      aggregator.dispose();
    });

    test('CountBasedAggregator validates expected count', () {
      expect(
        () => CountBasedAggregator<String>(
          expectedCount: 0,
          correlationIdExtractor: (msg) => msg.metadata['id'],
          resultBuilder: (messages) => messages.first.payload as String,
        ),
        throwsArgumentError,
      );

      expect(
        () => CountBasedAggregator<String>(
          expectedCount: -1,
          correlationIdExtractor: (msg) => msg.metadata['id'],
          resultBuilder: (messages) => messages.first.payload as String,
        ),
        throwsArgumentError,
      );
    });

    test('Aggregators handle null correlation IDs', () {
      final countAggregator = CountBasedAggregator<String>(
        expectedCount: 1,
        correlationIdExtractor: (msg) => msg.metadata['id'],
        resultBuilder: (messages) => messages.first.payload as String,
      );

      final message = Message(
        payload: 'Test',
        metadata: {}, // No correlation ID
      );

      expect(() => countAggregator.addMessage(message), throwsArgumentError);

      final timeAggregator = TimeBasedAggregator<String>(
        timeout: const Duration(milliseconds: 100),
        correlationIdExtractor: (msg) => msg.metadata['id'],
        resultBuilder: (messages) => messages.first.payload as String,
      );

      expect(() => timeAggregator.addMessage(message), throwsArgumentError);

      timeAggregator.dispose();
    });
  });

  group('Direct Democracy Use Cases', () {
    test('Vote aggregation scenario', () {
      final voteAggregator = CountBasedAggregator<Map<String, dynamic>>(
        expectedCount: 5, // 5 votes needed
        correlationIdExtractor: (msg) => msg.metadata['proposalId'],
        resultBuilder: (messages) => {
          'proposalId': messages.first.metadata['proposalId'],
          'totalVotes': messages.length,
          'votes': messages
              .map(
                (m) => {'voterId': m.metadata['voterId'], 'choice': m.payload},
              )
              .toList(),
          'yesVotes': messages.where((m) => m.payload == 'YES').length,
          'noVotes': messages.where((m) => m.payload == 'NO').length,
        },
      );

      // Simulate 5 votes for a proposal
      final votes = [
        {'voterId': 'voter1', 'choice': 'YES'},
        {'voterId': 'voter2', 'choice': 'YES'},
        {'voterId': 'voter3', 'choice': 'NO'},
        {'voterId': 'voter4', 'choice': 'YES'},
        {'voterId': 'voter5', 'choice': 'NO'},
      ];

      for (final vote in votes) {
        voteAggregator.addMessage(
          Message(
            payload: vote['choice'],
            metadata: {'proposalId': 'prop-123', 'voterId': vote['voterId']},
          ),
        );
      }

      expect(voteAggregator.isComplete(), isTrue);

      final result = voteAggregator.getAggregatedResult();
      expect(result['proposalId'], equals('prop-123'));
      expect(result['totalVotes'], equals(5));
      expect(result['yesVotes'], equals(3));
      expect(result['noVotes'], equals(2));
    });

    test('Citizen feedback collection scenario', () async {
      final feedbackAggregator = TimeBasedAggregator<Map<String, dynamic>>(
        timeout: const Duration(milliseconds: 200),
        correlationIdExtractor: (msg) => msg.metadata['topic'],
        resultBuilder: (messages) => {
          'topic': messages.first.metadata['topic'],
          'totalFeedback': messages.length,
          'feedback': messages
              .map(
                (m) => {
                  'citizenId': m.metadata['citizenId'],
                  'feedback': m.payload,
                  'rating': m.metadata['rating'],
                },
              )
              .toList(),
          'averageRating': messages.isEmpty
              ? 0
              : messages
                        .map((m) => m.metadata['rating'] as int)
                        .reduce((a, b) => a + b) /
                    messages.length,
        },
      );

      // Simulate citizen feedback on housing policy
      final feedback = [
        {'citizenId': 'citizen1', 'rating': 4, 'comment': 'Good initiative'},
        {'citizenId': 'citizen2', 'rating': 5, 'comment': 'Excellent policy'},
        {'citizenId': 'citizen3', 'rating': 2, 'comment': 'Needs improvement'},
      ];

      for (final item in feedback) {
        feedbackAggregator.addMessage(
          Message(
            payload: item['comment'],
            metadata: {
              'topic': 'housing-policy',
              'citizenId': item['citizenId'],
              'rating': item['rating'],
            },
          ),
        );
      }

      await AsyncTestHelpers.waitForCondition(
        () => feedbackAggregator.isComplete(),
        timeout: const Duration(seconds: 1),
        description:
            'waiting for citizen feedback aggregator timeout completion',
      );

      final result = feedbackAggregator.getAggregatedResult();
      expect(result['topic'], equals('housing-policy'));
      expect(result['totalFeedback'], equals(3));
      expect(result['averageRating'], equals(11 / 3)); // (4 + 5 + 2) / 3

      feedbackAggregator.dispose();
    });
  });
}
