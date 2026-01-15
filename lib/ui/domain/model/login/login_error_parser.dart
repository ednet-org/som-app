String parseLoginErrorMessage(Object? data) {
  const fallback = 'Something went wrong';
  if (data == null) return fallback;
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
