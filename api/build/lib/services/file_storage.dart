import 'dart:typed_data';

import 'package:mime/mime.dart';
import 'package:supabase/supabase.dart';

class FileStorage {
  FileStorage({required SupabaseClient client, required String bucket})
      : _client = client,
        _bucket = bucket;

  final SupabaseClient _client;
  final String _bucket;
  bool _bucketEnsured = false;

  Future<String> saveFile({
    required String category,
    required String fileName,
    required List<int> bytes,
  }) async {
    await _ensureBucket();
    final safeName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    final path =
        '$category/${DateTime.now().toUtc().millisecondsSinceEpoch}_$safeName';
    final contentType = lookupMimeType(fileName) ?? 'application/octet-stream';
    try {
      await _client.storage.from(_bucket).uploadBinary(
            path,
            Uint8List.fromList(bytes),
            fileOptions: FileOptions(contentType: contentType),
          );
    } on StorageException catch (error) {
      if (error.statusCode == 404) {
        await _client.storage
            .createBucket(_bucket, const BucketOptions(public: true));
        await _client.storage.from(_bucket).uploadBinary(
              path,
              Uint8List.fromList(bytes),
              fileOptions: FileOptions(contentType: contentType),
            );
      } else {
        rethrow;
      }
    }
    return _client.storage.from(_bucket).getPublicUrl(path);
  }

  Future<void> _ensureBucket() async {
    if (_bucketEnsured) {
      return;
    }
    try {
      await _client.storage
          .createBucket(_bucket, const BucketOptions(public: true));
    } on StorageException catch (error) {
      final message = error.message.toLowerCase();
      final alreadyExists =
          error.statusCode == 409 || message.contains('exists');
      if (!alreadyExists && error.statusCode == 404) {
        await _client.from('storage.buckets').insert({
          'id': _bucket,
          'name': _bucket,
          'public': true,
        });
      } else if (!alreadyExists) {
        rethrow;
      }
    }
    _bucketEnsured = true;
  }
}
