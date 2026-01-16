import 'package:test/test.dart';

import 'package:som_api/services/schema_version_service.dart';
import 'test_utils.dart';

void main() {
  group('SchemaVersionService', () {
    test('passes when schema version matches', () async {
      final repo = InMemorySchemaVersionRepository(version: 1);
      final service = SchemaVersionService(repository: repo);

      await service.ensureVersion();
    });

    test('throws when schema version is missing or mismatched', () async {
      final repo = InMemorySchemaVersionRepository(version: null);
      final service = SchemaVersionService(repository: repo);

      expect(service.ensureVersion(), throwsA(isA<StateError>()));
    });
  });
}
