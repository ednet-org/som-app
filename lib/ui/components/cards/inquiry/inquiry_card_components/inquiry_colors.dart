import 'package:flutter/material.dart';
import 'package:som/domain/model/inquiry_management/inquiry_status.dart';

class InquiryColors {
  static Map<String, Color> inquiryStatusColor(context, status) {
    switch (status) {
      case InquiryStatus.draft:
        return {
          "front": Theme.of(context).colorScheme.onPrimary,
          "back": Theme.of(context).colorScheme.primary,
        };

      case InquiryStatus.published:
        return {
          "front": Theme.of(context).colorScheme.onSecondary,
          "back": Theme.of(context).colorScheme.secondary,
        };

      case InquiryStatus.responded:
        return {
          "front": Theme.of(context).colorScheme.onTertiary,
          "back": Theme.of(context).colorScheme.tertiary,
        };

      case InquiryStatus.closed:
        return {
          "front": Theme.of(context).colorScheme.onPrimaryContainer,
          "back": Theme.of(context).colorScheme.primaryContainer,
        };

      case InquiryStatus.expired:
        return {
          "front": Theme.of(context).colorScheme.onSecondaryContainer,
          "back": Theme.of(context).colorScheme.secondaryContainer,
        };

      default:
        return {
          "front": Theme.of(context).colorScheme.onPrimary,
          "back": Theme.of(context).colorScheme.primary,
        };
    }
  }
}
