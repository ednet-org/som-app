/// Cross-platform file download utility.
///
/// Uses conditional imports to provide web-specific implementation
/// while maintaining testability on non-web platforms.
export 'file_download_stub.dart' if (dart.library.html) 'file_download_web.dart';
