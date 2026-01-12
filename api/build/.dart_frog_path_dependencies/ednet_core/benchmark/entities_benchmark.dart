import '../test/mocks/ednet_democracy_domain.dart';

void main() {
  final domain = EDNetDemocracyDomain();
  final citizens = domain.citizens;
  final referendums = domain.referendums;
  final votes = domain.votes;

  const total = 1000;

  final swAdd = Stopwatch()..start();
  for (var i = 0; i < total; i++) {
    final c = domain.createCitizen(
      name: 'Citizen $i',
      email: 'citizen$i@demo.org',
      idNumber: 'C$i',
    );
    citizens.add(c);
  }
  swAdd.stop();

  final referendum = domain.createReferendum(
    title: 'Perf',
    description: 'Benchmark',
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 7)),
  );
  referendums.add(referendum);

  final swRel = Stopwatch()..start();
  for (final citizen in citizens) {
    final vote = domain.createVote(
      citizen: citizen,
      referendum: referendum,
      choice: 'Yes',
    );
    votes.add(vote);
  }
  swRel.stop();

  final swQuery = Stopwatch()..start();
  final found = votes.selectWhereAttribute('choice', 'Yes');
  swQuery.stop();

  print('Add citizens: ${swAdd.elapsedMilliseconds} ms');
  print('Create votes: ${swRel.elapsedMilliseconds} ms');
  print(
    'Query votes: ${swQuery.elapsedMilliseconds} ms (found ${found.length})',
  );
}
