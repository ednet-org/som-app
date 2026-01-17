import 'package:dio/dio.dart';

String parseLoginErrorMessage(Object? data) {
  const fallback = 'Something went wrong';
  if (data == null) return fallback;

  if (data is DioException) {
    final uri = data.requestOptions.uri;
    final target = uri.hasAuthority
        ? '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}'
        : 'the API';
    switch (data.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Cannot reach $target. Is the API running?';
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        break;
    }

    final responseData = data.response?.data;
    if (responseData != null && responseData != data) {
      return parseLoginErrorMessage(responseData);
    }
    return data.message ?? fallback;
  }

  if (data is String) {
    final trimmed = data.trim();
    return trimmed.isEmpty ? fallback : data;
  }
  if (data is Map) {
    final message = data['message'] ?? data['error'] ?? data['detail'];
    if (message != null) {
      return message.toString();
    }
  }
  return data.toString();
}
