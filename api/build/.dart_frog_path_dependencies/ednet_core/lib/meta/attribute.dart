part of ednet_core;

class Attribute extends Property {
  bool guid = false;
  var init;
  int? increment;
  int? sequence;
  bool _derive = false;
  late int length;

  /// Extended metadata for enhanced YAML DSL support
  /// Stores additional attribute information like enumValues, validation rules, etc.
  Map<String, dynamic>? metadata;

  /// Comparison metadata for this specific attribute.
  ///
  /// This overrides any comparison metadata on the AttributeType,
  /// allowing per-attribute comparison configuration.
  ///
  /// Example YAML:
  /// ```yaml
  /// attributes:
  ///   name:
  ///     type: String
  ///     comparison:
  ///       strategy: lexicographic
  ///       caseSensitive: false
  /// ```
  ComparisonMetadata? comparisonMetadata;

  AttributeType? _type;

  Attribute(Concept sourceConcept, String attributeCode)
    : super(sourceConcept, attributeCode) {
    sourceConcept.attributes.add(this);
    // default type is String
    type = sourceConcept.model.domain.getType('String');
  }

  @override
  set required(bool req) {
    super.required = req;
    if (req && !sourceConcept.hasId) {
      essential = true;
    }
  }

  set type(AttributeType? attributeType) {
    _type = attributeType;
    length = attributeType != null ? attributeType.length : 0;
  }

  get type => _type;

  bool get derive => _derive;

  set derive(bool derive) {
    _derive = derive;
    if (_derive) {
      update = false;
    }
  }

  @override
  Map<String, dynamic> toGraph() {
    final graph = super.toGraph();
    graph['guid'] = guid;
    graph['init'] = init;
    graph['increment'] = increment;
    graph['sequence'] = sequence;
    graph['derive'] = derive;
    graph['length'] = length;
    graph['type'] = type?.toGraph();
    if (metadata != null) {
      graph['metadata'] = metadata;
    }
    return graph;
  }
}
