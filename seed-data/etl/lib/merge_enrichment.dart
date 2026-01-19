import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

class MergeResult {
  MergeResult({
    required this.records,
    required this.inputFiles,
    required this.inputRows,
    required this.skippedRows,
  });

  final List<Map<String, dynamic>> records;
  final int inputFiles;
  final int inputRows;
  final int skippedRows;
}

Future<MergeResult> mergeEnrichmentDirectory(
  Directory directory, {
  List<Pattern> excludePatterns = const [],
}) async {
  if (!directory.existsSync()) {
    throw ArgumentError('Directory does not exist: ${directory.path}');
  }
  final files = _listJsonlFiles(directory, excludePatterns: excludePatterns);
  return mergeEnrichmentFiles(files);
}

Future<MergeResult> mergeEnrichmentFiles(
  List<File> files,
) async {
  final orderedFiles = [...files]..sort((a, b) => a.path.compareTo(b.path));
  final bestByCompany = <String, Map<String, dynamic>>{};
  var inputRows = 0;
  var skippedRows = 0;

  for (final file in orderedFiles) {
    if (!file.existsSync()) {
      continue;
    }
    await for (final line in file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      if (line.trim().isEmpty) {
        continue;
      }
      inputRows += 1;
      Map<String, dynamic> data;
      try {
        final decoded = jsonDecode(line);
        if (decoded is! Map<String, dynamic>) {
          skippedRows += 1;
          continue;
        }
        data = decoded;
      } catch (_) {
        skippedRows += 1;
        continue;
      }

      final companyId = data['companyId'] as String?;
      if (companyId == null || companyId.isEmpty) {
        skippedRows += 1;
        continue;
      }

      final existing = bestByCompany[companyId];
      if (existing == null || _isBetterRecord(data, existing)) {
        bestByCompany[companyId] = data;
      }
    }
  }

  final records = bestByCompany.values.map(_orderedRecord).toList()
    ..sort((a, b) {
      final aId = (a['companyId'] ?? '').toString();
      final bId = (b['companyId'] ?? '').toString();
      return aId.compareTo(bId);
    });

  return MergeResult(
    records: records,
    inputFiles: orderedFiles.length,
    inputRows: inputRows,
    skippedRows: skippedRows,
  );
}

Future<void> writeMergedJsonl(
  List<Map<String, dynamic>> records,
  File output,
) async {
  output.parent.createSync(recursive: true);
  final sink = output.openWrite();
  for (final record in records) {
    sink.writeln(jsonEncode(record));
  }
  await sink.flush();
  await sink.close();
}

List<File> _listJsonlFiles(
  Directory directory, {
  List<Pattern> excludePatterns = const [],
}) {
  final files = <File>[];
  for (final entry in directory.listSync(followLinks: false)) {
    if (entry is! File) continue;
    if (!entry.path.endsWith('.jsonl')) continue;
    final name = p.basename(entry.path);
    if (_matchesAny(name, excludePatterns)) {
      continue;
    }
    files.add(entry);
  }
  return files;
}

bool _matchesAny(String value, List<Pattern> patterns) {
  for (final pattern in patterns) {
    if (pattern is RegExp) {
      if (pattern.hasMatch(value)) return true;
    } else if (value.contains(pattern.toString())) {
      return true;
    }
  }
  return false;
}

bool _isBetterRecord(
  Map<String, dynamic> candidate,
  Map<String, dynamic> existing,
) {
  var comparison = _compareDesc(
    _asDouble(candidate['avgCategoryConfidence']),
    _asDouble(existing['avgCategoryConfidence']),
  );
  if (comparison != 0) return comparison > 0;

  comparison = _compareDesc(
    _asDouble(candidate['branchConfidence']),
    _asDouble(existing['branchConfidence']),
  );
  if (comparison != 0) return comparison > 0;

  comparison = _compareDesc(
    _asInt(candidate['newCategoryCount']),
    _asInt(existing['newCategoryCount']),
  );
  if (comparison != 0) return comparison > 0;

  comparison = _compareDescDate(
    _asDate(candidate['createdAt']),
    _asDate(existing['createdAt']),
  );
  return comparison > 0;
}

int _compareDesc(num a, num b) => a.compareTo(b);

int _compareDescDate(DateTime a, DateTime b) => a.compareTo(b);

double _asDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? -1;
  return -1;
}

int _asInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value) ?? -1;
  return -1;
}

DateTime _asDate(Object? value) {
  if (value is DateTime) return value.toUtc();
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.toUtc();
  }
  if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  }
  return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

Map<String, dynamic> _orderedRecord(Map<String, dynamic> record) {
  final ordered = LinkedHashMap<String, dynamic>();
  const preferredKeys = [
    'companyId',
    'companyName',
    'website',
    'providerType',
    'branch',
    'branchId',
    'branchStatus',
    'branchConfidence',
    'categoryIds',
    'existingCategoryCount',
    'newCategoryCount',
    'avgCategoryConfidence',
    'raw',
    'createdAt',
  ];

  for (final key in preferredKeys) {
    if (record.containsKey(key)) {
      ordered[key] = record[key];
    }
  }
  for (final entry in record.entries) {
    if (!ordered.containsKey(entry.key)) {
      ordered[entry.key] = entry.value;
    }
  }
  return ordered;
}
