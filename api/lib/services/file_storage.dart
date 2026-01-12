import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:supabase/supabase.dart';

class FileStorage {
  FileStorage({required SupabaseClient client, required String bucket})
      : _client = client,
        _bucket = bucket;

  final SupabaseClient _client;
  final String _bucket;

  Future<String> saveFile({
    required String category,
    required String fileName,
    required List<int> bytes,
  }) async {
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    final path = '$category/${DateTime.now().toUtc().millisecondsSinceEpoch}_$safeName';
    final contentType = lookupMimeType(fileName) ?? 'application/octet-stream';
    await _client.storage.from(_bucket).uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: FileOptions(contentType: contentType),
        );
    return _client.storage.from(_bucket).getPublicUrl(path);
  }
}
