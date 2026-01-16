import '../infrastructure/repositories/schema_version_repository.dart';

class SchemaVersionService {
  SchemaVersionService({
    required this.repository,
    this.requiredVersion = 1,
  });

  final SchemaVersionRepository repository;
  final int requiredVersion;
  bool _checked = false;

  Future<void> ensureVersion() async {
    if (_checked) {
      return;
    }
    final version = await repository.getVersion();
    if (version != requiredVersion) {
      throw StateError(
        'Schema version mismatch. Expected $requiredVersion, got ${version ?? 'none'}',
      );
    }
    _checked = true;
  }
}
