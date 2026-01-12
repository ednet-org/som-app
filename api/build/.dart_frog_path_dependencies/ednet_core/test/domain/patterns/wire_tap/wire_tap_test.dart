import 'dart:async';

import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('Wire Tap Pattern Tests', () {
    late InMemoryChannel tappedChannel;
    late InMemoryChannel tapChannel;
    late BasicWireTap wireTap;

    setUp(() {
      tappedChannel = InMemoryChannel(id: 'tapped-channel', broadcast: true);
      tapChannel = InMemoryChannel(id: 'tap-channel', broadcast: true);
      wireTap = BasicWireTap(tappedChannel, tapChannel);
    });

    tearDown(() async {
      await wireTap.stop();
      await tappedChannel.close();
      await tapChannel.close();
    });

    test(
      'Given a basic wire tap, When started, Then it should be active',
      () async {
        // Given
        expect(wireTap.isActive, isFalse);

        // When
        await wireTap.start();

        // Then
        expect(wireTap.isActive, isTrue);
      },
    );

    test(
      'Given a running wire tap, When stopped, Then it should be inactive',
      () async {
        // Given
        await wireTap.start();
        expect(wireTap.isActive, isTrue);

        // When
        await wireTap.stop();

        // Then
        expect(wireTap.isActive, isFalse);
      },
    );

    test(
      'Given a wire tap with a message sent to tapped channel, When wire tap is active, Then message should appear in tap channel',
      () async {
        // Given
        await wireTap.start();
        final testMessage = Message(
          payload: 'test payload',
          metadata: {'type': 'test'},
        );
        final completer = Completer<Message>();

        // Listen to tap channel
        final subscription = tapChannel.receive().listen((message) {
          if (!completer.isCompleted) {
            completer.complete(message);
          }
        }, onError: (error) => completer.completeError(error));

        // When
        await tappedChannel.send(testMessage);

        // Then
        final receivedMessage = await completer.future.timeout(
          const Duration(seconds: 5),
        );
        expect(receivedMessage.payload, equals('test payload'));

        await subscription.cancel();
      },
    );

    test(
      'Given a wire tap with selective tapping enabled, When message matches filter, Then it should be tapped',
      () async {
        // Given
        final filter = ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'priority',
              operator: WireTapOperator.equals,
              value: 'high',
            ),
          ],
        );

        final selectiveWireTap = BasicWireTap(
          tappedChannel,
          tapChannel,
          selectiveTapping: true,
          filter: filter,
        );

        await selectiveWireTap.start();

        final matchingMessage = Message(
          payload: 'important message',
          metadata: {'priority': 'high'},
        );

        final completer = Completer<Message>();
        final subscription = tapChannel.receive().listen((message) {
          if (!completer.isCompleted) {
            completer.complete(message);
          }
        }, onError: (error) => completer.completeError(error));

        // When
        await tappedChannel.send(matchingMessage);

        // Then
        final receivedMessage = await completer.future.timeout(
          const Duration(seconds: 5),
        );
        await subscription.cancel();

        expect(receivedMessage.payload, equals('important message'));
      },
    );

    test(
      'Given a wire tap with selective tapping enabled, When message does not match filter, Then it should not be tapped',
      () async {
        // Given
        final filter = ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'priority',
              operator: WireTapOperator.equals,
              value: 'high',
            ),
          ],
        );

        final selectiveWireTap = BasicWireTap(
          tappedChannel,
          tapChannel,
          selectiveTapping: true,
          filter: filter,
        );

        await selectiveWireTap.start();

        final nonMatchingMessage = Message(
          payload: 'low priority message',
          metadata: {'priority': 'low'},
        );

        bool messageReceived = false;
        final subscription = tapChannel.receive().listen((message) {
          messageReceived = true;
        });

        // When
        await tappedChannel.send(nonMatchingMessage);
        await Future.delayed(const Duration(milliseconds: 50));

        // Then
        expect(messageReceived, isFalse);

        await subscription.cancel();
      },
    );

    test(
      'Given a wire tap with transformer, When message is processed, Then it should be transformed',
      () async {
        // Given
        final transformer = MetadataWireTapTransformer(
          tapSource: 'test-tap',
          additionalMetadata: {'transformed': true},
        );

        final transformedWireTap = BasicWireTap(
          tappedChannel,
          tapChannel,
          transformer: transformer,
        );

        await transformedWireTap.start();

        final originalMessage = Message(
          payload: 'original payload',
          metadata: {'original': true},
        );

        final completer = Completer<Message>();
        final subscription = tapChannel.receive().listen((message) {
          if (!completer.isCompleted) {
            completer.complete(message);
          }
        }, onError: (error) => completer.completeError(error));

        // When
        await tappedChannel.send(originalMessage);

        // Then
        final transformedMessage = await completer.future.timeout(
          const Duration(seconds: 5),
        );
        await subscription.cancel();

        expect(transformedMessage.payload, equals('original payload'));
        expect(transformedMessage.metadata['original'], isTrue);
        expect(transformedMessage.metadata['tapped'], isTrue);
        expect(transformedMessage.metadata['tapSource'], equals('test-tap'));
        expect(transformedMessage.metadata['transformed'], isTrue);
      },
    );

    test(
      'Given a wire tap, When multiple messages are sent, Then statistics should be updated correctly',
      () async {
        // Given
        await wireTap.start();

        final messages = [
          Message(payload: 'message 1', metadata: {'messageType': 'vote'}),
          Message(payload: 'message 2', metadata: {'messageType': 'vote'}),
          Message(payload: 'message 3', metadata: {'messageType': 'proposal'}),
        ];

        // When
        for (final message in messages) {
          await tappedChannel.send(message);
        }
        await Future.delayed(const Duration(milliseconds: 20));

        // Then
        final stats = wireTap.getStats();
        expect(stats.totalMessages, equals(3));
        expect(stats.messageTypes['vote'], equals(2));
        expect(stats.messageTypes['proposal'], equals(1));
        expect(stats.uptime, greaterThan(Duration.zero));
      },
    );

    test(
      'Given a composite wire tap, When started, Then all taps should be active',
      () async {
        // Given
        final tapChannel2 = InMemoryChannel(
          id: 'tap-channel-3',
          broadcast: true,
        );
        final tap2 = BasicWireTap(tappedChannel, tapChannel2);

        final compositeTap = CompositeWireTap('test-composite', [
          wireTap,
          tap2,
        ]);

        // When
        await compositeTap.start();

        // Then
        expect(compositeTap.isActive, isTrue);
        expect(wireTap.isActive, isTrue);
        expect(tap2.isActive, isTrue);
      },
    );

    test(
      'Given a composite wire tap, When message is sent, Then it should appear in all tap channels',
      () async {
        // Given
        final tapChannel2 = InMemoryChannel(
          id: 'tap-channel-3',
          broadcast: true,
        );
        final tap2 = BasicWireTap(tappedChannel, tapChannel2);

        final compositeTap = CompositeWireTap('test-composite', [
          wireTap,
          tap2,
        ]);
        await compositeTap.start();

        final testMessage = Message(payload: 'test payload');

        final completer1 = Completer<Message>();
        final completer2 = Completer<Message>();

        final subscription1 = tapChannel.receive().listen((message) {
          if (!completer1.isCompleted) {
            completer1.complete(message);
          }
        });

        final subscription2 = tapChannel2.receive().listen((message) {
          if (!completer2.isCompleted) {
            completer2.complete(message);
          }
        });

        // When
        await tappedChannel.send(testMessage);

        // Then
        final receivedMessage1 = await completer1.future.timeout(
          const Duration(seconds: 5),
        );
        final receivedMessage2 = await completer2.future.timeout(
          const Duration(seconds: 5),
        );

        await subscription1.cancel();
        await subscription2.cancel();

        expect(receivedMessage1.payload, equals('test payload'));
        expect(receivedMessage2.payload, equals('test payload'));
      },
    );
  });

  group('Wire Tap Filter Tests', () {
    test(
      'Given content-based filter with equals condition, When message matches, Then should return true',
      () {
        // Given
        final filter = ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'priority',
              operator: WireTapOperator.equals,
              value: 'high',
            ),
          ],
        );

        final message = Message(
          payload: 'test',
          metadata: {'priority': 'high'},
        );

        // When
        final result = filter.shouldTap(message);

        // Then
        expect(result, isTrue);
      },
    );

    test(
      'Given content-based filter with equals condition, When message does not match, Then should return false',
      () {
        // Given
        final filter = ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'priority',
              operator: WireTapOperator.equals,
              value: 'high',
            ),
          ],
        );

        final message = Message(payload: 'test', metadata: {'priority': 'low'});

        // When
        final result = filter.shouldTap(message);

        // Then
        expect(result, isFalse);
      },
    );

    test(
      'Given content-based filter with contains condition, When message contains value, Then should return true',
      () {
        // Given
        final filter = ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'message',
              operator: WireTapOperator.contains,
              value: 'important',
            ),
          ],
        );

        final message = Message(
          payload: {'message': 'This is an important message'},
          metadata: {},
        );

        // When
        final result = filter.shouldTap(message);

        // Then
        expect(result, isTrue);
      },
    );

    test(
      'Given content-based filter with OR logic, When any condition matches, Then should return true',
      () {
        // Given
        final filter = ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'type',
              operator: WireTapOperator.equals,
              value: 'vote',
            ),
            WireTapCondition(
              field: 'type',
              operator: WireTapOperator.equals,
              value: 'proposal',
            ),
          ],
          matchAll: false, // OR logic
        );

        final message = Message(
          payload: 'test',
          metadata: {'type': 'proposal'},
        );

        // When
        final result = filter.shouldTap(message);

        // Then
        expect(result, isTrue);
      },
    );

    test(
      'Given content-based filter with AND logic, When not all conditions match, Then should return false',
      () {
        // Given
        final filter = ContentBasedWireTapFilter(
          conditions: [
            WireTapCondition(
              field: 'type',
              operator: WireTapOperator.equals,
              value: 'vote',
            ),
            WireTapCondition(
              field: 'priority',
              operator: WireTapOperator.equals,
              value: 'high',
            ),
          ],
          matchAll: true, // AND logic
        );

        final message = Message(
          payload: 'test',
          metadata: {
            'type': 'vote',
            'priority': 'low',
          }, // Only first condition matches
        );

        // When
        final result = filter.shouldTap(message);

        // Then
        expect(result, isFalse);
      },
    );
  });

  group('Wire Tap Transformer Tests', () {
    test(
      'Given metadata transformer, When message is transformed, Then metadata should be added',
      () async {
        // Given
        final transformer = MetadataWireTapTransformer(
          tapSource: 'test-transformer',
          additionalMetadata: {'custom': 'value'},
        );

        final originalMessage = Message(
          payload: 'original payload',
          metadata: {'original': true},
        );

        // When
        final transformedMessage = await transformer.transform(originalMessage);

        // Then
        expect(transformedMessage.payload, equals('original payload'));
        expect(transformedMessage.metadata['original'], isTrue);
        expect(transformedMessage.metadata['tapped'], isTrue);
        expect(
          transformedMessage.metadata['tapSource'],
          equals('test-transformer'),
        );
        expect(transformedMessage.metadata['custom'], equals('value'));
        expect(transformedMessage.metadata.containsKey('tapTimestamp'), isTrue);
      },
    );

    test(
      'Given audit transformer, When message is transformed, Then audit information should be added',
      () async {
        // Given
        final transformer = AuditWireTapTransformer(
          auditReason: 'Security Audit',
          auditorId: 'audit-system',
        );

        final originalMessage = Message(
          payload: 'sensitive data',
          metadata: {'sensitive': true},
          id: 'test-message-id',
        );

        // When
        final transformedMessage = await transformer.transform(originalMessage);

        // Then
        expect(transformedMessage.payload, equals('sensitive data'));
        expect(transformedMessage.metadata['audit'], isNotNull);

        final auditInfo =
            transformedMessage.metadata['audit'] as Map<String, dynamic>;
        expect(auditInfo['reason'], equals('Security Audit'));
        expect(auditInfo['auditorId'], equals('audit-system'));
        expect(auditInfo['messageId'], equals('test-message-id'));
        expect(auditInfo['messageType'], equals('String'));
        expect(auditInfo.containsKey('timestamp'), isTrue);
      },
    );
  });

  group('EDNet-Specific Wire Tap Tests', () {
    late InMemoryChannel tappedChannel;
    late InMemoryChannel auditChannel;
    late VotingAuditWireTap votingTap;

    setUp(() {
      tappedChannel = InMemoryChannel(
        id: 'voting-tapped-channel',
        broadcast: true,
      );
      auditChannel = InMemoryChannel(
        id: 'voting-audit-channel',
        broadcast: true,
      );
      votingTap = VotingAuditWireTap(tappedChannel, auditChannel);
    });

    tearDown(() async {
      await votingTap.stop();
      await tappedChannel.close();
      await auditChannel.close();
    });

    test(
      'Given voting audit wire tap, When vote message is sent, Then it should be audited',
      () async {
        // Given
        await votingTap.start();

        final voteMessage = Message(
          payload: {'candidate': 'Candidate A', 'voterId': 'voter-123'},
          metadata: {'messageType': 'vote', 'electionId': 'election-2024'},
        );

        final completer = Completer<Message>();
        final subscription = auditChannel.receive().listen((message) {
          if (!completer.isCompleted) {
            completer.complete(message);
          }
        }, onError: (error) => completer.completeError(error));

        // When
        await tappedChannel.send(voteMessage);

        // Then
        final auditedMessage = await completer.future.timeout(
          const Duration(seconds: 5),
        );
        await subscription.cancel();

        expect(auditedMessage.payload, equals(voteMessage.payload));
        expect(auditedMessage.metadata['audit'], isNotNull);

        final auditInfo =
            auditedMessage.metadata['audit'] as Map<String, dynamic>;
        expect(auditInfo['reason'], equals('Voting Process Audit'));
        expect(auditInfo['auditorId'], equals('ednet-audit-system'));
      },
    );

    test(
      'Given proposal monitoring wire tap, When proposal message is sent, Then it should be monitored',
      () async {
        // Given
        final monitoringChannel = InMemoryChannel(
          id: 'monitoring-channel',
          broadcast: true,
        );
        final proposalTap = ProposalMonitoringWireTap(
          tappedChannel,
          monitoringChannel,
        );
        await proposalTap.start();

        final proposalMessage = Message(
          payload: {
            'title': 'New Policy Proposal',
            'description': 'Policy details',
          },
          metadata: {
            'messageType': 'proposal_created',
            'authorId': 'citizen-456',
          },
        );

        final completer = Completer<Message>();
        final subscription = monitoringChannel.receive().listen((message) {
          if (!completer.isCompleted) {
            completer.complete(message);
          }
        }, onError: (error) => completer.completeError(error));

        // When
        await tappedChannel.send(proposalMessage);

        // Then
        final monitoredMessage = await completer.future.timeout(
          const Duration(seconds: 5),
        );
        await subscription.cancel();

        expect(monitoredMessage.metadata['tapped'], isTrue);
        expect(
          monitoredMessage.metadata['tapSource'],
          equals('proposal-monitor'),
        );
        expect(monitoredMessage.metadata['monitoring'], isNotNull);
      },
    );
  });

  group('Wire Tap Manager Tests', () {
    test(
      'Given wire tap manager, When taps are added and started, Then all taps should be active',
      () async {
        // Given
        final manager = WireTapManager();
        final tappedChannel = InMemoryChannel(
          id: 'test-tapped-channel',
          broadcast: true,
        );
        final tapChannel1 = InMemoryChannel(
          id: 'tap-channel-1',
          broadcast: true,
        );
        final tapChannel2 = InMemoryChannel(
          id: 'tap-channel-3',
          broadcast: true,
        );

        final tap1 = BasicWireTap(tappedChannel, tapChannel1);
        final tap2 = BasicWireTap(tappedChannel, tapChannel2);

        manager.addTap('tap1', tap1);
        manager.addTap('tap2', tap2);

        // When
        await manager.startAll();

        // Then
        expect(manager.getTap('tap1')?.isActive, isTrue);
        expect(manager.getTap('tap2')?.isActive, isTrue);
      },
    );

    test(
      'Given wire tap manager with active taps, When stopped, Then all taps should be inactive',
      () async {
        // Given
        final manager = WireTapManager();
        final tappedChannel = InMemoryChannel(
          id: 'test-tapped-channel',
          broadcast: true,
        );
        final tapChannel = InMemoryChannel(
          id: 'manager-tap-channel',
          broadcast: true,
        );

        final tap = BasicWireTap(tappedChannel, tapChannel);
        manager.addTap('test-tap', tap);
        await manager.startAll();

        // When
        await manager.stopAll();

        // Then
        expect(manager.getTap('test-tap')?.isActive, isFalse);
      },
    );

    test(
      'Given wire tap manager, When tap is removed, Then it should not be accessible',
      () {
        // Given
        final manager = WireTapManager();
        final tappedChannel = InMemoryChannel(
          id: 'test-tapped-channel',
          broadcast: true,
        );
        final tapChannel = InMemoryChannel(
          id: 'manager-tap-channel',
          broadcast: true,
        );

        final tap = BasicWireTap(tappedChannel, tapChannel);
        manager.addTap('test-tap', tap);

        // When
        manager.removeTap('test-tap');

        // Then
        expect(manager.getTap('test-tap'), isNull);
      },
    );

    test(
      'Given wire tap manager with multiple taps, When summary stats requested, Then combined stats should be returned',
      () async {
        // Given
        final manager = WireTapManager();
        final tappedChannel = InMemoryChannel(
          id: 'test-tapped-channel',
          broadcast: true,
        );
        final tapChannel1 = InMemoryChannel(
          id: 'tap-channel-1',
          broadcast: true,
        );
        final tapChannel2 = InMemoryChannel(
          id: 'tap-channel-3',
          broadcast: true,
        );

        final tap1 = BasicWireTap(tappedChannel, tapChannel1);
        final tap2 = BasicWireTap(tappedChannel, tapChannel2);

        manager.addTap('tap1', tap1);
        manager.addTap('tap2', tap2);
        await manager.startAll();

        // Send some messages
        await tappedChannel.send(
          Message(payload: 'message 1', metadata: {'type': 'test'}),
        );
        await tappedChannel.send(
          Message(payload: 'message 2', metadata: {'type': 'test'}),
        );
        await Future.delayed(const Duration(milliseconds: 10));

        // When
        final summaryStats = manager.getSummaryStats();

        // Then
        expect(summaryStats['totalTaps'], equals(2));
        expect(
          summaryStats['totalMessages'],
          equals(4),
        ); // 2 messages to 2 taps
        expect(summaryStats['activeTaps'], equals(2));
      },
    );
  });
}
