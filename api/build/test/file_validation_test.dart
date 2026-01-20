import 'package:test/test.dart';
import 'package:som_api/services/file_validation.dart';

void main() {
  test('validatePdfUpload rejects oversized files', () {
    final bytes = List<int>.filled(maxPdfBytes + 1, 0);
    final error = validatePdfUpload(fileName: 'test.pdf', bytes: bytes);
    expect(error, isNotNull);
  });
}
