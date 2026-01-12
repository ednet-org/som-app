part of ednet_core;

/// **Platform User Entity - EDNet Core Domain Model**
///
/// Core platform user abstraction providing shared services across the EDNet ecosystem.
/// Implements the platform user concept from ednet_platform_core.ednet.yaml

class PlatformUser extends Entity<PlatformUser> {
  /// Shared domain for platform core services
  static Domain? _domain;
  static Model? _model;
  static Concept? _platformUserConcept;

  /// Initialize the EDNet Core domain model structure
  static void _initializeDomainModel() {
    if (_domain != null) return; // Already initialized

    // Create domain for platform core
    _domain = Domain('PlatformCore');
    _domain!.description = 'Core platform domain providing shared services';

    // Create model within the domain
    _model = Model(_domain!, 'PlatformCoreModel');
    _model!.description = 'Platform core domain model for user management';

    // Create the PlatformUser concept
    _platformUserConcept = Concept(_model!, 'PlatformUser');
    _platformUserConcept!.description = 'Core platform user abstraction';

    // Define core attributes for platform users
    final userIdAttribute = Attribute(_platformUserConcept!, 'userId');
    userIdAttribute.type = _model!.domain.getType('String');
    userIdAttribute.identifier = true;
    userIdAttribute.required = true;

    final emailAttribute = Attribute(_platformUserConcept!, 'email');
    emailAttribute.type = _model!.domain.getType('String');
    emailAttribute.required = true;

    final usernameAttribute = Attribute(_platformUserConcept!, 'username');
    usernameAttribute.type = _model!.domain.getType('String');
    usernameAttribute.required = true;

    final displayNameAttribute = Attribute(
      _platformUserConcept!,
      'displayName',
    );
    displayNameAttribute.type = _model!.domain.getType('String');
    displayNameAttribute.required = false;

    final isActiveAttribute = Attribute(_platformUserConcept!, 'isActive');
    isActiveAttribute.type = _model!.domain.getType('bool');
    isActiveAttribute.init = 'true';
    isActiveAttribute.required = true;

    final roleAttribute = Attribute(_platformUserConcept!, 'role');
    roleAttribute.type = _model!.domain.getType('String');
    roleAttribute.init = 'member';
    roleAttribute.required = true;

    final createdAtAttribute = Attribute(_platformUserConcept!, 'createdAt');
    createdAtAttribute.type = _model!.domain.getType('DateTime');
    createdAtAttribute.init = 'now';
    createdAtAttribute.required = true;

    final lastActiveAtAttribute = Attribute(
      _platformUserConcept!,
      'lastActiveAt',
    );
    lastActiveAtAttribute.type = _model!.domain.getType('DateTime');
    lastActiveAtAttribute.required = false;
  }

  /// Default constructor that initializes the concept
  PlatformUser() {
    _initializeDomainModel();
    concept = _platformUserConcept!;
  }

  /// Factory constructor to get the shared concept
  static Concept getPlatformUserConcept() {
    _initializeDomainModel();
    return _platformUserConcept!;
  }

  /// Factory constructor to get the shared model
  static Model getPlatformCoreModel() {
    _initializeDomainModel();
    return _model!;
  }

  /// Factory constructor to get the shared domain
  static Domain getPlatformCoreDomain() {
    _initializeDomainModel();
    return _domain!;
  }

  // **Core Platform User Properties**

  /// Unique platform user identifier
  String get userId => getAttribute('userId') ?? '';
  set userId(String value) => setAttribute('userId', value);

  /// User email address (required for authentication)
  String get email => getAttribute('email') ?? '';
  set email(String value) => setAttribute('email', value);

  /// Username for display and authentication
  String get username => getAttribute('username') ?? '';
  set username(String value) => setAttribute('username', value);

  /// Display name for UI presentation
  String? get displayName => getAttribute('displayName');
  set displayName(String? value) => setAttribute('displayName', value);

  /// Whether the user account is active
  bool get isActive => getAttribute('isActive') ?? true;
  set isActive(bool value) => setAttribute('isActive', value);

  /// User role within the platform
  String get role => getAttribute('role') ?? 'member';
  set role(String value) => setAttribute('role', value);

  /// When the user account was created
  DateTime? get createdAt => getAttribute('createdAt');
  set createdAt(DateTime? value) => setAttribute('createdAt', value);

  /// Last activity timestamp
  DateTime? get lastActiveAt => getAttribute('lastActiveAt');
  set lastActiveAt(DateTime? value) => setAttribute('lastActiveAt', value);

  // **Platform Integration Methods**

  /// Updates the last active timestamp to current time
  void updateLastActive() {
    lastActiveAt = DateTime.now();
  }

  /// Checks if the user has administrative privileges
  bool get isAdmin => role == 'admin';

  /// Checks if the user has moderator privileges
  bool get isModerator => ['admin', 'moderator'].contains(role);

  /// Validates the platform user according to business rules
  PolicyEvaluationResult validatePlatformUser() {
    return evaluatePolicies();
  }

  /// Creates a minimal representation for API responses
  Map<String, dynamic> toApiRepresentation() {
    return {
      'id': userId,
      'username': username,
      'displayName': displayName ?? username,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  /// Creates a complete representation including sensitive data
  Map<String, dynamic> toCompleteRepresentation() {
    return {
      'id': userId,
      'email': email,
      'username': username,
      'displayName': displayName,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
      'oid': oid.toString(),
    };
  }

  @override
  String toString() {
    return 'PlatformUser(id: $userId, username: $username, role: $role, isActive: $isActive)';
  }
}
