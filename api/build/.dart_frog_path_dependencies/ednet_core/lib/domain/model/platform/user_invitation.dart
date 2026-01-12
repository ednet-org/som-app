part of ednet_core;

/// **User Invitation Entity - EDNet Core Domain Model**
///
/// Manages email invitations for platform user registration.
/// Implements secure token-based invitation workflow with expiration handling.
class UserInvitation extends Entity<UserInvitation> {
  static Concept? _userInvitationConcept;

  /// Initialize the UserInvitation concept within existing PlatformCore domain
  static void _initializeDomainModel() {
    if (_userInvitationConcept != null) return; // Already initialized

    // Ensure PlatformUser domain is initialized first
    final platformCoreDomain = PlatformUser.getPlatformCoreDomain();
    final platformCoreModel = PlatformUser.getPlatformCoreModel();

    // Create the UserInvitation concept
    _userInvitationConcept = Concept(platformCoreModel, 'UserInvitation');
    _userInvitationConcept!.description =
        'Email invitation for platform user registration';

    // Define core attributes for user invitations
    final invitationIdAttribute = Attribute(
      _userInvitationConcept!,
      'invitationId',
    );
    invitationIdAttribute.type = platformCoreDomain.getType('String');
    invitationIdAttribute.identifier = true;
    invitationIdAttribute.required = true;

    final emailAttribute = Attribute(_userInvitationConcept!, 'email');
    emailAttribute.type = platformCoreDomain.getType('String');
    emailAttribute.required = true;

    final invitedByAttribute = Attribute(_userInvitationConcept!, 'invitedBy');
    invitedByAttribute.type = platformCoreDomain.getType('String');
    invitedByAttribute.required = true;

    final roleAttribute = Attribute(_userInvitationConcept!, 'role');
    roleAttribute.type = platformCoreDomain.getType('String');
    roleAttribute.init = 'member';
    roleAttribute.required = true;

    final statusAttribute = Attribute(_userInvitationConcept!, 'status');
    statusAttribute.type = platformCoreDomain.getType('String');
    statusAttribute.init = 'pending';
    statusAttribute.required = true;

    final tokenAttribute = Attribute(_userInvitationConcept!, 'token');
    tokenAttribute.type = platformCoreDomain.getType('String');
    tokenAttribute.required = true;
    tokenAttribute.sensitive = true;

    final createdAtAttribute = Attribute(_userInvitationConcept!, 'createdAt');
    createdAtAttribute.type = platformCoreDomain.getType('DateTime');
    createdAtAttribute.init = 'now';
    createdAtAttribute.required = true;

    final expiresAtAttribute = Attribute(_userInvitationConcept!, 'expiresAt');
    expiresAtAttribute.type = platformCoreDomain.getType('DateTime');
    expiresAtAttribute.required = false;

    final acceptedAtAttribute = Attribute(
      _userInvitationConcept!,
      'acceptedAt',
    );
    acceptedAtAttribute.type = platformCoreDomain.getType('DateTime');
    acceptedAtAttribute.required = false;
  }

  /// Default constructor that initializes the concept and generates secure token
  UserInvitation() {
    _initializeDomainModel();
    concept = _userInvitationConcept!;

    // Generate secure token and set expiration
    if (getAttribute('token') == null) {
      _generateSecureToken();
      _setDefaultExpiration();
    }
  }

  /// Factory constructor to get the shared concept
  static Concept getUserInvitationConcept() {
    _initializeDomainModel();
    return _userInvitationConcept!;
  }

  // **Core Invitation Properties**

  /// Unique invitation identifier
  String get invitationId => getAttribute('invitationId') ?? '';
  set invitationId(String value) => setAttribute('invitationId', value);

  /// Email address to send invitation to
  String get email => getAttribute('email') ?? '';
  set email(String value) => setAttribute('email', value);

  /// User ID who created this invitation
  String get invitedBy => getAttribute('invitedBy') ?? '';
  set invitedBy(String value) => setAttribute('invitedBy', value);

  /// Role to assign to invited user
  String get role => getAttribute('role') ?? 'member';
  set role(String value) => setAttribute('role', value);

  /// Current invitation status
  String get status => getAttribute('status') ?? 'pending';
  set status(String value) => setAttribute('status', value);

  /// Secure token for invitation validation
  String get token => getAttribute('token') ?? '';
  set token(String value) {
    // Only allow setting token if not already set (security measure)
    if (getAttribute('token') == null) {
      setAttribute('token', value);
    }
  }

  /// When the invitation was created
  DateTime? get createdAt => getAttribute('createdAt');
  set createdAt(DateTime? value) => setAttribute('createdAt', value);

  /// When the invitation expires
  DateTime? get expiresAt => getAttribute('expiresAt');
  set expiresAt(DateTime? value) => setAttribute('expiresAt', value);

  /// When the invitation was accepted
  DateTime? get acceptedAt => getAttribute('acceptedAt');
  set acceptedAt(DateTime? value) => setAttribute('acceptedAt', value);

  // **Status Check Properties**

  /// Check if invitation is pending
  bool get isPending => status == 'pending';

  /// Check if invitation is accepted
  bool get isAccepted => status == 'accepted';

  /// Check if invitation is rejected
  bool get isRejected => status == 'rejected';

  /// Check if invitation is expired
  bool get isExpired => status == 'expired';

  /// Check if invitation is expired by date
  bool get isExpiredByDate {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if invitation is still valid (not accepted/rejected/expired)
  bool get isValid {
    if (!isPending) return false;
    if (isExpiredByDate) return false;
    return true;
  }

  // **Invitation Lifecycle Methods**

  /// Accept the invitation
  void accept() {
    if (isPending && isValid) {
      status = 'accepted';
      acceptedAt = DateTime.now();
    }
  }

  /// Reject the invitation
  void reject() {
    if (isPending) {
      status = 'rejected';
    }
  }

  /// Mark invitation as expired
  void markAsExpired() {
    if (isPending) {
      status = 'expired';
    }
  }

  // **Email Integration Methods**

  /// Generate invitation URL with token
  String generateInvitationUrl(String baseUrl) {
    final encodedEmail = Uri.encodeComponent(email);
    return '$baseUrl/accept-invitation?token=$token&email=$encodedEmail';
  }

  /// Create email template data for invitation email
  Map<String, dynamic> createEmailTemplateData(
    String inviterName,
    String platformName,
  ) {
    return {
      'email': email,
      'inviterName': inviterName,
      'platformName': platformName,
      'role': role,
      'expiryDays': 7,
      'invitationUrl': generateInvitationUrl('https://platform.example.com'),
      'createdAt': createdAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  // **Validation Methods**

  /// Validate invitation according to business rules
  PolicyEvaluationResult validateInvitation() {
    final violations = <PolicyViolation>[];

    // Email validation
    if (email.isEmpty) {
      violations.add(PolicyViolation('email_required', 'Email is required'));
    } else if (!_isValidEmail(email)) {
      violations.add(
        PolicyViolation('email_format', 'Email format is invalid'),
      );
    }

    // Required fields validation
    if (invitationId.isEmpty) {
      violations.add(
        PolicyViolation('invitation_id_required', 'Invitation ID is required'),
      );
    }
    if (invitedBy.isEmpty) {
      violations.add(
        PolicyViolation('invited_by_required', 'Invited by user is required'),
      );
    }
    if (role.isEmpty) {
      violations.add(PolicyViolation('role_required', 'Role is required'));
    }

    return PolicyEvaluationResult(violations.isEmpty, violations);
  }

  // **Serialization Methods**

  /// Creates a representation for API responses (without sensitive data)
  Map<String, dynamic> toApiRepresentation() {
    return {
      'id': invitationId,
      'email': email,
      'role': role,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
    };
  }

  /// Creates a complete representation for admin use (includes sensitive data)
  Map<String, dynamic> toAdminRepresentation() {
    return {
      'id': invitationId,
      'email': email,
      'invitedBy': invitedBy,
      'role': role,
      'status': status,
      'token': token,
      'createdAt': createdAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'oid': oid.toString(),
    };
  }

  // **Private Helper Methods**

  /// Generate a secure random token
  void _generateSecureToken() {
    // Simple implementation for now - in production use crypto library
    final timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    final randomPart = (DateTime.now().microsecondsSinceEpoch * 7919)
        .toString();
    final combined = '$timestamp-$randomPart-invitation';

    // Create a simple hash-like token
    var hash = 0;
    for (int i = 0; i < combined.length; i++) {
      hash = ((hash << 5) - hash + combined.codeUnitAt(i)) & 0xffffffff;
    }

    setAttribute('token', 'inv_${hash.abs().toRadixString(36)}$timestamp');
  }

  /// Set default expiration to 7 days from now
  void _setDefaultExpiration() {
    expiresAt = DateTime.now().add(const Duration(days: 7));
  }

  /// Simple email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  String toString() {
    return 'UserInvitation(id: $invitationId, email: $email, status: $status, role: $role)';
  }
}
