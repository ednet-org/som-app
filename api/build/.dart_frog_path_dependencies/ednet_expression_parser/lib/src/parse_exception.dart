/// Exception thrown during expression parsing
class ParseException implements Exception {
  final String message;
  final String? source;
  final int? position;

  ParseException(this.message, {this.source, this.position});

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('ParseException: $message');

    if (source != null) {
      buffer.write('\nSource: $source');
    }

    if (position != null) {
      buffer.write('\nPosition: $position');
    }

    return buffer.toString();
  }
}
