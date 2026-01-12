part of ednet_core;

/// Configuration for message pattern behaviors
class MessagePatternsConfig {
  final Duration defaultMessageExpirationCleanupInterval;
  final Duration defaultConsumerTimeout;
  final Duration defaultMessageTtl;
  final int maxRetries;
  final Duration retryDelay;

  const MessagePatternsConfig({
    this.defaultMessageExpirationCleanupInterval = const Duration(minutes: 5),
    this.defaultConsumerTimeout = const Duration(seconds: 30),
    this.defaultMessageTtl = const Duration(hours: 24),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  /// Creates a config optimized for development
  factory MessagePatternsConfig.development() => const MessagePatternsConfig(
    defaultMessageExpirationCleanupInterval: Duration(minutes: 1),
    defaultConsumerTimeout: Duration(seconds: 10),
    defaultMessageTtl: Duration(hours: 1),
    maxRetries: 1,
    retryDelay: Duration(milliseconds: 500),
  );

  /// Creates a config optimized for production
  factory MessagePatternsConfig.production() => const MessagePatternsConfig(
    defaultMessageExpirationCleanupInterval: Duration(minutes: 15),
    defaultConsumerTimeout: Duration(seconds: 60),
    defaultMessageTtl: Duration(days: 7),
    maxRetries: 5,
    retryDelay: Duration(seconds: 2),
  );

  /// Creates a config from environment variables
  factory MessagePatternsConfig.fromEnvironment() {
    return MessagePatternsConfig(
      defaultMessageExpirationCleanupInterval: Duration(
        minutes:
            int.tryParse(
              const String.fromEnvironment(
                'MESSAGE_CLEANUP_INTERVAL_MINUTES',
                defaultValue: '5',
              ),
            ) ??
            5,
      ),
      defaultConsumerTimeout: Duration(
        seconds:
            int.tryParse(
              const String.fromEnvironment(
                'CONSUMER_TIMEOUT_SECONDS',
                defaultValue: '30',
              ),
            ) ??
            30,
      ),
      defaultMessageTtl: Duration(
        hours:
            int.tryParse(
              const String.fromEnvironment(
                'MESSAGE_TTL_HOURS',
                defaultValue: '24',
              ),
            ) ??
            24,
      ),
      maxRetries:
          int.tryParse(
            const String.fromEnvironment(
              'MAX_MESSAGE_RETRIES',
              defaultValue: '3',
            ),
          ) ??
          3,
      retryDelay: Duration(
        seconds:
            int.tryParse(
              const String.fromEnvironment(
                'MESSAGE_RETRY_DELAY_SECONDS',
                defaultValue: '1',
              ),
            ) ??
            1,
      ),
    );
  }
}

/// Provider for message patterns configuration
abstract class MessagePatternsConfigProvider {
  MessagePatternsConfig get config;
}

/// Default implementation using environment-based configuration
class DefaultMessagePatternsConfigProvider
    implements MessagePatternsConfigProvider {
  @override
  MessagePatternsConfig get config => MessagePatternsConfig.fromEnvironment();
}

/// Development-optimized configuration provider
class DevelopmentMessagePatternsConfigProvider
    implements MessagePatternsConfigProvider {
  @override
  MessagePatternsConfig get config => MessagePatternsConfig.development();
}

/// Production-optimized configuration provider
class ProductionMessagePatternsConfigProvider
    implements MessagePatternsConfigProvider {
  @override
  MessagePatternsConfig get config => MessagePatternsConfig.production();
}
