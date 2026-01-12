import 'package:ednet_core/ednet_core.dart';

/// A generic repository for serializable domain models
abstract class SerializableRepository<T extends Entity<dynamic>> {
  /// The concept code this repository handles
  String get conceptCode;

  /// Saves a domain entity to persistent storage
  Future<bool> save(T entity);

  /// Saves multiple domain entities to persistent storage
  Future<bool> saveAll(Iterable<T> entities);

  /// Finds an entity by its ID
  Future<T?> findById(dynamic id);

  /// Gets all entities of this type
  Future<Iterable<T>> findAll();

  /// Removes an entity from storage
  Future<bool> remove(T entity);

  /// Removes an entity by ID from storage
  Future<bool> removeById(dynamic id);

  /// Clears all entities of this type
  Future<bool> clear();

  /// Serializes an entity to a Map
  Map<String, dynamic> serialize(T entity);

  /// Deserializes a Map to an entity
  T deserialize(Map<String, dynamic> data);
}

/// Repository for aggregate roots with event sourcing capabilities
///
/// This interface provides:
/// - Support for event sourcing via save/load events
/// - Optimistic concurrency control via versions
/// - Snapshot management for performance
/// - Query capabilities with filtering
///
/// It specializes the base repository for aggregate root semantics.
abstract class AggregateRootRepository<T extends AggregateRoot<dynamic>>
    extends SerializableRepository<T> {
  /// Finds aggregate root by ID with optimistic concurrency control
  Future<T?> findByIdAndVersion(dynamic id, int version);

  /// Finds aggregate roots by a filter criteria
  Future<Iterable<T>> findByFilter(FilterCriteria filter);

  /// Saves aggregate with its uncommitted events
  Future<bool> saveWithEvents(T aggregate);

  /// Get all events for an aggregate by ID
  Future<List<DomainEvent>> getEventsForAggregate(dynamic id);

  /// Get events for an aggregate after a specific version
  Future<List<DomainEvent>> getEventsForAggregateAfterVersion(
    dynamic id,
    int version,
  );

  /// Save a snapshot of the aggregate's current state
  Future<bool> saveSnapshot(T aggregate);

  /// Get the latest snapshot for an aggregate
  Future<Map<String, dynamic>?> getLatestSnapshot(dynamic id);

  /// Reconstitute an aggregate from its event history
  Future<T?> getByIdFromEvents(dynamic id);

  /// Create a new instance of the aggregate
  T createInstance();
}

/// Repository for managing domain models with persistence
abstract class DomainModelRepository {
  /// Saves the entire domain model state
  Future<bool> saveDomainModel(dynamic domainModel, String domainModelId);

  /// Loads a domain model from persistence
  Future<dynamic> loadDomainModel(String domainModelId);

  /// Checks if a domain model exists in persistence
  Future<bool> domainModelExists(String domainModelId);

  /// Clears a domain model from persistence
  Future<bool> clearDomainModel(String domainModelId);
}

/// Repository factory for creating type-specific repositories
abstract class RepositoryFactory {
  /// Creates a repository for the given entity type
  SerializableRepository<T> createRepository<T extends Entity<dynamic>>(
    String conceptCode,
  );

  /// Creates an aggregate repository for the given aggregate root type
  AggregateRootRepository<T> createAggregateRepository<
    T extends AggregateRoot<dynamic>
  >(String aggregateType);

  /// Creates a domain model repository
  DomainModelRepository createDomainModelRepository();
}
