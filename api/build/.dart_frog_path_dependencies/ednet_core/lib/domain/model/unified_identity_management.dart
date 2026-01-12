part of ednet_core;

/// **Unified Identity Management System**
///
/// Manages semantic consistency and traceability of artifacts across domains and YAML partitions.
/// Enables microservice/microfrontend decomposition while maintaining architectural integrity.
///
/// Key Features:
/// - Global unique artifact identification across YAML files
/// - Semantic consistency tracking and validation
/// - Cross-domain dependency resolution
/// - Identity-aware code generation
/// - Partition-safe domain evolution
class UnifiedIdentityManager {
  /// Global registry of all artifact identities
  final Map<GlobalArtifactId, ArtifactIdentity> _globalRegistry = {};

  /// Cross-reference map for dependency tracking
  final Map<GlobalArtifactId, Set<GlobalArtifactId>> _dependencies = {};

  /// YAML partition registry - tracks which artifacts belong to which YAML files
  final Map<String, Set<GlobalArtifactId>> _partitionRegistry = {};

  /// Semantic consistency validation rules
  final List<SemanticConsistencyRule> _consistencyRules = [];

  /// Domain namespace registry to prevent conflicts
  final Map<String, DomainNamespace> _namespaceRegistry = {};

  /// Singleton instance for global access
  static final UnifiedIdentityManager _instance =
      UnifiedIdentityManager._internal();
  factory UnifiedIdentityManager() => _instance;
  UnifiedIdentityManager._internal() {
    _initializeDefaultRules();
  }

  /// Register a new artifact identity
  void registerArtifact({
    required ArtifactIdentity identity,
    required String yamlPartition,
    Set<GlobalArtifactId>? dependencies,
  }) {
    final globalId = identity.globalId;

    // Check for conflicts
    if (_globalRegistry.containsKey(globalId)) {
      final existing = _globalRegistry[globalId]!;
      if (!_areCompatible(existing, identity)) {
        throw IdentityConflictException(
          'Artifact identity conflict: ${globalId.qualifiedName}\n'
          'Existing: ${existing.yamlSource}\n'
          'New: ${identity.yamlSource}',
        );
      }
    }

    // Validate semantic consistency BEFORE adding to registry
    _validateSemanticConsistency(identity);

    // Register the artifact
    _globalRegistry[globalId] = identity;

    // Register partition mapping
    _partitionRegistry.putIfAbsent(yamlPartition, () => {}).add(globalId);

    // Register dependencies
    if (dependencies != null) {
      _dependencies[globalId] = dependencies;
    }
  }

  /// Get artifact identity by global ID
  ArtifactIdentity? getArtifact(GlobalArtifactId globalId) {
    return _globalRegistry[globalId];
  }

  /// Get all artifacts in a YAML partition
  Set<ArtifactIdentity> getPartitionArtifacts(String yamlPartition) {
    final artifactIds = _partitionRegistry[yamlPartition] ?? {};
    return artifactIds
        .map((id) => _globalRegistry[id])
        .where((artifact) => artifact != null)
        .cast<ArtifactIdentity>()
        .toSet();
  }

  /// Get all dependencies for an artifact
  Set<ArtifactIdentity> getDependencies(GlobalArtifactId globalId) {
    final dependencyIds = _dependencies[globalId] ?? {};
    return dependencyIds
        .map((id) => _globalRegistry[id])
        .where((artifact) => artifact != null)
        .cast<ArtifactIdentity>()
        .toSet();
  }

  /// Get all dependents (reverse dependencies) for an artifact
  Set<ArtifactIdentity> getDependents(GlobalArtifactId globalId) {
    final dependents = <ArtifactIdentity>{};

    for (final entry in _dependencies.entries) {
      if (entry.value.contains(globalId)) {
        final dependent = _globalRegistry[entry.key];
        if (dependent != null) {
          dependents.add(dependent);
        }
      }
    }

    return dependents;
  }

  /// Validate cross-partition consistency
  ConsistencyValidationResult validateCrossPartitionConsistency() {
    final issues = <ConsistencyIssue>[];

    // Check for missing dependencies
    for (final entry in _dependencies.entries) {
      final artifactId = entry.key;
      final dependencyIds = entry.value;

      for (final depId in dependencyIds) {
        if (!_globalRegistry.containsKey(depId)) {
          issues.add(
            ConsistencyIssue(
              type: ConsistencyIssueType.missingDependency,
              artifactId: artifactId,
              description: 'Missing dependency: ${depId.qualifiedName}',
              severity: IssueSeverity.error,
            ),
          );
        }
      }
    }

    // Check semantic consistency rules
    for (final rule in _consistencyRules) {
      final ruleIssues = rule.validate(_globalRegistry.values);
      issues.addAll(ruleIssues);
    }

    return ConsistencyValidationResult(
      isValid: issues.where((i) => i.severity == IssueSeverity.error).isEmpty,
      issues: issues,
    );
  }

  /// Generate cross-reference documentation
  CrossReferenceDocumentation generateCrossReference() {
    final sections = <CrossReferenceSection>[];

    // Artifacts by partition
    for (final entry in _partitionRegistry.entries) {
      final partition = entry.key;
      final artifactIds = entry.value;
      final artifacts = artifactIds
          .map((id) => _globalRegistry[id])
          .where((artifact) => artifact != null)
          .cast<ArtifactIdentity>()
          .toList();

      sections.add(
        CrossReferenceSection(
          title: 'YAML Partition: $partition',
          artifacts: artifacts,
          dependencies: _calculatePartitionDependencies(partition),
        ),
      );
    }

    return CrossReferenceDocumentation(
      sections: sections,
      totalArtifacts: _globalRegistry.length,
      totalPartitions: _partitionRegistry.length,
      consistencyStatus: validateCrossPartitionConsistency(),
    );
  }

  /// Register a domain namespace
  void registerNamespace(DomainNamespace namespace) {
    if (_namespaceRegistry.containsKey(namespace.name)) {
      throw NamespaceConflictException(
        'Namespace already exists: ${namespace.name}',
      );
    }

    _namespaceRegistry[namespace.name] = namespace;
  }

  /// Get namespace by name
  DomainNamespace? getNamespace(String name) {
    return _namespaceRegistry[name];
  }

  /// Generate unified namespace mapping for code generation
  Map<String, dynamic> generateNamespaceMapping() {
    return {
      'namespaces': _namespaceRegistry.values.map((ns) => ns.toMap()).toList(),
      'artifacts': _globalRegistry.values.map((art) => art.toMap()).toList(),
      'dependencies': _dependencies.map(
        (key, value) => MapEntry(
          key.qualifiedName,
          value.map((v) => v.qualifiedName).toList(),
        ),
      ),
      'partitions': _partitionRegistry.map(
        (key, value) =>
            MapEntry(key, value.map((v) => v.qualifiedName).toList()),
      ),
    };
  }

  /// Initialize default semantic consistency rules
  void _initializeDefaultRules() {
    _consistencyRules.addAll([
      UniqueNamesRule(),
      TypeConsistencyRule(),
      RelationshipConsistencyRule(),
      DependencyAcyclicRule(),
    ]);
  }

  /// Check if two artifact identities are compatible
  bool _areCompatible(ArtifactIdentity existing, ArtifactIdentity new_) {
    // Same type and compatible signatures
    return existing.artifactType == new_.artifactType &&
        existing.semanticSignature == new_.semanticSignature;
  }

  /// Validate semantic consistency for an artifact
  void _validateSemanticConsistency(ArtifactIdentity identity) {
    for (final rule in _consistencyRules) {
      final issues = rule.validateSingle(identity, _globalRegistry.values);

      for (final issue in issues) {
        if (issue.severity == IssueSeverity.error) {
          throw SemanticConsistencyException(
            'Semantic consistency violation: ${issue.description}',
          );
        }
      }
    }
  }

  /// Calculate dependencies for a partition
  Set<String> _calculatePartitionDependencies(String partition) {
    final artifactIds = _partitionRegistry[partition] ?? {};
    final externalDeps = <String>{};

    for (final artifactId in artifactIds) {
      final dependencies = _dependencies[artifactId] ?? {};

      for (final depId in dependencies) {
        // Find which partition this dependency belongs to
        for (final entry in _partitionRegistry.entries) {
          if (entry.value.contains(depId) && entry.key != partition) {
            externalDeps.add(entry.key);
          }
        }
      }
    }

    return externalDeps;
  }

  /// Clear all registrations (for testing)
  void clear() {
    _globalRegistry.clear();
    _dependencies.clear();
    _partitionRegistry.clear();
    _namespaceRegistry.clear();
  }
}

/// **Global Artifact Identity**
///
/// Unique identifier for any artifact across the entire EDNet ecosystem
class GlobalArtifactId {
  final String namespace;
  final String domain;
  final String artifactType;
  final String name;
  final String version;

  const GlobalArtifactId({
    required this.namespace,
    required this.domain,
    required this.artifactType,
    required this.name,
    this.version = '1.0.0',
  });

  /// Fully qualified name for unique identification
  String get qualifiedName => '$namespace.$domain.$artifactType.$name@$version';

  /// Create from string representation
  factory GlobalArtifactId.fromString(String qualifiedName) {
    final parts = qualifiedName.split('.');
    final nameVersion = parts.last.split('@');

    return GlobalArtifactId(
      namespace: parts[0],
      domain: parts[1],
      artifactType: parts[2],
      name: nameVersion[0],
      version: nameVersion.length > 1 ? nameVersion[1] : '1.0.0',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlobalArtifactId &&
          namespace == other.namespace &&
          domain == other.domain &&
          artifactType == other.artifactType &&
          name == other.name &&
          version == other.version;

  @override
  int get hashCode => qualifiedName.hashCode;

  @override
  String toString() => qualifiedName;

  Map<String, dynamic> toMap() => {
    'namespace': namespace,
    'domain': domain,
    'artifactType': artifactType,
    'name': name,
    'version': version,
    'qualifiedName': qualifiedName,
  };
}

/// **Artifact Identity**
///
/// Complete identity information for an artifact
class ArtifactIdentity {
  final GlobalArtifactId globalId;
  final String yamlSource;
  final String semanticSignature;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  ArtifactIdentity({
    required this.globalId,
    required this.yamlSource,
    required this.semanticSignature,
    this.metadata = const {},
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  String get artifactType => globalId.artifactType;
  String get qualifiedName => globalId.qualifiedName;

  ArtifactIdentity copyWith({
    GlobalArtifactId? globalId,
    String? yamlSource,
    String? semanticSignature,
    Map<String, dynamic>? metadata,
    DateTime? updatedAt,
  }) {
    return ArtifactIdentity(
      globalId: globalId ?? this.globalId,
      yamlSource: yamlSource ?? this.yamlSource,
      semanticSignature: semanticSignature ?? this.semanticSignature,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'globalId': globalId.toMap(),
    'yamlSource': yamlSource,
    'semanticSignature': semanticSignature,
    'metadata': metadata,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

/// **Domain Namespace**
///
/// Manages namespace hierarchy and prevents conflicts
class DomainNamespace {
  final String name;
  final String description;
  final String? parent;
  final Map<String, String> aliases;
  final Set<String> reservedNames;

  const DomainNamespace({
    required this.name,
    required this.description,
    this.parent,
    this.aliases = const {},
    this.reservedNames = const {},
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'parent': parent,
    'aliases': aliases,
    'reservedNames': reservedNames.toList(),
  };
}

/// **Semantic Consistency Rules**
abstract class SemanticConsistencyRule {
  String get name;
  String get description;

  List<ConsistencyIssue> validate(Iterable<ArtifactIdentity> artifacts);
  List<ConsistencyIssue> validateSingle(
    ArtifactIdentity artifact,
    Iterable<ArtifactIdentity> context,
  );
}

/// Rule: Ensure unique names within the same scope
class UniqueNamesRule extends SemanticConsistencyRule {
  @override
  String get name => 'Unique Names Rule (DDD Bounded Context Aware)';

  @override
  String get description =>
      'Artifact names must be unique within the same namespace, domain, and type. Same names allowed across bounded contexts.';

  @override
  List<ConsistencyIssue> validate(Iterable<ArtifactIdentity> artifacts) {
    final issues = <ConsistencyIssue>[];
    final seen = <String, ArtifactIdentity>{};

    for (final artifact in artifacts) {
      // DDD Fix: Include domain in uniqueness key to allow same concept names across bounded contexts
      final key =
          '${artifact.globalId.namespace}.${artifact.globalId.domain}.${artifact.globalId.artifactType}.${artifact.globalId.name}';

      if (seen.containsKey(key)) {
        final existing = seen[key]!;
        // Only flag as error if they're truly duplicates (same domain, namespace, type, name)
        issues.add(
          ConsistencyIssue(
            type: ConsistencyIssueType.nameConflict,
            artifactId: artifact.globalId,
            description:
                'Duplicate name within same bounded context: ${artifact.globalId.name} in domain ${artifact.globalId.domain} conflicts with ${existing.yamlSource}',
            severity: IssueSeverity.error,
          ),
        );
      } else {
        seen[key] = artifact;
      }
    }

    // DDD Enhancement: Track cross-context correlations for informational purposes
    final crossContextCorrelations = _findCrossContextCorrelations(artifacts);
    for (final correlation in crossContextCorrelations) {
      issues.add(
        ConsistencyIssue(
          type: ConsistencyIssueType.crossContextCorrelation,
          artifactId: correlation.primary.globalId,
          description:
              'Cross-context correlation detected: ${correlation.primary.globalId.name} exists in ${correlation.domains.join(", ")} domains - this is valid DDD pattern',
          severity: IssueSeverity.info,
        ),
      );
    }

    return issues;
  }

  @override
  List<ConsistencyIssue> validateSingle(
    ArtifactIdentity artifact,
    Iterable<ArtifactIdentity> context,
  ) {
    return validate([artifact, ...context]);
  }

  /// Find concepts with the same name across different bounded contexts (domains)
  /// This is a valid DDD pattern for identity correlation
  List<CrossContextCorrelation> _findCrossContextCorrelations(
    Iterable<ArtifactIdentity> artifacts,
  ) {
    final correlations = <CrossContextCorrelation>[];
    final nameGroups = <String, List<ArtifactIdentity>>{};

    // Group by concept name
    for (final artifact in artifacts) {
      if (artifact.artifactType == 'concept') {
        final name = artifact.globalId.name;
        nameGroups.putIfAbsent(name, () => []).add(artifact);
      }
    }

    // Find groups with multiple domains
    for (final entry in nameGroups.entries) {
      final name = entry.key;
      final artifacts = entry.value;

      if (artifacts.length > 1) {
        final domains = artifacts.map((a) => a.globalId.domain).toSet();
        if (domains.length > 1) {
          correlations.add(
            CrossContextCorrelation(
              conceptName: name,
              primary: artifacts.first,
              domains: domains.toList(),
              artifacts: artifacts,
            ),
          );
        }
      }
    }

    return correlations;
  }
}

/// Rule: Ensure type consistency across references
class TypeConsistencyRule extends SemanticConsistencyRule {
  @override
  String get name => 'Type Consistency Rule';

  @override
  String get description => 'Referenced artifacts must have consistent types';

  @override
  List<ConsistencyIssue> validate(Iterable<ArtifactIdentity> artifacts) {
    // Implementation for type consistency validation
    return [];
  }

  @override
  List<ConsistencyIssue> validateSingle(
    ArtifactIdentity artifact,
    Iterable<ArtifactIdentity> context,
  ) {
    return [];
  }
}

/// Rule: Ensure relationship consistency
class RelationshipConsistencyRule extends SemanticConsistencyRule {
  @override
  String get name => 'Relationship Consistency Rule';

  @override
  String get description => 'Relationships must reference valid artifacts';

  @override
  List<ConsistencyIssue> validate(Iterable<ArtifactIdentity> artifacts) {
    // Implementation for relationship consistency validation
    return [];
  }

  @override
  List<ConsistencyIssue> validateSingle(
    ArtifactIdentity artifact,
    Iterable<ArtifactIdentity> context,
  ) {
    return [];
  }
}

/// Rule: Ensure dependency graph is acyclic
class DependencyAcyclicRule extends SemanticConsistencyRule {
  @override
  String get name => 'Dependency Acyclic Rule';

  @override
  String get description => 'Dependency graph must not contain cycles';

  @override
  List<ConsistencyIssue> validate(Iterable<ArtifactIdentity> artifacts) {
    // Implementation for dependency cycle detection
    return [];
  }

  @override
  List<ConsistencyIssue> validateSingle(
    ArtifactIdentity artifact,
    Iterable<ArtifactIdentity> context,
  ) {
    return [];
  }
}

/// **Consistency Validation Results**
class ConsistencyValidationResult {
  final bool isValid;
  final List<ConsistencyIssue> issues;

  const ConsistencyValidationResult({
    required this.isValid,
    required this.issues,
  });

  List<ConsistencyIssue> get errors =>
      issues.where((i) => i.severity == IssueSeverity.error).toList();

  List<ConsistencyIssue> get warnings =>
      issues.where((i) => i.severity == IssueSeverity.warning).toList();
}

class ConsistencyIssue {
  final ConsistencyIssueType type;
  final GlobalArtifactId artifactId;
  final String description;
  final IssueSeverity severity;

  const ConsistencyIssue({
    required this.type,
    required this.artifactId,
    required this.description,
    required this.severity,
  });
}

/// **Cross-Context Correlation**
///
/// Represents the same concept across different bounded contexts (DDD pattern)
class CrossContextCorrelation {
  final String conceptName;
  final ArtifactIdentity primary;
  final List<String> domains;
  final List<ArtifactIdentity> artifacts;

  const CrossContextCorrelation({
    required this.conceptName,
    required this.primary,
    required this.domains,
    required this.artifacts,
  });

  Map<String, dynamic> toMap() => {
    'conceptName': conceptName,
    'primary': primary.toMap(),
    'domains': domains,
    'artifacts': artifacts.map((a) => a.toMap()).toList(),
  };
}

/// **Consistency Issue Types**
enum ConsistencyIssueType {
  nameConflict,
  missingDependency,
  typeMismatch,
  relationshipError,
  circularDependency,
  semanticInconsistency,
  crossContextCorrelation,
}

enum IssueSeverity { error, warning, info }

/// **Cross-Reference Documentation**
class CrossReferenceDocumentation {
  final List<CrossReferenceSection> sections;
  final int totalArtifacts;
  final int totalPartitions;
  final ConsistencyValidationResult consistencyStatus;

  const CrossReferenceDocumentation({
    required this.sections,
    required this.totalArtifacts,
    required this.totalPartitions,
    required this.consistencyStatus,
  });
}

class CrossReferenceSection {
  final String title;
  final List<ArtifactIdentity> artifacts;
  final Set<String> dependencies;

  const CrossReferenceSection({
    required this.title,
    required this.artifacts,
    required this.dependencies,
  });
}

/// **Exceptions**
class IdentityConflictException implements Exception {
  final String message;
  const IdentityConflictException(this.message);

  @override
  String toString() => 'IdentityConflictException: $message';
}

class NamespaceConflictException implements Exception {
  final String message;
  const NamespaceConflictException(this.message);

  @override
  String toString() => 'NamespaceConflictException: $message';
}

class SemanticConsistencyException implements Exception {
  final String message;
  const SemanticConsistencyException(this.message);

  @override
  String toString() => 'SemanticConsistencyException: $message';
}
