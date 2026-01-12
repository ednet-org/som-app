/// Infrastructure layer for the EDNet Core framework.
///
/// This library provides infrastructure components that support the domain layer:
/// - Graph-based data structures for domain relationships
/// - Repository implementations for persistence
/// - Infrastructure utilities and helpers
///
/// The infrastructure layer is responsible for:
/// - Data persistence and retrieval
/// - External system integration
/// - Technical concerns and implementations
/// - Supporting domain layer operations
///
/// Example usage:
/// ```dart
/// import 'package:ednet_core/domain/infrastructure.dart';
///
/// // Use graph structures
/// final graph = Graph();
///
/// // Use repositories
/// final repository = Repository();
/// ```
library infrastructure;

/// Exports graph-related functionality for domain relationships.
// NOTE: This package intentionally avoids depending on other packages here.
// export '../../../ednet_flow/lib/src/graph.dart';

/// Exports repository implementations for data persistence.
// NOTE: Add exports once the repository surface is finalized.
// export 'infrastructure/repository.dart';
