import 'package:dart_frog/dart_frog.dart';

class SecurityHeadersOptions {
  const SecurityHeadersOptions({
    this.enableHsts = false,
    this.hstsMaxAgeSeconds = 31536000,
    this.hstsIncludeSubDomains = true,
    this.contentSecurityPolicy = "default-src 'none'; frame-ancestors 'none';",
    this.referrerPolicy = 'no-referrer',
    this.permissionsPolicy =
        'camera=(), microphone=(), geolocation=(), interest-cohort=()',
    this.frameOptions = 'DENY',
    this.contentTypeOptions = 'nosniff',
  });

  factory SecurityHeadersOptions.fromEnvironment() {
    final enableHsts =
        const bool.fromEnvironment('ENABLE_HSTS', defaultValue: false);
    final hstsMaxAgeSeconds = int.tryParse(
            const String.fromEnvironment('HSTS_MAX_AGE_SECONDS')) ??
        31536000;
    final csp = const String.fromEnvironment(
      'API_CSP',
      defaultValue: "default-src 'none'; frame-ancestors 'none';",
    );
    return SecurityHeadersOptions(
      enableHsts: enableHsts,
      hstsMaxAgeSeconds: hstsMaxAgeSeconds,
      contentSecurityPolicy: csp,
    );
  }

  final bool enableHsts;
  final int hstsMaxAgeSeconds;
  final bool hstsIncludeSubDomains;
  final String contentSecurityPolicy;
  final String referrerPolicy;
  final String permissionsPolicy;
  final String frameOptions;
  final String contentTypeOptions;
}

Middleware securityHeaders({SecurityHeadersOptions? options}) {
  final resolved = options ?? SecurityHeadersOptions.fromEnvironment();
  return (handler) {
    return (context) async {
      final response = await handler(context);
      final headers = <String, String>{
        'X-Content-Type-Options': resolved.contentTypeOptions,
        'X-Frame-Options': resolved.frameOptions,
        'Referrer-Policy': resolved.referrerPolicy,
        'Permissions-Policy': resolved.permissionsPolicy,
        'Content-Security-Policy': resolved.contentSecurityPolicy,
      };
      if (resolved.enableHsts) {
        final includeSubdomains =
            resolved.hstsIncludeSubDomains ? '; includeSubDomains' : '';
        headers['Strict-Transport-Security'] =
            'max-age=${resolved.hstsMaxAgeSeconds}$includeSubdomains';
      }
      return response.copyWith(headers: {
        ...response.headers,
        ...headers,
      });
    };
  };
}
