import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('schema isolation migration exists and targets som schema', () {
    final file = File(
      '../supabase/migrations/20260120003000_som_schema_isolation.sql',
    );
    expect(file.existsSync(), isTrue);
    final content = file.readAsStringSync();
    expect(content.contains('create schema if not exists som'), isTrue);
    expect(
      content.contains(
        'alter table if exists public.companies set schema som',
      ),
      isTrue,
    );
  });
}
