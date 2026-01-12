import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

/// Integration test demonstrating Channel and Message work properly with CompetingConsumers
/// This test verifies that the ednet_core library correctly exposes all necessary classes
/// and that they integrate seamlessly without any "Undefined class" errors.
void main() {
  group('Channel, Message, and CompetingConsumers Integration Tests', () {
    late InMemoryChannel channel;
    late List<TestIntegrationConsumer> consumers;
    late CompetingConsumersCoordinator coordinator;

    setUp(() {
      // Create a real Channel instance
      channel = InMemoryChannel(
        id: 'integration-test-channel',
        name: 'Integration Test Channel',
        broadcast: true,
      );

      // Create test consumers that work with real Channel and Message instances
      consumers = [
        TestIntegrationConsumer('consumer-1', channel),
        TestIntegrationConsumer('consumer-2', channel),
      ];

      // Create coordinator with real config providers
      coordinator = CompetingConsumersCoordinator(
        channel,
        consumers,
        selectionStrategy: ConsumerSelectionStrategy.roundRobin,
        consumerTimeout: const Duration(seconds: 5),
        configProvider: DevelopmentMessagePatternsConfigProvider(),
      );
    });

    tearDown(() async {
      await coordinator.stop();
      await channel.close();
    });

    test('Channel class is properly accessible and functional', () {
      expect(channel, isA<Channel>());
      expect(channel.id, equals('integration-test-channel'));
      expect(channel.name, equals('Integration Test Channel'));
    });

    test('Message class is properly accessible and can be created', () {
      final message = Message(
        payload: 'test-payload',
        metadata: {'type': 'integration-test'},
      );

      expect(message, isA<Message>());
      expect(message.payload, equals('test-payload'));
      expect(message.metadata['type'], equals('integration-test'));
      expect(message.id, isNotEmpty);
    });

    test('TypedMessage system works correctly', () {
      final domainContext = MessageDomainContext('test-domain');
      final category = MessageCategory('integration');

      final typedMessage = GenericTypedMessage(
        payload: {'data': 'test'},
        domainContext: domainContext,
        category: category,
      );

      expect(typedMessage, isA<TypedMessage>());
      expect(typedMessage.domainContext.name, equals('test-domain'));
      expect(typedMessage.category.name, equals('integration'));

      // Test conversion to legacy Message
      final legacyMessage = Message.fromTypedMessage(typedMessage);
      expect(legacyMessage, isA<Message>());
      expect(legacyMessage.metadata['domain'], equals('test-domain'));
    });

    test(
      'CompetingConsumersCoordinator works with real Channel and Message instances',
      () async {
        await coordinator.start();

        // Send real Message instances through real Channel
        final messages = [
          Message(payload: 'message-1', metadata: {'priority': 'high'}),
          Message(payload: 'message-2', metadata: {'priority': 'low'}),
          Message(payload: 'message-3', metadata: {'priority': 'medium'}),
        ];

        final processedMessages = <String>[];

        // Set up consumers to capture processed messages
        for (final consumer in consumers) {
          consumer.onMessageProcessed = (message) {
            processedMessages.add('${consumer.consumerId}:${message.payload}');
          };
        }

        // Send all messages
        for (final message in messages) {
          await channel.send(message);
        }

        // Wait for processing
        await Future.delayed(const Duration(milliseconds: 100));

        // Verify messages were processed
        expect(processedMessages.length, equals(3));
        expect(processedMessages, contains(startsWith('consumer-')));

        // Verify coordinator statistics
        final stats = coordinator.getOverallStats();
        expect(stats['totalMessagesProcessed'], equals(3));
        expect(stats['totalMessagesSucceeded'], equals(3));
        expect(stats['totalMessagesFailed'], equals(0));
      },
    );

    test('Configuration providers work correctly', () {
      final devConfig = DevelopmentMessagePatternsConfigProvider();
      final prodConfig = ProductionMessagePatternsConfigProvider();

      expect(
        devConfig.config.defaultConsumerTimeout,
        equals(const Duration(seconds: 10)),
      );
      expect(
        prodConfig.config.defaultConsumerTimeout,
        equals(const Duration(seconds: 60)),
      );
      expect(devConfig.config.maxRetries, equals(1));
      expect(prodConfig.config.maxRetries, equals(5));
    });

    test('Business logic configuration works with real data', () {
      final config = CompetingConsumersBusinessLogicConfig.fromEnvironment();

      expect(config.recommendations, isNotEmpty);
      expect(config.sentiments, isNotEmpty);
      expect(config.engagementLevels, isNotEmpty);
      expect(config.deliveryMethods, isNotEmpty);

      // Test that all lists contain expected default values
      expect(config.recommendations, contains('approve'));
      expect(config.sentiments, contains('positive'));
      expect(config.engagementLevels, contains('high'));
      expect(config.deliveryMethods, contains('email'));
    });

    test('All analyzer-problematic classes are accessible and functional', () {
      // Test classes that were showing as "Undefined" when analyzed in isolation

      // Channel classes
      expect(channel, isA<Channel>());
      expect(channel, isA<InMemoryChannel>());

      // Message classes
      final message = Message(payload: 'test');
      expect(message, isA<Message>());

      // TypedMessage classes
      final typedMessage = GenericTypedMessage(
        payload: 'test',
        domainContext: MessageDomainContext('test'),
        category: MessageCategory('test'),
      );
      expect(typedMessage, isA<TypedMessage>());
      expect(typedMessage, isA<GenericTypedMessage>());

      // Configuration classes
      final configProvider = DevelopmentMessagePatternsConfigProvider();
      expect(configProvider, isA<MessagePatternsConfigProvider>());

      // Consumer classes
      final consumer = TestIntegrationConsumer('test', channel);
      expect(consumer, isA<MessageConsumer>());
      expect(consumer, isA<BaseMessageConsumer>());

      // Coordinator class
      expect(coordinator, isA<CompetingConsumersCoordinator>());
    });
  });
}

/// Test consumer for integration testing
class TestIntegrationConsumer extends BaseMessageConsumer {
  void Function(Message)? onMessageProcessed;

  TestIntegrationConsumer(String consumerId, Channel channel)
    : super(consumerId: consumerId, channel: channel);

  @override
  bool canHandle(Message message) => true;

  @override
  Future<MessageProcessingResult> doProcessMessage(Message message) async {
    // Simulate some processing time
    await Future.delayed(const Duration(milliseconds: 10));

    // Notify test of processing
    onMessageProcessed?.call(message);

    return MessageProcessingResult(
      originalMessage: message,
      success: true,
      result: {'processedBy': consumerId},
      processingTime: const Duration(milliseconds: 10),
    );
  }
}
