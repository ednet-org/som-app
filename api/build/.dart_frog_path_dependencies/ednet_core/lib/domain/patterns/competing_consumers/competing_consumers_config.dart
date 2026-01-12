part of ednet_core;

/// Configuration for Competing Consumers business logic.
/// Allows customization of recommendation, sentiment, and engagement arrays.
class CompetingConsumersBusinessLogicConfig {
  /// Available recommendations for proposal reviews
  final List<String> recommendations;

  /// Available sentiment options for deliberation analysis
  final List<String> sentiments;

  /// Available engagement levels for deliberation analysis
  final List<String> engagementLevels;

  /// Available delivery methods for notifications
  final List<String> deliveryMethods;

  const CompetingConsumersBusinessLogicConfig({
    required this.recommendations,
    required this.sentiments,
    required this.engagementLevels,
    required this.deliveryMethods,
  });

  /// Create configuration from environment variables with fallback to defaults
  factory CompetingConsumersBusinessLogicConfig.fromEnvironment() {
    return CompetingConsumersBusinessLogicConfig(
      recommendations:
          _parseListFromEnv('CC_RECOMMENDATIONS') ??
          ['approve', 'revise', 'reject', 'needs_discussion'],
      sentiments:
          _parseListFromEnv('CC_SENTIMENTS') ??
          ['positive', 'neutral', 'negative', 'constructive'],
      engagementLevels:
          _parseListFromEnv('CC_ENGAGEMENT_LEVELS') ??
          ['low', 'medium', 'high', 'very_high'],
      deliveryMethods:
          _parseListFromEnv('CC_DELIVERY_METHODS') ??
          ['email', 'sms', 'push', 'webhook'],
    );
  }

  /// Create configuration with custom values, fallback to defaults
  factory CompetingConsumersBusinessLogicConfig.custom({
    List<String>? recommendations,
    List<String>? sentiments,
    List<String>? engagementLevels,
    List<String>? deliveryMethods,
  }) {
    return CompetingConsumersBusinessLogicConfig(
      recommendations:
          recommendations ??
          ['approve', 'revise', 'reject', 'needs_discussion'],
      sentiments:
          sentiments ?? ['positive', 'neutral', 'negative', 'constructive'],
      engagementLevels:
          engagementLevels ?? ['low', 'medium', 'high', 'very_high'],
      deliveryMethods: deliveryMethods ?? ['email', 'sms', 'push', 'webhook'],
    );
  }

  /// Parse comma-separated list from environment variable
  static List<String>? _parseListFromEnv(String envKey) {
    final envValue = String.fromEnvironment(envKey, defaultValue: '');
    if (envValue.isEmpty) return null;

    return envValue
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  /// Validate configuration
  void validate() {
    if (recommendations.isEmpty) {
      throw ArgumentError('recommendations cannot be empty');
    }
    if (sentiments.isEmpty) {
      throw ArgumentError('sentiments cannot be empty');
    }
    if (engagementLevels.isEmpty) {
      throw ArgumentError('engagementLevels cannot be empty');
    }
    if (deliveryMethods.isEmpty) {
      throw ArgumentError('deliveryMethods cannot be empty');
    }

    // Check for duplicates
    if (recommendations.toSet().length != recommendations.length) {
      throw ArgumentError('recommendations must contain unique values');
    }
    if (sentiments.toSet().length != sentiments.length) {
      throw ArgumentError('sentiments must contain unique values');
    }
    if (engagementLevels.toSet().length != engagementLevels.length) {
      throw ArgumentError('engagementLevels must contain unique values');
    }
    if (deliveryMethods.toSet().length != deliveryMethods.length) {
      throw ArgumentError('deliveryMethods must contain unique values');
    }
  }

  @override
  String toString() {
    return 'CompetingConsumersBusinessLogicConfig{'
        'recommendations: $recommendations, '
        'sentiments: $sentiments, '
        'engagementLevels: $engagementLevels}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CompetingConsumersBusinessLogicConfig) return false;

    return _listsEqual(recommendations, other.recommendations) &&
        _listsEqual(sentiments, other.sentiments) &&
        _listsEqual(engagementLevels, other.engagementLevels) &&
        _listsEqual(deliveryMethods, other.deliveryMethods);
  }

  @override
  int get hashCode => Object.hash(
    recommendations.join(','),
    sentiments.join(','),
    engagementLevels.join(','),
    deliveryMethods.join(','),
  );

  static bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
