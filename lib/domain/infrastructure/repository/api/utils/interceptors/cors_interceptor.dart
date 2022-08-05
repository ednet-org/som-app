import 'dart:async';

import 'package:chopper/chopper.dart';

class CORSInterceptor implements RequestInterceptor {
  static const String CORS_HEADER = "Access-Control-Allow-Origin";
  static const String ORIGIN = "slavisam.gitlab.io";

  @override
  FutureOr<Request> onRequest(Request request) async {
    Request newRequest = request.copyWith(
        headers: {CORS_HEADER: ORIGIN, "content-type": "application/json"});
    return newRequest;
  }
}
