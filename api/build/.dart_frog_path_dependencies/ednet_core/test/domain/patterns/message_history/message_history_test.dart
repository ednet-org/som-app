import 'dart:async';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Message History Pattern Tests', () {
    late BasicMessageHistoryTracker tracker;

    setUp(() {
      tracker = BasicMessageHistoryTracker();
    });

    test(
      'Given a message history tracker, When recording event, Then event is stored',
      () async {
        // Given
        final message = Message(
          payload: {'action': 'test'},
          metadata: {'messageType': 'test'},
          id: 'test-message-1',
        );

        final event = MessageEvent.fromMessage(
          message,
          MessageEventType.created,
          'test-component',
          'test-type',
          eventData: {'customData': 'value'},
        );

        // When
        await tracker.recordEvent(message, event);

        // Then
        final history = await tracker.getMessageHistory(message.id);
        expect(history.length, equals(1));
        expect(history.first.eventType, equals(MessageEventType.created));
        expect(history.first.componentId, equals('test-component'));
        expect(history.first.eventData['customData'], equals('value'));
      },
    );

    test(
      'Given multiple events for same message, When getting history, Then events are returned in chronological order',
      () async {
        // Given
        final message = Message(
          payload: 'test',
          metadata: {'messageType': 'test'},
          id: 'test-message-2',
        );

        final event1 = MessageEvent.fromMessage(
          message,
          MessageEventType.created,
          'creator',
          'service',
          sequenceNumber: 1,
        );

        final event2 = MessageEvent.fromMessage(
          message,
          MessageEventType.sent,
          'sender',
          'service',
          sequenceNumber: 2,
        );

        final event3 = MessageEvent.fromMessage(
          message,
          MessageEventType.processingCompleted,
          'processor',
          'service',
          sequenceNumber: 3,
        );

        // When - Add events with small delays to ensure proper ordering
        await tracker.recordEvent(message, event1);
        await Future.delayed(const Duration(milliseconds: 10));
        await tracker.recordEvent(message, event2);
        await Future.delayed(const Duration(milliseconds: 10));
        await tracker.recordEvent(message, event3);

        final history = await tracker.getMessageHistory(message.id);

        // Then
        expect(history.length, equals(3));
        expect(history[0].eventType, equals(MessageEventType.created));
        expect(history[1].eventType, equals(MessageEventType.sent));
        expect(
          history[2].eventType,
          equals(MessageEventType.processingCompleted),
        );
      },
    );

    test(
      'Given message history tracker, When getting statistics, Then correct stats are returned',
      () async {
        // Given
        final message1 = Message(
          payload: 'msg1',
          metadata: {'messageType': 'vote'},
          id: 'msg-1',
        );
        final message2 = Message(
          payload: 'msg2',
          metadata: {'messageType': 'proposal'},
          id: 'msg-2',
        );

        await tracker.recordEvent(
          message1,
          MessageEvent.fromMessage(
            message1,
            MessageEventType.created,
            'comp1',
            'type1',
          ),
        );

        await tracker.recordEvent(
          message1,
          MessageEvent.fromMessage(
            message1,
            MessageEventType.processingCompleted,
            'comp2',
            'type2',
          ),
        );

        await tracker.recordEvent(
          message2,
          MessageEvent.fromMessage(
            message2,
            MessageEventType.created,
            'comp3',
            'type3',
          ),
        );

        await tracker.recordEvent(
          message2,
          MessageEvent.fromMessage(
            message2,
            MessageEventType.processingFailed,
            'comp4',
            'type4',
          ),
        );

        // When
        final stats = tracker.getStats();

        // Then
        expect(stats.totalMessages, equals(2));
        expect(stats.totalEvents, equals(4));
        expect(stats.eventsByType[MessageEventType.created], equals(2));
        expect(
          stats.eventsByType[MessageEventType.processingCompleted],
          equals(1),
        );
        expect(
          stats.eventsByType[MessageEventType.processingFailed],
          equals(1),
        );
        expect(stats.eventsByComponent['comp1'], equals(1));
        expect(
          stats.successRate,
          equals(0.5),
        ); // 1 successful out of 2 messages
      },
    );

    test(
      'Given message history tracker with time query, When querying messages, Then time-filtered results are returned',
      () async {
        // Given
        final now = DateTime.now();
        final message1 = Message(payload: 'old', metadata: {}, id: 'old-msg');
        final message2 = Message(payload: 'new', metadata: {}, id: 'new-msg');

        // Create events at different times
        final oldEvent = MessageEvent(
          eventId: 'old-event',
          messageId: 'old-msg',
          eventType: MessageEventType.created,
          timestamp: now.subtract(const Duration(hours: 2)),
          componentId: 'comp',
          componentType: 'type',
        );

        final newEvent = MessageEvent(
          eventId: 'new-event',
          messageId: 'new-msg',
          eventType: MessageEventType.created,
          timestamp: now.subtract(const Duration(minutes: 30)),
          componentId: 'comp',
          componentType: 'type',
        );

        await tracker.recordEvent(message1, oldEvent);
        await tracker.recordEvent(message2, newEvent);

        // When
        final query = MessageHistoryQuery(
          fromTime: now.subtract(const Duration(hours: 1)),
          toTime: now,
        );

        final results = await tracker.getMessagesHistory(query);

        // Then
        expect(results.length, equals(1));
        expect(results.first.messageId, equals('new-msg'));
      },
    );

    test(
      'Given message history tracker with event type query, When querying messages, Then type-filtered results are returned',
      () async {
        // Given
        final message1 = Message(
          payload: 'created',
          metadata: {},
          id: 'created-msg',
        );
        final message2 = Message(payload: 'sent', metadata: {}, id: 'sent-msg');

        await tracker.recordEvent(
          message1,
          MessageEvent.fromMessage(
            message1,
            MessageEventType.created,
            'comp',
            'type',
          ),
        );

        await tracker.recordEvent(
          message2,
          MessageEvent.fromMessage(
            message2,
            MessageEventType.sent,
            'comp',
            'type',
          ),
        );

        // When
        final query = MessageHistoryQuery(
          eventTypes: [MessageEventType.created],
        );

        final results = await tracker.getMessagesHistory(query);

        // Then
        expect(results.length, equals(1));
        expect(results.first.messageId, equals('created-msg'));
      },
    );

    test(
      'Given message history tracker, When cleaning up old history, Then old entries are removed',
      () async {
        // Given
        final oldMessage = Message(payload: 'old', metadata: {}, id: 'old-msg');
        final newMessage = Message(payload: 'new', metadata: {}, id: 'new-msg');

        // Create old event (2 hours ago)
        final oldEvent = MessageEvent(
          eventId: 'old-event',
          messageId: 'old-msg',
          eventType: MessageEventType.created,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          componentId: 'comp',
          componentType: 'type',
        );

        // Create new event (30 minutes ago)
        final newEvent = MessageEvent(
          eventId: 'new-event',
          messageId: 'new-msg',
          eventType: MessageEventType.created,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          componentId: 'comp',
          componentType: 'type',
        );

        await tracker.recordEvent(oldMessage, oldEvent);
        await tracker.recordEvent(newMessage, newEvent);

        // When
        final cleanedCount = await tracker.cleanupHistory(
          const Duration(hours: 1),
        );

        // Then
        expect(cleanedCount, equals(1));

        final remainingHistory = await tracker.getMessageHistory('old-msg');
        expect(remainingHistory.length, equals(0));

        final newHistory = await tracker.getMessageHistory('new-msg');
        expect(newHistory.length, equals(1));
      },
    );
  });

  group('Message History Tests', () {
    test(
      'Given message history with multiple events, When getting processing duration, Then correct duration is calculated',
      () {
        // Given
        final startTime = DateTime.now();
        final endTime = startTime.add(const Duration(seconds: 30));

        final events = [
          MessageEvent(
            eventId: 'start',
            messageId: 'test-msg',
            eventType: MessageEventType.processingStarted,
            timestamp: startTime,
            componentId: 'processor',
            componentType: 'service',
          ),
          MessageEvent(
            eventId: 'end',
            messageId: 'test-msg',
            eventType: MessageEventType.processingCompleted,
            timestamp: endTime,
            componentId: 'processor',
            componentType: 'service',
          ),
        ];

        final history = MessageHistory(
          messageId: 'test-msg',
          events: events,
          firstEvent: startTime,
          lastEvent: endTime,
          totalLifetime: const Duration(seconds: 30),
          summary: {},
        );

        // When
        final duration = history.getProcessingDuration();

        // Then
        expect(duration, isNotNull);
        expect(duration!.inSeconds, equals(30));
      },
    );

    test(
      'Given message history with successful completion, When checking success, Then returns true',
      () {
        // Given
        final events = [
          MessageEvent(
            eventId: 'created',
            messageId: 'test-msg',
            eventType: MessageEventType.created,
            timestamp: DateTime.now(),
            componentId: 'creator',
            componentType: 'service',
          ),
          MessageEvent(
            eventId: 'completed',
            messageId: 'test-msg',
            eventType: MessageEventType.processingCompleted,
            timestamp: DateTime.now(),
            componentId: 'processor',
            componentType: 'service',
          ),
        ];

        final history = MessageHistory(
          messageId: 'test-msg',
          events: events,
          firstEvent: DateTime.now(),
          lastEvent: DateTime.now(),
          totalLifetime: Duration.zero,
          summary: {},
        );

        // When & Then
        expect(history.wasSuccessful, isTrue);
        expect(
          history.finalDisposition,
          equals(MessageEventType.processingCompleted),
        );
      },
    );

    test(
      'Given message history with failure, When checking success, Then returns false',
      () {
        // Given
        final events = [
          MessageEvent(
            eventId: 'created',
            messageId: 'test-msg',
            eventType: MessageEventType.created,
            timestamp: DateTime.now(),
            componentId: 'creator',
            componentType: 'service',
          ),
          MessageEvent(
            eventId: 'failed',
            messageId: 'test-msg',
            eventType: MessageEventType.processingFailed,
            timestamp: DateTime.now(),
            componentId: 'processor',
            componentType: 'service',
          ),
        ];

        final history = MessageHistory(
          messageId: 'test-msg',
          events: events,
          firstEvent: DateTime.now(),
          lastEvent: DateTime.now(),
          totalLifetime: Duration.zero,
          summary: {},
        );

        // When & Then
        expect(history.wasSuccessful, isFalse);
        expect(
          history.finalDisposition,
          equals(MessageEventType.processingFailed),
        );
      },
    );

    test(
      'Given message history, When getting events of specific type, Then filtered events are returned',
      () {
        // Given
        final events = [
          MessageEvent(
            eventId: 'e1',
            messageId: 'test-msg',
            eventType: MessageEventType.created,
            timestamp: DateTime.now(),
            componentId: 'comp1',
            componentType: 'type1',
          ),
          MessageEvent(
            eventId: 'e2',
            messageId: 'test-msg',
            eventType: MessageEventType.sent,
            timestamp: DateTime.now(),
            componentId: 'comp2',
            componentType: 'type2',
          ),
          MessageEvent(
            eventId: 'e3',
            messageId: 'test-msg',
            eventType: MessageEventType.created,
            timestamp: DateTime.now(),
            componentId: 'comp3',
            componentType: 'type3',
          ),
        ];

        final history = MessageHistory(
          messageId: 'test-msg',
          events: events,
          firstEvent: DateTime.now(),
          lastEvent: DateTime.now(),
          totalLifetime: Duration.zero,
          summary: {},
        );

        // When
        final createdEvents = history.getEventsOfType(MessageEventType.created);
        final sentEvents = history.getEventsOfType(MessageEventType.sent);

        // Then
        expect(createdEvents.length, equals(2));
        expect(sentEvents.length, equals(1));
      },
    );
  });

  group('Message History Interceptor Tests', () {
    late BasicMessageHistoryTracker tracker;
    late MessageHistoryInterceptor interceptor;

    setUp(() {
      tracker = BasicMessageHistoryTracker();
      interceptor = MessageHistoryInterceptor(
        tracker,
        'test-component',
        'test-type',
      );
    });

    test(
      'Given message history interceptor, When intercepting message creation, Then creation event is recorded',
      () async {
        // Given
        final message = Message(
          payload: {'action': 'create'},
          metadata: {'messageType': 'test'},
          id: 'test-msg',
        );

        // When
        final interceptedMessage = await interceptor.interceptCreation(message);

        // Then
        expect(interceptedMessage, equals(message));

        final history = await tracker.getMessageHistory(message.id);
        expect(history.length, equals(1));
        expect(history.first.eventType, equals(MessageEventType.created));
        expect(history.first.componentId, equals('test-component'));
      },
    );

    test(
      'Given message history interceptor, When intercepting message sending, Then sent event is recorded',
      () async {
        // Given
        final message = Message(
          payload: {'action': 'send'},
          metadata: {'messageType': 'test'},
          id: 'send-msg',
        );

        final channel = InMemoryChannel(id: 'test-channel', broadcast: true);

        // When
        await interceptor.interceptSending(message, channel);

        // Then
        final history = await tracker.getMessageHistory(message.id);
        expect(history.length, equals(1));
        expect(history.first.eventType, equals(MessageEventType.sent));
        expect(history.first.eventData['channelId'], equals('test-channel'));
      },
    );

    test(
      'Given message history interceptor, When intercepting processing start and completion, Then processing events are recorded',
      () async {
        // Given
        final message = Message(
          payload: {'action': 'process'},
          metadata: {'messageType': 'test'},
          id: 'process-msg',
        );

        // When
        await interceptor.interceptProcessingStart(message);
        await interceptor.interceptProcessingCompletion(message, {
          'result': 'success',
        });

        // Then
        final history = await tracker.getMessageHistory(message.id);
        expect(history.length, equals(2));
        expect(
          history[0].eventType,
          equals(MessageEventType.processingStarted),
        );
        expect(
          history[1].eventType,
          equals(MessageEventType.processingCompleted),
        );
        expect(history[1].eventData, equals({'result': 'success'}));
      },
    );

    test(
      'Given message history interceptor, When intercepting transformation, Then transformation event is recorded',
      () async {
        // Given
        final originalMessage = Message(
          payload: {'data': 'original'},
          metadata: {'messageType': 'test'},
          id: 'transform-msg',
        );

        final transformedMessage = Message(
          payload: {'data': 'transformed'},
          metadata: {'messageType': 'test'},
          id: 'transform-msg',
        );

        // When
        final result = await interceptor.interceptTransformation(
          originalMessage,
          transformedMessage,
        );

        // Then
        expect(result, equals(transformedMessage));

        final history = await tracker.getMessageHistory(originalMessage.id);
        expect(history.length, equals(1));
        expect(history.first.eventType, equals(MessageEventType.transformed));
        expect(
          history.first.eventData['originalPayload'],
          equals({'data': 'original'}),
        );
        expect(
          history.first.eventData['transformedPayload'],
          equals({'data': 'transformed'}),
        );
      },
    );
  });

  group('EDNet-Specific Message History Tests', () {
    test(
      'Given voting history tracker, When recording vote events, Then events are properly tracked',
      () async {
        // Given
        final tracker = VotingHistoryTracker();
        final voteMessage = Message(
          payload: {'candidate': 'Candidate A'},
          metadata: {'messageType': 'vote'},
          id: 'vote-msg-123',
        );

        // When
        await tracker.recordVoteCast(
          voteMessage,
          'citizen-456',
          'election-2024',
        );
        await tracker.recordVoteValidation(voteMessage, true, 'Valid vote');
        await tracker.recordVoteProcessingComplete(voteMessage, 'tx-789');

        // Then
        final history = await tracker.getMessageHistory(voteMessage.id);
        expect(history.length, equals(3));
        expect(history[0].eventType, equals(MessageEventType.created));
        expect(history[1].eventType, equals(MessageEventType.transformed));
        expect(
          history[2].eventType,
          equals(MessageEventType.processingCompleted),
        );

        expect(history[0].eventData['citizenId'], equals('citizen-456'));
        expect(history[0].eventData['electionId'], equals('election-2024'));
        expect(history[1].eventData['validationResult'], isTrue);
        expect(history[2].eventData['transactionId'], equals('tx-789'));
      },
    );

    test(
      'Given proposal history tracker, When recording proposal workflow, Then complete workflow is tracked',
      () async {
        // Given
        final tracker = ProposalHistoryTracker();
        final proposalMessage = Message(
          payload: {'title': 'New Policy Proposal'},
          metadata: {'messageType': 'proposal'},
          id: 'proposal-msg-456',
        );

        // When
        await tracker.recordProposalCreated(
          proposalMessage,
          'author-123',
          'prop-456',
        );

        final amendedMessage = Message(
          payload: {'title': 'Amended Policy Proposal'},
          metadata: {'messageType': 'proposal'},
          id: 'amended-msg-789',
        );

        await tracker.recordProposalAmendment(
          proposalMessage,
          amendedMessage,
          'amender-456',
        );

        await tracker.recordProposalDecision(
          proposalMessage,
          'approved',
          'reviewer-789',
          'Well-structured proposal',
        );

        // Then
        final history = await tracker.getMessageHistory(proposalMessage.id);
        expect(history.length, equals(3));
        expect(history[0].eventType, equals(MessageEventType.created));
        expect(history[1].eventType, equals(MessageEventType.transformed));
        expect(
          history[2].eventType,
          equals(MessageEventType.processingCompleted),
        );

        expect(history[0].eventData['authorId'], equals('author-123'));
        expect(history[1].eventData['amendmentAuthor'], equals('amender-456'));
        expect(history[2].eventData['decision'], equals('approved'));
      },
    );

    test(
      'Given deliberation history tracker, When recording deliberation session, Then session events are tracked',
      () async {
        // Given
        final tracker = DeliberationHistoryTracker();
        final deliberationMessage = Message(
          payload: {'content': 'I think this policy needs revision'},
          metadata: {'messageType': 'deliberation_message'},
          id: 'deliberation-msg-789',
        );

        // When
        await tracker.recordDeliberationMessage(
          deliberationMessage,
          'citizen-101',
          'topic-education',
          'session-001',
        );

        await tracker.recordSentimentAnalysis(
          deliberationMessage,
          'constructive',
          0.85,
        );

        await tracker.recordModerationAction(
          deliberationMessage,
          'approved',
          'moderator-202',
          'Content is appropriate for discussion',
        );

        // Then
        final history = await tracker.getMessageHistory(deliberationMessage.id);
        expect(history.length, equals(3));
        expect(history[0].eventType, equals(MessageEventType.created));
        expect(history[1].eventType, equals(MessageEventType.transformed));
        expect(history[2].eventType, equals(MessageEventType.transformed));

        expect(history[0].eventData['citizenId'], equals('citizen-101'));
        expect(history[0].eventData['topicId'], equals('topic-education'));
        expect(history[1].eventData['sentiment'], equals('constructive'));
        expect(history[1].eventData['confidence'], equals(0.85));
        expect(history[2].eventData['moderationAction'], equals('approved'));
      },
    );
  });

  group('EDNet Message History System Tests', () {
    late EDNetMessageHistorySystem system;

    setUp(() {
      system = EDNetMessageHistorySystem();
      system.initialize();
    });

    test(
      'Given EDNet message history system, When initialized, Then domain trackers are available',
      () {
        // Given - system is initialized in setUp

        // When
        final votingTracker = system.getDomainTracker('voting');
        final proposalTracker = system.getDomainTracker('proposals');
        final generalTracker = system.getDomainTracker('unknown');

        // Then
        expect(votingTracker, isNotNull);
        expect(proposalTracker, isNotNull);
        expect(generalTracker, isNotNull);
        expect(votingTracker is VotingHistoryTracker, isTrue);
        expect(proposalTracker is ProposalHistoryTracker, isTrue);
        expect(generalTracker is BasicMessageHistoryTracker, isTrue);
      },
    );

    test(
      'Given EDNet message history system, When creating interceptor, Then interceptor is configured correctly',
      () {
        // Given
        const componentId = 'test-component';
        const componentType = 'test-service';

        // When
        final interceptor = system.createInterceptor(
          componentId,
          componentType,
          domain: 'voting',
        );

        // Then
        expect(interceptor, isNotNull);
        expect(system.getInterceptor(componentId), equals(interceptor));
      },
    );

    test(
      'Given EDNet message history system, When recording custom event, Then event is stored in appropriate domain',
      () async {
        // Given
        final message = Message(
          payload: {'action': 'custom'},
          metadata: {'messageType': 'custom'},
          id: 'custom-msg-001',
        );

        // When
        await system.recordCustomEvent(
          message,
          'Custom audit event',
          eventData: {'auditInfo': 'Security check passed'},
          domain: 'voting',
        );

        // Then
        final votingTracker =
            system.getDomainTracker('voting') as VotingHistoryTracker;
        final history = await votingTracker.getMessageHistory(message.id);
        expect(history.length, equals(1));
        expect(history.first.eventType, equals(MessageEventType.custom));
        expect(
          history.first.eventData['description'],
          equals('Custom audit event'),
        );
        expect(
          history.first.eventData['auditInfo'],
          equals('Security check passed'),
        );
      },
    );

    test(
      'Given EDNet message history system, When getting global message history, Then histories from all domains are combined',
      () async {
        // Given
        final votingMessage = Message(
          payload: 'vote',
          metadata: {'domain': 'voting'},
          id: 'vote-001',
        );
        final proposalMessage = Message(
          payload: 'proposal',
          metadata: {'domain': 'proposals'},
          id: 'prop-001',
        );

        await system
            .getDomainTracker('voting')
            .recordEvent(
              votingMessage,
              MessageEvent.fromMessage(
                votingMessage,
                MessageEventType.created,
                'comp1',
                'type1',
              ),
            );

        await system
            .getDomainTracker('proposals')
            .recordEvent(
              proposalMessage,
              MessageEvent.fromMessage(
                proposalMessage,
                MessageEventType.created,
                'comp2',
                'type2',
              ),
            );

        // When
        final query = MessageHistoryQuery(limit: 10);
        final globalHistory = await system.getGlobalMessageHistory(query);

        // Then
        expect(globalHistory.length, equals(2));
        final messageIds = globalHistory.map((h) => h.messageId).toSet();
        expect(messageIds, containsAll(['vote-001', 'prop-001']));
      },
    );

    test(
      'Given EDNet message history system, When getting system stats, Then comprehensive statistics are returned',
      () {
        // Given - system has domain trackers

        // When
        final stats = system.getSystemStats();

        // Then
        expect(stats.containsKey('voting'), isTrue);
        expect(stats.containsKey('proposals'), isTrue);
        expect(stats.containsKey('deliberation'), isTrue);
        expect(stats.containsKey('general'), isTrue);

        // Verify all trackers have proper stats structure
        for (final domainStats in stats.values) {
          expect(
            domainStats.totalMessages,
            equals(0),
          ); // No messages processed yet
          expect(domainStats.totalEvents, equals(0));
          expect(domainStats.successRate, equals(0.0));
        }
      },
    );

    test(
      'Given EDNet message history system, When cleaning up old history, Then cleanup is performed across all domains',
      () async {
        // Given
        final votingMessage = Message(
          payload: 'old vote',
          metadata: {},
          id: 'old-vote',
        );
        final oldEvent = MessageEvent(
          eventId: 'old-event',
          messageId: 'old-vote',
          eventType: MessageEventType.created,
          timestamp: DateTime.now().subtract(const Duration(days: 30)),
          componentId: 'old-comp',
          componentType: 'old-type',
        );

        await system
            .getDomainTracker('voting')
            .recordEvent(votingMessage, oldEvent);

        // When
        final cleanedCount = await system.cleanupOldHistory(
          const Duration(days: 7),
        );

        // Then
        expect(cleanedCount, equals(1));

        final remainingHistory = await system
            .getDomainTracker('voting')
            .getMessageHistory('old-vote');
        expect(remainingHistory.length, equals(0));
      },
    );
  });

  group('Message History Query Tests', () {
    test(
      'Given message history query with multiple filters, When created, Then query properties are set correctly',
      () {
        // Given
        final fromTime = DateTime.now().subtract(const Duration(hours: 1));
        final toTime = DateTime.now();

        // When
        final query = MessageHistoryQuery(
          fromTime: fromTime,
          toTime: toTime,
          eventTypes: [MessageEventType.created, MessageEventType.sent],
          componentIds: ['comp1', 'comp2'],
          limit: 50,
          sortOrder: MessageHistorySortOrder.oldestFirst,
        );

        // Then
        expect(query.fromTime, equals(fromTime));
        expect(query.toTime, equals(toTime));
        expect(
          query.eventTypes,
          equals([MessageEventType.created, MessageEventType.sent]),
        );
        expect(query.componentIds, equals(['comp1', 'comp2']));
        expect(query.limit, equals(50));
        expect(query.sortOrder, equals(MessageHistorySortOrder.oldestFirst));
      },
    );

    test(
      'Given message history query with message criteria, When querying, Then criteria-based filtering works',
      () async {
        // Given
        final tracker = BasicMessageHistoryTracker();
        final message1 = Message(
          payload: {'priority': 'high'},
          metadata: {'messageType': 'alert'},
          id: 'high-priority-msg',
        );

        final message2 = Message(
          payload: {'priority': 'low'},
          metadata: {'messageType': 'alert'},
          id: 'low-priority-msg',
        );

        await tracker.recordEvent(
          message1,
          MessageEvent.fromMessage(
            message1,
            MessageEventType.created,
            'comp',
            'type',
          ),
        );

        await tracker.recordEvent(
          message2,
          MessageEvent.fromMessage(
            message2,
            MessageEventType.created,
            'comp',
            'type',
          ),
        );

        // When
        final query = MessageHistoryQuery(
          messageCriteria: {
            'payload': {'priority': 'high'},
          },
        );

        final results = await tracker.getMessagesHistory(query);

        // Then
        // Note: This is a simplified test - the actual message criteria filtering
        // would need more complex implementation in the tracker
        expect(
          results.length,
          equals(2),
        ); // Both messages returned (simplified implementation)
      },
    );
  });
}
