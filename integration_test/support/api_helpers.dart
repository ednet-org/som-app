import 'dart:async';

import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

import 'test_env.dart';

Openapi buildApi({String? baseUrl}) {
  return Openapi(
    dio: Dio(BaseOptions(baseUrl: baseUrl ?? TestEnv.apiBaseUrl)),
    serializers: standardSerializers,
  );
}

Map<String, String> authHeader(String token) => {
      'Authorization': 'Bearer $token',
    };

Future<T> withRetry<T>(
  Future<T> Function() action, {
  int retries = 5,
  Duration delay = const Duration(milliseconds: 500),
}) async {
  Object? lastError;
  for (var attempt = 0; attempt < retries; attempt++) {
    try {
      return await action();
    } catch (error) {
      lastError = error;
      await Future<void>.delayed(delay);
    }
  }
  Error.throwWithStackTrace(lastError ?? StateError('Retry failed'), StackTrace.current);
}

Future<String> login(
  Openapi api,
  String email,
  String password, {
  int retries = 5,
}) async {
  return withRetry(
    () async {
      final auth = api.getAuthApi();
      final request = AuthLoginPostRequestBuilder()
        ..email = email
        ..password = password;
      final result = await auth.authLoginPost(
        authLoginPostRequest: request.build(),
      );
      final token = result.data?.token;
      if (token == null || token.isEmpty) {
        throw StateError('Login did not return a token for $email');
      }
      return token;
    },
    retries: retries,
  );
}
