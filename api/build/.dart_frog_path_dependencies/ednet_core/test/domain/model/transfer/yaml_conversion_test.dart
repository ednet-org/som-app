import 'package:test/test.dart';
import 'package:yaml/yaml.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('YAML to Map Conversion Tests', () {
    test('should convert YamlMap to Map<String, dynamic>', () {
      // Red: Create a failing test
      const yamlString = '''
validation:
  required: true
  minLength: 5
  pattern: "^[a-zA-Z]+\$"
''';

      final yamlDoc = loadYaml(yamlString);
      final yamlMap = yamlDoc['validation'];

      // This should not throw an exception
      expect(() {
        final converted = convertYamlToMap(yamlMap);
        expect(converted, isA<Map<String, dynamic>>());
        expect(converted!['required'], isTrue);
        expect(converted['minLength'], equals(5));
        expect(converted['pattern'], equals('^[a-zA-Z]+\$'));
      }, returnsNormally);
    });

    test('should return null for null input', () {
      expect(convertYamlToMap(null), isNull);
    });
  });
}
