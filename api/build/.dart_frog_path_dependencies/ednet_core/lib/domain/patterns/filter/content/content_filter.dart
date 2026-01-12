part of ednet_core;

/// Content Filter Pattern
///
/// The Content Filter pattern simplifies message content by removing or transforming
/// unnecessary data, keeping only the information that the message recipient needs.
/// This pattern is essential when consumers are only interested in a subset of the
/// message data, reducing processing overhead and network traffic.
///
/// In EDNet/direct democracy contexts, content filtering is crucial for:
/// * Simplifying citizen notifications to include only relevant information
/// * Reducing proposal data to essential elements for mobile consumption
/// * Filtering voting results to show only pertinent statistics
/// * Streamlining deliberation messages for different user roles
/// * Optimizing data transmission for bandwidth-constrained environments

/// Abstract interface for content filtering
abstract class ContentFilter {
  /// Filters the content of a message
  Future<Message> filter(Message message);

  /// Checks if this filter can process the given message
  bool canFilter(Message message);

  /// Gets the filter criteria or rules
  Map<String, dynamic> getFilterCriteria();
}

/// Filter rule definition
class FilterRule {
  final String field;
  final FilterOperation operation;
  final dynamic value;
  final bool keep; // true to keep matching fields, false to remove them

  FilterRule({
    required this.field,
    required this.operation,
    this.value,
    this.keep = true,
  });

  bool matches(dynamic fieldValue) {
    switch (operation) {
      case FilterOperation.equals:
        return value != null && fieldValue == value;
      case FilterOperation.notEquals:
        return value != null && fieldValue != value;
      case FilterOperation.contains:
        if (value == null) return false;
        if (fieldValue is String && value is String) {
          return fieldValue.contains(value);
        }
        if (fieldValue is List) {
          return fieldValue.contains(value);
        }
        return false;
      case FilterOperation.notContains:
        if (value == null) return true;
        if (fieldValue is String && value is String) {
          return !fieldValue.contains(value);
        }
        if (fieldValue is List) {
          return !fieldValue.contains(value);
        }
        return true;
      case FilterOperation.greaterThan:
        if (value == null) return false;
        if (fieldValue is num && value is num) {
          return fieldValue > value;
        }
        return false;
      case FilterOperation.lessThan:
        if (value == null) return false;
        if (fieldValue is num && value is num) {
          return fieldValue < value;
        }
        return false;
      case FilterOperation.exists:
        return fieldValue != null;
      case FilterOperation.notExists:
        return fieldValue == null;
      case FilterOperation.regex:
        if (value == null) return false;
        if (fieldValue is String && value is String) {
          return RegExp(value).hasMatch(fieldValue);
        }
        return false;
    }
  }
}

/// Filter operations
enum FilterOperation {
  equals,
  notEquals,
  contains,
  notContains,
  greaterThan,
  lessThan,
  exists,
  notExists,
  regex,
}

/// Field-based content filter
class FieldBasedContentFilter implements ContentFilter {
  final List<String> fieldsToKeep;
  final List<String> fieldsToRemove;
  final List<FilterRule> rules;
  final String filterName;

  FieldBasedContentFilter({
    required this.filterName,
    this.fieldsToKeep = const [],
    this.fieldsToRemove = const [],
    this.rules = const [],
  });

  @override
  Future<Message> filter(Message message) async {
    if (!canFilter(message) || message.payload is! Map<String, dynamic>) {
      return message;
    }

    final originalPayload = message.payload as Map<String, dynamic>;
    final filteredPayload = <String, dynamic>{};

    // Apply field filtering
    if (fieldsToKeep.isNotEmpty) {
      // Keep only specified fields
      for (final field in fieldsToKeep) {
        if (originalPayload.containsKey(field)) {
          filteredPayload[field] = originalPayload[field];
        }
      }
    } else if (fieldsToRemove.isNotEmpty) {
      // Remove specified fields
      originalPayload.forEach((key, value) {
        if (!fieldsToRemove.contains(key)) {
          filteredPayload[key] = value;
        }
      });
    } else {
      // Keep all fields if no specific filtering
      filteredPayload.addAll(originalPayload);
    }

    // Apply rule-based filtering
    final ruleFilteredPayload = <String, dynamic>{};
    filteredPayload.forEach((key, value) {
      bool keepField = true;

      for (final rule in rules) {
        if (rule.field == key || rule.field == '*') {
          keepField = rule.keep && rule.matches(value);
          if (!keepField) break;
        }
      }

      if (keepField) {
        ruleFilteredPayload[key] = value;
      }
    });

    // Create filtered metadata
    final filteredMetadata = Map<String, dynamic>.from(message.metadata);
    filteredMetadata['filtered'] = true;
    filteredMetadata['filterName'] = filterName;
    filteredMetadata['originalFieldCount'] = originalPayload.length;
    filteredMetadata['filteredFieldCount'] = ruleFilteredPayload.length;
    filteredMetadata['fieldsRemoved'] =
        originalPayload.length - ruleFilteredPayload.length;

    return Message(payload: ruleFilteredPayload, metadata: filteredMetadata);
  }

  @override
  bool canFilter(Message message) {
    return message.payload is Map<String, dynamic>;
  }

  @override
  Map<String, dynamic> getFilterCriteria() {
    return {
      'name': filterName,
      'fieldsToKeep': fieldsToKeep,
      'fieldsToRemove': fieldsToRemove,
      'rules': rules
          .map(
            (rule) => {
              'field': rule.field,
              'operation': rule.operation.toString(),
              'value': rule.value,
              'keep': rule.keep,
            },
          )
          .toList(),
    };
  }
}

/// Size-based content filter that limits payload size
class SizeBasedContentFilter implements ContentFilter {
  final int maxPayloadSize;
  final bool prioritizeImportantFields;
  final List<String> importantFields;
  final String filterName;

  SizeBasedContentFilter({
    required this.filterName,
    required this.maxPayloadSize,
    this.prioritizeImportantFields = true,
    this.importantFields = const [],
  });

  @override
  Future<Message> filter(Message message) async {
    if (!canFilter(message) || message.payload is! Map<String, dynamic>) {
      return message;
    }

    final originalPayload = message.payload as Map<String, dynamic>;
    final currentSize = _estimatePayloadSize(originalPayload);

    if (currentSize <= maxPayloadSize) {
      return message; // No filtering needed
    }

    final filteredPayload = <String, dynamic>{};

    if (prioritizeImportantFields && importantFields.isNotEmpty) {
      // Always include important fields
      for (final field in importantFields) {
        if (originalPayload.containsKey(field)) {
          filteredPayload[field] = originalPayload[field];
        }
      }

      // Add other fields until we reach the size limit
      for (final entry in originalPayload.entries) {
        if (!importantFields.contains(entry.key) &&
            !filteredPayload.containsKey(entry.key)) {
          final testPayload = Map<String, dynamic>.from(filteredPayload);
          testPayload[entry.key] = entry.value;

          if (_estimatePayloadSize(testPayload) <= maxPayloadSize) {
            filteredPayload[entry.key] = entry.value;
          } else {
            break; // Can't add more fields
          }
        }
      }
    } else {
      // Simple truncation - add fields until size limit
      for (final entry in originalPayload.entries) {
        final testPayload = Map<String, dynamic>.from(filteredPayload);
        testPayload[entry.key] = entry.value;

        if (_estimatePayloadSize(testPayload) <= maxPayloadSize) {
          filteredPayload[entry.key] = entry.value;
        } else {
          break;
        }
      }
    }

    // Create filtered metadata
    final filteredMetadata = Map<String, dynamic>.from(message.metadata);
    filteredMetadata['filtered'] = true;
    filteredMetadata['filterName'] = filterName;
    filteredMetadata['sizeFiltered'] = true;
    filteredMetadata['originalSize'] = currentSize;
    filteredMetadata['filteredSize'] = _estimatePayloadSize(filteredPayload);
    filteredMetadata['maxAllowedSize'] = maxPayloadSize;

    return Message(payload: filteredPayload, metadata: filteredMetadata);
  }

  @override
  bool canFilter(Message message) {
    return message.payload is Map<String, dynamic>;
  }

  @override
  Map<String, dynamic> getFilterCriteria() {
    return {
      'name': filterName,
      'maxPayloadSize': maxPayloadSize,
      'prioritizeImportantFields': prioritizeImportantFields,
      'importantFields': importantFields,
    };
  }

  int _estimatePayloadSize(Map<String, dynamic> payload) {
    // Simple size estimation
    int size = 0;
    payload.forEach((key, value) {
      size += key.length * 2; // Key size
      if (value is String) {
        size += value.length * 2;
      } else if (value is num) {
        size += 8;
      } else if (value is List) {
        size += value.length * 4;
      } else if (value is Map) {
        size += value.length * 8;
      } else {
        size += 16; // Default object size
      }
    });
    return size;
  }
}

/// Composite content filter that combines multiple filters
class CompositeContentFilter implements ContentFilter {
  final List<ContentFilter> filters;
  final String filterName;
  final bool stopOnFirstMatch;

  CompositeContentFilter({
    required this.filterName,
    required this.filters,
    this.stopOnFirstMatch = false,
  });

  @override
  Future<Message> filter(Message message) async {
    Message filteredMessage = message;

    for (final filter in filters) {
      if (filter.canFilter(filteredMessage)) {
        filteredMessage = await filter.filter(filteredMessage);

        if (stopOnFirstMatch) {
          break;
        }
      }
    }

    // Add composite filter metadata
    final metadata = Map<String, dynamic>.from(filteredMessage.metadata);
    metadata['compositeFilter'] = filterName;
    metadata['appliedFilters'] = filters
        .map((f) => f.getFilterCriteria()['name'])
        .toList();

    return Message(payload: filteredMessage.payload, metadata: metadata);
  }

  @override
  bool canFilter(Message message) {
    return filters.any((filter) => filter.canFilter(message));
  }

  @override
  Map<String, dynamic> getFilterCriteria() {
    return {
      'name': filterName,
      'stopOnFirstMatch': stopOnFirstMatch,
      'filters': filters.map((f) => f.getFilterCriteria()).toList(),
    };
  }
}

/// Content filter processor for channels
class ContentFilterChannelProcessor {
  final ContentFilter filter;
  final Channel sourceChannel;
  final Channel targetChannel;

  ContentFilterChannelProcessor({
    required this.filter,
    required this.sourceChannel,
    required this.targetChannel,
  });

  /// Starts processing messages from source to target channel
  Future<void> start() async {
    final subscription = sourceChannel.receive().listen(
      (message) async {
        try {
          final filteredMessage = await filter.filter(message);
          await targetChannel.send(filteredMessage);
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

/// Filter chain for sequential content filtering
class ContentFilterChain {
  final List<ContentFilter> filters;

  ContentFilterChain(this.filters);

  /// Applies all filters in sequence
  Future<Message> process(Message message) async {
    Message currentMessage = message;

    for (final filter in filters) {
      if (filter.canFilter(currentMessage)) {
        currentMessage = await filter.filter(currentMessage);
      }
    }

    return currentMessage;
  }

  /// Gets statistics about the filter chain
  Map<String, dynamic> getChainStats() {
    return {
      'filterCount': filters.length,
      'filters': filters.map((f) => f.getFilterCriteria()).toList(),
    };
  }
}
