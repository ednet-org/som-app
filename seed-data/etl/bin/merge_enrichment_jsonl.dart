import 'dart:io';

import 'package:args/args.dart';
import 'package:etl/merge_enrichment.dart';

Future<void> main(List<String> args) async {
  final parser = ArgParser()
    ..addOption(
      'input-dir',
      defaultsTo: '../out/enrichment_gpt41',
      help: 'Directory with enrichment JSONL files.',
    )
    ..addOption(
      'output',
      defaultsTo: '../out/enrichment_gpt41_merged.jsonl',
      help: 'Output JSONL file.',
    )
    ..addMultiOption(
      'exclude',
      defaultsTo: ['merged', 'full'],
      help: 'Exclude files whose names contain these patterns.',
    )
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Show usage.',
    );

  final results = parser.parse(args);
  if (results['help'] == true) {
    stdout.writeln(
      'Usage: dart run bin/merge_enrichment_jsonl.dart [--input-dir <dir>] '
      '[--output <file>] [--exclude <pattern> ...]',
    );
    stdout.writeln(parser.usage);
    exit(0);
  }

  final inputDir = Directory(results['input-dir'] as String);
  if (!inputDir.existsSync()) {
    stderr.writeln('Input directory not found: ${inputDir.path}');
    exit(1);
  }

  final patterns = (results['exclude'] as List<String>)
      .where((value) => value.trim().isNotEmpty)
      .toList();

  final mergeResult = await mergeEnrichmentDirectory(
    inputDir,
    excludePatterns: patterns,
  );

  final outputFile = File(results['output'] as String);
  await writeMergedJsonl(mergeResult.records, outputFile);

  stdout.writeln('Merged files: ${mergeResult.inputFiles}');
  stdout.writeln('Input rows: ${mergeResult.inputRows}');
  stdout.writeln('Skipped rows: ${mergeResult.skippedRows}');
  stdout.writeln('Output rows: ${mergeResult.records.length}');
  stdout.writeln('Merged JSONL: ${outputFile.path}');
}
