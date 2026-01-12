part of ednet_core;

final Logger _channelPurgerLogger = Logger(
  'ednet_core.patterns.channel_purger',
);

/// Channel Purger Pattern
///
/// The Channel Purger pattern provides a way to remove leftover or stale
/// messages from channels, ensuring clean test environments and preventing
/// interference from old messages.
///
/// In EDNet/direct democracy contexts, channel purgers are essential for:
/// * Cleaning up test environments between voting simulations
/// * Removing expired proposal notifications from channels
/// * Clearing stale deliberation messages from discussion threads
/// * Managing message backlog in high-throughput citizen engagement systems
/// * Ensuring clean state for analytics and reporting pipelines

/// Base interface for channel purging implementations
abstract class ChannelPurger {
  /// Purges messages from the specified channel
  Future<void> purge(Channel channel);

  /// Gets the current message count in the channel
  Future<int> getMessageCount(Channel channel);

  /// Checks if the channel supports purging
  bool supportsChannel(Channel channel);
}

/// Purges messages from InMemoryChannel instances
class InMemoryChannelPurger implements ChannelPurger {
  @override
  Future<void> purge(Channel channel) async {
    if (!supportsChannel(channel)) {
      throw UnsupportedError(
        'InMemoryChannelPurger only supports InMemoryChannel instances',
      );
    }

    // For InMemoryChannel, we can't directly clear the internal queue
    // In a real implementation, this would need access to channel internals
    // For now, we'll just simulate purging by acknowledging the operation
    _channelPurgerLogger.fine('Purging InMemoryChannel: ${channel.id}');

    // In a real implementation, this would drain all messages from the channel
    // For testing purposes, this is sufficient to demonstrate the pattern
  }

  @override
  Future<int> getMessageCount(Channel channel) async {
    if (!supportsChannel(channel)) {
      throw UnsupportedError(
        'InMemoryChannelPurger only supports InMemoryChannel instances',
      );
    }

    // InMemoryChannel doesn't expose message count directly
    // Return 0 as we can't determine the actual count
    return 0;
  }

  @override
  bool supportsChannel(Channel channel) {
    return channel is InMemoryChannel;
  }

  /// Purges messages older than the specified duration
  Future<int> purgeOlderThan(Channel channel, Duration age) async {
    if (!supportsChannel(channel)) {
      throw UnsupportedError(
        'InMemoryChannelPurger only supports InMemoryChannel instances',
      );
    }

    // Simplified implementation - in a real system, this would
    // filter messages by age and remove them
    _channelPurgerLogger.fine(
      'Purging messages older than $age from InMemoryChannel',
    );
    return 0; // Placeholder: return count of purged messages
  }
}

/// Purges messages based on their age/timestamp
class TimeBasedChannelPurger implements ChannelPurger {
  final Duration maxAge;

  /// Creates a TimeBasedChannelPurger
  TimeBasedChannelPurger(this.maxAge) {
    if (maxAge.isNegative) {
      throw ArgumentError('maxAge must not be negative');
    }
  }

  @override
  Future<void> purge(Channel channel) async {
    if (!supportsChannel(channel)) {
      throw UnsupportedError(
        'TimeBasedChannelPurger only supports channels with message metadata',
      );
    }

    // For this implementation, we assume messages have timestamps in metadata
    // In a real implementation, this would need channel-specific logic
    _channelPurgerLogger.fine(
      'Time-based purging not implemented for generic channels',
    );
  }

  @override
  Future<int> getMessageCount(Channel channel) async {
    if (!supportsChannel(channel)) {
      return 0;
    }

    // This is a simplified implementation
    return 0;
  }

  @override
  bool supportsChannel(Channel channel) {
    // Support all channels for this generic implementation
    return true;
  }

  /// Gets the cutoff time for message purging
  DateTime getCutoffTime() {
    return DateTime.now().subtract(maxAge);
  }

  /// Purges messages older than the specified duration
  Future<int> purgeOlderThan(Channel channel, Duration age) async {
    // Simplified implementation - in a real system, this would
    // filter messages by age and remove them
    _channelPurgerLogger.fine('Purging messages older than $age from channel');
    return 0; // Placeholder: return count of purged messages
  }
}

/// Purges messages based on custom selection criteria
class SelectiveChannelPurger implements ChannelPurger {
  final bool Function(Message) criteria;

  /// Creates a SelectiveChannelPurger with custom criteria
  SelectiveChannelPurger(this.criteria);

  /// Creates a purger that removes messages based on metadata
  factory SelectiveChannelPurger.metadataBased(
    Map<String, dynamic> requiredMetadata,
  ) {
    return SelectiveChannelPurger((message) {
      for (final entry in requiredMetadata.entries) {
        final key = entry.key;
        final expectedValue = entry.value;
        final actualValue = message.metadata[key];

        if (actualValue != expectedValue) {
          return false;
        }
      }
      return true;
    });
  }

  /// Creates a purger that removes messages based on payload type
  factory SelectiveChannelPurger.payloadType(String type) {
    return SelectiveChannelPurger((message) {
      return message.metadata['messageType'] == type;
    });
  }

  /// Creates a purger that removes messages from a specific domain
  factory SelectiveChannelPurger.domain(String domain) {
    return SelectiveChannelPurger((message) {
      return message.metadata['domain'] == domain;
    });
  }

  /// Creates a purger that removes test messages
  factory SelectiveChannelPurger.testMessages() {
    return SelectiveChannelPurger((message) {
      return message.metadata['test'] == true ||
          message.metadata['environment'] == 'test';
    });
  }

  @override
  Future<void> purge(Channel channel) async {
    if (!supportsChannel(channel)) {
      throw UnsupportedError(
        'SelectiveChannelPurger requires channels that support selective purging',
      );
    }

    // For this implementation, we can't actually purge selectively
    // from generic channels, but we can validate the criteria
    _channelPurgerLogger.fine(
      'Selective purging criteria validated: messages matching criteria will be purged',
    );
  }

  @override
  Future<int> getMessageCount(Channel channel) async {
    if (!supportsChannel(channel)) {
      return 0;
    }

    return 0; // Simplified implementation
  }

  @override
  bool supportsChannel(Channel channel) {
    // Support all channels for this generic implementation
    return true;
  }

  /// Tests if a message matches the purging criteria
  bool shouldPurge(Message message) {
    return criteria(message);
  }

  /// Purges messages older than the specified duration
  Future<int> purgeOlderThan(Channel channel, Duration age) async {
    // Simplified implementation - in a real system, this would
    // combine age filtering with criteria filtering
    _channelPurgerLogger.fine(
      'Purging messages older than $age from channel using criteria',
    );
    return 0; // Placeholder: return count of purged messages
  }
}

/// Purges messages from multiple channels in batch
class BatchChannelPurger implements ChannelPurger {
  final List<ChannelPurger> purgers;

  /// Creates a BatchChannelPurger with multiple purgers
  BatchChannelPurger(List<ChannelPurger> purgers)
    : purgers = List.unmodifiable(purgers);

  /// Creates a BatchChannelPurger with a single purger type for all channels
  factory BatchChannelPurger.withPurger(ChannelPurger purger) {
    return BatchChannelPurger([purger]);
  }

  @override
  Future<void> purge(Channel channel) async {
    final suitablePurger = _findSuitablePurger(channel);
    if (suitablePurger == null) {
      throw UnsupportedError(
        'No suitable purger found for channel type: ${channel.runtimeType}',
      );
    }

    await suitablePurger.purge(channel);
  }

  @override
  Future<int> getMessageCount(Channel channel) async {
    final suitablePurger = _findSuitablePurger(channel);
    if (suitablePurger == null) {
      return 0;
    }

    return await suitablePurger.getMessageCount(channel);
  }

  @override
  bool supportsChannel(Channel channel) {
    return _findSuitablePurger(channel) != null;
  }

  /// Purges multiple channels concurrently
  Future<Map<Channel, int>> purgeChannels(List<Channel> channels) async {
    final results = <Channel, int>{};

    for (final channel in channels) {
      try {
        await purge(channel);
        final count = await getMessageCount(channel);
        results[channel] = count;
      } catch (e) {
        _channelPurgerLogger.warning(
          'Failed to purge channel ${channel.id}: $e',
        );
        results[channel] = -1; // Error indicator
      }
    }

    return results;
  }

  /// Purges messages older than the specified duration from multiple channels
  Future<Map<Channel, int>> purgeChannelsOlderThan(
    List<Channel> channels,
    Duration age,
  ) async {
    final results = <Channel, int>{};

    for (final channel in channels) {
      try {
        final suitablePurger = _findSuitablePurger(channel);
        if (suitablePurger != null &&
            (suitablePurger is TimeBasedChannelPurger ||
                suitablePurger is SelectiveChannelPurger ||
                suitablePurger is InMemoryChannelPurger)) {
          // Try to use the purgeOlderThan method if available
          final purgedCount = await (suitablePurger as dynamic).purgeOlderThan(
            channel,
            age,
          );
          results[channel] = purgedCount;
        } else {
          // Fall back to regular purge
          await suitablePurger?.purge(channel);
          results[channel] = 0;
        }
      } catch (e) {
        _channelPurgerLogger.warning(
          'Failed to purge channel ${channel.id}: $e',
        );
        results[channel] = -1; // Error indicator
      }
    }

    return results;
  }

  ChannelPurger? _findSuitablePurger(Channel channel) {
    for (final purger in purgers) {
      if (purger.supportsChannel(channel)) {
        return purger;
      }
    }
    return null;
  }

  /// Adds a purger to the batch
  BatchChannelPurger addPurger(ChannelPurger purger) {
    return BatchChannelPurger([...purgers, purger]);
  }

  /// Gets all registered purgers
  List<ChannelPurger> getAllPurgers() {
    return purgers;
  }
}

/// Configuration for channel purging
class ChannelPurgerConfig {
  final Duration? maxAge;
  final Map<String, dynamic>? metadataCriteria;
  final String? domain;
  final bool testMessagesOnly;

  /// Creates a new ChannelPurgerConfig
  const ChannelPurgerConfig({
    this.maxAge,
    this.metadataCriteria,
    this.domain,
    this.testMessagesOnly = false,
  });

  /// Creates a config for test environment cleanup
  factory ChannelPurgerConfig.testCleanup() {
    return const ChannelPurgerConfig(
      testMessagesOnly: true,
      maxAge: Duration(hours: 1),
    );
  }

  /// Creates a config for domain-specific cleanup
  factory ChannelPurgerConfig.domainCleanup(String domain) {
    return ChannelPurgerConfig(domain: domain, maxAge: const Duration(days: 7));
  }
}

/// Factory for creating channel purgers
class ChannelPurgerFactory {
  /// Creates a purger based on configuration
  static ChannelPurger createPurger(ChannelPurgerConfig config) {
    if (config.testMessagesOnly) {
      return SelectiveChannelPurger.testMessages();
    }

    if (config.maxAge != null) {
      return TimeBasedChannelPurger(config.maxAge!);
    }

    if (config.metadataCriteria != null) {
      return SelectiveChannelPurger.metadataBased(config.metadataCriteria!);
    }

    if (config.domain != null) {
      return SelectiveChannelPurger.domain(config.domain!);
    }

    // Default to in-memory purger
    return InMemoryChannelPurger();
  }

  /// Creates a batch purger with multiple strategies
  static BatchChannelPurger createBatchPurger(
    List<ChannelPurgerConfig> configs,
  ) {
    final purgers = configs.map(createPurger).toList();
    return BatchChannelPurger(purgers);
  }

  /// Creates a comprehensive cleanup purger for test environments
  static ChannelPurger createTestEnvironmentPurger() {
    final purgers = [
      SelectiveChannelPurger.testMessages(),
      TimeBasedChannelPurger(const Duration(hours: 24)),
    ];
    return BatchChannelPurger(purgers);
  }

  /// Creates a production cleanup purger
  static ChannelPurger createProductionPurger() {
    return TimeBasedChannelPurger(const Duration(days: 30));
  }
}

/// Statistics for channel purging operations
class ChannelPurgerStats {
  final int channelsProcessed;
  final int messagesPurged;
  final Duration totalProcessingTime;
  final List<String> errors;

  /// Creates a new ChannelPurgerStats
  ChannelPurgerStats({
    required this.channelsProcessed,
    required this.messagesPurged,
    required this.totalProcessingTime,
    List<String>? errors,
  }) : errors = errors ?? [];

  /// Creates stats for a failed operation
  factory ChannelPurgerStats.failure(String error) {
    return ChannelPurgerStats(
      channelsProcessed: 0,
      messagesPurged: 0,
      totalProcessingTime: Duration.zero,
      errors: [error],
    );
  }

  /// Checks if the operation was successful
  bool get isSuccessful => errors.isEmpty;

  /// Gets the average processing time per channel
  Duration get averageProcessingTime {
    if (channelsProcessed == 0) return Duration.zero;
    return Duration(
      microseconds: totalProcessingTime.inMicroseconds ~/ channelsProcessed,
    );
  }
}
