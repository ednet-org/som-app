import 'package:ednet_core/ednet_core.dart';
import 'package:test/test.dart';

void main() {
  group('ConceptMetadataChangedEvent', () {
    test('serializes concept metadata details', () {
      final domain = Domain('TestDomain');
      final model = Model(domain, 'TestModel');
      final concept = Concept(model, 'Product')
        ..metadata['label'] = 'Product';
      Attribute(concept, 'name');

      final event = ConceptMetadataChangedEvent(
        concept: concept,
        previousMetadata: const {'label': 'Old'},
      );

      final json = event.toJson();

      expect(event.conceptCode, 'Product');
      expect(json['conceptCode'], 'Product');
      expect(json['previousMetadata'], containsPair('label', 'Old'));
      expect(
        (json['attributeCodes'] as List<dynamic>).cast<String>(),
        contains('name'),
      );
    });
  });
}
