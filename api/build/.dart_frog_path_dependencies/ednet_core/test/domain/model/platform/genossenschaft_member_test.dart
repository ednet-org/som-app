import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('GenossenschaftMember Entity Tests', () {
    late GenossenschaftMember member;
    late PlatformUser baseUser;

    setUp(() {
      member = GenossenschaftMember();

      // Setup base user for member creation
      baseUser = PlatformUser();
      baseUser.userId = 'user-123';
      baseUser.email = 'member@example.com';
      baseUser.username = 'testmember';
      baseUser.role = 'member';
    });

    group('Entity Creation and Austrian Legal Compliance', () {
      test('should create GenossenschaftMember with proper concept', () {
        expect(member, isNotNull);
        expect(member.concept, isNotNull);
        expect(member.concept.code, equals('GenossenschaftMember'));
        expect(
          member.concept.description,
          contains('Austrian cooperative member'),
        );
      });

      test('should have correct domain and model structure', () {
        final concept = GenossenschaftMember.getGenossenschaftMemberConcept();
        expect(concept.model.code, equals('PlatformCoreModel'));
        expect(concept.model.domain.code, equals('PlatformCore'));
      });

      test('should have all required Austrian legal attributes', () {
        final concept = member.concept;
        final attributeCodes = concept.attributes
            .toList()
            .map((a) => a.code)
            .toList();

        // Identity attributes
        expect(attributeCodes, contains('memberId'));
        expect(attributeCodes, contains('platformUserId'));

        // Austrian legal requirements
        expect(attributeCodes, contains('socialSecurityNumber'));
        expect(attributeCodes, contains('citizenshipStatus'));
        expect(attributeCodes, contains('residencyAddress'));
        expect(attributeCodes, contains('legalCapacity'));

        // Membership attributes
        expect(attributeCodes, contains('membershipType'));
        expect(attributeCodes, contains('membershipStatus'));
        expect(attributeCodes, contains('joinedAt'));
        expect(attributeCodes, contains('shareContribution'));
        expect(attributeCodes, contains('votingRights'));

        // Governance attributes
        expect(attributeCodes, contains('committees'));
        expect(attributeCodes, contains('responsibilities'));
        expect(attributeCodes, contains('mandates'));
      });
    });

    group('Austrian Legal Compliance Validation', () {
      setUp(() {
        member.memberId = 'GM-2024-001';
        member.platformUserId = 'user-123';
        member.socialSecurityNumber = '1234 010180'; // Austrian format
        member.citizenshipStatus = 'austrian_citizen';
      });

      test('should validate Austrian social security number format', () {
        member.socialSecurityNumber = '1234 010180';
        expect(member.isValidSocialSecurityNumber(), isTrue);

        member.socialSecurityNumber = '1234-01-01-80'; // Invalid format
        expect(member.isValidSocialSecurityNumber(), isFalse);
      });

      test('should validate Austrian citizenship requirements', () {
        member.citizenshipStatus = 'austrian_citizen';
        expect(member.meetsAustrianCitizenshipRequirements(), isTrue);

        member.citizenshipStatus = 'eu_citizen';
        expect(member.meetsAustrianCitizenshipRequirements(), isTrue);

        member.citizenshipStatus = 'non_eu_citizen';
        expect(member.meetsAustrianCitizenshipRequirements(), isFalse);
      });

      test('should validate legal capacity for cooperative membership', () {
        member.legalCapacity = 'full_capacity';
        expect(member.hasLegalCapacityForMembership(), isTrue);

        member.legalCapacity = 'limited_capacity';
        expect(member.hasLegalCapacityForMembership(), isFalse);

        member.legalCapacity = 'no_capacity';
        expect(member.hasLegalCapacityForMembership(), isFalse);
      });

      test('should validate Austrian residency requirements', () {
        final validAddress = {
          'street': 'Mariahilfer Straße 123',
          'city': 'Wien',
          'postalCode': '1060',
          'country': 'Austria',
        };

        member.residencyAddress = validAddress;
        expect(member.hasValidAustrianResidency(), isTrue);

        final invalidAddress = {
          'street': 'Main Street 123',
          'city': 'Berlin',
          'postalCode': '10115',
          'country': 'Germany',
        };

        member.residencyAddress = invalidAddress;
        expect(member.hasValidAustrianResidency(), isFalse);
      });
    });

    group('Membership Management', () {
      setUp(() {
        member.memberId = 'GM-2024-001';
        member.platformUserId = 'user-123';
        member.membershipType = 'standard';
        member.membershipStatus = 'pending';
      });

      test('should handle membership application process', () {
        expect(member.membershipStatus, equals('pending'));
        expect(member.isPendingApproval, isTrue);
        expect(member.isActiveMember, isFalse);

        member.approveMembership();
        expect(member.membershipStatus, equals('active'));
        expect(member.isActiveMember, isTrue);
        expect(member.joinedAt, isNotNull);
      });

      test('should handle membership rejection', () {
        member.rejectMembership('Incomplete documentation');

        expect(member.membershipStatus, equals('rejected'));
        expect(member.isRejected, isTrue);
        expect(member.rejectionReason, equals('Incomplete documentation'));
      });

      test('should calculate membership contributions', () {
        member.membershipType = 'standard';
        expect(
          member.calculateRequiredShareContribution(),
          equals(100.0),
        ); // €100 standard

        member.membershipType = 'premium';
        expect(
          member.calculateRequiredShareContribution(),
          equals(500.0),
        ); // €500 premium

        member.membershipType = 'student';
        expect(
          member.calculateRequiredShareContribution(),
          equals(25.0),
        ); // €25 student
      });

      test('should handle share contribution payments', () {
        member.membershipType = 'standard';
        final requiredAmount = member.calculateRequiredShareContribution();

        member.recordShareContribution(
          requiredAmount,
          'Initial membership contribution',
        );

        expect(member.shareContribution, equals(requiredAmount));
        expect(member.hasMetContributionRequirements(), isTrue);
      });
    });

    group('Voting Rights and Governance', () {
      setUp(() {
        member.memberId = 'GM-2024-001';
        member.membershipStatus = 'active';
        member.membershipType = 'standard';
      });

      test('should assign voting rights based on membership type', () {
        member.membershipType = 'standard';
        member.calculateVotingRights();
        expect(member.votingRights, equals(1));

        member.membershipType = 'premium';
        member.calculateVotingRights();
        expect(member.votingRights, equals(2));

        member.membershipType = 'founding';
        member.calculateVotingRights();
        expect(member.votingRights, equals(3));
      });

      test('should handle committee assignments', () {
        final committees = ['audit_committee', 'technical_committee'];
        member.assignToCommittees(committees);

        expect(member.committees, containsAll(committees));
        expect(member.isOnCommittee('audit_committee'), isTrue);
        expect(member.isOnCommittee('governance_committee'), isFalse);
      });

      test('should manage governance responsibilities', () {
        final responsibilities = [
          'platform_content_moderation',
          'new_member_onboarding',
          'technical_documentation',
        ];

        member.assignResponsibilities(responsibilities);

        expect(member.responsibilities, containsAll(responsibilities));
        expect(member.hasResponsibility('platform_content_moderation'), isTrue);
      });

      test('should handle mandate periods', () {
        final mandate = {
          'role': 'board_member',
          'startDate': DateTime.now(),
          'endDate': DateTime.now().add(const Duration(days: 365)),
          'description': 'Board member representing technical interests',
        };

        member.assignMandate(mandate);

        expect(member.mandates, contains(mandate));
        expect(member.hasActiveMandate(), isTrue);
        expect(member.getCurrentMandateRole(), equals('board_member'));
      });
    });

    group('Austrian Firmenbuch Integration Preparation', () {
      test('should prepare data for Firmenbuch registration', () {
        member.memberId = 'GM-2024-001';
        member.socialSecurityNumber = '1234 010180';
        member.citizenshipStatus = 'austrian_citizen';
        member.membershipStatus = 'active';

        final firmenbuchData = member.prepareFirmenbuchData();

        expect(firmenbuchData['member_id'], equals('GM-2024-001'));
        expect(firmenbuchData['legal_capacity'], isNotNull);
        expect(firmenbuchData['citizenship_verified'], isTrue);
        expect(firmenbuchData['residency_verified'], isNotNull);
      });

      test('should validate completeness for Firmenbuch submission', () {
        // Incomplete member
        expect(member.isReadyForFirmenbuchSubmission(), isFalse);

        // Complete member
        member.memberId = 'GM-2024-001';
        member.socialSecurityNumber = '1234 010180';
        member.citizenshipStatus = 'austrian_citizen';
        member.legalCapacity = 'full_capacity';
        member.membershipStatus = 'active';
        member.shareContribution = 100.0;

        expect(member.isReadyForFirmenbuchSubmission(), isTrue);
      });
    });

    group('GDPR Compliance and Data Protection', () {
      setUp(() {
        member.memberId = 'GM-2024-001';
        member.socialSecurityNumber = '1234 010180';
        member.citizenshipStatus = 'austrian_citizen';
      });

      test('should provide GDPR-compliant data export', () {
        final exportData = member.exportPersonalData();

        expect(exportData['member_id'], equals('GM-2024-001'));
        expect(exportData['data_export_timestamp'], isNotNull);
        expect(exportData.containsKey('social_security_number'), isTrue);
        expect(exportData['data_retention_notice'], isNotNull);
      });

      test('should handle data anonymization for departed members', () {
        member.membershipStatus = 'departed';
        member.anonymizePersonalData();

        expect(member.socialSecurityNumber, equals('[ANONYMIZED]'));
        expect(member.residencyAddress, equals({}));
        expect(member.membershipStatus, equals('anonymized'));
        expect(member.memberId, equals('GM-2024-001'));
      });

      test('should support right to be forgotten', () {
        member.requestDataDeletion('Member requested account closure');

        expect(member.membershipStatus, equals('deleted'));
        expect(member.isDataDeleted(), isTrue);
        expect(member.getDeletionTimestamp(), isNotNull);
      });
    });

    group('Integration with Platform Systems', () {
      test('should link to platform user account', () {
        member.platformUserId = 'user-123';
        member.linkToPlatformUser(baseUser);

        expect(member.getPlatformUser(), equals(baseUser));
        expect(member.isLinkedToPlatformUser(), isTrue);
      });

      test('should sync member status with platform user role', () {
        member.membershipStatus = 'active';
        member.membershipType = 'premium';

        member.syncWithPlatformUser(baseUser);

        expect(baseUser.role, equals('premium_member'));
        expect(baseUser.isActive, isTrue);
      });
    });

    group('Serialization and API Integration', () {
      setUp(() {
        member.memberId = 'GM-2024-001';
        member.platformUserId = 'user-123';
        member.membershipType = 'standard';
        member.membershipStatus = 'active';
      });

      test('should create public API representation', () {
        final apiRep = member.toApiRepresentation();

        expect(apiRep['member_id'], equals('GM-2024-001'));
        expect(apiRep['membership_type'], equals('standard'));
        expect(apiRep['membership_status'], equals('active'));
        expect(apiRep['voting_rights'], isNotNull);

        // Should not contain sensitive data
        expect(apiRep.containsKey('social_security_number'), isFalse);
        expect(apiRep.containsKey('residency_address'), isFalse);
      });

      test('should create admin representation with compliance data', () {
        final adminRep = member.toAdminRepresentation();

        expect(adminRep['member_id'], equals('GM-2024-001'));
        expect(adminRep['platform_user_id'], equals('user-123'));
        expect(adminRep.containsKey('legal_compliance_status'), isTrue);
        expect(adminRep.containsKey('firmenbuch_ready'), isTrue);
      });
    });
  });
}
