import 'package:dart_frog/dart_frog.dart';

Middleware corsHeaders() {
  return (handler) {
    return (context) async {
      if (context.request.method == HttpMethod.options) {
        return Response(
          statusCode: 204,
          headers: _headers,
        );
      }
      final response = await handler(context);
      return response.copyWith(headers: {...response.headers, ..._headers});
    };
  };
}

const _headers = <String, String>{
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
};
