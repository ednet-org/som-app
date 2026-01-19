import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_test/dart_frog_test.dart';
import 'package:test/test.dart';

import 'package:som_api/infrastructure/clock.dart';
import 'package:som_api/services/rate_limit_middleware.dart';

class TestClock extends Clock {
  TestClock(this._now);
  DateTime _now;

  @override
  DateTime nowUtc() => _now;

  void advance(Duration delta) {
    _now = _now.add(delta);
  }
}

void main() {
  group('rateLimitMiddleware', () {
    test('blocks after limit reached', () async {
      final clock = TestClock(DateTime.utc(2026, 1, 1));
      final limiter = RateLimiter(clock: clock);
      final policy = RateLimitPolicy(
        rules: [
          RateLimitRule(
            name: 'login',
            limit: 2,
            window: const Duration(minutes: 1),
            matches: (context) =>
                context.request.method == HttpMethod.post &&
                context.request.uri.path == '/auth/login',
          ),
        ],
      );
      final handler = rateLimitMiddleware()((_) async => Response());

      Future<Response> request() async {
        final context = TestRequestContext(
          path: '/auth/login',
          method: HttpMethod.post,
          headers: const {'x-forwarded-for': '127.0.0.1'},
        );
        context.provide<RateLimiter>(limiter);
        context.provide<RateLimitPolicy>(policy);
        return handler(context.context);
      }

      final first = await request();
      expect(first.statusCode, 200);
      final second = await request();
      expect(second.statusCode, 200);
      final third = await request();
      expect(third.statusCode, 429);
      expect(third.headers['Retry-After'], isNotNull);
    });

    test('limits only when rule matches', () async {
      final clock = TestClock(DateTime.utc(2026, 1, 1));
      final limiter = RateLimiter(clock: clock);
      final policy = RateLimitPolicy(
        rules: [
          RateLimitRule(
            name: 'csv-export',
            limit: 1,
            window: const Duration(minutes: 1),
            matches: (context) =>
                context.request.method == HttpMethod.get &&
                context.request.uri.path == '/inquiries' &&
                context.request.uri.queryParameters['format'] == 'csv',
          ),
        ],
      );
      final handler = rateLimitMiddleware()((_) async => Response());

      final csvContext = TestRequestContext(
        path: '/inquiries?format=csv',
        method: HttpMethod.get,
        headers: const {'x-forwarded-for': '127.0.0.1'},
      );
      csvContext.provide<RateLimiter>(limiter);
      csvContext.provide<RateLimitPolicy>(policy);
      final csvFirst = await handler(csvContext.context);
      expect(csvFirst.statusCode, 200);

      final csvSecond = await handler(csvContext.context);
      expect(csvSecond.statusCode, 429);

      final normalContext = TestRequestContext(
        path: '/inquiries',
        method: HttpMethod.get,
        headers: const {'x-forwarded-for': '127.0.0.1'},
      );
      normalContext.provide<RateLimiter>(limiter);
      normalContext.provide<RateLimitPolicy>(policy);
      final normalResponse = await handler(normalContext.context);
      expect(normalResponse.statusCode, 200);
    });
  });
}
