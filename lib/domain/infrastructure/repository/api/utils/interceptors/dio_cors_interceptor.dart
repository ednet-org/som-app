import 'package:dio/dio.dart';

class CorsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Access-Control-Allow-Origin'] = '*';
    return handler.next(options);
  }
}
