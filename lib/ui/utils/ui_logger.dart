import 'package:logger/logger.dart';

/// Centralized logging utility for UI layer.
///
/// Uses the logger package for structured, readable output.
/// Provides different log levels for debugging, warnings, and errors.
class UILogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// Log informational messages
  static void info(String message) => _logger.i(message);

  /// Log warning messages
  static void warning(String message) => _logger.w(message);

  /// Log error messages with optional error object and stack trace
  static void error(String message,
      [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  /// Log debug messages (only in debug mode)
  static void debug(String message) => _logger.d(message);

  /// Log non-critical errors that shouldn't crash the app.
  ///
  /// Use this for API failures during bootstrap/initialization
  /// where the app can continue without the data.
  ///
  /// [context] - Description of where the error occurred (e.g., 'InquiryAppBody._bootstrap.branches')
  /// [error] - The caught error object
  /// [stackTrace] - Optional stack trace for debugging
  static void silentError(
    String context,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    _logger.w('[$context] Non-critical error: $error');
    if (stackTrace != null) {
      _logger.d('Stack trace for [$context]:\n$stackTrace');
    }
  }

  /// Log API call failures with request context
  static void apiError(
    String endpoint,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    _logger.e(
      'API call failed: $endpoint',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
