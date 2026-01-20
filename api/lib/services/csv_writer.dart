class CsvWriter {
  CsvWriter({String separator = ','}) : _separator = separator;

  final String _separator;
  final StringBuffer _buffer = StringBuffer();

  void writeRow(List<Object?> values) {
    for (var i = 0; i < values.length; i++) {
      if (i > 0) {
        _buffer.write(_separator);
      }
      _buffer.write(_escape(values[i]));
    }
    _buffer.write('\n');
  }

  @override
  String toString() => _buffer.toString();

  String _escape(Object? value) {
    if (value == null) {
      return '""';
    }
    final text = value.toString();
    final needsQuotes = text.contains(_separator) ||
        text.contains('"') ||
        text.contains('\n') ||
        text.contains('\r');
    if (!needsQuotes) {
      return text;
    }
    final escaped = text.replaceAll('"', '""');
    return '"$escaped"';
  }
}
