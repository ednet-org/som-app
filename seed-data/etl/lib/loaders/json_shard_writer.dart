/// JSON file writer.
/// Writes business entities to a single JSON file.
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../models/business_entity.dart';

/// Result of writing the output file.
class OutputFileInfo {
  OutputFileInfo({
    required this.filename,
    required this.sizeBytes,
    required this.recordCount,
    required this.sha256Hash,
  });

  final String filename;
  final int sizeBytes;
  final int recordCount;
  final String sha256Hash;

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'size_bytes': sizeBytes,
        'record_count': recordCount,
        'sha256': sha256Hash,
      };
}

/// Writes entities to a single JSON file.
class JsonFileWriter {
  JsonFileWriter({
    required this.outputDir,
    this.filename = 'businesses.json',
    this.prettyPrint = true,
  });

  final String outputDir;
  final String filename;
  final bool prettyPrint;

  /// Write all entities to a single JSON file.
  Future<OutputFileInfo> write(List<BusinessEntity> entities) async {
    // Ensure output directory exists
    final dir = Directory(outputDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final filepath = '$outputDir/$filename';

    // Encode JSON (pretty print for readability)
    final encoder = prettyPrint
        ? const JsonEncoder.withIndent('  ')
        : const JsonEncoder();
    final json = encoder.convert(entities.map((e) => e.toJson()).toList());
    final bytes = utf8.encode(json);

    // Calculate hash
    final hash = sha256.convert(bytes).toString();

    // Write file
    final file = File(filepath);
    await file.writeAsString(json);

    return OutputFileInfo(
      filename: filename,
      sizeBytes: bytes.length,
      recordCount: entities.length,
      sha256Hash: hash,
    );
  }
}
