import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('RLS migration enables policies for core tables', () {
    final file = File(
      '../supabase/migrations/20260120002000_rls_policies.sql',
    );
    expect(file.existsSync(), isTrue);
    final content = file.readAsStringSync();
    const tables = [
      'companies',
      'users',
      'inquiries',
      'offers',
      'ads',
      'storage.objects',
    ];
    for (final table in tables) {
      final normalized = table.contains('.') ? table : 'public.$table';
      expect(
        content.contains(
              'alter table $table enable row level security',
            ) ||
            content.contains(
              'alter table $normalized enable row level security',
            ),
        isTrue,
      );
    }
  });
}
