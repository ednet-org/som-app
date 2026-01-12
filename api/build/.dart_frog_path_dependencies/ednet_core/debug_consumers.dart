import 'package:ednet_core/ednet_core.dart';

void main() {
  var sourceChannel = InMemoryChannel(id: 'source');
  var consumer1 = VoteProcessingConsumer(
    consumerId: 'consumer-1',
    channel: sourceChannel,
  );
  var consumer2 = VoteProcessingConsumer(
    consumerId: 'consumer-2',
    channel: sourceChannel,
  );
  var consumers = [consumer1, consumer2];

  var coordinator = CompetingConsumersCoordinator(sourceChannel, consumers);

  print('Consumers list length: ${consumers.length}');

  // Try to access the private field using reflection-like approach
  // Since this is a library, let's check the stats before and after start
  var statsBefore = coordinator.getOverallStats();
  print('Stats before start: $statsBefore');

  coordinator.start();

  var statsAfter = coordinator.getOverallStats();
  print('Stats after start: $statsAfter');
}
