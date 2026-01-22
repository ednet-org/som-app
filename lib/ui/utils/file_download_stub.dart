/// Stub implementation for non-web platforms.
/// On non-web platforms, file downloads are not supported via browser APIs.
void downloadFile(List<int> bytes, String fileName, String mimeType) {
  // On non-web platforms, this is a no-op.
  // File saving would need platform-specific implementation (e.g., path_provider + dart:io).
  throw UnsupportedError('File download not supported on this platform');
}
