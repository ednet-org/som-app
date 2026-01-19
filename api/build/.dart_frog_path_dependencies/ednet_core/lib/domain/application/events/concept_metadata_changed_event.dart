part of ednet_core;

/// Domain event emitted when Concept metadata changes.
class ConceptMetadataChangedEvent extends DomainEvent {
  /// Creates a concept metadata changed event.
  ConceptMetadataChangedEvent({
    required this.concept,
    Map<String, dynamic>? previousMetadata,
    Map<String, dynamic>? updatedMetadata,
    String? aggregateId,
    String? aggregateType,
  }) : previousMetadata = Map<String, dynamic>.from(
         previousMetadata ?? const {},
       ),
       updatedMetadata = Map<String, dynamic>.from(
         updatedMetadata ?? concept.metadata,
       ),
       super(
         name: 'ConceptMetadataChanged',
         entity: concept,
         aggregateId: aggregateId ?? (concept.code ?? ''),
         aggregateType: aggregateType ?? 'Concept',
       );

  /// The concept whose metadata changed.
  final Concept concept;

  /// Metadata snapshot before the change.
  final Map<String, dynamic> previousMetadata;

  /// Metadata snapshot after the change.
  final Map<String, dynamic> updatedMetadata;

  /// Concept code for quick filtering.
  String get conceptCode => concept.code ?? '';

  /// Attribute codes in the updated concept.
  List<String> get attributeCodes =>
      concept.attributes.map((attr) => attr.code).toList();

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'conceptCode': conceptCode,
      'previousMetadata': previousMetadata,
      'updatedMetadata': updatedMetadata,
      'attributeCodes': attributeCodes,
    });
    return json;
  }
}
