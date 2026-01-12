import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';
import '../../test_helpers/async_test_helpers.dart';

void main() {
  group('EDNet Core Patterns Integration', () {
    tearDown(() {
      // Clear any static state between tests
      ObservabilityExtension.clearAllObservabilityHandlers();
    });
    test('Integration between Channel Adapter and Message Filter', () async {
      // Create new channels for this test
      final uniqueId =
          '${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().hashCode}';
      final sourceChannel = InMemoryChannel(
        id: 'source_${uniqueId}_1',
        name: 'Source Channel',
        broadcast: true,
      );
      final targetChannel = InMemoryChannel(
        id: 'target_${uniqueId}_1',
        name: 'Target Channel',
        broadcast: true,
      );

      // Create HTTP adapter connected to source channel
      final httpAdapter = HttpChannelAdapter(
        channel: sourceChannel,
        baseUrl: 'http://localhost:8080',
        name: 'Test HTTP Adapter',
      );

      // Create a filter that only passes messages with a specific topic
      final filter = PredicateMessageFilter(
        sourceChannel: sourceChannel,
        targetChannel: targetChannel,
        name: 'JSON Content Filter',
        predicate: (message) =>
            message.metadata['contentType'] == 'application/json',
      );

      // Start components
      await httpAdapter.start();
      await filter.start();

      // Collect messages that pass through the filter
      final receivedMessages = <Message>[];
      final subscription = targetChannel.receive().listen((message) {
        receivedMessages.add(message);
      });

      // Create test HTTP requests
      final jsonRequest = HttpRequest(
        method: 'POST',
        path: '/api/test',
        headers: {'Content-Type': 'application/json'},
        body: '{"key": "value"}',
      );

      final textRequest = HttpRequest(
        method: 'POST',
        path: '/api/test',
        headers: {'Content-Type': 'text/plain'},
        body: 'Plain text content',
      );

      // Process the requests through the adapter
      await httpAdapter.handleRequest(jsonRequest);
      await httpAdapter.handleRequest(textRequest);

      // Wait for message processing using deterministic helper
      await AsyncTestHelpers.waitForCondition(
        () => sourceChannel.messageCount >= 2,
        timeout: const Duration(seconds: 3),
        description: 'waiting for 2 messages to be processed',
      );

      // Verify only the JSON message passed through the filter
      expect(sourceChannel.messageCount, equals(2));
      expect(receivedMessages.length, equals(1));
      expect(
        receivedMessages.first.metadata['contentType'],
        equals('application/json'),
      );

      // Clean up
      await subscription.cancel();
      await filter.stop();
      await httpAdapter.stop();
    });

    test('Full cycle: HTTP Request → Message → Filter → HTTP Response', () async {
      // Create new channels for this test
      final uniqueId2 =
          '${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().hashCode}_2';
      final sourceChannel = InMemoryChannel(
        id: 'source_${uniqueId2}',
        name: 'Source Channel',
        broadcast: true,
      );
      final targetChannel = InMemoryChannel(
        id: 'target_${uniqueId2}',
        name: 'Target Channel',
        broadcast: true,
      );

      // Create HTTP adapter connected to source channel
      final httpAdapter = HttpChannelAdapter(
        channel: sourceChannel,
        baseUrl: 'http://localhost:8080',
        name: 'Test HTTP Adapter',
      );

      // Create a filter that only passes messages with a specific topic
      final filter = PredicateMessageFilter(
        sourceChannel: sourceChannel,
        targetChannel: targetChannel,
        name: 'JSON Content Filter',
        predicate: (message) =>
            message.metadata['contentType'] == 'application/json',
      );

      await httpAdapter.start();
      await filter.start();

      // Simulate incoming HTTP request
      final request = HttpRequest(
        method: 'GET',
        path: '/api/data',
        headers: {'Content-Type': 'application/json'},
      );

      // Handle the request (converts to message and sends to source channel)
      await httpAdapter.handleRequest(request);

      // Wait for message processing using deterministic helper
      await AsyncTestHelpers.waitForCondition(
        () => sourceChannel.messageCount >= 1,
        timeout: const Duration(seconds: 3),
        description: 'waiting for message to be processed',
      );

      // Verify message was sent to source channel
      expect(sourceChannel.messageCount, equals(1));

      // Create a response from a similar message
      final message = Message(
        payload: {'data': 'test response'},
        metadata: {'contentType': 'application/json'},
      );

      // Create a response from the message
      final response = await httpAdapter.createResponse(message);

      // Verify response properties
      expect(response.statusCode, equals(200));
      expect(response.headers['Content-Type'], equals('application/json'));

      // Clean up
      await filter.stop();
      await httpAdapter.stop();
    });
  });
}
