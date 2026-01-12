part of ednet_core;

/// **User Registration Process - EDNet Core Process Manager**
///
/// Orchestrates the complete user registration workflow from invitation acceptance to user creation.
/// Implements the Process Manager pattern for handling multi-step business processes.
class UserRegistrationProcess extends Entity<UserRegistrationProcess> {
  static Concept? _userRegistrationProcessConcept;

  /// Initialize the UserRegistrationProcess concept within existing PlatformCore domain
  static void _initializeDomainModel() {
    if (_userRegistrationProcessConcept != null) return; // Already initialized

    // Ensure PlatformUser domain is initialized first
    final platformCoreDomain = PlatformUser.getPlatformCoreDomain();
    final platformCoreModel = PlatformUser.getPlatformCoreModel();

    // Create the UserRegistrationProcess concept
    _userRegistrationProcessConcept = Concept(
      platformCoreModel,
      'UserRegistrationProcess',
    );
    _userRegistrationProcessConcept!.description =
        'Orchestrates user registration workflow from invitation to completion';

    // Define core attributes for registration process
    final processIdAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'processId',
    );
    processIdAttribute.type = platformCoreDomain.getType('String');
    processIdAttribute.identifier = true;
    processIdAttribute.required = true;

    final invitationIdAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'invitationId',
    );
    invitationIdAttribute.type = platformCoreDomain.getType('String');
    invitationIdAttribute.required = false;

    final userIdAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'userId',
    );
    userIdAttribute.type = platformCoreDomain.getType('String');
    userIdAttribute.required = false;

    final statusAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'status',
    );
    statusAttribute.type = platformCoreDomain.getType('String');
    statusAttribute.init = 'pending';
    statusAttribute.required = true;

    final currentStepAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'currentStep',
    );
    currentStepAttribute.type = platformCoreDomain.getType('String');
    currentStepAttribute.init = 'invitation_validation';
    currentStepAttribute.required = true;

    final registrationDataAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'registrationData',
    );
    registrationDataAttribute.type = platformCoreDomain.getType('dynamic');
    registrationDataAttribute.required = false;

    final createdAtAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'createdAt',
    );
    createdAtAttribute.type = platformCoreDomain.getType('DateTime');
    createdAtAttribute.init = 'now';
    createdAtAttribute.required = true;

    final completedAtAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'completedAt',
    );
    completedAtAttribute.type = platformCoreDomain.getType('DateTime');
    completedAtAttribute.required = false;

    final errorMessageAttribute = Attribute(
      _userRegistrationProcessConcept!,
      'errorMessage',
    );
    errorMessageAttribute.type = platformCoreDomain.getType('String');
    errorMessageAttribute.required = false;
  }

  /// Default constructor that initializes the concept
  UserRegistrationProcess() {
    _initializeDomainModel();
    concept = _userRegistrationProcessConcept!;
  }

  /// Factory constructor to get the shared concept
  static Concept getUserRegistrationProcessConcept() {
    _initializeDomainModel();
    return _userRegistrationProcessConcept!;
  }

  // **Core Process Properties**

  /// Unique process identifier
  String get processId => getAttribute('processId') ?? '';
  set processId(String value) => setAttribute('processId', value);

  /// Related invitation ID
  String get invitationId => getAttribute('invitationId') ?? '';
  set invitationId(String value) => setAttribute('invitationId', value);

  /// Created user ID (set upon completion)
  String get userId => getAttribute('userId') ?? '';
  set userId(String value) => setAttribute('userId', value);

  /// Current process status
  String get status => getAttribute('status') ?? 'pending';
  set status(String value) => setAttribute('status', value);

  /// Current workflow step
  String get currentStep =>
      getAttribute('currentStep') ?? 'invitation_validation';
  set currentStep(String value) => setAttribute('currentStep', value);

  /// Registration data collected during process
  Map<String, dynamic> get registrationData {
    final data = getAttribute('registrationData');
    return data is Map<String, dynamic> ? data : {};
  }

  set registrationData(Map<String, dynamic> value) =>
      setAttribute('registrationData', value);

  /// When the process was created
  DateTime? get createdAt => getAttribute('createdAt');
  set createdAt(DateTime? value) => setAttribute('createdAt', value);

  /// When the process was completed
  DateTime? get completedAt => getAttribute('completedAt');
  set completedAt(DateTime? value) => setAttribute('completedAt', value);

  /// Error message if process failed
  String get errorMessage => getAttribute('errorMessage') ?? '';
  set errorMessage(String value) => setAttribute('errorMessage', value);

  // **Status Check Properties**

  /// Check if process is pending
  bool get isPending => status == 'pending';

  /// Check if process is in progress
  bool get isInProgress => status == 'in_progress';

  /// Check if process is completed
  bool get isCompleted => status == 'completed';

  /// Check if process has failed
  bool get isFailed => status == 'failed';

  // **Process Management Methods**

  /// Start the registration process with a valid invitation
  bool startWithInvitation(UserInvitation invitation) {
    final validationResult = invitation.validateInvitation();
    if (!validationResult.success) {
      fail(
        'Invalid invitation: ${validationResult.violations.map((v) => v.message).join(', ')}',
        'invitation_validation',
      );
      return false;
    }

    if (!invitation.isValid) {
      fail(
        'Invitation is not valid (expired, used, or rejected)',
        'invitation_validation',
      );
      return false;
    }

    // Initialize process with invitation data
    invitationId = invitation.invitationId;
    status = 'in_progress';

    // Set initial registration data from invitation
    registrationData = {
      'email': invitation.email,
      'role': invitation.role,
      'invitedBy': invitation.invitedBy,
    };

    // Advance to user input collection step
    currentStep = 'user_input';
    return true;
  }

  /// Collect and validate user-provided registration data
  bool collectUserData(Map<String, dynamic> userData) {
    if (currentStep != 'user_input') {
      fail(
        'Cannot collect user data at current step: $currentStep',
        currentStep,
      );
      return false;
    }

    // Validate required fields
    final validationResult = _validateUserData(userData);
    if (!validationResult.success) {
      fail(
        'User data validation failed: ${validationResult.violations.map((v) => v.message).join(', ')}',
        'user_input',
      );
      return false;
    }

    // Merge user data with existing registration data
    final currentData = Map<String, dynamic>.from(registrationData);
    currentData.addAll(userData);
    registrationData = currentData;

    // Advance to next step based on role requirements
    if (_requiresIdentityVerification()) {
      currentStep = 'identity_verification';
    } else {
      currentStep = 'user_creation';
    }

    return true;
  }

  /// Complete identity verification step
  bool completeIdentityVerification(dynamic verificationData) {
    if (currentStep != 'identity_verification') {
      fail(
        'Cannot complete identity verification at current step: $currentStep',
        currentStep,
      );
      return false;
    }

    bool isVerified = false;

    if (verificationData is String && verificationData == 'verified') {
      // Simple verification (for testing)
      isVerified = true;
    } else if (verificationData is Map<String, dynamic>) {
      isVerified = verificationData['verified'] == true;

      if (isVerified) {
        // Store verification details
        final currentData = Map<String, dynamic>.from(registrationData);
        currentData['identityVerified'] = true;
        currentData['identityProvider'] = verificationData['provider'];
        if (verificationData.containsKey('citizenId')) {
          currentData['citizenId'] = verificationData['citizenId'];
        }
        registrationData = currentData;
      } else {
        final error =
            verificationData['error'] ?? 'Identity verification failed';
        fail('Identity verification failed: $error', 'identity_verification');
        return false;
      }
    }

    if (!isVerified) {
      fail('Identity verification failed', 'identity_verification');
      return false;
    }

    // Advance to user creation
    currentStep = 'user_creation';
    return true;
  }

  /// Complete user creation step
  bool completeUserCreation(String createdUserId) {
    if (currentStep != 'user_creation') {
      fail(
        'Cannot complete user creation at current step: $currentStep',
        currentStep,
      );
      return false;
    }

    if (createdUserId.isEmpty) {
      fail('Invalid user ID provided for completion', 'user_creation');
      return false;
    }

    // Complete the process
    userId = createdUserId;
    status = 'completed';
    currentStep = 'completed';
    completedAt = DateTime.now();

    return true;
  }

  /// Mark process as failed with error message
  void fail(String error, String step) {
    status = 'failed';
    errorMessage = error;
    currentStep = step;
  }

  /// Retry failed process from current step
  bool retry() {
    if (!isFailed) return false;

    status = 'in_progress';
    errorMessage = '';
    return true;
  }

  // **Data Access Methods**

  /// Get specific registration field value
  T? getRegistrationField<T>(String key) {
    return registrationData[key] as T?;
  }

  /// Build complete user data for PlatformUser creation
  Map<String, dynamic> buildCompleteUserData() {
    return Map<String, dynamic>.from(registrationData);
  }

  /// Get process duration
  Duration? getProcessDuration() {
    if (createdAt == null) return null;
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(createdAt!);
  }

  /// Get process progress as percentage (0-100)
  int getProgressPercentage() {
    switch (currentStep) {
      case 'invitation_validation':
        return 0;
      case 'user_input':
        return 25;
      case 'identity_verification':
        return 50;
      case 'user_creation':
        return 75;
      case 'completed':
        return 100;
      default:
        return 0;
    }
  }

  // **Serialization Methods**

  /// Creates a representation for API responses (without sensitive data)
  Map<String, dynamic> toApiRepresentation() {
    return {
      'id': processId,
      'status': status,
      'currentStep': currentStep,
      'progress': getProgressPercentage(),
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage.isNotEmpty ? errorMessage : null,
    };
  }

  /// Creates a complete representation for admin use (includes all data)
  Map<String, dynamic> toAdminRepresentation() {
    return {
      'id': processId,
      'invitationId': invitationId,
      'userId': userId,
      'status': status,
      'currentStep': currentStep,
      'registrationData': registrationData,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'oid': oid.toString(),
    };
  }

  // **Private Helper Methods**

  /// Validate user-provided data
  PolicyEvaluationResult _validateUserData(Map<String, dynamic> userData) {
    final violations = <PolicyViolation>[];

    // Required fields validation
    if (!userData.containsKey('termsAccepted') ||
        userData['termsAccepted'] != true) {
      violations.add(
        PolicyViolation(
          'terms_required',
          'Terms and conditions must be accepted',
        ),
      );
    }

    if (!userData.containsKey('username') ||
        userData['username'].toString().isEmpty) {
      violations.add(
        PolicyViolation('username_required', 'Username is required'),
      );
    } else {
      final username = userData['username'].toString();
      if (username.length < 3) {
        violations.add(
          PolicyViolation(
            'username_format',
            'Username must be at least 3 characters long',
          ),
        );
      }
      if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
        violations.add(
          PolicyViolation(
            'username_format',
            'Username can only contain letters, numbers, and underscores',
          ),
        );
      }
    }

    return PolicyEvaluationResult(violations.isEmpty, violations);
  }

  /// Check if identity verification is required for current role
  bool _requiresIdentityVerification() {
    final role = getRegistrationField<String>('role') ?? 'member';
    // Guest role doesn't require verification, others do
    return role != 'guest';
  }

  @override
  String toString() {
    return 'UserRegistrationProcess(id: $processId, status: $status, step: $currentStep)';
  }
}
