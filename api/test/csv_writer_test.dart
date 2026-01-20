import 'package:test/test.dart';

import 'package:som_api/services/csv_writer.dart';

void main() {
  group('CsvWriter', () {
    test('escapes commas quotes and newlines', () {
      final writer = CsvWriter();
      writer.writeRow(['plain', 'a,b', 'he"llo', 'line\nbreak', null]);

      expect(
        writer.toString(),
        'plain,"a,b","he""llo","line\nbreak",""\n',
      );
    });
  });
}
