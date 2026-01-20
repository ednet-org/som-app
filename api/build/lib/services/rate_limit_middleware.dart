import 'package:dart_frog/dart_frog.dart';

import '../infrastructure/clock.dart';

class RateLimitRule {
  RateLimitRule({
    required this.name,
    required this.limit,
    required this.window,
    required this.matches,
    this.keyBuilder,
  });

  final String name;
  final int limit;
  final Duration window;
  final bool Function(RequestContext context) matches;
  final String Function(RequestContext context)? keyBuilder;

  String resolveKey(RequestContext context) {
    final builder = keyBuilder;
    if (builder != null) {
      return builder(context);
    }
    return _defaultKeyBuilder(context);
  }
}

class RateLimitPolicy {
  RateLimitPolicy({required this.rules});

  factory RateLimitPolicy.fromEnvironment() {
    final loginLimit =
        int.tryParse(const String.fromEnvironment('RATE_LIMIT_LOGIN')) ?? 10;
    final loginWindowMinutes = int.tryParse(
            const String.fromEnvironment('RATE_LIMIT_LOGIN_WINDOW_MINUTES')) ??
        5;
    final resetLimit =
        int.tryParse(const String.fromEnvironment('RATE_LIMIT_RESET')) ?? 5;
    final resetWindowMinutes = int.tryParse(
            const String.fromEnvironment('RATE_LIMIT_RESET_WINDOW_MINUTES')) ??
        15;
    final pdfLimit =
        int.tryParse(const String.fromEnvironment('RATE_LIMIT_PDF')) ?? 60;
    final pdfWindowMinutes = int.tryParse(
            const String.fromEnvironment('RATE_LIMIT_PDF_WINDOW_MINUTES')) ??
        1;
    final exportLimit =
        int.tryParse(const String.fromEnvironment('RATE_LIMIT_EXPORT')) ?? 20;
    final exportWindowMinutes = int.tryParse(
            const String.fromEnvironment('RATE_LIMIT_EXPORT_WINDOW_MINUTES')) ??
        1;

    return RateLimitPolicy(
      rules: [
        RateLimitRule(
          name: 'auth-login',
          limit: loginLimit,
          window: Duration(minutes: loginWindowMinutes),
          matches: (context) =>
              context.request.method == HttpMethod.post &&
              context.request.uri.path == '/auth/login',
        ),
        RateLimitRule(
          name: 'auth-forgot',
          limit: resetLimit,
          window: Duration(minutes: resetWindowMinutes),
          matches: (context) =>
              context.request.method == HttpMethod.post &&
              context.request.uri.path == '/auth/forgotPassword',
        ),
        RateLimitRule(
          name: 'auth-reset',
          limit: resetLimit,
          window: Duration(minutes: resetWindowMinutes),
          matches: (context) =>
              context.request.method == HttpMethod.post &&
              context.request.uri.path == '/auth/resetPassword',
        ),
        RateLimitRule(
          name: 'pdf-download',
          limit: pdfLimit,
          window: Duration(minutes: pdfWindowMinutes),
          matches: (context) {
            if (context.request.method != HttpMethod.get) return false;
            final path = context.request.uri.path;
            return path.endsWith('/pdf') &&
                (path.startsWith('/inquiries/') ||
                    path.startsWith('/offers/'));
          },
        ),
        RateLimitRule(
          name: 'csv-export',
          limit: exportLimit,
          window: Duration(minutes: exportWindowMinutes),
          matches: (context) {
            if (context.request.method != HttpMethod.get) return false;
            return context.request.uri.queryParameters['format'] == 'csv';
          },
        ),
      ],
    );
  }

  final List<RateLimitRule> rules;

  RateLimitRule? match(RequestContext context) {
    for (final rule in rules) {
      if (rule.matches(context)) {
        return rule;
      }
    }
    return null;
  }
}

class RateLimitDecision {
  RateLimitDecision.allowed() : allowed = true, retryAfterSeconds = null;

  RateLimitDecision.blocked(this.retryAfterSeconds) : allowed = false;

  final bool allowed;
  final int? retryAfterSeconds;
}

class RateLimiter {
  RateLimiter({Clock? clock}) : _clock = clock ?? const Clock();

  final Clock _clock;
  final Map<String, _RateLimitEntry> _entries = {};

  RateLimitDecision check(String key, RateLimitRule rule) {
    if (rule.limit <= 0 || rule.window.inSeconds <= 0) {
      return RateLimitDecision.allowed();
    }
    final now = _clock.nowUtc();
    final entry = _entries[key];
    if (entry == null ||
        now.difference(entry.windowStart) >= rule.window) {
      _entries[key] = _RateLimitEntry(windowStart: now, count: 1);
      return RateLimitDecision.allowed();
    }
    if (entry.count < rule.limit) {
      entry.count += 1;
      return RateLimitDecision.allowed();
    }
    final retryAfter = rule.window - now.difference(entry.windowStart);
    final seconds = retryAfter.inSeconds <= 0 ? 1 : retryAfter.inSeconds;
    return RateLimitDecision.blocked(seconds);
  }
}

class _RateLimitEntry {
  _RateLimitEntry({required this.windowStart, required this.count});

  DateTime windowStart;
  int count;
}

Middleware rateLimitMiddleware({
  RateLimiter? limiter,
  RateLimitPolicy? policy,
}) {
  return (handler) {
    return (context) async {
      final resolvedLimiter = limiter ?? context.read<RateLimiter>();
      final resolvedPolicy = policy ?? context.read<RateLimitPolicy>();
      final rule = resolvedPolicy.match(context);
      if (rule == null) {
        return handler(context);
      }
      final key = '${rule.name}:${rule.resolveKey(context)}';
      final decision = resolvedLimiter.check(key, rule);
      if (!decision.allowed) {
        return Response.json(
          statusCode: 429,
          headers: {
            if (decision.retryAfterSeconds != null)
              'Retry-After': decision.retryAfterSeconds.toString(),
          },
          body: 'Too many requests. Please try again later.',
        );
      }
      return handler(context);
    };
  };
}

String _defaultKeyBuilder(RequestContext context) {
  final auth = context.request.headers['authorization'];
  if (auth != null && auth.startsWith('Bearer ')) {
    return auth.substring(7);
  }
  final forwarded = context.request.headers['x-forwarded-for'];
  if (forwarded != null && forwarded.trim().isNotEmpty) {
    return forwarded.split(',').first.trim();
  }
  return 'anonymous';
}
