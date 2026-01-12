part of ednet_core;

/// Input for Bloom Filter algorithm
class BloomFilterInput {
  final List<String> items;
  final int expectedElements;
  final double falsePositiveRate;

  BloomFilterInput({
    required this.items,
    required this.expectedElements,
    required this.falsePositiveRate,
  });
}

/// Result of Bloom Filter algorithm
class BloomFilterResult {
  final List<bool> _filter;
  final int _hashFunctions;
  final int _size;
  final double _falsePositiveRate;
  final int _expectedElements;

  BloomFilterResult({
    required List<bool> filter,
    required int hashFunctions,
    required int size,
    required double falsePositiveRate,
    required int expectedElements,
  }) : _filter = filter,
       _hashFunctions = hashFunctions,
       _size = size,
       _falsePositiveRate = falsePositiveRate,
       _expectedElements = expectedElements;

  /// Check if an item might be in the filter
  bool contains(String item) {
    for (int i = 0; i < _hashFunctions; i++) {
      final hash = _hash(item, i) % _size;
      if (!_filter[hash]) {
        return false; // Definitely not in set
      }
    }
    return true; // Might be in set (or false positive)
  }

  /// Add an item to the filter
  void add(String item) {
    for (int i = 0; i < _hashFunctions; i++) {
      final hash = _hash(item, i) % _size;
      _filter[hash] = true;
    }
  }

  /// Get the bit array (for inspection)
  List<bool> get filter => List.unmodifiable(_filter);

  /// Get the size of the bit array
  int get size => _size;

  /// Get the number of hash functions
  int get hashFunctions => _hashFunctions;

  /// Get statistics about the filter
  Map<String, dynamic> getStatistics() {
    final setBits = _filter.where((bit) => bit).length;
    final fillRatio = setBits / _size;

    return {
      'size': _size,
      'hashFunctions': _hashFunctions,
      'expectedElements': _expectedElements,
      'falsePositiveRate': _falsePositiveRate,
      'bitsPerElement': _size / _expectedElements,
      'setBits': setBits,
      'fillRatio': fillRatio,
    };
  }

  /// Hash function with seed for multiple hash functions
  int _hash(String item, int seed) {
    var hash = seed;
    for (int i = 0; i < item.length; i++) {
      hash = (hash * 31 + item.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return hash;
  }
}

/// Bloom Filter algorithm implementation
///
/// A space-efficient probabilistic data structure for fast membership testing.
/// Can have false positives but never false negatives.
/// Perfect for "definitely not in set" vs "possibly in set" scenarios.
class BloomFilterAlgorithm
    extends Algorithm<BloomFilterInput, BloomFilterResult> {
  BloomFilterAlgorithm()
    : super(
        code: 'bloom_filter',
        name: 'Bloom Filter',
        description:
            'Space-efficient probabilistic data structure for fast membership testing',
        applicableToConcepts: [
          'Search',
          'Index',
          'Cache',
          'KnowledgeBase',
          'Recommendation',
        ],
        providedBehaviors: [
          'fast-membership-testing',
          'probabilistic-search',
          'memory-efficient-lookup',
          'concept-filtering',
          'semantic-recommendation',
          'knowledge-base-optimization',
        ],
      );

  @override
  BloomFilterResult performExecution(BloomFilterInput input) {
    final items = input.items;
    final expectedElements = input.expectedElements;
    final falsePositiveRate = input.falsePositiveRate;

    // Calculate optimal bit array size
    // m = -n * ln(p) / (ln(2)^2)
    // where n = expected elements, p = false positive rate
    final size = _calculateOptimalSize(expectedElements, falsePositiveRate);

    // Calculate optimal number of hash functions
    // k = (m/n) * ln(2)
    // where m = bit array size, n = expected elements
    final hashFunctions = _calculateOptimalHashFunctions(
      size,
      expectedElements,
    );

    // Create bit array
    final filter = List<bool>.filled(size, false);

    // Create result with empty filter
    final result = BloomFilterResult(
      filter: filter,
      hashFunctions: hashFunctions,
      size: size,
      falsePositiveRate: falsePositiveRate,
      expectedElements: expectedElements,
    );

    // Add all items to the filter
    for (final item in items) {
      result.add(item);
    }

    return result;
  }

  /// Calculate optimal bit array size based on expected elements and false positive rate
  int _calculateOptimalSize(int expectedElements, double falsePositiveRate) {
    if (expectedElements <= 0) return 64; // Minimum size

    // m = -n * ln(p) / (ln(2)^2)
    final size =
        (-expectedElements * log(falsePositiveRate) / (log(2) * log(2))).ceil();
    return size.clamp(64, 1000000); // Reasonable bounds
  }

  /// Calculate optimal number of hash functions
  int _calculateOptimalHashFunctions(int size, int expectedElements) {
    if (expectedElements <= 0) return 1;

    // k = (m/n) * ln(2)
    final hashFunctions = ((size / expectedElements) * log(2)).round();
    return hashFunctions.clamp(1, 20); // Reasonable bounds
  }
}
