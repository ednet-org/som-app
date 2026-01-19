import 'dart:io';

import 'package:etl/merge_enrichment.dart';
import 'package:test/test.dart';

void main() {
  test('merge picks best record and sorts by companyId', () async {
    final tempDir = await Directory.systemTemp.createTemp('enrich_merge_test_');
    addTearDown(() => tempDir.delete(recursive: true));

    final fileA = File('${tempDir.path}/part_a.jsonl');
    final fileB = File('${tempDir.path}/part_b.jsonl');

    await fileA.writeAsString('''
{"companyId":"b","avgCategoryConfidence":0.4,"branchConfidence":0.5,"newCategoryCount":1,"createdAt":"2026-01-01T00:00:00Z"}
{"companyId":"a","avgCategoryConfidence":0.9,"branchConfidence":0.2,"newCategoryCount":1,"createdAt":"2026-01-01T00:00:00Z"}
''');

    await fileB.writeAsString('''
{"companyId":"b","avgCategoryConfidence":0.4,"branchConfidence":0.7,"newCategoryCount":1,"createdAt":"2026-01-02T00:00:00Z"}
''');

    final result = await mergeEnrichmentDirectory(tempDir);

    expect(result.records.length, 2);
    expect(result.records.first['companyId'], 'a');
    expect(result.records.last['companyId'], 'b');
    expect(result.records.last['branchConfidence'], 0.7);
  });

  test('merge uses newCategoryCount and createdAt as tie-breakers', () async {
    final tempDir = await Directory.systemTemp.createTemp('enrich_merge_test_');
    addTearDown(() => tempDir.delete(recursive: true));

    final fileA = File('${tempDir.path}/part_a.jsonl');
    final fileB = File('${tempDir.path}/part_b.jsonl');

    await fileA.writeAsString('''
{"companyId":"c","avgCategoryConfidence":0.5,"branchConfidence":0.6,"newCategoryCount":1,"createdAt":"2026-01-01T00:00:00Z"}
{"companyId":"c","avgCategoryConfidence":0.5,"branchConfidence":0.6,"newCategoryCount":2,"createdAt":"2026-01-01T00:00:00Z"}
''');

    await fileB.writeAsString('''
{"companyId":"c","avgCategoryConfidence":0.5,"branchConfidence":0.6,"newCategoryCount":2,"createdAt":"2026-01-02T00:00:00Z"}
''');

    final result = await mergeEnrichmentDirectory(tempDir);

    expect(result.records.length, 1);
    expect(result.records.first['createdAt'], '2026-01-02T00:00:00Z');
  });
}
