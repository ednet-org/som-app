import 'package:supabase/supabase.dart';

class SchemaVersionRepository {
  SchemaVersionRepository(this._client);

  final SupabaseClient _client;

  Future<int?> getVersion() async {
    final rows = await _client
        .from('schema_version')
        .select('version')
        .limit(1) as List<dynamic>;
    if (rows.isEmpty) {
      return null;
    }
    final row = rows.first as Map<String, dynamic>;
    final raw = row['version'];
    if (raw is int) {
      return raw;
    }
    return int.tryParse(raw?.toString() ?? '');
  }
}
