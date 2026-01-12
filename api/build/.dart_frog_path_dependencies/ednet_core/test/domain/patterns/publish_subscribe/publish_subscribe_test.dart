import 'dart:async';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../../../test_helpers/async_test_helpers.dart';

void main() {
  group('Publish-Subscribe Channel Pattern Tests', () {
    late TopicBasedPublishSubscribeChannel channel;
    late VoteProcessingConsumer consumer1;
    late VoteProcessingConsumer consumer2;

    setUp(() {
      channel = TopicBasedPublishSubscribeChannel(
        id: 'test-channel',
        topic: 'test-topic',
      );
      consumer1 = VoteProcessingConsumer(
        consumerId: 'consumer-1',
        channel: channel,
      );
      consumer2 = VoteProcessingConsumer(
        consumerId: 'consumer-2',
        channel: channel,
      );
    });

    tearDown(() async {
      await channel.close();
    });

    test(
      'Given a publish-subscribe channel, When subscribing a consumer, Then subscriber count increases',
      () {
        // When
        channel.subscribe(consumer1);

        // Then
        expect(channel.subscriberCount, equals(1));
        expect(channel.isSubscribed(consumer1), isTrue);
      },
    );

    test(
      'Given a subscribed consumer, When unsubscribing, Then subscriber count decreases',
      () async {
        // Given
        channel.subscribe(consumer1);
        expect(channel.subscriberCount, equals(1));

        // When
        await channel.unsubscribe(consumer1);

        // Then
        expect(channel.subscriberCount, equals(0));
        expect(channel.isSubscribed(consumer1), isFalse);
      },
    );

    test(
      'Given multiple subscribers, When publishing a message, Then all subscribers receive it',
      () async {
        // Given
        channel.subscribe(consumer1);
        channel.subscribe(consumer2);

        final message = Message(
          payload: {'candidate': 'Candidate A', 'voterId': 'voter-123'},
          metadata: {'messageType': 'vote'},
        );

        // When
        await channel.send(message);

        // Wait for async processing using deterministic helper
        await AsyncTestHelpers.waitForCondition(
          () => channel.getStats().totalMessagesDelivered >= 2,
          timeout: const Duration(seconds: 3),
          description: 'waiting for message delivery to 2 subscribers',
        );

        // Then
        final stats = channel.getStats();
        expect(stats.totalMessagesPublished, equals(1));
        expect(
          stats.totalMessagesDelivered,
          equals(2),
        ); // Delivered to 2 subscribers
        expect(stats.subscriberCount, equals(2));
      },
    );

    test(
      'Given a channel with subscribers, When getting statistics, Then correct stats are returned',
      () async {
        // Given
        channel.subscribe(consumer1);
        channel.subscribe(consumer2);

        final messages = [
          Message(payload: 'msg1', metadata: {'messageType': 'vote'}),
          Message(payload: 'msg2', metadata: {'messageType': 'notification'}),
        ];

        // When
        for (final message in messages) {
          await channel.send(message);
        }

        // Wait for async processing using deterministic helper
        await AsyncTestHelpers.waitForCondition(
          () =>
              channel.getStats().totalMessagesDelivered >=
              4, // 2 messages * 2 subscribers = 4
          timeout: const Duration(seconds: 3),
          description: 'waiting for 4 total message deliveries',
        );

        // Then
        final stats = channel.getStats();
        expect(stats.channelId, equals('test-channel'));
        expect(stats.subscriberCount, equals(2));
        expect(stats.totalMessagesPublished, equals(2));
        expect(stats.messagesByType['vote'], equals(1));
        expect(stats.messagesByType['notification'], equals(1));
        expect(
          stats.deliveryRate,
          equals(2.0),
        ); // 4 deliveries (2 subs × 2 msgs) / 2 published = 2.0
      },
    );

    test(
      'Given a channel, When getting subscriber IDs, Then correct list is returned',
      () {
        // Given
        channel.subscribe(consumer1);
        channel.subscribe(consumer2);

        // When
        final subscriberIds = channel.subscriberIds;

        // Then
        expect(subscriberIds.length, equals(2));
        expect(subscriberIds, contains('consumer-1'));
        expect(subscriberIds, contains('consumer-2'));
      },
    );
  });

  group('Durable Subscriber Tests', () {
    late InMemoryChannel channel;
    late DurableSubscriber subscriber;

    setUp(() {
      channel = InMemoryChannel(id: 'test-channel', broadcast: true);
      subscriber = DurableSubscriber(
        consumerId: 'durable-consumer',
        channel: channel,
      );
    });

    test(
      'Given a durable subscriber, When processing a message, Then it returns success result',
      () async {
        // Given
        final message = Message(
          payload: 'test message',
          metadata: {'messageType': 'test'},
        );

        // When
        final result = await subscriber.processMessage(message);

        // Then
        expect(result.success, isTrue);
        expect(result.result, isNotNull);
        expect(result.result['processed'], isTrue);
        expect(
          result.result['subscriptionId'],
          equals(subscriber.subscriptionId),
        );
      },
    );

    test(
      'Given a durable subscriber, When checking canHandle, Then it returns true for any message',
      () {
        // Given
        final messages = [
          Message(payload: 'vote', metadata: {'messageType': 'vote'}),
          Message(
            payload: 'notification',
            metadata: {'messageType': 'notification'},
          ),
          Message(payload: 'alert', metadata: {'messageType': 'alert'}),
        ];

        // When & Then
        for (final message in messages) {
          expect(subscriber.canHandle(message), isTrue);
        }
      },
    );

    test(
      'Given a durable subscriber, When adding pending messages, Then they are stored',
      () {
        // Given
        final messages = [
          Message(payload: 'msg1', metadata: {'type': 'test'}),
          Message(payload: 'msg2', metadata: {'type': 'test'}),
        ];

        // When
        for (final message in messages) {
          subscriber.addPendingMessage(message);
        }

        // Then
        expect(subscriber.hasPendingMessages(), isTrue);

        final pendingMessages = subscriber.getAndClearPendingMessages();
        expect(pendingMessages.length, equals(2));
        expect(subscriber.hasPendingMessages(), isFalse);
      },
    );
  });

  group('Selective Subscriber Tests', () {
    late InMemoryChannel channel;
    late SelectiveSubscriber subscriber;

    setUp(() {
      channel = InMemoryChannel(id: 'test-channel', broadcast: true);
      subscriber = SelectiveSubscriber(
        consumerId: 'selective-consumer',
        channel: channel,
        subscribedMessageTypes: ['vote', 'proposal'],
        filterCriteria: {'priority': 'high'},
      );
    });

    test(
      'Given a selective subscriber, When message matches criteria, Then canHandle returns true',
      () {
        // Given
        final matchingMessage = Message(
          payload: {'content': 'High priority vote'},
          metadata: {'messageType': 'vote', 'priority': 'high'},
        );

        // When
        final canHandle = subscriber.canHandle(matchingMessage);

        // Then
        expect(canHandle, isTrue);
      },
    );

    test(
      'Given a selective subscriber, When message type does not match, Then canHandle returns false',
      () {
        // Given
        final nonMatchingMessage = Message(
          payload: {'content': 'Low priority notification'},
          metadata: {'messageType': 'notification', 'priority': 'low'},
        );

        // When
        final canHandle = subscriber.canHandle(nonMatchingMessage);

        // Then
        expect(canHandle, isFalse);
      },
    );

    test(
      'Given a selective subscriber, When message priority does not match filter, Then canHandle returns false',
      () {
        // Given
        final nonMatchingMessage = Message(
          payload: {'content': 'Low priority vote'},
          metadata: {'messageType': 'vote', 'priority': 'low'},
        );

        // When
        final canHandle = subscriber.canHandle(nonMatchingMessage);

        // Then
        expect(canHandle, isFalse);
      },
    );

    test(
      'Given a selective subscriber, When processing filtered message, Then result indicates filtering',
      () async {
        // Given
        final filteredMessage = Message(
          payload: {'content': 'Low priority vote'},
          metadata: {'messageType': 'notification', 'priority': 'low'},
        );

        // When
        final result = await subscriber.processMessage(filteredMessage);

        // Then
        expect(result.success, isFalse);
        expect(result.result['filtered'], isTrue);
        expect(result.errorMessage, equals('Message filtered out'));
      },
    );
  });

  group('Publish-Subscribe Broker Tests', () {
    late PublishSubscribeBroker broker;
    late VoteProcessingConsumer consumer;

    setUp(() {
      broker = PublishSubscribeBroker();
      consumer = VoteProcessingConsumer(
        consumerId: 'broker-consumer',
        channel: InMemoryChannel(id: 'dummy', broadcast: true),
      );
    });

    tearDown(() async {
      await broker.shutdown();
    });

    test(
      'Given a broker, When creating a channel, Then channel is created and accessible',
      () {
        // When
        final channel = broker.createChannel(
          channelId: 'test-channel',
          topic: 'test-topic',
          name: 'Test Channel',
        );

        // Then
        expect(channel.id, equals('test-channel'));
        expect(channel is TopicBasedPublishSubscribeChannel, isTrue);
        expect(
          (channel as TopicBasedPublishSubscribeChannel).topic,
          equals('test-topic'),
        );

        final retrievedChannel = broker.getChannel('test-channel');
        expect(retrievedChannel, equals(channel));
      },
    );

    test(
      'Given a broker with channel, When subscribing consumer, Then subscription is created',
      () async {
        // Given
        final channel = broker.createChannel(
          channelId: 'subscription-test',
          topic: 'test',
        );

        // When
        final subscription = broker.subscribeToChannel(
          'subscription-test',
          consumer,
        );

        // Then
        expect(channel.subscriberCount, equals(1));
        expect(channel.isSubscribed(consumer), isTrue);

        await subscription.cancel();
      },
    );

    test(
      'Given a broker with subscribed consumer, When publishing to channel, Then consumer receives message',
      () async {
        // Given
        final channel = broker.createChannel(
          channelId: 'publish-test',
          topic: 'test',
        );

        broker.subscribeToChannel('publish-test', consumer);

        final message = Message(
          payload: {'candidate': 'Test Candidate'},
          metadata: {'messageType': 'vote'},
        );

        final completer = Completer<void>();
        final subscription = channel.receive().listen((msg) {
          completer.complete();
        });

        // When
        await broker.publishToChannel('publish-test', message);

        // Then
        await completer.future.timeout(const Duration(seconds: 2));

        await subscription.cancel();
      },
    );

    test(
      'Given a broker with multiple channels of same topic, When publishing to topic, Then all channels receive message',
      () async {
        // Given
        final channel1 = broker.createChannel(
          channelId: 'topic-channel-1',
          topic: 'shared-topic',
        );

        final channel2 = broker.createChannel(
          channelId: 'topic-channel-2',
          topic: 'shared-topic',
        );

        final channel3 = broker.createChannel(
          channelId: 'different-topic',
          topic: 'different',
        );

        final message = Message(
          payload: 'Topic message',
          metadata: {'type': 'test'},
        );

        final completers = List.generate(3, (_) => Completer<void>());
        int receivedCount = 0;

        final subscription1 = channel1.receive().listen((msg) {
          receivedCount++;
          completers[0].complete();
        });

        final subscription2 = channel2.receive().listen((msg) {
          receivedCount++;
          completers[1].complete();
        });

        final subscription3 = channel3.receive().listen((msg) {
          receivedCount++;
          completers[2].complete();
        });

        // When
        await broker.publishToTopic('shared-topic', message);

        // Then
        await completers[0].future.timeout(const Duration(seconds: 2));
        await completers[1].future.timeout(const Duration(seconds: 2));
        expect(receivedCount, equals(2)); // Only 2 channels should receive

        await subscription1.cancel();
        await subscription2.cancel();
        await subscription3.cancel();
      },
    );

    test(
      'Given a broker, When getting overall statistics, Then correct stats are returned',
      () {
        // Given
        broker.createChannel(channelId: 'stats-channel-1', topic: 'topic1');
        broker.createChannel(channelId: 'stats-channel-2', topic: 'topic2');

        // When
        final stats = broker.getStats().getOverallStats();

        // Then
        expect(stats['totalChannels'], equals(2));
        expect(stats['channels'], isNotNull);

        final channels = stats['channels'] as Map<String, dynamic>;
        expect(channels.containsKey('stats-channel-1'), isTrue);
        expect(channels.containsKey('stats-channel-2'), isTrue);
        expect(channels['stats-channel-1']['topic'], equals('topic1'));
        expect(channels['stats-channel-2']['topic'], equals('topic2'));
      },
    );
  });
}
