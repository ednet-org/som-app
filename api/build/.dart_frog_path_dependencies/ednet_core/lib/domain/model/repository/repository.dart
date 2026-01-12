part of ednet_core;

/// Base repository interface for EDNet Core
///
/// This interface defines the core repository operations
/// and serves as the foundation for all repository types.
abstract class Repository {
  /// The concept this repository manages
  Concept get concept;

  /// Initializes the repository
  Future<void> initialize();

  /// Executes a query against this repository
  Future<EntityQueryResult> executeQuery(IQuery query);
}

/// Repository for serializable entities
///
/// This interface defines operations for repositories
/// that work with serializable entities.
abstract class SerializableRepository<T extends Entity<dynamic>>
    extends Repository {
  /// Finds an entity by ID
  Future<T?> findById(String id);

  /// Finds entities matching the given criteria
  Future<EntityQueryResult<T>> findByCriteria(dynamic criteria);

  /// Saves an entity
  Future<bool> save(T entity);

  /// Deletes an entity
  Future<bool> delete(T entity);

  /// Deletes an entity by ID
  Future<bool> deleteById(String id);

  /// Counts entities matching the given criteria
  Future<int> count([dynamic criteria]);

  /// Checks if an entity with the given ID exists
  Future<bool> exists(String id);
}

/// Repository for aggregate roots
///
/// This interface defines operations for repositories
/// that work with aggregate roots, including event sourcing.
abstract class AggregateRootRepository<T extends AggregateRoot<dynamic>>
    extends SerializableRepository<T> {
  /// Finds an aggregate by ID
  @override
  Future<T?> findById(String id);

  /// Saves an aggregate
  @override
  Future<bool> save(T aggregate);

  /// Gets the event history for an aggregate
  Future<List<DomainEvent>> getEventHistory(String aggregateId);

  /// Applies events to reconstruct an aggregate
  Future<T?> rehydrateFromEvents(String aggregateId);

  /// Saves an aggregate and its domain events
  Future<bool> saveWithEvents(T aggregate);

  /// Creates a new aggregate
  Future<T> createAggregate();
}

/// Repository for an entire domain model
///
/// This interface defines operations for repositories
/// that work with entire domain models.
abstract class DomainModelRepository {
  /// Saves a domain model
  Future<bool> saveDomainModel(dynamic domainModel, String domainModelId);

  /// Loads a domain model
  Future<dynamic> loadDomainModel(String domainModelId);

  /// Checks if a domain model exists
  Future<bool> domainModelExists(String domainModelId);

  /// Clears a domain model
  Future<bool> clearDomainModel(String domainModelId);
}

/// Factory for creating repositories
///
/// This interface defines operations for creating different types of repositories.
abstract class RepositoryFactory {
  /// Creates a repository for an entity type
  SerializableRepository<T> createRepository<T extends Entity<dynamic>>(
    String conceptCode,
  );

  /// Creates a repository for an aggregate root type
  AggregateRootRepository<T> createAggregateRepository<
    T extends AggregateRoot<dynamic>
  >(String aggregateType);

  /// Creates a repository for an entire domain model
  DomainModelRepository createDomainModelRepository();
}
