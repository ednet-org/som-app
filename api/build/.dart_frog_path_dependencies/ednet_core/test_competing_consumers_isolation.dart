// Minimal reproducible test for competing consumers timing issues
import 'dart:async';
import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Competing Consumers Timing Issues - Minimal Reproduction', () {
    test(
      'Multiple consumers should process messages concurrently without race conditions',
      () async {
        // Setup
        final channel = InMemoryChannel(
          id: 'test-${DateTime.now().millisecondsSinceEpoch}',
          broadcast: true,
        );
        final processed = <String>[];
        final lock = <String, Completer<void>>{};

        // Create test consumers with controlled timing
        final consumer1 = TestConsumerWithDelay(
          'c1',
          channel,
          Duration(milliseconds: 10),
          processed,
          lock,
        );

        final consumer2 = TestConsumerWithDelay(
          'c2',
          channel,
          Duration(milliseconds: 5),
          processed,
          lock,
        );

        final coordinator = CompetingConsumersCoordinator(channel, [
          consumer1,
          consumer2,
        ], selectionStrategy: ConsumerSelectionStrategy.roundRobin);

        // Start coordinator
        await coordinator.start();

        // Send messages
        const messageCount = 10;
        final futures = <Future>[];

        for (int i = 0; i < messageCount; i++) {
          final message = Message(
            payload: 'msg-$i',
            metadata: {'messageType': 'test'},
          );
          lock['msg-$i'] = Completer<void>();
          await channel.send(message);
        }

        // Wait for all messages to be processed with timeout
        await Future.wait(
          lock.values.map((c) => c.future),
          eagerError: true,
        ).timeout(Duration(seconds: 5));

        // Verify
        expect(processed.length, equals(messageCount));
        expect(
          processed.toSet().length,
          equals(messageCount),
          reason: 'Duplicate processing detected',
        );

        // Check distribution between consumers
        final consumer1Count = processed
            .where((p) => p.startsWith('c1'))
            .length;
        final consumer2Count = processed
            .where((p) => p.startsWith('c2'))
            .length;

        expect(consumer1Count + consumer2Count, equals(messageCount));
        expect(
          consumer1Count,
          greaterThan(0),
          reason: 'Consumer 1 did not process any messages',
        );
        expect(
          consumer2Count,
          greaterThan(0),
          reason: 'Consumer 2 did not process any messages',
        );

        // Cleanup
        await coordinator.stop();
      },
    );

    test('Consumer timeout should not cause message loss', () async {
      final channel = InMemoryChannel(
        id: 'timeout-test-${DateTime.now().millisecondsSinceEpoch}',
        broadcast: true,
      );
      final processed = <String>[];
      final timedOut = <String>[];

      // Create a consumer that times out on specific messages
      final consumer = TimeoutTestConsumer(
        'timeout-consumer',
        channel,
        processed,
        timedOut,
      );

      final coordinator = CompetingConsumersCoordinator(
        channel,
        [consumer],
        consumerTimeout: Duration(milliseconds: 50), // Short timeout
      );

      await coordinator.start();

      // Send messages - some will timeout
      for (int i = 0; i < 5; i++) {
        await channel.send(
          Message(payload: i, metadata: {'shouldTimeout': i % 2 == 0}),
        );
      }

      // Wait for processing
      await Future.delayed(Duration(milliseconds: 200));

      // Verify
      expect(
        processed.length + timedOut.length,
        greaterThanOrEqualTo(3),
        reason: 'Not all messages were attempted',
      );

      await coordinator.stop();
    });

    test(
      'Race condition when consumers start/stop during message processing',
      () async {
        final channel = InMemoryChannel(
          id: 'race-${DateTime.now().millisecondsSinceEpoch}',
          broadcast: true,
        );
        final processed = <String>[];

        final consumer1 = SimpleTestConsumer('c1', channel, processed);
        final consumer2 = SimpleTestConsumer('c2', channel, processed);

        final coordinator = CompetingConsumersCoordinator(channel, [consumer1]);

        await coordinator.start();

        // Send messages while adding/removing consumers
        final sendFuture = () async {
          for (int i = 0; i < 20; i++) {
            await channel.send(Message(payload: 'msg-$i'));
            await Future.delayed(Duration(milliseconds: 2));
          }
        }();

        // Concurrently add/remove consumers
        final modifyFuture = () async {
          await Future.delayed(Duration(milliseconds: 10));
          await coordinator.addConsumer(consumer2);
          await Future.delayed(Duration(milliseconds: 10));
          await coordinator.removeConsumer('c1');
          await Future.delayed(Duration(milliseconds: 10));
          await coordinator.addConsumer(consumer1);
        }();

        await Future.wait([sendFuture, modifyFuture]);
        await Future.delayed(Duration(milliseconds: 100));

        // Verify no crashes and some messages processed
        expect(processed.length, greaterThan(0));
        expect(
          processed.toSet().length,
          equals(processed.length),
          reason: 'Duplicate messages detected during consumer changes',
        );

        await coordinator.stop();
      },
    );
  });
}

// Test consumer implementations
class TestConsumerWithDelay extends BaseMessageConsumer {
  final Duration delay;
  final List<String> processed;
  final Map<String, Completer<void>> lock;

  TestConsumerWithDelay(
    String consumerId,
    Channel channel,
    this.delay,
    this.processed,
    this.lock,
  ) : super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) => true;

  @override
  Future<MessageProcessingResult> processMessage(Message message) async {
    final start = DateTime.now();
    await Future.delayed(delay);

    final payload = message.payload.toString();
    processed.add('$consumerId:$payload');
    lock[payload]?.complete();

    return MessageProcessingResult(
      originalMessage: message,
      success: true,
      result: {'consumer': consumerId},
      processingTime: DateTime.now().difference(start),
    );
  }
}

class TimeoutTestConsumer extends BaseMessageConsumer {
  final List<String> processed;
  final List<String> timedOut;

  TimeoutTestConsumer(
    String consumerId,
    Channel channel,
    this.processed,
    this.timedOut,
  ) : super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) => true;

  @override
  Future<MessageProcessingResult> processMessage(Message message) async {
    final shouldTimeout = message.metadata['shouldTimeout'] == true;

    if (shouldTimeout) {
      // Simulate long processing that will timeout
      await Future.delayed(Duration(milliseconds: 100));
      timedOut.add(message.payload.toString());
    } else {
      processed.add(message.payload.toString());
    }

    return MessageProcessingResult(
      originalMessage: message,
      success: true,
      result: {},
      processingTime: Duration(milliseconds: 1),
    );
  }
}

class SimpleTestConsumer extends BaseMessageConsumer {
  final List<String> processed;

  SimpleTestConsumer(String consumerId, Channel channel, this.processed)
    : super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) => true;

  @override
  Future<MessageProcessingResult> processMessage(Message message) async {
    processed.add('$consumerId:${message.payload}');
    return MessageProcessingResult(
      originalMessage: message,
      success: true,
      result: {},
      processingTime: Duration(milliseconds: 1),
    );
  }
}
