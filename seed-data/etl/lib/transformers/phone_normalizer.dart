/// Phone number normalizer for Austrian phone numbers.
/// Converts various formats to E.164 international format (+43...).
library;

/// Normalizes Austrian phone numbers to E.164 format.
class PhoneNormalizer {
  /// Austrian country code.
  static const String countryCode = '+43';

  /// Pattern for Austrian phone numbers in various formats.
  static final RegExp _phonePattern = RegExp(
    r'^[\s(]*'
    r'(?:(?:\+|00)?43|0)?'
    r'[\s)/-]*'
    r'(\d[\d\s/-]{5,})',
    caseSensitive: false,
  );

  /// Normalize a phone number to E.164 format.
  ///
  /// Returns null if the input is not a valid Austrian phone number.
  static String? normalize(String? input) {
    if (input == null || input.trim().isEmpty) {
      return null;
    }

    // Remove all whitespace, dashes, slashes, parentheses
    var cleaned = input.replaceAll(RegExp(r'[\s()\-/]'), '');

    // Handle various prefixes
    if (cleaned.startsWith('+43')) {
      cleaned = cleaned.substring(3);
    } else if (cleaned.startsWith('0043')) {
      cleaned = cleaned.substring(4);
    } else if (cleaned.startsWith('43') && cleaned.length > 10) {
      cleaned = cleaned.substring(2);
    } else if (cleaned.startsWith('0')) {
      cleaned = cleaned.substring(1);
    }

    // Validate remaining digits
    if (!RegExp(r'^\d{6,13}$').hasMatch(cleaned)) {
      return null;
    }

    // Validate Austrian area codes (simplified check)
    // Austrian area codes start with 1 (Vienna), 2-7 (landlines), or mobile prefixes
    final firstDigit = cleaned[0];
    if (!['1', '2', '3', '4', '5', '6', '7'].contains(firstDigit)) {
      return null;
    }

    return '$countryCode$cleaned';
  }

  /// Check if a phone number looks like a mobile number.
  static bool isMobile(String normalized) {
    // Austrian mobile prefixes after country code: 650, 660, 664, 676, 680, 681, 688, 699
    final mobilePrefixes = [
      '650',
      '660',
      '664',
      '676',
      '680',
      '681',
      '688',
      '699'
    ];
    final numberPart = normalized.replaceFirst('+43', '');
    return mobilePrefixes.any((prefix) => numberPart.startsWith(prefix));
  }

  /// Check if a phone number looks like a fax number.
  /// This is a heuristic based on context - typically fax numbers are indicated
  /// by text like "Fax:" or similar in the source data.
  static bool isFaxNumber(String rawInput) {
    final lower = rawInput.toLowerCase();
    return lower.contains('fax') || lower.contains('telefax');
  }

  /// Extract and normalize all phone numbers from a text string.
  static List<String> extractAll(String text) {
    final results = <String>[];
    final matches = _phonePattern.allMatches(text);

    for (final match in matches) {
      final normalized = normalize(match.group(0));
      if (normalized != null && !results.contains(normalized)) {
        results.add(normalized);
      }
    }

    return results;
  }

  /// Format a normalized E.164 number for display.
  static String formatForDisplay(String normalized) {
    if (!normalized.startsWith('+43')) {
      return normalized;
    }

    final number = normalized.substring(3);
    if (number.length < 7) {
      return normalized;
    }

    // Vienna (1)
    if (number.startsWith('1')) {
      return '+43 1 ${_groupDigits(number.substring(1))}';
    }

    // Mobile or other area codes (typically 3 digits)
    final areaCode = number.substring(0, 3);
    final rest = number.substring(3);
    return '+43 $areaCode ${_groupDigits(rest)}';
  }

  static String _groupDigits(String digits) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
