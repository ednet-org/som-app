part of ednet_core;

/// Content Enricher Pattern
///
/// The Content Enricher pattern augments message content with additional data
/// from external sources. This pattern is essential when messages don't contain
/// all the information needed by their consumers and must be enhanced before
/// processing can continue.
///
/// In EDNet/direct democracy contexts, content enrichment is crucial for:
/// * Adding citizen profile information to voting messages
/// * Enriching proposal data with historical context and related initiatives
/// * Augmenting deliberation messages with participant expertise and voting history
/// * Enhancing notification messages with personalized content and preferences
/// * Adding jurisdictional context to governance messages

/// Abstract interface for content enrichment
abstract class ContentEnricher {
  /// Enriches a message with additional content
  Future<Message> enrich(Message message);

  /// Gets the enrichment sources used by this enricher
  List<String> get enrichmentSources;

  /// Checks if this enricher can handle the given message type
  bool canEnrich(Message message);
}

/// Enrichment data source interface
abstract class EnrichmentSource {
  /// The name/identifier of this enrichment source
  String get name;

  /// Enriches the given data with additional information
  Future<Map<String, dynamic>> enrichData(Map<String, dynamic> data);

  /// Checks if this source can provide enrichment for the given data
  bool canEnrich(Map<String, dynamic> data);
}

/// In-memory enrichment source for testing and simple scenarios
class InMemoryEnrichmentSource implements EnrichmentSource {
  final String _name;
  final Map<String, Map<String, dynamic>> _enrichmentData;

  InMemoryEnrichmentSource(this._name, this._enrichmentData);

  @override
  String get name => _name;

  @override
  Future<Map<String, dynamic>> enrichData(Map<String, dynamic> data) async {
    final enriched = Map<String, dynamic>.from(data);

    // Simple key-based enrichment - only add keys that don't exist
    for (final entry in _enrichmentData.entries) {
      final key = entry.key;
      if (data.containsKey(key)) {
        final enrichment = entry.value;
        // Only add enrichment data that doesn't conflict with existing keys
        enrichment.forEach((enrichKey, enrichValue) {
          if (!enriched.containsKey(enrichKey)) {
            enriched[enrichKey] = enrichValue;
          } else {
            // For conflicting keys, create a namespaced version
            enriched['enriched_$enrichKey'] = enrichValue;
          }
        });
      }
    }

    return enriched;
  }

  @override
  bool canEnrich(Map<String, dynamic> data) {
    return _enrichmentData.keys.any((key) => data.containsKey(key));
  }
}

/// Database-backed enrichment source
class DatabaseEnrichmentSource implements EnrichmentSource {
  final String _name;
  final Future<Map<String, dynamic>> Function(String key) _lookupFunction;

  DatabaseEnrichmentSource(this._name, this._lookupFunction);

  @override
  String get name => _name;

  @override
  Future<Map<String, dynamic>> enrichData(Map<String, dynamic> data) async {
    final enriched = Map<String, dynamic>.from(data);

    // Look for enrichment keys in the data
    for (final key in data.keys) {
      if (key.endsWith('Id') || key.endsWith('Key') || key == 'reference') {
        try {
          final lookupKey = data[key] as String?;
          if (lookupKey != null) {
            final enrichment = await _lookupFunction(lookupKey);
            // Add enrichment data, handling conflicts by namespacing
            enrichment.forEach((enrichKey, enrichValue) {
              if (!enriched.containsKey(enrichKey)) {
                enriched[enrichKey] = enrichValue;
              } else {
                // For conflicting keys, create a namespaced version
                enriched['enriched_$enrichKey'] = enrichValue;
              }
            });
          }
        } catch (e) {
          // Skip enrichment if lookup fails
        }
      }
    }

    return enriched;
  }

  @override
  bool canEnrich(Map<String, dynamic> data) {
    return data.keys.any(
      (key) => key.endsWith('Id') || key.endsWith('Key') || key == 'reference',
    );
  }
}

/// API-based enrichment source
class ApiEnrichmentSource implements EnrichmentSource {
  final String _name;
  final Future<Map<String, dynamic>> Function(Map<String, dynamic>) _apiCall;

  ApiEnrichmentSource(this._name, this._apiCall);

  @override
  String get name => _name;

  @override
  Future<Map<String, dynamic>> enrichData(Map<String, dynamic> data) async {
    final enriched = Map<String, dynamic>.from(data);
    final apiResult = await _apiCall(data);
    enriched.addAll(apiResult);
    return enriched;
  }

  @override
  bool canEnrich(Map<String, dynamic> data) {
    // API sources typically can enrich any data
    return true;
  }
}

/// Composite enricher that combines multiple enrichment sources
class CompositeContentEnricher implements ContentEnricher {
  final List<ContentEnricher> _enrichers;
  final EnrichmentStrategy _strategy;

  CompositeContentEnricher(this._enrichers, this._strategy);

  @override
  Future<Message> enrich(Message message) async {
    switch (_strategy) {
      case EnrichmentStrategy.firstOnly:
        // Use only the first successful enrichment
        for (final enricher in _enrichers) {
          if (enricher.canEnrich(message)) {
            return await enricher.enrich(message);
          }
        }
        return message;

      case EnrichmentStrategy.mergeOverride:
      case EnrichmentStrategy.mergePreserve:
      case EnrichmentStrategy.consensus:
        // Default implementation: sequential enrichment (mergeOverride behavior)
        Message enrichedMessage = message;
        for (final enricher in _enrichers) {
          if (enricher.canEnrich(enrichedMessage)) {
            enrichedMessage = await enricher.enrich(enrichedMessage);
          }
        }
        return enrichedMessage;
    }
  }

  @override
  List<String> get enrichmentSources {
    return _enrichers.expand((e) => e.enrichmentSources).toList();
  }

  @override
  bool canEnrich(Message message) {
    return _enrichers.any((enricher) => enricher.canEnrich(message));
  }
}

/// Enrichment strategy for handling conflicts between enrichers
enum EnrichmentStrategy {
  /// Merge all enrichments, later ones override earlier ones
  mergeOverride,

  /// Merge all enrichments, preserve existing values
  mergePreserve,

  /// Only use the first successful enrichment
  firstOnly,

  /// Require all enrichers to agree on values
  consensus,
}

/// Basic content enricher implementation
class BasicContentEnricher implements ContentEnricher {
  final List<EnrichmentSource> _sources;
  final String _enricherName;

  BasicContentEnricher(this._enricherName, this._sources);

  @override
  Future<Message> enrich(Message message) async {
    if (!canEnrich(message)) {
      return message;
    }

    final enrichedData = Map<String, dynamic>.from(
      message.payload as Map<String, dynamic>? ?? {},
    );
    final enrichmentMetadata = <String, dynamic>{};

    for (final source in _sources) {
      if (source.canEnrich(enrichedData)) {
        try {
          final enrichment = await source.enrichData(enrichedData);
          enrichedData.addAll(enrichment);

          // Track enrichment source
          enrichmentMetadata[source.name] = {
            'enriched': true,
            'timestamp': DateTime.now().toIso8601String(),
          };
        } catch (e) {
          // Track failed enrichment
          enrichmentMetadata[source.name] = {
            'enriched': false,
            'error': e.toString(),
            'timestamp': DateTime.now().toIso8601String(),
          };
        }
      }
    }

    // Create enriched message with metadata
    final enrichedMetadata = Map<String, dynamic>.from(message.metadata);
    enrichedMetadata['enrichment'] = enrichmentMetadata;
    enrichedMetadata['enrichedAt'] = DateTime.now().toIso8601String();
    enrichedMetadata['enrichedBy'] = _enricherName;

    return Message(payload: enrichedData, metadata: enrichedMetadata);
  }

  @override
  List<String> get enrichmentSources => _sources.map((s) => s.name).toList();

  @override
  bool canEnrich(Message message) {
    if (message.payload is! Map<String, dynamic>) {
      return false;
    }

    final data = message.payload as Map<String, dynamic>;
    return _sources.any((source) => source.canEnrich(data));
  }
}

/// Content enricher processor for channels
class ContentEnricherChannelProcessor {
  final ContentEnricher enricher;
  final Channel sourceChannel;
  final Channel targetChannel;

  ContentEnricherChannelProcessor({
    required this.enricher,
    required this.sourceChannel,
    required this.targetChannel,
  });

  /// Starts processing messages from source to target channel
  Future<void> start() async {
    final subscription = sourceChannel.receive().listen(
      (message) async {
        try {
          final enrichedMessage = await enricher.enrich(message);
          await targetChannel.send(enrichedMessage);
        } catch (e) {
          // Log error and optionally send error message
          // In a real implementation, you'd have proper error handling
        }
      },
      onError: (error) {
        // Handle stream errors
      },
      onDone: () {
        // Handle stream completion
      },
    );

    // Store subscription for cleanup
    _subscription = subscription;
  }

  /// Stops processing messages
  Future<void> stop() async {
    await _subscription?.cancel();
    _subscription = null;
  }

  StreamSubscription<Message>? _subscription;
}

/// Enrichment pipeline that chains multiple enrichers
class EnrichmentPipeline {
  final List<ContentEnricher> _enrichers;

  EnrichmentPipeline(this._enrichers);

  /// Processes a message through the entire enrichment pipeline
  Future<Message> process(Message message) async {
    Message currentMessage = message;

    for (final enricher in _enrichers) {
      if (enricher.canEnrich(currentMessage)) {
        currentMessage = await enricher.enrich(currentMessage);
      }
    }

    return currentMessage;
  }

  /// Gets all enrichment sources used in the pipeline
  List<String> get allEnrichmentSources {
    return _enrichers.expand((e) => e.enrichmentSources).toList();
  }
}
