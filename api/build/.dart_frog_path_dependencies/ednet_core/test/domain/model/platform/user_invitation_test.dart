import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('UserInvitation Entity Tests', () {
    late UserInvitation userInvitation;

    setUp(() {
      userInvitation = UserInvitation();
    });

    group('Entity Creation and Domain Model', () {
      test('should create UserInvitation with proper concept', () {
        expect(userInvitation, isNotNull);
        expect(userInvitation.concept, isNotNull);
        expect(userInvitation.concept.code, equals('UserInvitation'));
        expect(
          userInvitation.concept.description,
          contains('Email invitation'),
        );
      });

      test('should have correct domain and model structure', () {
        final concept = UserInvitation.getUserInvitationConcept();
        expect(concept.model.code, equals('PlatformCoreModel'));
        expect(concept.model.domain.code, equals('PlatformCore'));
      });

      test('should have all required attributes defined', () {
        final concept = userInvitation.concept;
        final attributeCodes = concept.attributes
            .toList()
            .map((a) => a.code)
            .toList();

        expect(attributeCodes, contains('invitationId'));
        expect(attributeCodes, contains('email'));
        expect(attributeCodes, contains('invitedBy'));
        expect(attributeCodes, contains('role'));
        expect(attributeCodes, contains('status'));
        expect(attributeCodes, contains('createdAt'));
        expect(attributeCodes, contains('expiresAt'));
        expect(attributeCodes, contains('acceptedAt'));
        expect(attributeCodes, contains('token'));
      });
    });

    group('Invitation Lifecycle Management', () {
      setUp(() {
        userInvitation.invitationId = 'inv-123';
        userInvitation.email = 'newuser@example.com';
        userInvitation.invitedBy = 'admin-user-456';
        userInvitation.role = 'member';
      });

      test('should set invitation as pending by default', () {
        expect(userInvitation.status, equals('pending'));
        expect(userInvitation.isPending, isTrue);
        expect(userInvitation.isAccepted, isFalse);
        expect(userInvitation.isExpired, isFalse);
      });

      test('should generate secure token on creation', () {
        expect(userInvitation.token, isNotNull);
        expect(userInvitation.token.length, greaterThan(20));
      });

      test('should set expiration date to 7 days from creation', () {
        expect(userInvitation.expiresAt, isNotNull);
        final expectedExpiry = DateTime.now().add(const Duration(days: 7));
        final actualExpiry = userInvitation.expiresAt!;

        // Allow 1-minute tolerance for test execution time
        expect(
          actualExpiry.difference(expectedExpiry).abs().inMinutes,
          lessThan(2),
        );
      });

      test('should accept invitation successfully', () {
        userInvitation.accept();

        expect(userInvitation.status, equals('accepted'));
        expect(userInvitation.isAccepted, isTrue);
        expect(userInvitation.acceptedAt, isNotNull);
      });

      test('should reject invitation successfully', () {
        userInvitation.reject();

        expect(userInvitation.status, equals('rejected'));
        expect(userInvitation.isRejected, isTrue);
      });

      test('should expire invitation successfully', () {
        userInvitation.markAsExpired();

        expect(userInvitation.status, equals('expired'));
        expect(userInvitation.isExpired, isTrue);
      });

      test('should check if invitation is expired based on date', () {
        // Set expiration to past date
        userInvitation.expiresAt = DateTime.now().subtract(
          const Duration(days: 1),
        );

        expect(userInvitation.isExpiredByDate, isTrue);
      });

      test('should validate invitation is still usable', () {
        expect(userInvitation.isValid, isTrue);

        userInvitation.accept();
        expect(userInvitation.isValid, isFalse);

        final expiredInvitation = UserInvitation();
        expiredInvitation.expiresAt = DateTime.now().subtract(
          const Duration(days: 1),
        );
        expect(expiredInvitation.isValid, isFalse);
      });
    });

    group('Email Integration Methods', () {
      setUp(() {
        userInvitation.invitationId = 'inv-123';
        userInvitation.email = 'newuser@example.com';
        userInvitation.invitedBy = 'admin-user-456';
        userInvitation.role = 'member';
      });

      test('should generate invitation URL with token', () {
        final url = userInvitation.generateInvitationUrl(
          'https://platform.example.com',
        );

        expect(url, contains('https://platform.example.com'));
        expect(url, contains('/accept-invitation'));
        expect(url, contains('token=${userInvitation.token}'));
        expect(
          url,
          contains('email=${Uri.encodeComponent(userInvitation.email)}'),
        );
      });

      test('should create email template data', () {
        final templateData = userInvitation.createEmailTemplateData(
          'Admin User',
          'EDNet Platform',
        );

        expect(templateData['email'], equals('newuser@example.com'));
        expect(templateData['inviterName'], equals('Admin User'));
        expect(templateData['platformName'], equals('EDNet Platform'));
        expect(templateData['role'], equals('member'));
        expect(templateData['expiryDays'], equals(7));
        expect(templateData['invitationUrl'], isNotNull);
      });
    });

    group('Security and Validation', () {
      test('should not allow token updates after initial generation', () {
        final originalToken = userInvitation.token;
        expect(originalToken, isNotNull);

        // Attempting to set token should not work
        userInvitation.token = 'new-token';
        expect(userInvitation.token, equals(originalToken));
      });

      test('should validate email format requirements', () {
        userInvitation.email = 'invalid-email';

        final result = userInvitation.validateInvitation();
        expect(result.success, isFalse);
        expect(
          result.violations.any(
            (v) => v.message.toLowerCase().contains('email'),
          ),
          isTrue,
        );
      });

      test('should validate required fields', () {
        final emptyInvitation = UserInvitation();

        final result = emptyInvitation.validateInvitation();
        expect(result.success, isFalse);
        expect(result.violations.length, greaterThan(0));
      });
    });

    group('Serialization and API Integration', () {
      setUp(() {
        userInvitation.invitationId = 'inv-123';
        userInvitation.email = 'newuser@example.com';
        userInvitation.invitedBy = 'admin-user-456';
        userInvitation.role = 'member';
      });

      test('should create API representation without sensitive data', () {
        final apiRep = userInvitation.toApiRepresentation();

        expect(apiRep['id'], equals('inv-123'));
        expect(apiRep['email'], equals('newuser@example.com'));
        expect(apiRep['role'], equals('member'));
        expect(apiRep['status'], equals('pending'));
        expect(apiRep['createdAt'], isNotNull);
        expect(apiRep['expiresAt'], isNotNull);

        // Should not contain sensitive data
        expect(apiRep.containsKey('token'), isFalse);
      });

      test('should create admin representation with all data', () {
        final adminRep = userInvitation.toAdminRepresentation();

        expect(adminRep['id'], equals('inv-123'));
        expect(adminRep['email'], equals('newuser@example.com'));
        expect(adminRep['invitedBy'], equals('admin-user-456'));
        expect(adminRep['token'], isNotNull);
        expect(adminRep['oid'], isNotNull);
      });
    });

    group('Edge Cases and Error Handling', () {
      test('should handle multiple status transitions gracefully', () {
        userInvitation.invitationId = 'inv-123';
        userInvitation.email = 'test@example.com';

        userInvitation.accept();
        expect(userInvitation.isAccepted, isTrue);

        // Trying to reject after accepting should not work
        userInvitation.reject();
        expect(userInvitation.isAccepted, isTrue);
        expect(userInvitation.isRejected, isFalse);
      });

      test('should handle null expiration gracefully', () {
        userInvitation.expiresAt = null;
        expect(userInvitation.isExpiredByDate, isFalse);
        expect(
          userInvitation.isValid,
          isTrue,
        ); // Status is pending, so still valid
      });
    });
  });
}
