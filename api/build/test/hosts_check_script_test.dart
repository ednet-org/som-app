import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('hosts check script exists and targets local domains', () {
    final script = File('../scripts/ensure_hosts.sh');
    expect(script.existsSync(), isTrue);
    final content = script.readAsStringSync();
    expect(content.contains('som.localhost'), isTrue);
    expect(content.contains('tenant.localhost'), isTrue);
    expect(content.contains('/etc/hosts'), isTrue);
  });
}
