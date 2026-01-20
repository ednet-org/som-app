import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('privileged storage RLS script and SQL exist', () {
    final sqlFile = File('../supabase/privileged/storage_rls.sql');
    expect(sqlFile.existsSync(), isTrue);
    final sql = sqlFile.readAsStringSync();
    expect(sql.contains('alter table storage.objects enable row level security'),
        isTrue);

    final script = File('../scripts/apply_storage_rls.sh');
    expect(script.existsSync(), isTrue);
    final scriptText = script.readAsStringSync();
    expect(scriptText.contains('docker exec'), isTrue);
    expect(scriptText.contains('storage_rls.sql'), isTrue);
  });
}
