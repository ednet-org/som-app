import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';
import '../mocks/ednet_democracy_domain.dart' as democracy;

void main() {
  group('Transaction Testing in Direct Democracy Domain', () {
    late democracy.EDNetDemocracyDomain domain;
    late DomainSession session;
    late Entities<democracy.Citizen> citizens;
    late Entities<democracy.Referendum> referendums;
    late Entities<democracy.Vote> votes;

    setUp(() {
      // Initialize domain using the common mock
      domain = democracy.EDNetDemocracyDomain();
      session = domain.session;
      citizens = domain.citizens;
      referendums = domain.referendums;
      votes = domain.votes;
    });

    test('Transaction with valid commands should succeed', () {
      // Create entities WITHOUT adding to collections
      final citizen = democracy.Citizen.withConcept(domain.citizenConcept);
      citizen.setAttribute('name', 'Jane Citizen');
      citizen.setAttribute('email', 'jane@democracy.org');
      citizen.setAttribute('idNumber', 'C123456');

      final referendum = democracy.Referendum.withConcept(
        domain.referendumConcept,
      );
      referendum.setAttribute('title', 'Test Referendum');
      referendum.setAttribute('description', 'Test description');
      referendum.setAttribute('startDate', DateTime.now());
      referendum.setAttribute(
        'endDate',
        DateTime.now().add(const Duration(days: 7)),
      );

      final vote = democracy.Vote.withConcept(domain.voteConcept);
      vote.setAttribute('choice', 'Yes');
      vote.setAttribute('timestamp', DateTime.now());
      vote.setParent('citizen', citizen);
      vote.setParent('referendum', referendum);

      final transaction = Transaction('VoteTransaction', session);
      final addCitizenCmd = AddCommand(session, citizens, citizen);
      final addReferendumCmd = AddCommand(session, referendums, referendum);
      final addVoteCmd = AddCommand(session, votes, vote);

      addCitizenCmd.partOfTransaction = true;
      addReferendumCmd.partOfTransaction = true;
      addVoteCmd.partOfTransaction = true;

      transaction.add(addCitizenCmd);
      transaction.add(addReferendumCmd);
      transaction.add(addVoteCmd);

      bool result = transaction.doIt();
      expect(result, isTrue);
      expect(citizens.length, equals(1));
      expect(referendums.length, equals(1));
      expect(votes.length, equals(1));
      expect(session.past.commands.length, equals(1));
      expect(session.past.commands.first, equals(transaction));
    });

    test('Transaction with an invalid command should rollback', () {
      // Create entities WITHOUT adding to collections
      final citizen = democracy.Citizen.withConcept(domain.citizenConcept);
      citizen.setAttribute('name', 'Jane Citizen');
      citizen.setAttribute('email', 'jane@democracy.org');
      citizen.setAttribute('idNumber', 'C123456');

      final referendum = democracy.Referendum.withConcept(
        domain.referendumConcept,
      );
      referendum.setAttribute('title', 'Test Referendum');
      referendum.setAttribute('description', 'Test description');
      referendum.setAttribute('startDate', DateTime.now());
      referendum.setAttribute(
        'endDate',
        DateTime.now().add(const Duration(days: 7)),
      );

      // Create an invalid vote missing the referendum parent
      final invalidVote = democracy.Vote();
      invalidVote.concept = domain.voteConcept;
      invalidVote.setAttribute('choice', 'No');
      invalidVote.setAttribute('timestamp', DateTime.now());
      invalidVote.setParent('citizen', citizen);
      // Intentionally not setting the referendum parent

      final transaction = Transaction('InvalidVoteTransaction', session);
      final addCitizenCmd = AddCommand(session, citizens, citizen);
      final addReferendumCmd = AddCommand(session, referendums, referendum);
      final addInvalidVoteCmd = AddCommand(session, votes, invalidVote);

      addCitizenCmd.partOfTransaction = true;
      addReferendumCmd.partOfTransaction = true;
      addInvalidVoteCmd.partOfTransaction = true;

      transaction.add(addCitizenCmd);
      transaction.add(addReferendumCmd);
      transaction.add(addInvalidVoteCmd);

      bool result = transaction.doIt();
      expect(result, isFalse);
      expect(citizens.isEmpty, isTrue);
      expect(referendums.isEmpty, isTrue);
      expect(votes.isEmpty, isTrue);
      expect(session.past.commands.isEmpty, isTrue);
    });

    test('Undo transaction should revert all changes', () {
      // Create entities WITHOUT adding to collections
      final citizen = democracy.Citizen.withConcept(domain.citizenConcept);
      citizen.setAttribute('name', 'Jane Citizen');
      citizen.setAttribute('email', 'jane@democracy.org');
      citizen.setAttribute('idNumber', 'C123456');

      final referendum = democracy.Referendum.withConcept(
        domain.referendumConcept,
      );
      referendum.setAttribute('title', 'Test Referendum');
      referendum.setAttribute('description', 'Test description');
      referendum.setAttribute('startDate', DateTime.now());
      referendum.setAttribute(
        'endDate',
        DateTime.now().add(const Duration(days: 7)),
      );

      final vote = democracy.Vote.withConcept(domain.voteConcept);
      vote.setAttribute('choice', 'Yes');
      vote.setAttribute('timestamp', DateTime.now());
      vote.setParent('citizen', citizen);
      vote.setParent('referendum', referendum);

      final transaction = Transaction('VoteTransaction', session);
      final addCitizenCmd = AddCommand(session, citizens, citizen);
      final addReferendumCmd = AddCommand(session, referendums, referendum);
      final addVoteCmd = AddCommand(session, votes, vote);

      addCitizenCmd.partOfTransaction = true;
      addReferendumCmd.partOfTransaction = true;
      addVoteCmd.partOfTransaction = true;

      transaction.add(addCitizenCmd);
      transaction.add(addReferendumCmd);
      transaction.add(addVoteCmd);

      transaction.doIt();
      expect(citizens.length, equals(1));
      expect(referendums.length, equals(1));
      expect(votes.length, equals(1));

      bool undoResult = transaction.undo();
      expect(undoResult, isTrue);
      expect(citizens.isEmpty, isTrue);
      expect(referendums.isEmpty, isTrue);
      expect(votes.isEmpty, isTrue);
    });

    test('Redo transaction should reapply all changes', () {
      // Create entities WITHOUT adding to collections
      final citizen = democracy.Citizen.withConcept(domain.citizenConcept);
      citizen.setAttribute('name', 'Jane Citizen');
      citizen.setAttribute('email', 'jane@democracy.org');
      citizen.setAttribute('idNumber', 'C123456');

      final referendum = democracy.Referendum.withConcept(
        domain.referendumConcept,
      );
      referendum.setAttribute('title', 'Test Referendum');
      referendum.setAttribute('description', 'Test description');
      referendum.setAttribute('startDate', DateTime.now());
      referendum.setAttribute(
        'endDate',
        DateTime.now().add(const Duration(days: 7)),
      );

      final vote = democracy.Vote.withConcept(domain.voteConcept);
      vote.setAttribute('choice', 'Yes');
      vote.setAttribute('timestamp', DateTime.now());
      vote.setParent('citizen', citizen);
      vote.setParent('referendum', referendum);

      final transaction = Transaction('VoteTransaction', session);
      final addCitizenCmd = AddCommand(session, citizens, citizen);
      final addReferendumCmd = AddCommand(session, referendums, referendum);
      final addVoteCmd = AddCommand(session, votes, vote);

      addCitizenCmd.partOfTransaction = true;
      addReferendumCmd.partOfTransaction = true;
      addVoteCmd.partOfTransaction = true;

      transaction.add(addCitizenCmd);
      transaction.add(addReferendumCmd);
      transaction.add(addVoteCmd);

      transaction.doIt();
      transaction.undo();

      bool redoResult = transaction.redo();
      expect(redoResult, isTrue);
      expect(citizens.length, equals(1));
      expect(referendums.length, equals(1));
      expect(votes.length, equals(1));
    });

    test('Transaction with Set Attribute Commands', () {
      // Create citizen WITHOUT adding to collection
      final citizen = democracy.Citizen.withConcept(domain.citizenConcept);
      citizen.setAttribute('name', 'Initial Name');
      citizen.setAttribute('email', 'initial@democracy.org');
      citizen.setAttribute('idNumber', 'C123456');
      citizens.add(citizen);

      expect(citizen.getAttribute('name'), equals('Initial Name'));

      final transaction = Transaction('UpdateCitizenAttributes', session);
      final setNameCmd = SetAttributeCommand(
        session,
        citizen,
        'name',
        'Updated Name',
      );
      final setEmailCmd = SetAttributeCommand(
        session,
        citizen,
        'email',
        'updated@democracy.org',
      );

      setNameCmd.partOfTransaction = true;
      setEmailCmd.partOfTransaction = true;

      transaction.add(setNameCmd);
      transaction.add(setEmailCmd);

      bool result = transaction.doIt();
      expect(result, isTrue);
      expect(citizen.getAttribute('name'), equals('Updated Name'));
      expect(citizen.getAttribute('email'), equals('updated@democracy.org'));

      transaction.undo();
      expect(citizen.getAttribute('name'), equals('Initial Name'));
      expect(citizen.getAttribute('email'), equals('initial@democracy.org'));
    });

    test('Transaction with mix of Add and Remove Commands', () {
      // Create citizen1 WITHOUT adding to collection, then add it
      final citizen1 = democracy.Citizen.withConcept(domain.citizenConcept);
      citizen1.setAttribute('name', 'Citizen One');
      citizen1.setAttribute('email', 'one@democracy.org');
      citizen1.setAttribute('idNumber', 'C123456');
      citizens.add(citizen1);

      // Create citizen2 WITHOUT adding to collection
      final citizen2 = democracy.Citizen.withConcept(domain.citizenConcept);
      citizen2.setAttribute('name', 'Citizen Two');
      citizen2.setAttribute('email', 'two@democracy.org');
      citizen2.setAttribute('idNumber', 'C654321');

      expect(citizens.length, equals(1));

      final transaction = Transaction('AddRemoveMix', session);
      final removeCmd = RemoveCommand(session, citizens, citizen1);
      final addCmd = AddCommand(session, citizens, citizen2);

      removeCmd.partOfTransaction = true;
      addCmd.partOfTransaction = true;

      transaction.add(removeCmd);
      transaction.add(addCmd);

      bool result = transaction.doIt();
      expect(result, isTrue);
      expect(citizens.length, equals(1));
      expect(citizens.first.getAttribute('name'), equals('Citizen Two'));

      transaction.undo();
      expect(citizens.length, equals(1));
      expect(citizens.first.getAttribute('name'), equals('Citizen One'));
    });
  });
}
