import 'test/mocks/ednet_democracy_domain.dart';

void main() {
  print('=== Debug Validation Test ===');

  final domain = EDNetDemocracyDomain();

  // Create citizen without required attributes
  final invalidCitizen = Citizen();
  invalidCitizen.concept = domain.citizenConcept;

  print('Created citizen with concept: ${invalidCitizen.concept.code}');
  print(
    'Citizen name: "${invalidCitizen.getAttribute('name')}" (null: ${invalidCitizen.getAttribute('name') == null})',
  );
  print(
    'Citizen email: "${invalidCitizen.getAttribute('email')}" (null: ${invalidCitizen.getAttribute('email') == null})',
  );
  print(
    'Citizen idNumber: "${invalidCitizen.getAttribute('idNumber')}" (null: ${invalidCitizen.getAttribute('idNumber') == null})',
  );

  // Check collection setup
  final citizens = domain.citizens;
  print('Citizens collection concept: ${citizens.concept.code}');
  print('Citizens collection pre validation: ${citizens.pre}');
  print('Citizens collection post validation: ${citizens.post}');

  // Clear any existing exceptions
  citizens.exceptions.clear();
  print('Initial exceptions count: ${citizens.exceptions.length}');

  // Try to add invalid entity
  print('Adding invalid citizen...');
  final added = citizens.add(invalidCitizen);

  print('Entity was added: $added');
  print('Collection size: ${citizens.length}');
  print('Collection isEmpty: ${citizens.isEmpty}');
  print('Exceptions count: ${citizens.exceptions.length}');

  if (citizens.exceptions.length > 0) {
    print('Validation exceptions:');
    print('  - ${citizens.exceptions.toString()}');
  }
}
