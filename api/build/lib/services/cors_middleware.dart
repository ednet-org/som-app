import 'package:dart_frog/dart_frog.dart';

class CorsOptions {
  const CorsOptions({
    required this.allowedOrigins,
    this.allowCredentials = false,
    this.allowedMethods = const ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    this.allowedHeaders = const [
      'Origin',
      'Content-Type',
      'Authorization',
      'Accept',
      'X-Requested-With',
      'Access-Control-Allow-Origin',
      'apikey',
      'x-api-key',
    ],
    this.maxAgeSeconds = 86400,
  });

  factory CorsOptions.fromEnvironment() {
    const originsEnv =
        String.fromEnvironment('CORS_ALLOWED_ORIGINS', defaultValue: '*');
    final allowCredentials =
        const bool.fromEnvironment('CORS_ALLOW_CREDENTIALS', defaultValue: false);
    final allowedOrigins = _parseOrigins(originsEnv);
    return CorsOptions(
      allowedOrigins: allowedOrigins,
      allowCredentials: allowCredentials,
    );
  }

  final List<String> allowedOrigins;
  final bool allowCredentials;
  final List<String> allowedMethods;
  final List<String> allowedHeaders;
  final int maxAgeSeconds;

  bool isOriginAllowed(String? origin) {
    if (allowedOrigins.contains('*')) {
      return true;
    }
    if (origin == null || origin.isEmpty) {
      return false;
    }
    return allowedOrigins.contains(origin);
  }

  Map<String, String> headersForOrigin(String? origin) {
    final allowAny = allowedOrigins.contains('*');
    final allowOrigin = allowAny && !allowCredentials
        ? '*'
        : (origin ?? allowedOrigins.first);
    return {
      'Access-Control-Allow-Origin': allowOrigin,
      'Access-Control-Allow-Methods': allowedMethods.join(','),
      'Access-Control-Allow-Headers': allowedHeaders.join(', '),
      'Access-Control-Max-Age': maxAgeSeconds.toString(),
      if (allowCredentials) 'Access-Control-Allow-Credentials': 'true',
      if (!allowAny) 'Vary': 'Origin',
    };
  }
}

Middleware corsHeaders({CorsOptions? options}) {
  final resolved = options ?? CorsOptions.fromEnvironment();
  return (handler) {
    return (context) async {
      final origin = context.request.headers['origin'];
      final isAllowed = resolved.isOriginAllowed(origin);
      if (context.request.method == HttpMethod.options) {
        if (!isAllowed) {
          return Response(statusCode: 403);
        }
        return Response(
          statusCode: 204,
          headers: resolved.headersForOrigin(origin),
        );
      }
      final response = await handler(context);
      if (origin != null && origin.isNotEmpty && !isAllowed) {
        return response;
      }
      return response.copyWith(
        headers: {
          ...response.headers,
          ...resolved.headersForOrigin(origin),
        },
      );
    };
  };
}

List<String> _parseOrigins(String origins) {
  final trimmed = origins.trim();
  if (trimmed.isEmpty) {
    return const ['*'];
  }
  if (trimmed == '*') {
    return const ['*'];
  }
  return trimmed
      .split(',')
      .map((origin) => origin.trim())
      .where((origin) => origin.isNotEmpty)
      .toList();
}
