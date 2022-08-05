import 'dart:async';

import 'package:chopper/chopper.dart' as Chopper;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final chopperLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
);

@immutable
class HttpColorLoggingInterceptor
    implements Chopper.RequestInterceptor, Chopper.ResponseInterceptor {
  @override
  FutureOr<Chopper.Request> onRequest(Chopper.Request request) async {
    final base = await request.toBaseRequest();
    chopperLogger.d('--> ${base.method} ${base.url}');
    base.headers.forEach((k, v) => chopperLogger.d('$k: $v'));

    var bytes = '';
    if (base is http.Request) {
      final body = base.body;
      if (body != null && body.isNotEmpty) {
        chopperLogger.d(body);
        bytes = ' (${base.bodyBytes.length}-byte body)';
      }
    }

    chopperLogger.d('--> END ${base.method}$bytes');
    return request;
  }

  @override
  FutureOr<Chopper.Response> onResponse(Chopper.Response response) {
    final base = response.base.request;
    chopperLogger.d('<-- ${response.statusCode} ${base?.url}');

    response.base.headers.forEach((k, v) => chopperLogger.d('$k: $v'));

    var bytes;
    if (response.base is http.Response) {
      final resp = response.base as http.Response;
      if (resp.body != null && resp.body.isNotEmpty) {
        chopperLogger.d(resp.body);
        bytes = ' (${response.bodyBytes.length}-byte body)';
      }
    }

    chopperLogger.d('--> END ${base?.method}$bytes');
    return response;
  }
}
