import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInterceptor implements RequestInterceptor {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const String CONTENT_TYPE_HEADER = "Content-Type";
  static const String CONTENT_TYPE = "application/json";

  static const String AUTH_HEADER = "Authorization";
  static const String BEARER = "Bearer ";

  @override
  FutureOr<Request> onRequest(Request request) async {
    final sharedPrefs = await _prefs;
    String? TOKEN = await sharedPrefs.getString('token');
    if (TOKEN != null) {
      return request.copyWith(headers: {
        AUTH_HEADER: BEARER + TOKEN,
        CONTENT_TYPE_HEADER: CONTENT_TYPE
      });
    } else {
      return request.copyWith(headers: {CONTENT_TYPE_HEADER: CONTENT_TYPE});
    }
  }
}
