import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/services/security_headers.dart';

void main() {
  group('securityHeaders', () {
    test('adds standard security headers', () async {
      final handler = securityHeaders(
        options: const SecurityHeadersOptions(
          enableHsts: true,
        ),
      )((_) async => Response());

      final context = TestRequestContext(path: '/', method: HttpMethod.get);
      final response = await handler(context.context);

      expect(response.headers['X-Content-Type-Options'], 'nosniff');
      expect(response.headers['X-Frame-Options'], 'DENY');
      expect(response.headers['Referrer-Policy'], isNotEmpty);
      expect(response.headers['Permissions-Policy'], isNotEmpty);
      expect(response.headers['Strict-Transport-Security'], isNotEmpty);
      expect(response.headers['Content-Security-Policy'], isNotEmpty);
    });
  });
}
