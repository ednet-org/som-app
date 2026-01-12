import 'dart:async';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Correlation Identifier Pattern Tests', () {
    late BasicCorrelationManager correlationManager;

    setUp(() {
      correlationManager = BasicCorrelationManager();
    });

    test(
      'Given a correlation manager, When generating correlation ID, Then it should return a unique ID',
      () {
        // When
        final id1 = correlationManager.generateCorrelationId();
        final id2 = correlationManager.generateCorrelationId();

        // Then
        expect(id1, isNotEmpty);
        expect(id2, isNotEmpty);
        expect(id1, isNot(equals(id2)));
        expect(id1.startsWith('corr-'), isTrue);
      },
    );

    test(
      'Given a message, When correlating with ID, Then message should contain correlation metadata',
      () {
        // Given
        final message = Message(
          payload: 'test payload',
          metadata: {'type': 'test'},
        );
        const correlationId = 'test-correlation-123';

        // When
        final correlatedMessage = correlationManager.correlateMessage(
          message,
          correlationId,
        );

        // Then
        expect(correlatedMessage.payload, equals('test payload'));
        expect(
          correlatedMessage.metadata['correlationId'],
          equals(correlationId),
        );
        expect(correlatedMessage.metadata['correlatedAt'], isNotNull);
      },
    );

    test(
      'Given a correlated message, When extracting correlation ID, Then it should return the correct ID',
      () {
        // Given
        final message = Message(
          payload: 'test',
          metadata: {'correlationId': 'test-123'},
        );

        // When
        final extractedId = correlationManager.getCorrelationId(message);

        // Then
        expect(extractedId, equals('test-123'));
      },
    );

    test(
      'Given an uncorrelated message, When extracting correlation ID, Then it should return null',
      () {
        // Given
        final message = Message(payload: 'test', metadata: {'type': 'test'});

        // When
        final extractedId = correlationManager.getCorrelationId(message);

        // Then
        expect(extractedId, isNull);
      },
    );

    test(
      'Given correlated messages, When finding by correlation ID, Then it should return all related messages',
      () async {
        // Given
        const correlationId = 'test-correlation-456';
        final message1 = Message(payload: 'message 1', metadata: {'seq': 1});
        final message2 = Message(payload: 'message 2', metadata: {'seq': 2});

        correlationManager.correlateMessage(message1, correlationId);
        correlationManager.correlateMessage(message2, correlationId);

        // When
        final correlatedMessages = await correlationManager
            .findCorrelatedMessages(correlationId);

        // Then
        expect(correlatedMessages.length, equals(2));
        expect(
          correlatedMessages.map((m) => m.payload),
          containsAll(['message 1', 'message 2']),
        );
      },
    );

    test(
      'Given an original message, When creating correlated response, Then response should have same correlation ID',
      () {
        // Given
        final originalMessage = Message(
          payload: 'request payload',
          metadata: {'correlationId': 'request-123', 'requestType': 'vote'},
        );
        final responsePayload = {'result': 'success', 'voteCount': 150};

        // When
        final responseMessage = correlationManager.createCorrelatedResponse(
          originalMessage,
          responsePayload,
        );

        // Then
        expect(responseMessage.payload, equals(responsePayload));
        expect(
          responseMessage.metadata['correlationId'],
          equals('request-123'),
        );
        expect(responseMessage.metadata['isResponse'], isTrue);
        expect(
          responseMessage.metadata['originalMessageId'],
          equals(originalMessage.id),
        );
      },
    );

    test(
      'Given two messages with same correlation ID, When checking if correlated, Then it should return true',
      () {
        // Given
        final message1 = Message(
          payload: 'msg1',
          metadata: {'correlationId': 'shared-123'},
        );
        final message2 = Message(
          payload: 'msg2',
          metadata: {'correlationId': 'shared-123'},
        );

        // When
        final areCorrelated = correlationManager.areCorrelated(
          message1,
          message2,
        );

        // Then
        expect(areCorrelated, isTrue);
      },
    );

    test(
      'Given two messages with different correlation IDs, When checking if correlated, Then it should return false',
      () {
        // Given
        final message1 = Message(
          payload: 'msg1',
          metadata: {'correlationId': 'id-123'},
        );
        final message2 = Message(
          payload: 'msg2',
          metadata: {'correlationId': 'id-456'},
        );

        // When
        final areCorrelated = correlationManager.areCorrelated(
          message1,
          message2,
        );

        // Then
        expect(areCorrelated, isFalse);
      },
    );

    test(
      'Given correlation manager with messages, When getting statistics, Then it should return correct stats',
      () {
        // Given
        final message1 = Message(payload: 'msg1', metadata: {'type': 'vote'});
        final message2 = Message(payload: 'msg2', metadata: {'type': 'vote'});

        correlationManager.correlateMessage(message1, 'corr-1');
        correlationManager.correlateMessage(message2, 'corr-2');

        // When
        final stats = correlationManager.getStats();

        // Then
        expect(stats.totalCorrelations, equals(2));
        expect(stats.activeCorrelations, equals(2));
        expect(stats.correlationsByType['basic'], equals(2));
      },
    );
  });

  group('Correlation Context Tests', () {
    test(
      'Given a correlation context, When adding related message, Then context should include the message ID',
      () {
        // Given
        final context = CorrelationContext(
          correlationId: 'test-context',
          contextType: 'test',
        );

        // When
        final updatedContext = context.addRelatedMessage('msg-123');

        // Then
        expect(updatedContext.relatedMessageIds, contains('msg-123'));
        expect(updatedContext.correlationId, equals('test-context'));
      },
    );

    test(
      'Given a correlation context, When copying with updates, Then it should preserve original values',
      () {
        // Given
        final originalContext = CorrelationContext(
          correlationId: 'original-id',
          contextType: 'original-type',
          properties: {'key1': 'value1'},
        );

        // When
        final updatedContext = originalContext.copyWith(
          properties: {'key1': 'value1', 'key2': 'value2'},
        );

        // Then
        expect(updatedContext.correlationId, equals('original-id'));
        expect(updatedContext.contextType, equals('original-type'));
        expect(updatedContext.properties['key1'], equals('value1'));
        expect(updatedContext.properties['key2'], equals('value2'));
      },
    );

    test(
      'Given a correlation context, When checking if expired with short TTL, Then it should return false',
      () {
        // Given
        final context = CorrelationContext(
          correlationId: 'test-id',
          contextType: 'test',
          createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        );

        // When
        final isExpired = context.isExpired(const Duration(hours: 1));

        // Then
        expect(isExpired, isFalse);
      },
    );

    test(
      'Given a correlation context, When checking if expired with very short TTL, Then it should return true',
      () {
        // Given
        final context = CorrelationContext(
          correlationId: 'test-id',
          contextType: 'test',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        );

        // When
        final isExpired = context.isExpired(const Duration(minutes: 30));

        // Then
        expect(isExpired, isTrue);
      },
    );
  });

  group('Correlation ID Generator Tests', () {
    test(
      'Given timestamp generator, When generating ID, Then it should contain timestamp and prefix',
      () {
        // Given
        final generator = TimestampCorrelationIdGenerator(prefix: 'test');

        // When
        final id = generator.generate();

        // Then
        expect(id.startsWith('test-'), isTrue);
        expect(id, contains('-'));
      },
    );

    test(
      'Given business context generator, When generating ID, Then it should contain business domain info',
      () {
        // Given
        final generator = BusinessContextCorrelationIdGenerator(
          businessDomain: 'voting',
          entityType: 'election',
        );

        // When
        final id = generator.generate();

        // Then
        expect(id.startsWith('voting-election-'), isTrue);
      },
    );

    test(
      'Given UUID generator, When generating ID, Then it should be unique',
      () {
        // Given
        final generator = UuidCorrelationIdGenerator();

        // When
        final id1 = generator.generate();
        final id2 = generator.generate();

        // Then
        expect(id1, isNot(equals(id2)));
        expect(id1.startsWith('uuid-'), isTrue);
      },
    );
  });

  group('Message Correlation Enricher Tests', () {
    late BasicCorrelationManager correlationManager;
    late MessageCorrelationEnricher enricher;

    setUp(() {
      correlationManager = BasicCorrelationManager();
      enricher = MessageCorrelationEnricher(
        correlationManager: correlationManager,
        idGenerator: TimestampCorrelationIdGenerator(),
      );
    });

    test(
      'Given a message enricher, When enriching message, Then it should add correlation ID',
      () {
        // Given
        final message = Message(
          payload: 'test payload',
          metadata: {'type': 'test'},
        );

        // When
        final enrichedMessage = enricher.enrichMessage(message);

        // Then
        expect(enricher.isCorrelated(enrichedMessage), isTrue);
        final correlationId = correlationManager.getCorrelationId(
          enrichedMessage,
        );
        expect(correlationId, isNotNull);
      },
    );

    test(
      'Given an enriched message, When creating response, Then response should be correlated',
      () {
        // Given
        final originalMessage = enricher.enrichMessage(
          Message(payload: 'request', metadata: {'type': 'query'}),
        );
        const responsePayload = 'response data';

        // When
        final responseMessage = enricher.enrichResponse(
          originalMessage,
          responsePayload,
        );

        // Then
        final originalCorrelationId = correlationManager.getCorrelationId(
          originalMessage,
        );
        final responseCorrelationId = correlationManager.getCorrelationId(
          responseMessage,
        );
        expect(originalCorrelationId, equals(responseCorrelationId));
        expect(responseMessage.payload, equals(responsePayload));
      },
    );

    test(
      'Given a non-correlated message, When checking if correlated, Then it should return false',
      () {
        // Given
        final message = Message(payload: 'test', metadata: {'type': 'test'});

        // When
        final isCorrelated = enricher.isCorrelated(message);

        // Then
        expect(isCorrelated, isFalse);
      },
    );
  });

  group('Correlation Message Filter Tests', () {
    late BasicCorrelationManager correlationManager;
    late CorrelationMessageFilter filter;

    setUp(() {
      correlationManager = BasicCorrelationManager();
      filter = CorrelationMessageFilter(correlationManager: correlationManager);
    });

    test(
      'Given filter with no restrictions, When processing correlated message, Then it should allow processing',
      () {
        // Given
        final message = correlationManager.correlateMessage(
          Message(payload: 'test', metadata: {'type': 'test'}),
          'test-id',
        );

        // When
        final shouldProcess = filter.shouldProcess(message);

        // Then
        expect(shouldProcess, isTrue);
      },
    );

    test(
      'Given filter with no restrictions, When processing uncorrelated message, Then it should not allow processing',
      () {
        // Given
        final message = Message(payload: 'test', metadata: {'type': 'test'});

        // When
        final shouldProcess = filter.shouldProcess(message);

        // Then
        expect(shouldProcess, isFalse);
      },
    );

    test(
      'Given filter with allowed correlation IDs, When processing allowed message, Then it should allow processing',
      () {
        // Given
        const allowedId = 'allowed-id';
        filter.allowCorrelation(allowedId);

        final message = correlationManager.correlateMessage(
          Message(payload: 'test', metadata: {'type': 'test'}),
          allowedId,
        );

        // When
        final shouldProcess = filter.shouldProcess(message);

        // Then
        expect(shouldProcess, isTrue);
      },
    );

    test(
      'Given filter with allowed correlation IDs, When processing disallowed message, Then it should not allow processing',
      () {
        // Given
        filter.allowCorrelation('allowed-id');

        final message = correlationManager.correlateMessage(
          Message(payload: 'test', metadata: {'type': 'test'}),
          'disallowed-id',
        );

        // When
        final shouldProcess = filter.shouldProcess(message);

        // Then
        expect(shouldProcess, isFalse);
      },
    );

    test(
      'Given filter with allowed correlation IDs, When all IDs are disallowed, Then correlated messages should be allowed',
      () {
        // Given
        const correlationId = 'test-id';
        filter.allowCorrelation(correlationId);

        final message = correlationManager.correlateMessage(
          Message(payload: 'test', metadata: {'type': 'test'}),
          correlationId,
        );

        // When - disallow the only allowed ID (making the set empty)
        filter.disallowCorrelation(correlationId);
        final shouldProcess = filter.shouldProcess(message);

        // Then - should allow because empty set means no restrictions
        expect(shouldProcess, isTrue);
      },
    );
  });

  group('Correlation Channel Processor Tests', () {
    late InMemoryChannel sourceChannel;
    late InMemoryChannel targetChannel;
    late BasicCorrelationManager correlationManager;
    late CorrelationChannelProcessor processor;

    setUp(() {
      sourceChannel = InMemoryChannel(id: 'source', broadcast: true);
      targetChannel = InMemoryChannel(id: 'target', broadcast: true);
      correlationManager = BasicCorrelationManager();
      processor = CorrelationChannelProcessor(
        sourceChannel: sourceChannel,
        targetChannel: targetChannel,
        correlationManager: correlationManager,
      );
    });

    tearDown(() async {
      await processor.stop();
    });

    test(
      'Given correlation processor, When processing correlated message, Then it should forward with enriched metadata',
      () async {
        // Given
        await processor.start();

        final correlatedMessage = correlationManager.correlateMessage(
          Message(payload: 'test payload', metadata: {'type': 'test'}),
          'test-correlation',
        );

        final completer = Completer<Message>();
        final subscription = targetChannel.receive().listen((message) {
          if (!completer.isCompleted) {
            completer.complete(message);
          }
        }, onError: (error) => completer.completeError(error));

        // When
        await sourceChannel.send(correlatedMessage);
        final receivedMessage = await completer.future.timeout(
          const Duration(seconds: 2),
        );

        // Then
        expect(receivedMessage.payload, equals('test payload'));
        expect(
          receivedMessage.metadata['correlationId'],
          equals('test-correlation'),
        );
        expect(
          receivedMessage.metadata['processedByCorrelationProcessor'],
          isTrue,
        );

        await subscription.cancel();
      },
    );
  });

  group('EDNet-Specific Correlation Tests', () {
    test(
      'Given voting session correlation manager, When starting voting session, Then it should create proper context',
      () {
        // Given
        final manager = VotingSessionCorrelationManager();

        // When
        final sessionId = manager.startVotingSession(
          'election-2024',
          'presidential',
        );

        // Then
        final context = manager.getContext(sessionId);
        expect(context, isNotNull);
        expect(context!.contextType, equals('voting-session'));
        expect(context.properties['electionId'], equals('election-2024'));
        expect(context.properties['sessionType'], equals('presidential'));
        expect(context.properties['status'], equals('active'));
      },
    );

    test(
      'Given voting session correlation manager, When correlating vote, Then session context should be updated',
      () {
        // Given
        final manager = VotingSessionCorrelationManager();
        final sessionId = manager.startVotingSession(
          'election-2024',
          'presidential',
        );

        final voteMessage = Message(
          payload: {'candidate': 'Candidate A', 'voterId': 'voter-123'},
          metadata: {'type': 'vote'},
        );

        // When
        manager.correlateVote(voteMessage, sessionId);

        // Then
        final context = manager.getContext(sessionId);
        expect(context!.properties['voteCount'], equals(1));
      },
    );

    test(
      'Given proposal correlation manager, When starting proposal workflow, Then it should create proper context',
      () {
        // Given
        final manager = ProposalCorrelationManager();

        // When
        final workflowId = manager.startProposalWorkflow(
          'proposal-123',
          'citizen-456',
        );

        // Then
        final context = manager.getContext(workflowId);
        expect(context, isNotNull);
        expect(context!.contextType, equals('proposal-workflow'));
        expect(context.properties['proposalId'], equals('proposal-123'));
        expect(context.properties['authorId'], equals('citizen-456'));
        expect(context.properties['status'], equals('draft'));
      },
    );

    test(
      'Given deliberation correlation manager, When starting deliberation thread, Then it should track participants',
      () {
        // Given
        final manager = DeliberationCorrelationManager();

        // When
        final threadId = manager.startDeliberationThread(
          'topic-789',
          'initiator-101',
        );

        // Then
        final context = manager.getContext(threadId);
        expect(context, isNotNull);
        expect(context!.contextType, equals('deliberation-thread'));
        expect(context.properties['topicId'], equals('topic-789'));
        expect(context.properties['initiatorId'], equals('initiator-101'));
        expect(context.properties['participantCount'], equals(1));
      },
    );

    test(
      'Given deliberation correlation manager, When correlating messages from different participants, Then participant count should increase',
      () {
        // Given
        final manager = DeliberationCorrelationManager();
        final threadId = manager.startDeliberationThread(
          'topic-789',
          'initiator-101',
        );

        final message1 = Message(
          payload: 'First message',
          metadata: {'citizenId': 'participant-1'},
        );

        final message2 = Message(
          payload: 'Second message',
          metadata: {'citizenId': 'participant-2'},
        );

        // When
        manager.correlateDeliberationMessage(message1, threadId);
        manager.correlateDeliberationMessage(message2, threadId);

        // Then
        final context = manager.getContext(threadId);
        expect(context!.properties['messageCount'], equals(2));
        expect(context.properties['participantCount'], equals(2));
      },
    );

    test(
      'Given audit trail correlation manager, When starting audit trail, Then it should track governance actions',
      () {
        // Given
        final manager = AuditTrailCorrelationManager();

        // When
        final trailId = manager.startAuditTrail(
          'proposal_creation',
          'citizen-123',
          'proposal-456',
        );

        // Then
        final context = manager.getContext(trailId);
        expect(context, isNotNull);
        expect(context!.contextType, equals('audit-trail'));
        expect(context.properties['actionType'], equals('proposal_creation'));
        expect(context.properties['actorId'], equals('citizen-123'));
        expect(context.properties['targetId'], equals('proposal-456'));
      },
    );

    test(
      'Given audit trail correlation manager, When correlating audit events, Then event count should increase',
      () {
        // Given
        final manager = AuditTrailCorrelationManager();
        final trailId = manager.startAuditTrail(
          'vote_cast',
          'voter-789',
          'election-2024',
        );

        final auditEvent1 = Message(
          payload: {'event': 'vote_submitted'},
          metadata: {'timestamp': DateTime.now().toIso8601String()},
        );

        final auditEvent2 = Message(
          payload: {'event': 'vote_confirmed'},
          metadata: {'timestamp': DateTime.now().toIso8601String()},
        );

        // When
        manager.correlateAuditEvent(auditEvent1, trailId);
        manager.correlateAuditEvent(auditEvent2, trailId);

        // Then
        final context = manager.getContext(trailId);
        expect(context!.properties['eventCount'], equals(2));
        expect(context.properties['lastEventAt'], isNotNull);
      },
    );
  });
}
