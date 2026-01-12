part of ednet_core;

/// **Enhanced OneApplication Interface**
///
/// Core orchestrator for the EDNet.One ecosystem that manages:
/// - Domain models and their relationships
/// - Unified identity management across YAML partitions
/// - Ontology integration with DBpedia
/// - Agentic domain modeling recommendations
/// - Semantic consistency and traceability
abstract class IOneApplication {
  /// Core domain management (existing)
  Domains get domains;
  Domains get groupedDomains;
  DomainModels getDomainModels(String domain, String model);

  /// **Unified Identity Management** 🌍

  /// Get the unified identity manager for cross-partition artifact tracking
  UnifiedIdentityManager get identityManager;

  /// Register artifacts from multiple YAML sources with semantic consistency
  Future<IdentityRegistrationResult> registerArtifactsFromYamls({
    required List<String> yamlFilePaths,
    String defaultNamespace = 'ednet',
    bool strictValidation = false,
  });

  /// Validate semantic consistency across all registered artifacts
  Future<SemanticConsistencyReport> validateSemanticConsistency();

  /// Find artifacts across all partitions with advanced querying
  // ArtifactIdentities findArtifacts({
  //   String? namespace,
  //   String? domain,
  //   String? artifactType,
  //   String? yamlSource,
  // });

  /// Get cross-partition dependency graph
  Map<String, Set<String>> getCrossPartitionDependencies();

  /// **Ontology Integration** 🧠

  /// Bind artifact to DBpedia ontology for semantic enrichment
  Future<OntologyBinding> bindToDbpedia(ArtifactIdentity artifact);

  /// Generate domain model recommendations based on DBpedia knowledge
  Future<List<DomainModelRecommendation>> getDbpediaRecommendations({
    required String domainContext,
    int maxRecommendations = 10,
  });

  /// Enrich existing domain model with ontological relationships
  Future<EnrichmentResult> enrichWithOntology(String domainName);

  /// **Agentic Domain Modeling** 🤖

  /// Get intelligent suggestions for domain modeling based on context
  Future<List<AgenticSuggestion>> getModelingSuggestions({
    required String currentContext,
    List<ArtifactIdentity>? existingArtifacts,
  });

  /// Execute recommended domain modeling actions
  Future<ActionExecutionResult> executeRecommendedAction(AgenticAction action);

  /// Get contextual tooling proposals for domain evolution
  Future<List<ToolingProposal>> getToolingProposals({
    required String domainName,
    required String evolutionGoal,
  });

  /// **Semantic Evolution & Learning** 📚

  /// Learn from user's domain modeling patterns for future recommendations
  Future<void> learnFromModelingSession(ModelingSession session);

  /// Generate semantic similarity reports between artifacts
  Future<SimilarityReport> generateSimilarityReport(
    ArtifactIdentity artifact1,
    ArtifactIdentity artifact2,
  );

  /// Track domain model evolution over time
  Future<EvolutionTimeline> getEvolutionTimeline(String domainName);

  /// **Code Generation & Deployment** 🚀

  /// Generate code with unified identity awareness
  Future<GenerationResult> generateWithIdentityManagement({
    required List<String> yamlFilePaths,
    required String outputPath,
    GenerationOptions? options,
  });

  /// Deploy to multiple environments with partition-aware configurations
  Future<DeploymentResult> deployPartitionedSystem({
    required Map<String, String> partitionEnvironments,
    DeploymentOptions? options,
  });

  /// **Quality & Governance** 🛡️

  /// Run comprehensive quality gates across all partitions
  Future<QualityGateReport> runQualityGates();

  /// Generate architectural decision records (ADRs) for identity changes
  Future<List<ArchitecturalDecisionRecord>> generateADRs({
    DateTime? since,
    String? namespace,
  });

  /// Validate compliance with domain modeling best practices
  Future<ComplianceReport> validateCompliance(ComplianceStandard standard);
}

/// **Supporting Data Classes for Enhanced OneApplication**

/// Result of registering artifacts from YAML files
class IdentityRegistrationResult {
  final int totalArtifacts;
  final int successfulRegistrations;
  final List<String> errors;
  final Map<String, int> artifactsByType;
  final Map<String, int> artifactsByNamespace;

  const IdentityRegistrationResult({
    required this.totalArtifacts,
    required this.successfulRegistrations,
    required this.errors,
    required this.artifactsByType,
    required this.artifactsByNamespace,
  });

  bool get isSuccessful => errors.isEmpty;
  double get successRate => successfulRegistrations / totalArtifacts;
}

/// Semantic consistency validation report
class SemanticConsistencyReport {
  final bool isConsistent;
  final List<SemanticInconsistency> inconsistencies;
  final Map<String, List<String>> conflictsByType;
  final int totalArtifactsChecked;

  const SemanticConsistencyReport({
    required this.isConsistent,
    required this.inconsistencies,
    required this.conflictsByType,
    required this.totalArtifactsChecked,
  });
}

/// Ontology binding result for DBpedia integration
class OntologyBinding {
  final ArtifactIdentity artifact;
  final String dbpediaUri;
  final Map<String, dynamic> ontologyProperties;
  final List<String> relatedConcepts;
  final double confidenceScore;

  const OntologyBinding({
    required this.artifact,
    required this.dbpediaUri,
    required this.ontologyProperties,
    required this.relatedConcepts,
    required this.confidenceScore,
  });
}

/// Domain model recommendation from DBpedia analysis
class DomainModelRecommendation {
  final String conceptName;
  final String description;
  final List<String> suggestedAttributes;
  final List<String> suggestedRelationships;
  final String dbpediaSource;
  final double relevanceScore;

  const DomainModelRecommendation({
    required this.conceptName,
    required this.description,
    required this.suggestedAttributes,
    required this.suggestedRelationships,
    required this.dbpediaSource,
    required this.relevanceScore,
  });
}

/// Agentic suggestion for domain modeling improvements
class AgenticSuggestion {
  final String suggestionId;
  final String type; // 'concept', 'attribute', 'relationship', 'pattern'
  final String title;
  final String description;
  final String rationale;
  final List<AgenticAction> proposedActions;
  final double confidenceScore;

  const AgenticSuggestion({
    required this.suggestionId,
    required this.type,
    required this.title,
    required this.description,
    required this.rationale,
    required this.proposedActions,
    required this.confidenceScore,
  });
}

/// Action that can be executed based on agentic recommendations
class AgenticAction {
  final String actionId;
  final String type; // 'create', 'modify', 'delete', 'refactor'
  final String targetArtifact;
  final Map<String, dynamic> parameters;
  final List<String> dependencies;

  const AgenticAction({
    required this.actionId,
    required this.type,
    required this.targetArtifact,
    required this.parameters,
    required this.dependencies,
  });
}

/// Result of executing agentic actions
class ActionExecutionResult {
  final String actionId;
  final bool success;
  final String? errorMessage;
  final List<String> generatedArtifacts;
  final List<String> modifiedArtifacts;

  const ActionExecutionResult({
    required this.actionId,
    required this.success,
    this.errorMessage,
    required this.generatedArtifacts,
    required this.modifiedArtifacts,
  });
}

/// Tooling proposal for domain evolution
class ToolingProposal {
  final String proposalId;
  final String toolName;
  final String description;
  final Map<String, dynamic> configuration;
  final List<String> expectedBenefits;

  const ToolingProposal({
    required this.proposalId,
    required this.toolName,
    required this.description,
    required this.configuration,
    required this.expectedBenefits,
  });
}

/// Comprehensive quality gate report
class QualityGateReport {
  final bool allGatesPassed;
  final Map<String, QualityGateResult> gateResults;
  final List<String> criticalIssues;
  final List<String> warnings;
  final double overallScore;

  const QualityGateReport({
    required this.allGatesPassed,
    required this.gateResults,
    required this.criticalIssues,
    required this.warnings,
    required this.overallScore,
  });
}

/// Individual quality gate result
class QualityGateResult {
  final String gateName;
  final bool passed;
  final double score;
  final List<String> issues;
  final Map<String, dynamic> metrics;

  const QualityGateResult({
    required this.gateName,
    required this.passed,
    required this.score,
    required this.issues,
    required this.metrics,
  });
}

/// Architectural decision record for governance
class ArchitecturalDecisionRecord {
  final String id;
  final String title;
  final String context;
  final String decision;
  final String rationale;
  final List<String> consequences;
  final DateTime timestamp;
  final String author;

  const ArchitecturalDecisionRecord({
    required this.id,
    required this.title,
    required this.context,
    required this.decision,
    required this.rationale,
    required this.consequences,
    required this.timestamp,
    required this.author,
  });
}

/// Additional supporting classes for comprehensive functionality
class SemanticInconsistency {
  final String type;
  final String description;
  final List<String> affectedArtifacts;
  final String severity;

  const SemanticInconsistency({
    required this.type,
    required this.description,
    required this.affectedArtifacts,
    required this.severity,
  });
}

class EnrichmentResult {
  final String domainName;
  final int enrichedArtifacts;
  final List<String> addedConcepts;
  final List<String> addedRelationships;
  final Map<String, String> ontologyMappings;

  const EnrichmentResult({
    required this.domainName,
    required this.enrichedArtifacts,
    required this.addedConcepts,
    required this.addedRelationships,
    required this.ontologyMappings,
  });
}

class ModelingSession {
  final String sessionId;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> actionsPerformed;
  final Map<String, dynamic> userPreferences;
  final List<String> domainsModified;

  const ModelingSession({
    required this.sessionId,
    required this.startTime,
    required this.endTime,
    required this.actionsPerformed,
    required this.userPreferences,
    required this.domainsModified,
  });
}

class SimilarityReport {
  final ArtifactIdentity artifact1;
  final ArtifactIdentity artifact2;
  final double semanticSimilarity;
  final double structuralSimilarity;
  final Map<String, double> similarityBreakdown;
  final List<String> commonFeatures;
  final List<String> differences;

  const SimilarityReport({
    required this.artifact1,
    required this.artifact2,
    required this.semanticSimilarity,
    required this.structuralSimilarity,
    required this.similarityBreakdown,
    required this.commonFeatures,
    required this.differences,
  });
}

class EvolutionTimeline {
  final String domainName;
  final List<EvolutionEvent> events;
  final Map<String, int> changesByType;
  final List<String> majorMilestones;

  const EvolutionTimeline({
    required this.domainName,
    required this.events,
    required this.changesByType,
    required this.majorMilestones,
  });
}

class EvolutionEvent {
  final DateTime timestamp;
  final String eventType;
  final String description;
  final List<String> affectedArtifacts;
  final String author;

  const EvolutionEvent({
    required this.timestamp,
    required this.eventType,
    required this.description,
    required this.affectedArtifacts,
    required this.author,
  });
}

class GenerationOptions {
  final bool enableIdentityTracking;
  final bool generateDocumentation;
  final bool validateConsistency;
  final Map<String, dynamic> customOptions;

  const GenerationOptions({
    this.enableIdentityTracking = true,
    this.generateDocumentation = true,
    this.validateConsistency = true,
    this.customOptions = const {},
  });
}

class GenerationResult {
  final bool success;
  final List<String> generatedFiles;
  final Map<String, dynamic> statistics;
  final List<String> warnings;
  final String? errorMessage;

  const GenerationResult({
    required this.success,
    required this.generatedFiles,
    required this.statistics,
    required this.warnings,
    this.errorMessage,
  });
}

class DeploymentOptions {
  final bool enableRollback;
  final Map<String, String> environmentConfig;
  final List<String> healthCheckEndpoints;

  const DeploymentOptions({
    this.enableRollback = true,
    this.environmentConfig = const {},
    this.healthCheckEndpoints = const [],
  });
}

class DeploymentResult {
  final bool success;
  final Map<String, String> deployedEnvironments;
  final List<String> healthCheckResults;
  final String? errorMessage;

  const DeploymentResult({
    required this.success,
    required this.deployedEnvironments,
    required this.healthCheckResults,
    this.errorMessage,
  });
}

class ComplianceStandard {
  final String name;
  final List<String> requiredPolicies;
  final Map<String, dynamic> thresholds;

  const ComplianceStandard({
    required this.name,
    required this.requiredPolicies,
    required this.thresholds,
  });
}

class ComplianceReport {
  final bool isCompliant;
  final Map<String, bool> policyResults;
  final List<String> violations;
  final double complianceScore;

  const ComplianceReport({
    required this.isCompliant,
    required this.policyResults,
    required this.violations,
    required this.complianceScore,
  });
}
