import 'package:intl/intl.dart';

/// Utility class for formatting data for display.
///
/// Provides consistent formatting for dates, times, and identifiers
/// across the application.
class SomFormatters {
  SomFormatters._();

  // Date formatters
  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _dateTimeFormat = DateFormat('MMM d, yyyy HH:mm');
  static final _timeFormat = DateFormat('HH:mm');

  /// Format DateTime for display (e.g., "Jan 15, 2024")
  static String date(DateTime? dt) {
    if (dt == null) return '-';
    return _dateFormat.format(dt.toLocal());
  }

  /// Format DateTime with time (e.g., "Jan 15, 2024 14:30")
  static String dateTime(DateTime? dt) {
    if (dt == null) return '-';
    return _dateTimeFormat.format(dt.toLocal());
  }

  /// Format time only (e.g., "14:30")
  static String time(DateTime? dt) {
    if (dt == null) return '-';
    return _timeFormat.format(dt.toLocal());
  }

  /// Format as relative time (e.g., "2 days ago", "Just now")
  static String relative(DateTime? dt) {
    if (dt == null) return '-';

    final now = DateTime.now();
    final diff = now.difference(dt);

    // Future dates
    if (diff.isNegative) {
      final absDiff = dt.difference(now);
      if (absDiff.inDays > 30) return date(dt);
      if (absDiff.inDays > 1) return 'in ${absDiff.inDays} days';
      if (absDiff.inDays == 1) return 'tomorrow';
      if (absDiff.inHours > 1) return 'in ${absDiff.inHours}h';
      if (absDiff.inMinutes > 1) return 'in ${absDiff.inMinutes}m';
      return 'soon';
    }

    // Past dates
    if (diff.inDays > 30) return date(dt);
    if (diff.inDays > 1) return '${diff.inDays} days ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inHours > 1) return '${diff.inHours}h ago';
    if (diff.inMinutes > 1) return '${diff.inMinutes}m ago';
    return 'just now';
  }

  /// Truncate UUID for display (e.g., "1a2b3c4d" -> "#1a2b3c4d")
  static String shortId(String? id) {
    if (id == null || id.isEmpty) return '-';
    if (id.length <= 8) return '#$id';
    return '#${id.substring(0, 8)}';
  }

  /// Get first N characters of a string with ellipsis if truncated
  static String truncate(String? text, int maxLength) {
    if (text == null || text.isEmpty) return '-';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format a number with thousand separators
  static String number(num? value) {
    if (value == null) return '-';
    return NumberFormat('#,###').format(value);
  }

  /// Format currency (Euro)
  static String currency(num? value) {
    if (value == null) return '-';
    return NumberFormat.currency(locale: 'de_DE', symbol: '\u20AC').format(value);
  }

  /// Format a list as comma-separated string
  static String list(List<String>? items, {int maxItems = 3}) {
    if (items == null || items.isEmpty) return '-';
    if (items.length <= maxItems) return items.join(', ');
    return '${items.take(maxItems).join(', ')} +${items.length - maxItems} more';
  }

  /// Capitalize first letter
  static String capitalize(String? text) {
    if (text == null || text.isEmpty) return '';
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
}
