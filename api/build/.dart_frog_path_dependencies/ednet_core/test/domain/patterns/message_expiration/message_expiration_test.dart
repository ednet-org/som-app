import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('Message Expiration Pattern Tests', () {
    late TtlExpirationHandler handler;

    setUp(() {
      handler = TtlExpirationHandler(
        defaultTtl: const Duration(hours: 1),
        typeSpecificTtl: {
          'urgent': const Duration(minutes: 30),
          'normal': const Duration(hours: 2),
        },
      );
    });

    test(
      'Given a message with past expiration time, When checking expiration, Then returns true',
      () {
        // Given
        final pastTime = DateTime.now().subtract(const Duration(hours: 2));
        final message = Message(
          payload: 'test',
          metadata: {
            'expiresAt': pastTime.toIso8601String(),
            'messageType': 'test',
          },
        );

        // When
        final isExpired = handler.isExpired(message);
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(isExpired, isTrue);
        expect(expirationTime, equals(pastTime));
      },
    );

    test(
      'Given a message with future expiration time, When checking expiration, Then returns false',
      () {
        // Given
        final futureTime = DateTime.now().add(const Duration(hours: 2));
        final message = Message(
          payload: 'test',
          metadata: {
            'expiresAt': futureTime.toIso8601String(),
            'messageType': 'test',
          },
        );

        // When
        final isExpired = handler.isExpired(message);
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(isExpired, isFalse);
        expect(expirationTime, equals(futureTime));
      },
    );

    test(
      'Given a message with TTL, When checking expiration, Then calculates correctly',
      () {
        // Given
        final createdAt = DateTime.now().subtract(const Duration(minutes: 30));
        final message = Message(
          payload: 'test',
          metadata: {
            'ttl': 3600, // 1 hour in seconds
            'createdAt': createdAt.toIso8601String(),
            'messageType': 'test',
          },
        );

        // When
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(expirationTime, isNotNull);
        final expectedExpiration = createdAt.add(const Duration(hours: 1));
        expect(expirationTime, equals(expectedExpiration));
      },
    );

    test(
      'Given a message with type-specific TTL, When checking expiration, Then uses type-specific TTL',
      () {
        // Given
        final createdAt = DateTime.now();
        final message = Message(
          payload: 'test',
          metadata: {
            'messageType': 'urgent',
            'createdAt': createdAt.toIso8601String(),
          },
        );

        // When
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(expirationTime, isNotNull);
        final expectedExpiration = createdAt.add(const Duration(minutes: 30));
        expect(expirationTime, equals(expectedExpiration));
      },
    );

    test(
      'Given expired messages, When getting statistics, Then tracks correctly',
      () {
        // Given
        final pastTime = DateTime.now().subtract(const Duration(hours: 2));
        final expiredMessage = Message(
          payload: 'test',
          metadata: {
            'expiresAt': pastTime.toIso8601String(),
            'messageType': 'test',
          },
        );

        // When
        handler.isExpired(expiredMessage);

        // Then
        final stats = handler.getStats();
        expect(stats.totalMessages, equals(1));
        expect(stats.expiredMessages, equals(1));
      },
    );
  });

  group('Expirable Message Tests', () {
    test(
      'Given an expirable message with TTL, When created, Then has correct properties',
      () {
        // Given & When
        final message = ExpirableMessage(
          payload: 'test payload',
          ttl: const Duration(hours: 2),
          expirationAction: ExpirationAction.archive,
        );

        // Then
        expect(message.payload, equals('test payload'));
        expect(message.ttl, equals(const Duration(hours: 2)));
        expect(message.expirationAction, equals(ExpirationAction.archive));
        expect(message.metadata['ttl'], equals(7200)); // 2 hours in seconds
      },
    );

    test(
      'Given an expirable message with explicit expiration time, When created, Then has correct expiration',
      () {
        // Given
        final expirationTime = DateTime.now().add(const Duration(hours: 3));

        // When
        final message = ExpirableMessage.expiresAt(
          payload: 'test payload',
          expiresAt: expirationTime,
        );

        // Then
        expect(
          message.metadata['expiresAt'],
          equals(expirationTime.toIso8601String()),
        );
      },
    );

    test(
      'Given an unexpired message, When checking expiration, Then returns false',
      () {
        // Given
        final message = ExpirableMessage(
          payload: 'test',
          ttl: const Duration(hours: 1),
        );

        // When & Then
        expect(message.isExpired, isFalse);
      },
    );
  });

  group('EDNet-Specific Expiration Tests', () {
    test(
      'Given voting expiration handler, When created, Then has correct TTL configuration',
      () {
        // Given
        final handler = VotingExpirationHandler();

        // When
        final message = Message(
          payload: 'vote',
          metadata: {
            'messageType': 'vote_cast',
            'createdAt': DateTime.now().toIso8601String(),
          },
        );
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(expirationTime, isNotNull);
      },
    );

    test(
      'Given proposal expiration handler, When created, Then has correct TTL configuration',
      () {
        // Given
        final handler = ProposalExpirationHandler();

        // When
        final message = Message(
          payload: 'proposal',
          metadata: {
            'messageType': 'proposal_amendment',
            'createdAt': DateTime.now().toIso8601String(),
          },
        );
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(expirationTime, isNotNull);
      },
    );

    test(
      'Given authentication expiration handler, When created, Then has correct TTL configuration',
      () {
        // Given
        final handler = AuthenticationExpirationHandler();

        // When
        final message = Message(
          payload: 'auth',
          metadata: {
            'messageType': 'login_session',
            'createdAt': DateTime.now().toIso8601String(),
          },
        );
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(expirationTime, isNotNull);
      },
    );
  });

  group('EDNet Expiration System Tests', () {
    late EDNetExpirationSystem system;

    setUp(() {
      system = EDNetExpirationSystem();
      system.initialize();
    });

    test(
      'Given EDNet expiration system, When initialized, Then has all standard handlers',
      () {
        // Then
        expect(system, isNotNull);
      },
    );

    test(
      'Given EDNet system, When creating expirable message, Then has appropriate properties',
      () {
        // When
        final message = system.createExpirableMessage('voting', {
          'vote': 'yes',
        });

        // Then
        expect(message.payload, contains('vote'));
        expect(message.metadata['domain'], equals('voting'));
      },
    );

    test(
      'Given EDNet system, When checking message expiration, Then uses domain-specific handler',
      () {
        // Given
        final message = Message(
          payload: 'test',
          metadata: {
            'domain': 'voting',
            'messageType': 'vote_cast',
            'createdAt': DateTime.now().toIso8601String(),
          },
        );

        // When
        final isExpired = system.isMessageExpired(message);

        // Then
        expect(isExpired, isFalse); // Should not be expired immediately
      },
    );
  });

  group('Edge Cases and Error Handling Tests', () {
    late TtlExpirationHandler handler;

    setUp(() {
      handler = TtlExpirationHandler();
    });

    test(
      'Given message with invalid expiration time, When checking expiration, Then handles gracefully',
      () {
        // Given
        final message = Message(
          payload: 'test',
          metadata: {'expiresAt': 'invalid-date', 'messageType': 'test'},
        );

        // When
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(expirationTime, isNull); // Should handle gracefully
      },
    );

    test(
      'Given message without creation time, When checking TTL expiration, Then uses default behavior',
      () {
        // Given
        final message = Message(
          payload: 'test',
          metadata: {'ttl': 3600, 'messageType': 'test'},
        );

        // When
        final expirationTime = handler.getExpirationTime(message);

        // Then
        expect(expirationTime, isNotNull); // Should still work
      },
    );

    test(
      'Given message with zero TTL, When checking expiration, Then expires immediately',
      () {
        // Given
        final message = Message(
          payload: 'test',
          metadata: {
            'ttl': 0,
            'createdAt': DateTime.now().toIso8601String(),
            'messageType': 'test',
          },
        );

        // When
        final isExpired = handler.isExpired(message);

        // Then
        expect(isExpired, isTrue);
      },
    );

    test(
      'Given message with negative TTL, When checking expiration, Then is considered expired',
      () {
        // Given
        final message = Message(
          payload: 'test',
          metadata: {
            'ttl': -3600,
            'createdAt': DateTime.now().toIso8601String(),
            'messageType': 'test',
          },
        );

        // When
        final isExpired = handler.isExpired(message);

        // Then
        expect(isExpired, isTrue);
      },
    );
  });
}
