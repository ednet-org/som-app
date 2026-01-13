import 'package:dio/dio.dart';

import '../../application/application.dart';

class AuthTokenInterceptor extends Interceptor {
  final Application appStore;

  AuthTokenInterceptor(this.appStore);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = appStore.authorization?.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
