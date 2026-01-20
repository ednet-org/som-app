import 'package:mime/mime.dart';

const int maxPdfBytes = 10 * 1024 * 1024; // 10 MB

String? validatePdfUpload({
  required String fileName,
  required List<int> bytes,
}) {
  if (bytes.isEmpty) {
    return 'File is empty.';
  }
  if (bytes.length > maxPdfBytes) {
    return 'PDF exceeds maximum size of 10MB.';
  }
  final mimeType = lookupMimeType(fileName, headerBytes: bytes);
  if (mimeType != 'application/pdf') {
    return 'Only PDF files are allowed.';
  }
  return null;
}
