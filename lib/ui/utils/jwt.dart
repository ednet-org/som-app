import 'dart:convert';

Map<String, dynamic>? decodeJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    return null;
  }
  final payload = parts[1];
  final normalized = base64Url.normalize(payload);
  try {
    final decoded = utf8.decode(base64Url.decode(normalized));
    final data = jsonDecode(decoded);
    if (data is Map<String, dynamic>) {
      return data;
    }
  } catch (_) {
    return null;
  }
  return null;
}
