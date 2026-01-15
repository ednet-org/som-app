import 'package:dio/dio.dart';

class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Do not send CORS response headers from the client.
    handler.next(options);
  }
}
