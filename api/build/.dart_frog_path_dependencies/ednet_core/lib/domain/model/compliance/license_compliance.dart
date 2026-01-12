import 'package:ednet_core/ednet_core.dart';

/// **License Compliance Entity - EDNet Core Domain Model**
///
/// Represents license compliance status for platform components,
/// integrating the license scanner functionality into the platform domain model.
/// Ensures transparent responsibility in modern open source business world.

class LicenseCompliance extends Entity<LicenseCompliance> {
  /// Shared domain for platform compliance
  static Domain? _domain;
  static Model? _model;
  static Concept? _concept;

  /// Initialize the EDNet Core domain model structure
  static void _initializeDomainModel() {
    if (_domain != null) return; // Already initialized

    // Create domain for platform compliance
    _domain = Domain('PlatformCompliance');
    _domain!.description =
        'Domain for platform-wide compliance and legal requirements';

    // Create model within the domain
    _model = Model(_domain!, 'LicenseComplianceModel');
    _model!.description = 'Model for open source license compliance tracking';
    _model!.author = 'EDNet.One Platform';

    // Create concept within the model
    _concept = Concept(_model!, 'LicenseCompliance');
    _concept!.description =
        'License compliance tracking for platform components';
    _concept!.entry = true;
    _concept!.updateOid = true;
    _concept!.updateCode = true;
    _concept!.updateWhen = true;

    // Add attributes to concept using proper domain types
    final stringType = _domain!.getType('String')!;
    final boolType = _domain!.getType('bool')!;
    final dateTimeType = _domain!.getType('DateTime')!;
    final dynamicType = _domain!.getType('dynamic')!;

    _concept!.attributes.add(
      Attribute(_concept!, 'complianceId')
        ..type = stringType
        ..identifier = true
        ..required = true,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'packageName')
        ..type = stringType
        ..required = true,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'packageVersion')
        ..type = stringType
        ..required = true,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'licenseType')
        ..type = stringType
        ..required = true,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'isCompliant')
        ..type = boolType
        ..required = true
        ..init = 'false',
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'riskLevel')
        ..type = stringType
        ..required = true,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'violations')..type = dynamicType,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'scanDate')
        ..type = dateTimeType
        ..required = true
        ..init = 'now',
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'platformComponent')
        ..type = stringType
        ..required = true,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'attributionRequired')
        ..type = boolType
        ..required = true
        ..init = 'false',
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'licenseUrl')..type = stringType,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'source')
        ..type = stringType
        ..required = true,
    );

    _concept!.attributes.add(
      Attribute(_concept!, 'resolvedBy')..type = stringType,
    );

    _concept!.attributes.add(Attribute(_concept!, 'notes')..type = stringType);
  }

  /// Get the concept for LicenseCompliance
  static Concept getComplianceConcept() {
    _initializeDomainModel();
    return _concept!;
  }

  /// Constructor following EDNet Core patterns
  LicenseCompliance() : super() {
    concept = getComplianceConcept();
  }

  /// Named constructor for creating compliance records
  LicenseCompliance.create({
    required String complianceId,
    required String packageName,
    required String packageVersion,
    required String licenseType,
    required bool isCompliant,
    required LicenseRiskLevel riskLevel,
    required String platformComponent,
    List<String>? violations,
    DateTime? scanDate,
    bool? attributionRequired,
    String? licenseUrl,
    required LicenseSource source,
    String? resolvedBy,
    String? notes,
  }) : super() {
    concept = getComplianceConcept();
    this.complianceId = complianceId;
    this.packageName = packageName;
    this.packageVersion = packageVersion;
    this.licenseType = licenseType;
    this.isCompliant = isCompliant;
    this.riskLevel = riskLevel;
    this.platformComponent = platformComponent;
    this.violations = violations ?? [];
    this.scanDate = scanDate ?? DateTime.now();
    this.attributionRequired = attributionRequired ?? false;
    this.licenseUrl = licenseUrl;
    this.source = source;
    this.resolvedBy = resolvedBy;
    this.notes = notes;
  }

  /// Unique identifier for compliance record
  String get complianceId => getAttribute('complianceId') ?? '';
  set complianceId(String value) => setAttribute('complianceId', value);

  /// Package name being tracked
  String get packageName => getAttribute('packageName') ?? '';
  set packageName(String value) => setAttribute('packageName', value);

  /// Package version
  String get packageVersion => getAttribute('packageVersion') ?? '';
  set packageVersion(String value) => setAttribute('packageVersion', value);

  /// License type (MIT, Apache-2.0, GPL-3.0, etc.)
  String get licenseType => getAttribute('licenseType') ?? '';
  set licenseType(String value) => setAttribute('licenseType', value);

  /// Whether the license is compliant with platform policies
  bool get isCompliant => getAttribute('isCompliant') ?? false;
  set isCompliant(bool value) => setAttribute('isCompliant', value);

  /// Risk level of the license
  LicenseRiskLevel get riskLevel => LicenseRiskLevel.values.firstWhere(
    (r) => r.name == getAttribute('riskLevel'),
    orElse: () => LicenseRiskLevel.medium,
  );
  set riskLevel(LicenseRiskLevel value) =>
      setAttribute('riskLevel', value.name);

  /// List of compliance violations
  List<String> get violations =>
      List<String>.from(getAttribute('violations') ?? []);
  set violations(List<String> value) => setAttribute('violations', value);

  /// When the compliance scan was performed
  DateTime get scanDate => getAttribute('scanDate') ?? DateTime.now();
  set scanDate(DateTime value) => setAttribute('scanDate', value);

  /// Platform component using this package
  String get platformComponent => getAttribute('platformComponent') ?? '';
  set platformComponent(String value) =>
      setAttribute('platformComponent', value);

  /// Whether attribution is required in final product
  bool get attributionRequired => getAttribute('attributionRequired') ?? false;
  set attributionRequired(bool value) =>
      setAttribute('attributionRequired', value);

  /// URL to license text
  String? get licenseUrl => getAttribute('licenseUrl');
  set licenseUrl(String? value) => setAttribute('licenseUrl', value);

  /// Source of the package
  LicenseSource get source => LicenseSource.values.firstWhere(
    (s) => s.name == getAttribute('source'),
    orElse: () => LicenseSource.pubDev,
  );
  set source(LicenseSource value) => setAttribute('source', value.name);

  /// Who resolved any compliance issues
  String? get resolvedBy => getAttribute('resolvedBy');
  set resolvedBy(String? value) => setAttribute('resolvedBy', value);

  /// Additional compliance notes
  String? get notes => getAttribute('notes');
  set notes(String? value) => setAttribute('notes', value);

  /// Check if license requires legal review
  bool get requiresLegalReview {
    return riskLevel == LicenseRiskLevel.high ||
        riskLevel == LicenseRiskLevel.critical ||
        violations.isNotEmpty;
  }

  /// Get compliance status summary
  ComplianceStatus get complianceStatus {
    if (!isCompliant) return ComplianceStatus.nonCompliant;
    if (requiresLegalReview) return ComplianceStatus.needsReview;
    return ComplianceStatus.compliant;
  }

  /// Add a compliance violation
  void addViolation(String violation) {
    final currentViolations = List<String>.from(violations);
    currentViolations.add(violation);
    violations = currentViolations;
    isCompliant = false;
  }

  /// Remove a compliance violation
  void removeViolation(String violation) {
    final currentViolations = List<String>.from(violations);
    currentViolations.remove(violation);
    violations = currentViolations;

    // Update compliance status if no violations remain
    if (currentViolations.isEmpty) {
      isCompliant = true;
    }
  }

  /// Mark as resolved by legal team
  void markResolved(String resolvedBy, String resolution) {
    this.resolvedBy = resolvedBy;
    notes = resolution;
    isCompliant = true;
  }

  /// Update risk assessment
  void updateRiskAssessment(LicenseRiskLevel newRiskLevel, String reason) {
    riskLevel = newRiskLevel;
    final currentNotes = notes ?? '';
    notes = '$currentNotes\nRisk updated to ${newRiskLevel.name}: $reason';
  }

  @override
  String toString() {
    return 'LicenseCompliance(package: $packageName@$packageVersion, license: $licenseType, compliant: $isCompliant, risk: ${riskLevel.name})';
  }
}

/// **License Compliance Collection - EDNet Core Entities**
class LicenseCompliances extends Entities<LicenseCompliance> {
  LicenseCompliances() : super();

  /// Find compliance records by package name
  LicenseCompliances findByPackage(String packageName) {
    final filtered = LicenseCompliances();
    for (final compliance in this) {
      if (compliance.packageName == packageName) {
        filtered.add(compliance);
      }
    }
    return filtered;
  }

  /// Find compliance records by platform component
  LicenseCompliances findByComponent(String component) {
    final filtered = LicenseCompliances();
    for (final compliance in this) {
      if (compliance.platformComponent == component) {
        filtered.add(compliance);
      }
    }
    return filtered;
  }

  /// Find non-compliant packages
  LicenseCompliances findNonCompliant() {
    final filtered = LicenseCompliances();
    for (final compliance in this) {
      if (!compliance.isCompliant) {
        filtered.add(compliance);
      }
    }
    return filtered;
  }

  /// Find by risk level
  LicenseCompliances findByRiskLevel(LicenseRiskLevel riskLevel) {
    final filtered = LicenseCompliances();
    for (final compliance in this) {
      if (compliance.riskLevel == riskLevel) {
        filtered.add(compliance);
      }
    }
    return filtered;
  }

  /// Find packages requiring attribution
  LicenseCompliances findRequiringAttribution() {
    final filtered = LicenseCompliances();
    for (final compliance in this) {
      if (compliance.attributionRequired) {
        filtered.add(compliance);
      }
    }
    return filtered;
  }

  /// Get compliance statistics
  ComplianceStatistics getStatistics() {
    final total = length;
    final compliant = where((c) => c.isCompliant).length;
    final nonCompliant = total - compliant;
    final needsReview = where((c) => c.requiresLegalReview).length;

    final byRisk = <LicenseRiskLevel, int>{};
    for (final risk in LicenseRiskLevel.values) {
      byRisk[risk] = where((c) => c.riskLevel == risk).length;
    }

    return ComplianceStatistics(
      totalPackages: total,
      compliantPackages: compliant,
      nonCompliantPackages: nonCompliant,
      packagesNeedingReview: needsReview,
      complianceRate: total > 0 ? compliant / total : 0.0,
      packagesByRisk: byRisk,
    );
  }
}

/// **Supporting Enums and Classes**

enum LicenseRiskLevel { low, medium, high, critical }

enum LicenseSource { pubDev, git, local, hosted }

enum ComplianceStatus { compliant, needsReview, nonCompliant }

/// **Compliance Statistics Value Object**
class ComplianceStatistics extends ValueObject {
  final int totalPackages;
  final int compliantPackages;
  final int nonCompliantPackages;
  final int packagesNeedingReview;
  final double complianceRate;
  final Map<LicenseRiskLevel, int> packagesByRisk;

  ComplianceStatistics({
    required this.totalPackages,
    required this.compliantPackages,
    required this.nonCompliantPackages,
    required this.packagesNeedingReview,
    required this.complianceRate,
    required this.packagesByRisk,
  });

  @override
  List<Object> get props => [
    totalPackages,
    compliantPackages,
    nonCompliantPackages,
    packagesNeedingReview,
    complianceRate,
    packagesByRisk,
  ];

  @override
  ComplianceStatistics copyWith({
    int? totalPackages,
    int? compliantPackages,
    int? nonCompliantPackages,
    int? packagesNeedingReview,
    double? complianceRate,
    Map<LicenseRiskLevel, int>? packagesByRisk,
  }) {
    return ComplianceStatistics(
      totalPackages: totalPackages ?? this.totalPackages,
      compliantPackages: compliantPackages ?? this.compliantPackages,
      nonCompliantPackages: nonCompliantPackages ?? this.nonCompliantPackages,
      packagesNeedingReview:
          packagesNeedingReview ?? this.packagesNeedingReview,
      complianceRate: complianceRate ?? this.complianceRate,
      packagesByRisk: packagesByRisk ?? this.packagesByRisk,
    );
  }

  @override
  String toString() {
    final percentage = (complianceRate * 100).toStringAsFixed(1);
    return 'ComplianceStatistics(total: $totalPackages, compliant: $percentage%, non-compliant: $nonCompliantPackages)';
  }
}
