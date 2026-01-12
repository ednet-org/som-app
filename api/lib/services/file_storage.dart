import 'dart:io';

import 'package:path/path.dart' as p;

class FileStorage {
  FileStorage({String? basePath}) : _basePath = basePath ?? _defaultBasePath();

  final String _basePath;

  static String _defaultBasePath() {
    final base = Directory.current.path;
    return p.join(base, 'storage', 'uploads');
  }

  Future<String> saveFile({required String category, required String fileName, required List<int> bytes}) async {
    final dir = Directory(p.join(_basePath, category));
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    final filePath = p.join(dir.path, safeName);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }
}
