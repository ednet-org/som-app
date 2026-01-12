part of ednet_core;

/// **Genossenschaft Member Entity - Austrian Legal Compliance**
///
/// Represents a member of an Austrian cooperative (Genossenschaft) with full legal compliance.
/// Implements Austrian legal requirements, GDPR compliance, and governance integration.
///
/// This entity demonstrates:
/// - Austrian legal system integration
/// - GDPR and data protection compliance
/// - Cooperative governance patterns
/// - Human-centered membership experience
class GenossenschaftMember extends Entity<GenossenschaftMember> {
  static Concept? _genossenschaftMemberConcept;

  /// Cache for linked platform user
  PlatformUser? _linkedPlatformUser;

  /// Initialize the GenossenschaftMember concept within existing PlatformCore domain
  static void _initializeDomainModel() {
    if (_genossenschaftMemberConcept != null) return; // Already initialized

    // Ensure PlatformUser domain is initialized first
    final platformCoreDomain = PlatformUser.getPlatformCoreDomain();
    final platformCoreModel = PlatformUser.getPlatformCoreModel();

    // Create the GenossenschaftMember concept
    _genossenschaftMemberConcept = Concept(
      platformCoreModel,
      'GenossenschaftMember',
    );
    _genossenschaftMemberConcept!.description =
        'Austrian cooperative member with legal compliance';

    // Identity attributes
    final memberIdAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'memberId',
    );
    memberIdAttribute.type = platformCoreDomain.getType('String');
    memberIdAttribute.identifier = true;
    memberIdAttribute.required = true;

    final platformUserIdAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'platformUserId',
    );
    platformUserIdAttribute.type = platformCoreDomain.getType('String');
    platformUserIdAttribute.required = true;

    // Austrian legal compliance attributes
    final socialSecurityNumberAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'socialSecurityNumber',
    );
    socialSecurityNumberAttribute.type = platformCoreDomain.getType('String');
    socialSecurityNumberAttribute.required = true;
    socialSecurityNumberAttribute.sensitive = true;

    final citizenshipStatusAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'citizenshipStatus',
    );
    citizenshipStatusAttribute.type = platformCoreDomain.getType('String');
    citizenshipStatusAttribute.required = true;

    final residencyAddressAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'residencyAddress',
    );
    residencyAddressAttribute.type = platformCoreDomain.getType('dynamic');
    residencyAddressAttribute.required = true;
    residencyAddressAttribute.sensitive = true;

    final legalCapacityAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'legalCapacity',
    );
    legalCapacityAttribute.type = platformCoreDomain.getType('String');
    legalCapacityAttribute.required = true;

    // Membership attributes
    final membershipTypeAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'membershipType',
    );
    membershipTypeAttribute.type = platformCoreDomain.getType('String');
    membershipTypeAttribute.init = 'standard';
    membershipTypeAttribute.required = true;

    final membershipStatusAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'membershipStatus',
    );
    membershipStatusAttribute.type = platformCoreDomain.getType('String');
    membershipStatusAttribute.init = 'pending';
    membershipStatusAttribute.required = true;

    final joinedAtAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'joinedAt',
    );
    joinedAtAttribute.type = platformCoreDomain.getType('DateTime');
    joinedAtAttribute.required = false;

    final shareContributionAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'shareContribution',
    );
    shareContributionAttribute.type = platformCoreDomain.getType('double');
    shareContributionAttribute.init = '0.0';
    shareContributionAttribute.required = true;

    final votingRightsAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'votingRights',
    );
    votingRightsAttribute.type = platformCoreDomain.getType('int');
    votingRightsAttribute.init = '0';
    votingRightsAttribute.required = true;

    // Governance attributes
    final committeesAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'committees',
    );
    committeesAttribute.type = platformCoreDomain.getType('dynamic');
    committeesAttribute.required = false;

    final responsibilitiesAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'responsibilities',
    );
    responsibilitiesAttribute.type = platformCoreDomain.getType('dynamic');
    responsibilitiesAttribute.required = false;

    final mandatesAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'mandates',
    );
    mandatesAttribute.type = platformCoreDomain.getType('dynamic');
    mandatesAttribute.required = false;

    // Additional compliance attributes
    final rejectionReasonAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'rejectionReason',
    );
    rejectionReasonAttribute.type = platformCoreDomain.getType('String');
    rejectionReasonAttribute.required = false;

    final deletionTimestampAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'deletionTimestamp',
    );
    deletionTimestampAttribute.type = platformCoreDomain.getType('DateTime');
    deletionTimestampAttribute.required = false;

    final anonymizedAtAttribute = Attribute(
      _genossenschaftMemberConcept!,
      'anonymizedAt',
    );
    anonymizedAtAttribute.type = platformCoreDomain.getType('DateTime');
    anonymizedAtAttribute.required = false;
  }

  /// Default constructor that initializes the concept
  GenossenschaftMember() {
    _initializeDomainModel();
    concept = _genossenschaftMemberConcept!;
  }

  /// Factory constructor to get the shared concept
  static Concept getGenossenschaftMemberConcept() {
    _initializeDomainModel();
    return _genossenschaftMemberConcept!;
  }

  // **Core Identity Properties**

  /// Unique member identifier
  String get memberId => getAttribute('memberId') ?? '';
  set memberId(String value) => setAttribute('memberId', value);

  /// Related platform user ID
  String get platformUserId => getAttribute('platformUserId') ?? '';
  set platformUserId(String value) => setAttribute('platformUserId', value);

  // **Austrian Legal Compliance Properties**

  /// Austrian social security number (sensitive data)
  String get socialSecurityNumber => getAttribute('socialSecurityNumber') ?? '';
  set socialSecurityNumber(String value) =>
      setAttribute('socialSecurityNumber', value);

  /// Citizenship status for legal compliance
  String get citizenshipStatus => getAttribute('citizenshipStatus') ?? '';
  set citizenshipStatus(String value) =>
      setAttribute('citizenshipStatus', value);

  /// Austrian residency address (sensitive data)
  Map<String, dynamic> get residencyAddress {
    final address = getAttribute('residencyAddress');
    return address is Map<String, dynamic> ? address : {};
  }

  set residencyAddress(Map<String, dynamic> value) =>
      setAttribute('residencyAddress', value);

  /// Legal capacity status
  String get legalCapacity => getAttribute('legalCapacity') ?? '';
  set legalCapacity(String value) => setAttribute('legalCapacity', value);

  // **Membership Properties**

  /// Type of membership
  String get membershipType => getAttribute('membershipType') ?? 'standard';
  set membershipType(String value) => setAttribute('membershipType', value);

  /// Current membership status
  String get membershipStatus => getAttribute('membershipStatus') ?? 'pending';
  set membershipStatus(String value) => setAttribute('membershipStatus', value);

  /// When member joined the cooperative
  DateTime? get joinedAt => getAttribute('joinedAt');
  set joinedAt(DateTime? value) => setAttribute('joinedAt', value);

  /// Share contribution amount
  double get shareContribution => getAttribute('shareContribution') ?? 0.0;
  set shareContribution(double value) =>
      setAttribute('shareContribution', value);

  /// Number of voting rights
  int get votingRights => getAttribute('votingRights') ?? 0;
  set votingRights(int value) => setAttribute('votingRights', value);

  // **Governance Properties**

  /// Committee memberships
  List<String> get committees {
    final comms = getAttribute('committees');
    return comms is List ? List<String>.from(comms) : [];
  }

  set committees(List<String> value) => setAttribute('committees', value);

  /// Governance responsibilities
  List<String> get responsibilities {
    final resps = getAttribute('responsibilities');
    return resps is List ? List<String>.from(resps) : [];
  }

  set responsibilities(List<String> value) =>
      setAttribute('responsibilities', value);

  /// Active mandates
  List<Map<String, dynamic>> get mandates {
    final mands = getAttribute('mandates');
    return mands is List ? List<Map<String, dynamic>>.from(mands) : [];
  }

  set mandates(List<Map<String, dynamic>> value) =>
      setAttribute('mandates', value);

  /// Rejection reason (if applicable)
  String get rejectionReason => getAttribute('rejectionReason') ?? '';
  set rejectionReason(String value) => setAttribute('rejectionReason', value);

  /// Deletion timestamp for GDPR compliance
  DateTime? get deletionTimestamp => getAttribute('deletionTimestamp');
  set deletionTimestamp(DateTime? value) =>
      setAttribute('deletionTimestamp', value);

  // **Status Check Properties**

  /// Check if membership is pending approval
  bool get isPendingApproval => membershipStatus == 'pending';

  /// Check if member is active
  bool get isActiveMember => membershipStatus == 'active';

  /// Check if membership was rejected
  bool get isRejected => membershipStatus == 'rejected';

  /// Check if data has been deleted (GDPR)
  bool isDataDeleted() => deletionTimestamp != null;

  // **Austrian Legal Validation Methods**

  /// Validate Austrian social security number format
  bool isValidSocialSecurityNumber() {
    if (socialSecurityNumber.isEmpty) return false;
    // Austrian SSN format: XXXX DDMMYY (10 digits with space)
    final austrianSSNPattern = RegExp(r'^\d{4} \d{6}$');
    return austrianSSNPattern.hasMatch(socialSecurityNumber);
  }

  /// Check if meets Austrian citizenship requirements
  bool meetsAustrianCitizenshipRequirements() {
    return ['austrian_citizen', 'eu_citizen'].contains(citizenshipStatus);
  }

  /// Check if has legal capacity for membership
  bool hasLegalCapacityForMembership() {
    return legalCapacity == 'full_capacity';
  }

  /// Validate Austrian residency
  bool hasValidAustrianResidency() {
    if (residencyAddress.isEmpty) return false;
    final country = residencyAddress['country']?.toString().toLowerCase();
    return country == 'austria' || country == 'österreich';
  }

  // **Membership Management Methods**

  /// Approve membership application
  void approveMembership() {
    if (isPendingApproval) {
      membershipStatus = 'active';
      joinedAt = DateTime.now();
      calculateVotingRights();
    }
  }

  /// Reject membership application
  void rejectMembership(String reason) {
    membershipStatus = 'rejected';
    rejectionReason = reason;
  }

  /// Calculate required share contribution based on membership type
  double calculateRequiredShareContribution() {
    switch (membershipType) {
      case 'standard':
        return 100.0; // €100
      case 'premium':
        return 500.0; // €500
      case 'student':
        return 25.0; // €25
      case 'founding':
        return 1000.0; // €1000
      default:
        return 100.0;
    }
  }

  /// Record share contribution payment
  void recordShareContribution(double amount, String description) {
    shareContribution = amount;
    // In a full implementation, would also record payment details
  }

  /// Check if contribution requirements are met
  bool hasMetContributionRequirements() {
    return shareContribution >= calculateRequiredShareContribution();
  }

  // **Voting Rights and Governance Methods**

  /// Calculate voting rights based on membership type
  void calculateVotingRights() {
    switch (membershipType) {
      case 'standard':
        votingRights = 1;
        break;
      case 'premium':
        votingRights = 2;
        break;
      case 'founding':
        votingRights = 3;
        break;
      case 'student':
        votingRights = 1;
        break;
      default:
        votingRights = 1;
    }
  }

  /// Assign member to committees
  void assignToCommittees(List<String> committeeList) {
    committees = committeeList;
  }

  /// Check if member is on specific committee
  bool isOnCommittee(String committeeName) {
    return committees.contains(committeeName);
  }

  /// Assign governance responsibilities
  void assignResponsibilities(List<String> responsibilityList) {
    responsibilities = responsibilityList;
  }

  /// Check if member has specific responsibility
  bool hasResponsibility(String responsibility) {
    return responsibilities.contains(responsibility);
  }

  /// Assign mandate (governance role)
  void assignMandate(Map<String, dynamic> mandate) {
    final currentMandates = List<Map<String, dynamic>>.from(mandates);
    currentMandates.add(mandate);
    mandates = currentMandates;
  }

  /// Check if member has active mandate
  bool hasActiveMandate() {
    final now = DateTime.now();
    return mandates.any((mandate) {
      final endDate = mandate['endDate'] as DateTime?;
      return endDate == null || endDate.isAfter(now);
    });
  }

  /// Get current mandate role
  String getCurrentMandateRole() {
    final now = DateTime.now();
    final activeMandates = mandates.where((mandate) {
      final endDate = mandate['endDate'] as DateTime?;
      return endDate == null || endDate.isAfter(now);
    });

    return activeMandates.isNotEmpty
        ? activeMandates.first['role']?.toString() ?? ''
        : '';
  }

  // **Austrian Firmenbuch Integration**

  /// Prepare data for Austrian Firmenbuch registration
  Map<String, dynamic> prepareFirmenbuchData() {
    return {
      'member_id': memberId,
      'legal_capacity': legalCapacity,
      'citizenship_verified': meetsAustrianCitizenshipRequirements(),
      'residency_verified': hasValidAustrianResidency(),
      'share_contribution': shareContribution,
      'membership_status': membershipStatus,
      'voting_rights': votingRights,
      'ssn_validated': isValidSocialSecurityNumber(),
    };
  }

  /// Check if ready for Firmenbuch submission
  bool isReadyForFirmenbuchSubmission() {
    return memberId.isNotEmpty &&
        isValidSocialSecurityNumber() &&
        meetsAustrianCitizenshipRequirements() &&
        hasLegalCapacityForMembership() &&
        membershipStatus == 'active' &&
        hasMetContributionRequirements();
  }

  // **GDPR Compliance Methods**

  /// Export personal data for GDPR compliance
  Map<String, dynamic> exportPersonalData() {
    return {
      'member_id': memberId,
      'platform_user_id': platformUserId,
      'social_security_number': socialSecurityNumber,
      'citizenship_status': citizenshipStatus,
      'residency_address': residencyAddress,
      'legal_capacity': legalCapacity,
      'membership_type': membershipType,
      'membership_status': membershipStatus,
      'share_contribution': shareContribution,
      'committees': committees,
      'responsibilities': responsibilities,
      'mandates': mandates,
      'data_export_timestamp': DateTime.now().toIso8601String(),
      'data_retention_notice':
          'Data retained as per Austrian cooperative law requirements',
    };
  }

  /// Anonymize personal data for departed members
  void anonymizePersonalData() {
    socialSecurityNumber = '[ANONYMIZED]';
    residencyAddress = {};
    // Note: memberId is immutable (identifier), so we mark as anonymized instead
    membershipStatus = 'anonymized';
    // Add anonymization timestamp to track when this occurred
    setAttribute('anonymizedAt', DateTime.now());
  }

  /// Request data deletion (right to be forgotten)
  void requestDataDeletion(String reason) {
    membershipStatus = 'deleted';
    deletionTimestamp = DateTime.now();
    // In full implementation, would trigger deletion workflow
  }

  /// Get deletion timestamp
  DateTime? getDeletionTimestamp() => deletionTimestamp;

  // **Platform Integration Methods**

  /// Link to platform user
  void linkToPlatformUser(PlatformUser user) {
    _linkedPlatformUser = user;
    platformUserId = user.userId;
  }

  /// Get linked platform user
  PlatformUser? getPlatformUser() => _linkedPlatformUser;

  /// Check if linked to platform user
  bool isLinkedToPlatformUser() => _linkedPlatformUser != null;

  /// Sync member status with platform user
  void syncWithPlatformUser(PlatformUser user) {
    if (membershipStatus == 'active') {
      user.isActive = true;
      user.role = '${membershipType}_member';
    } else {
      user.isActive = false;
    }
  }

  // **Serialization Methods**

  /// Create public API representation (no sensitive data)
  Map<String, dynamic> toApiRepresentation() {
    return {
      'member_id': memberId,
      'membership_type': membershipType,
      'membership_status': membershipStatus,
      'voting_rights': votingRights,
      'committees': committees,
      'responsibilities': responsibilities,
      'has_active_mandate': hasActiveMandate(),
      'joined_at': joinedAt?.toIso8601String(),
    };
  }

  /// Create admin representation with compliance data
  Map<String, dynamic> toAdminRepresentation() {
    return {
      'member_id': memberId,
      'platform_user_id': platformUserId,
      'membership_type': membershipType,
      'membership_status': membershipStatus,
      'legal_compliance_status': {
        'ssn_valid': isValidSocialSecurityNumber(),
        'citizenship_valid': meetsAustrianCitizenshipRequirements(),
        'residency_valid': hasValidAustrianResidency(),
        'legal_capacity': hasLegalCapacityForMembership(),
      },
      'contribution_status': {
        'required': calculateRequiredShareContribution(),
        'paid': shareContribution,
        'met_requirements': hasMetContributionRequirements(),
      },
      'firmenbuch_ready': isReadyForFirmenbuchSubmission(),
      'voting_rights': votingRights,
      'committees': committees,
      'responsibilities': responsibilities,
      'mandates': mandates,
      'oid': oid.toString(),
    };
  }

  @override
  String toString() {
    return 'GenossenschaftMember(id: $memberId, status: $membershipStatus, type: $membershipType)';
  }
}
