part of ednet_core;

/// A dynamic entity implementation for runtime-loaded domain models.
///
/// This entity type is used when domain models are loaded dynamically
/// (e.g., from YAML) rather than having pre-compiled entity classes.
/// It satisfies EDNet Core's self-referential type constraint while
/// allowing flexible runtime entity creation.
class DynamicEntity extends Entity<DynamicEntity> {
  DynamicEntity() : super();

  /// Creates a new dynamic entity with optional concept
  DynamicEntity.withConcept(Concept concept) : super() {
    this.concept = concept;
  }

  /// Factory method to create a dynamic entity for a concept
  static DynamicEntity create(Concept concept) {
    final entity = DynamicEntity();
    entity.concept = concept;
    return entity;
  }

  @override
  String toString() {
    return 'DynamicEntity<${concept.code}>(oid: $oid)';
  }
}

/// Collection type for dynamic entities
typedef DynamicEntities = Entities<DynamicEntity>;
