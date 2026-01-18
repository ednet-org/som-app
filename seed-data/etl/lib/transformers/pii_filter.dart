/// PII filter for GDPR compliance.
/// Filters out personal contact information, keeping only generic business contacts.
library;

import '../models/business_entity.dart';

/// Result of PII filtering.
class PiiFilterResult {
  const PiiFilterResult({
    required this.allowed,
    required this.filtered,
    required this.reason,
  });

  final bool allowed;
  final bool filtered;
  final String reason;
}

/// Filters personal information from contact data.
class PiiFilter {
  /// Generic email prefixes that are allowed (business/role-based).
  static const List<String> _allowedEmailPrefixes = [
    'info',
    'office',
    'kontakt',
    'contact',
    'sales',
    'verkauf',
    'support',
    'service',
    'kundenservice',
    'bestellung',
    'orders',
    'anfrage',
    'inquiry',
    'mail',
    'hello',
    'hallo',
    'willkommen',
    'welcome',
    'team',
    'firma',
    'company',
    'post',
    'zentrale',
    'reception',
    'empfang',
    'booking',
    'buchung',
    'reservierung',
    'reservation',
    'presse',
    'press',
    'media',
    'marketing',
    'hr',
    'jobs',
    'karriere',
    'career',
    'bewerbung',
    'datenschutz',
    'privacy',
    'impressum',
    'legal',
    'rechnung',
    'invoice',
    'billing',
    'buchhaltung',
    'accounting',
    'admin',
    'webmaster',
    'newsletter',
  ];

  /// Pattern for personal email addresses (firstname.lastname or similar).
  static final RegExp _personalEmailPattern = RegExp(
    r'^[a-z]+\.[a-z]+@',
    caseSensitive: false,
  );

  /// Pattern for email addresses with initials (j.doe@).
  static final RegExp _initialsEmailPattern = RegExp(
    r'^[a-z]\.[a-z]+@',
    caseSensitive: false,
  );

  /// Pattern for generic domain emails (noreply, no-reply, etc).
  static final RegExp _noReplyPattern = RegExp(
    r'^no[-_]?reply@',
    caseSensitive: false,
  );

  /// Check if an email address is allowed (generic/business).
  static PiiFilterResult filterEmail(String email) {
    final lower = email.toLowerCase().trim();

    // Always filter no-reply addresses
    if (_noReplyPattern.hasMatch(lower)) {
      return const PiiFilterResult(
        allowed: false,
        filtered: true,
        reason: 'No-reply address',
      );
    }

    // Extract local part (before @)
    final atIndex = lower.indexOf('@');
    if (atIndex <= 0) {
      return const PiiFilterResult(
        allowed: false,
        filtered: true,
        reason: 'Invalid email format',
      );
    }

    final localPart = lower.substring(0, atIndex);

    // Check for allowed prefixes
    for (final prefix in _allowedEmailPrefixes) {
      if (localPart == prefix ||
          localPart.startsWith('$prefix.') ||
          localPart.startsWith('${prefix}_') ||
          localPart.startsWith('$prefix-')) {
        return const PiiFilterResult(
          allowed: true,
          filtered: false,
          reason: 'Generic business email',
        );
      }
    }

    // Filter personal patterns
    if (_personalEmailPattern.hasMatch(lower)) {
      return const PiiFilterResult(
        allowed: false,
        filtered: true,
        reason: 'Personal email (firstname.lastname pattern)',
      );
    }

    if (_initialsEmailPattern.hasMatch(lower)) {
      return const PiiFilterResult(
        allowed: false,
        filtered: true,
        reason: 'Personal email (initials pattern)',
      );
    }

    // If no pattern matches, default to filtering for safety
    // But allow if it looks like a department or function
    if (_looksLikeFunction(localPart)) {
      return const PiiFilterResult(
        allowed: true,
        filtered: false,
        reason: 'Appears to be functional email',
      );
    }

    return const PiiFilterResult(
      allowed: false,
      filtered: true,
      reason: 'Unknown pattern - filtered for safety',
    );
  }

  /// Check if local part looks like a function/department.
  static bool _looksLikeFunction(String localPart) {
    // Check for numbers (often department IDs)
    if (localPart.contains(RegExp(r'\d'))) {
      return true;
    }

    // Check for very short names (likely abbreviations)
    if (localPart.length <= 4) {
      return true;
    }

    // Check for underscores or dashes (often functional)
    if (localPart.contains('_') || localPart.contains('-')) {
      // But not if it's firstname-lastname pattern
      if (!RegExp(r'^[a-z]+-[a-z]+$').hasMatch(localPart)) {
        return true;
      }
    }

    return false;
  }

  /// Check if a phone number is likely a main/business line.
  /// Personal mobile numbers should be filtered.
  static PiiFilterResult filterPhone(String phone, {String? context}) {
    final contextLower = context?.toLowerCase() ?? '';

    // If context mentions "mobile" or "handy" for a specific person, filter
    if (contextLower.contains('mobil') || contextLower.contains('handy')) {
      if (_containsPersonName(contextLower)) {
        return const PiiFilterResult(
          allowed: false,
          filtered: true,
          reason: 'Personal mobile number',
        );
      }
    }

    // Allow business phone numbers by default
    return const PiiFilterResult(
      allowed: true,
      filtered: false,
      reason: 'Business phone allowed',
    );
  }

  /// Check if context contains what looks like a person's name.
  static bool _containsPersonName(String context) {
    // Look for patterns like "Hr.", "Fr.", "Herr", "Frau"
    return RegExp(r'\b(hr|fr|herr|frau|mr|mrs|ms)\b', caseSensitive: false)
        .hasMatch(context);
  }

  /// Filter contacts, removing personal information.
  static Contacts filterContacts(Contacts contacts) {
    final filteredPhones = <PhoneContact>[];
    final filteredEmails = <EmailContact>[];

    for (final phone in contacts.phones) {
      final result = filterPhone(phone.value);
      if (result.allowed) {
        filteredPhones.add(phone);
      }
    }

    for (final email in contacts.emails) {
      final result = filterEmail(email.value);
      if (result.allowed) {
        filteredEmails.add(email);
      }
    }

    // Websites are generally public and can be kept
    return Contacts(
      phones: filteredPhones,
      emails: filteredEmails,
      websites: contacts.websites,
    );
  }

  /// Audit contacts and return statistics.
  static PiiAuditReport auditContacts(Contacts contacts) {
    var allowedPhones = 0;
    var filteredPhones = 0;
    var allowedEmails = 0;
    var filteredEmails = 0;
    final filteredReasons = <String, int>{};

    for (final phone in contacts.phones) {
      final result = filterPhone(phone.value);
      if (result.allowed) {
        allowedPhones++;
      } else {
        filteredPhones++;
        filteredReasons[result.reason] =
            (filteredReasons[result.reason] ?? 0) + 1;
      }
    }

    for (final email in contacts.emails) {
      final result = filterEmail(email.value);
      if (result.allowed) {
        allowedEmails++;
      } else {
        filteredEmails++;
        filteredReasons[result.reason] =
            (filteredReasons[result.reason] ?? 0) + 1;
      }
    }

    return PiiAuditReport(
      allowedPhones: allowedPhones,
      filteredPhones: filteredPhones,
      allowedEmails: allowedEmails,
      filteredEmails: filteredEmails,
      allowedWebsites: contacts.websites.length,
      filteredReasons: filteredReasons,
    );
  }
}

/// PII audit report.
class PiiAuditReport {
  const PiiAuditReport({
    required this.allowedPhones,
    required this.filteredPhones,
    required this.allowedEmails,
    required this.filteredEmails,
    required this.allowedWebsites,
    required this.filteredReasons,
  });

  final int allowedPhones;
  final int filteredPhones;
  final int allowedEmails;
  final int filteredEmails;
  final int allowedWebsites;
  final Map<String, int> filteredReasons;

  int get totalFiltered => filteredPhones + filteredEmails;
  int get totalAllowed => allowedPhones + allowedEmails + allowedWebsites;

  PiiAuditReport merge(PiiAuditReport other) {
    final mergedReasons = <String, int>{};
    for (final entry in filteredReasons.entries) {
      mergedReasons[entry.key] = entry.value;
    }
    for (final entry in other.filteredReasons.entries) {
      mergedReasons[entry.key] = (mergedReasons[entry.key] ?? 0) + entry.value;
    }

    return PiiAuditReport(
      allowedPhones: allowedPhones + other.allowedPhones,
      filteredPhones: filteredPhones + other.filteredPhones,
      allowedEmails: allowedEmails + other.allowedEmails,
      filteredEmails: filteredEmails + other.filteredEmails,
      allowedWebsites: allowedWebsites + other.allowedWebsites,
      filteredReasons: mergedReasons,
    );
  }
}
