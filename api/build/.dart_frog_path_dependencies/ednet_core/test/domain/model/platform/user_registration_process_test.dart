import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('UserRegistrationProcess Entity Tests', () {
    late UserRegistrationProcess registrationProcess;
    late UserInvitation mockInvitation;
    late PlatformUser mockUser;

    setUp(() {
      registrationProcess = UserRegistrationProcess();

      // Setup mock invitation
      mockInvitation = UserInvitation();
      mockInvitation.invitationId = 'inv-123';
      mockInvitation.email = 'newuser@example.com';
      mockInvitation.role = 'member';
      mockInvitation.invitedBy = 'admin-456';

      // Setup mock user for completed registrations
      mockUser = PlatformUser();
      mockUser.userId = 'user-789';
      mockUser.email = 'newuser@example.com';
      mockUser.username = 'newuser';
    });

    group('Entity Creation and Domain Model', () {
      test('should create UserRegistrationProcess with proper concept', () {
        expect(registrationProcess, isNotNull);
        expect(registrationProcess.concept, isNotNull);
        expect(
          registrationProcess.concept.code,
          equals('UserRegistrationProcess'),
        );
        expect(
          registrationProcess.concept.description,
          contains('registration workflow'),
        );
      });

      test('should have correct domain and model structure', () {
        final concept =
            UserRegistrationProcess.getUserRegistrationProcessConcept();
        expect(concept.model.code, equals('PlatformCoreModel'));
        expect(concept.model.domain.code, equals('PlatformCore'));
      });

      test('should have all required attributes defined', () {
        final concept = registrationProcess.concept;
        final attributeCodes = concept.attributes
            .toList()
            .map((a) => a.code)
            .toList();

        expect(attributeCodes, contains('processId'));
        expect(attributeCodes, contains('invitationId'));
        expect(attributeCodes, contains('userId'));
        expect(attributeCodes, contains('status'));
        expect(attributeCodes, contains('currentStep'));
        expect(attributeCodes, contains('registrationData'));
        expect(attributeCodes, contains('createdAt'));
        expect(attributeCodes, contains('completedAt'));
        expect(attributeCodes, contains('errorMessage'));
      });
    });

    group('Registration Process Lifecycle', () {
      setUp(() {
        registrationProcess.processId = 'reg-proc-123';
        registrationProcess.invitationId = 'inv-123';
      });

      test('should initialize with pending status', () {
        expect(registrationProcess.status, equals('pending'));
        expect(
          registrationProcess.currentStep,
          equals('invitation_validation'),
        );
        expect(registrationProcess.isPending, isTrue);
        expect(registrationProcess.isCompleted, isFalse);
        expect(registrationProcess.isFailed, isFalse);
      });

      test('should start registration process with invitation', () {
        final result = registrationProcess.startWithInvitation(mockInvitation);

        expect(result, isTrue);
        expect(registrationProcess.status, equals('in_progress'));
        expect(registrationProcess.currentStep, equals('user_input'));
        expect(registrationProcess.invitationId, equals('inv-123'));
      });

      test('should not start with invalid invitation', () {
        final invalidInvitation = UserInvitation();
        invalidInvitation.invitationId = '';

        final result = registrationProcess.startWithInvitation(
          invalidInvitation,
        );

        expect(result, isFalse);
        expect(registrationProcess.status, equals('failed'));
        expect(registrationProcess.errorMessage, isNotNull);
      });

      test('should advance through registration steps', () {
        registrationProcess.startWithInvitation(mockInvitation);

        // Step 1: User input collection
        expect(registrationProcess.currentStep, equals('user_input'));

        final userData = {
          'username': 'newuser',
          'displayName': 'New User',
          'termsAccepted': true,
        };

        registrationProcess.collectUserData(userData);
        expect(
          registrationProcess.currentStep,
          equals('identity_verification'),
        );

        // Step 2: Identity verification (simulated)
        registrationProcess.completeIdentityVerification('verified');
        expect(registrationProcess.currentStep, equals('user_creation'));

        // Step 3: User creation
        registrationProcess.completeUserCreation('user-789');
        expect(registrationProcess.currentStep, equals('completed'));
        expect(registrationProcess.status, equals('completed'));
        expect(registrationProcess.isCompleted, isTrue);
      });

      test('should handle step failures gracefully', () {
        registrationProcess.startWithInvitation(mockInvitation);

        registrationProcess.fail('User data validation failed', 'user_input');

        expect(registrationProcess.status, equals('failed'));
        expect(registrationProcess.isFailed, isTrue);
        expect(
          registrationProcess.errorMessage,
          equals('User data validation failed'),
        );
        expect(registrationProcess.currentStep, equals('user_input'));
      });

      test('should support process retry after failure', () {
        registrationProcess.startWithInvitation(mockInvitation);
        registrationProcess.fail('Temporary error', 'identity_verification');

        expect(registrationProcess.isFailed, isTrue);

        final retryResult = registrationProcess.retry();
        expect(retryResult, isTrue);
        expect(registrationProcess.status, equals('in_progress'));
        expect(registrationProcess.errorMessage, isEmpty);
      });
    });

    group('Data Collection and Validation', () {
      setUp(() {
        registrationProcess.processId = 'reg-proc-123';
        registrationProcess.startWithInvitation(mockInvitation);
      });

      test('should collect and validate user registration data', () {
        final userData = {
          'username': 'newuser',
          'displayName': 'New User',
          'termsAccepted': true,
          'marketingOptIn': false,
        };

        final result = registrationProcess.collectUserData(userData);

        expect(result, isTrue);
        expect(registrationProcess.registrationData, isNotNull);
        expect(
          registrationProcess.getRegistrationField('username'),
          equals('newuser'),
        );
        expect(
          registrationProcess.getRegistrationField('termsAccepted'),
          isTrue,
        );
      });

      test('should validate required registration fields', () {
        final incompleteData = {
          'username': 'newuser',
          // Missing termsAccepted
        };

        final result = registrationProcess.collectUserData(incompleteData);

        expect(result, isFalse);
        expect(registrationProcess.status, equals('failed'));
        expect(
          registrationProcess.errorMessage,
          contains('Terms and conditions'),
        );
      });

      test('should validate username format and availability', () {
        final invalidData = {
          'username': 'ab', // Too short
          'termsAccepted': true,
        };

        final result = registrationProcess.collectUserData(invalidData);

        expect(result, isFalse);
        expect(
          registrationProcess.errorMessage,
          contains('at least 3 characters'),
        );
      });

      test('should merge registration data with invitation data', () {
        final userData = {
          'username': 'newuser',
          'displayName': 'New User',
          'termsAccepted': true,
        };

        registrationProcess.collectUserData(userData);
        final completeData = registrationProcess.buildCompleteUserData();

        expect(completeData['email'], equals('newuser@example.com'));
        expect(completeData['role'], equals('member'));
        expect(completeData['username'], equals('newuser'));
        expect(completeData['invitedBy'], equals('admin-456'));
      });
    });

    group('Identity Verification Integration', () {
      setUp(() {
        registrationProcess.processId = 'reg-proc-123';
        registrationProcess.startWithInvitation(mockInvitation);
        registrationProcess.collectUserData({
          'username': 'newuser',
          'termsAccepted': true,
        });
      });

      test('should handle Austrian ID verification', () {
        final verificationData = {
          'provider': 'id_austria',
          'verified': true,
          'citizenId': 'AT-123456789',
        };

        final result = registrationProcess.completeIdentityVerification(
          verificationData,
        );

        expect(result, isTrue);
        expect(registrationProcess.currentStep, equals('user_creation'));
        expect(
          registrationProcess.getRegistrationField('identityVerified'),
          isTrue,
        );
        expect(
          registrationProcess.getRegistrationField('identityProvider'),
          equals('id_austria'),
        );
      });

      test('should handle verification failure', () {
        final failedVerification = {
          'provider': 'id_austria',
          'verified': false,
          'error': 'Document expired',
        };

        final result = registrationProcess.completeIdentityVerification(
          failedVerification,
        );

        expect(result, isFalse);
        expect(registrationProcess.status, equals('failed'));
        expect(registrationProcess.errorMessage, contains('verification'));
      });

      test('should support optional verification for certain roles', () {
        // Create invitation for guest role (optional verification)
        final guestInvitation = UserInvitation();
        guestInvitation.invitationId = 'inv-guest-123';
        guestInvitation.email = 'guest@example.com';
        guestInvitation.role = 'guest';
        guestInvitation.invitedBy = 'admin-123';

        final guestProcess = UserRegistrationProcess();
        guestProcess.processId = 'guest-proc-123';

        // Verify invitation setup
        expect(guestInvitation.invitationId, isNotEmpty);
        expect(guestInvitation.email, isNotEmpty);
        expect(guestInvitation.invitedBy, isNotEmpty);

        final startResult = guestProcess.startWithInvitation(guestInvitation);
        expect(startResult, isTrue);
        expect(guestProcess.currentStep, equals('user_input'));

        final dataResult = guestProcess.collectUserData({
          'username': 'guest',
          'termsAccepted': true,
        });
        expect(dataResult, isTrue);

        // Should skip verification for guest role
        expect(guestProcess.currentStep, equals('user_creation'));
      });
    });

    group('Process State Management', () {
      test('should track process duration and timestamps', () {
        final startTime = DateTime.now();

        registrationProcess.processId = 'reg-proc-123';
        registrationProcess.startWithInvitation(mockInvitation);

        expect(registrationProcess.createdAt, isNotNull);
        expect(
          registrationProcess.createdAt!.isAfter(
            startTime.subtract(const Duration(seconds: 1)),
          ),
          isTrue,
        );

        // Complete the process
        registrationProcess.collectUserData({
          'username': 'test',
          'termsAccepted': true,
        });
        registrationProcess.completeIdentityVerification('verified');
        registrationProcess.completeUserCreation('user-123');

        expect(registrationProcess.completedAt, isNotNull);
        expect(registrationProcess.isCompleted, isTrue);

        final duration = registrationProcess.getProcessDuration();
        expect(duration, isNotNull);
        expect(duration!.inSeconds, greaterThanOrEqualTo(0));
      });

      test('should provide process progress percentage', () {
        registrationProcess.startWithInvitation(mockInvitation);

        expect(
          registrationProcess.getProgressPercentage(),
          equals(25),
        ); // Started

        registrationProcess.collectUserData({
          'username': 'test',
          'termsAccepted': true,
        });
        expect(
          registrationProcess.getProgressPercentage(),
          equals(50),
        ); // Data collected

        registrationProcess.completeIdentityVerification('verified');
        expect(
          registrationProcess.getProgressPercentage(),
          equals(75),
        ); // Verified

        registrationProcess.completeUserCreation('user-123');
        expect(
          registrationProcess.getProgressPercentage(),
          equals(100),
        ); // Completed
      });
    });

    group('Serialization and API Integration', () {
      setUp(() {
        registrationProcess.processId = 'reg-proc-123';
        registrationProcess.startWithInvitation(mockInvitation);
      });

      test('should create API representation for monitoring', () {
        final apiRep = registrationProcess.toApiRepresentation();

        expect(apiRep['id'], equals('reg-proc-123'));
        expect(apiRep['status'], equals('in_progress'));
        expect(apiRep['currentStep'], equals('user_input'));
        expect(apiRep['progress'], equals(25));
        expect(apiRep['createdAt'], isNotNull);

        // Should not contain sensitive data
        expect(apiRep.containsKey('registrationData'), isFalse);
      });

      test('should create admin representation with full data', () {
        registrationProcess.collectUserData({
          'username': 'test',
          'termsAccepted': true,
        });

        final adminRep = registrationProcess.toAdminRepresentation();

        expect(adminRep['id'], equals('reg-proc-123'));
        expect(adminRep['invitationId'], equals('inv-123'));
        expect(adminRep['registrationData'], isNotNull);
        expect(adminRep['oid'], isNotNull);
      });
    });
  });
}
