import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/services/cors_middleware.dart';

void main() {
  group('corsHeaders', () {
    test('allows configured origin', () async {
      final handler = corsHeaders(
        options: CorsOptions(
          allowedOrigins: const ['http://app.test'],
          allowCredentials: true,
        ),
      )((_) async => Response());

      final context = TestRequestContext(
        path: '/',
        method: HttpMethod.get,
        headers: const {'origin': 'http://app.test'},
      );

      final response = await handler(context.context);
      expect(response.statusCode, 200);
      expect(response.headers['Access-Control-Allow-Origin'], 'http://app.test');
      expect(response.headers['Access-Control-Allow-Credentials'], 'true');
      expect(response.headers['Vary'], contains('Origin'));
    });

    test('rejects disallowed origin on preflight', () async {
      final handler = corsHeaders(
        options: CorsOptions(
          allowedOrigins: const ['http://app.test'],
        ),
      )((_) async => Response());

      final context = TestRequestContext(
        path: '/',
        method: HttpMethod.options,
        headers: const {'origin': 'http://evil.test'},
      );

      final response = await handler(context.context);
      expect(response.statusCode, 403);
    });

    test('handles preflight for allowed origin', () async {
      final handler = corsHeaders(
        options: CorsOptions(
          allowedOrigins: const ['http://app.test'],
        ),
      )((_) async => Response());

      final context = TestRequestContext(
        path: '/',
        method: HttpMethod.options,
        headers: const {
          'origin': 'http://app.test',
          'access-control-request-method': 'GET',
        },
      );

      final response = await handler(context.context);
      expect(response.statusCode, 204);
      expect(response.headers['Access-Control-Allow-Origin'], 'http://app.test');
    });
  });
}
