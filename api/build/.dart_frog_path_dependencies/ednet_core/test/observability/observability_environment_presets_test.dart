import 'package:test/test.dart';
import 'package:ednet_core/ednet_core.dart';

void main() {
  group('RuntimeEnvironment', () {
    test('should have all standard environments', () {
      expect(RuntimeEnvironment.values, hasLength(5));
      expect(
        RuntimeEnvironment.values,
        contains(RuntimeEnvironment.development),
      );
      expect(RuntimeEnvironment.values, contains(RuntimeEnvironment.staging));
      expect(
        RuntimeEnvironment.values,
        contains(RuntimeEnvironment.production),
      );
      expect(RuntimeEnvironment.values, contains(RuntimeEnvironment.testing));
      expect(RuntimeEnvironment.values, contains(RuntimeEnvironment.custom));
    });
  });

  group('ObservabilityEnvironmentPresets', () {
    group('development()', () {
      late ObservabilityConfiguration config;

      setUp(() {
        config = ObservabilityEnvironmentPresets.development();
      });

      test('should have trace as default level', () {
        expect(config.defaultLevel, equals(ObservabilityLevel.trace));
      });

      test('should have environment set to development', () {
        expect(config.environment, equals(RuntimeEnvironment.development));
      });

      test('should include all domain categories at trace/debug level', () {
        expect(
          config.categoryLevels['domain'],
          equals(ObservabilityLevel.trace),
        );
        expect(
          config.categoryLevels['infrastructure'],
          equals(ObservabilityLevel.debug),
        );
        expect(
          config.categoryLevels['application'],
          equals(ObservabilityLevel.debug),
        );
        expect(
          config.categoryLevels['commands'],
          equals(ObservabilityLevel.trace),
        );
        expect(
          config.categoryLevels['events'],
          equals(ObservabilityLevel.trace),
        );
      });

      test('should include console channel', () {
        expect(config.channels, hasLength(1));
        expect(config.channels.first, isA<ConsoleObservabilityChannel>());
      });

      test('should include stack traces', () {
        expect(config.includeStackTraces, isTrue);
      });

      test('should include timestamps and context', () {
        expect(config.includeTimestamps, isTrue);
        expect(config.includeComponentContext, isTrue);
      });
    });

    group('staging()', () {
      late ObservabilityConfiguration config;

      setUp(() {
        config = ObservabilityEnvironmentPresets.staging();
      });

      test('should have info as default level', () {
        expect(config.defaultLevel, equals(ObservabilityLevel.info));
      });

      test('should have environment set to staging', () {
        expect(config.environment, equals(RuntimeEnvironment.staging));
      });

      test('should have balanced logging levels', () {
        expect(
          config.categoryLevels['domain'],
          equals(ObservabilityLevel.info),
        );
        expect(
          config.categoryLevels['infrastructure'],
          equals(ObservabilityLevel.warning),
        );
        expect(
          config.categoryLevels['application'],
          equals(ObservabilityLevel.info),
        );
      });

      test('should not include stack traces', () {
        expect(config.includeStackTraces, isFalse);
      });

      test('should include console channel', () {
        expect(config.channels, hasLength(1));
        expect(config.channels.first, isA<ConsoleObservabilityChannel>());
      });
    });

    group('production()', () {
      late ObservabilityConfiguration config;

      setUp(() {
        config = ObservabilityEnvironmentPresets.production();
      });

      test('should have warning as default level', () {
        expect(config.defaultLevel, equals(ObservabilityLevel.warning));
      });

      test('should have environment set to production', () {
        expect(config.environment, equals(RuntimeEnvironment.production));
      });

      test('should have critical categories at error level', () {
        expect(
          config.categoryLevels['domain'],
          equals(ObservabilityLevel.error),
        );
        expect(
          config.categoryLevels['infrastructure'],
          equals(ObservabilityLevel.error),
        );
        expect(
          config.categoryLevels['commands'],
          equals(ObservabilityLevel.error),
        );
        expect(
          config.categoryLevels['events'],
          equals(ObservabilityLevel.error),
        );
      });

      test('should have no channels (silent operation)', () {
        expect(config.channels, isEmpty);
      });

      test('should include stack traces for errors', () {
        expect(config.includeStackTraces, isTrue);
      });

      test('should not include component context (minimize overhead)', () {
        expect(config.includeComponentContext, isFalse);
      });
    });

    group('testing()', () {
      late ObservabilityConfiguration config;

      setUp(() {
        config = ObservabilityEnvironmentPresets.testing();
      });

      test('should have none as default level (silent)', () {
        expect(config.defaultLevel, equals(ObservabilityLevel.none));
      });

      test('should have environment set to testing', () {
        expect(config.environment, equals(RuntimeEnvironment.testing));
      });

      test('should have no category levels configured', () {
        expect(config.categoryLevels, isEmpty);
      });

      test('should have no channels', () {
        expect(config.channels, isEmpty);
      });

      test('should not include stack traces, timestamps, or context', () {
        expect(config.includeStackTraces, isFalse);
        expect(config.includeTimestamps, isFalse);
        expect(config.includeComponentContext, isFalse);
      });
    });

    group('forEnvironment()', () {
      test('should return development config for development environment', () {
        final config = ObservabilityEnvironmentPresets.forEnvironment(
          RuntimeEnvironment.development,
        );
        expect(config.environment, equals(RuntimeEnvironment.development));
        expect(config.defaultLevel, equals(ObservabilityLevel.trace));
      });

      test('should return staging config for staging environment', () {
        final config = ObservabilityEnvironmentPresets.forEnvironment(
          RuntimeEnvironment.staging,
        );
        expect(config.environment, equals(RuntimeEnvironment.staging));
        expect(config.defaultLevel, equals(ObservabilityLevel.info));
      });

      test('should return production config for production environment', () {
        final config = ObservabilityEnvironmentPresets.forEnvironment(
          RuntimeEnvironment.production,
        );
        expect(config.environment, equals(RuntimeEnvironment.production));
        expect(config.defaultLevel, equals(ObservabilityLevel.warning));
      });

      test('should return testing config for testing environment', () {
        final config = ObservabilityEnvironmentPresets.forEnvironment(
          RuntimeEnvironment.testing,
        );
        expect(config.environment, equals(RuntimeEnvironment.testing));
        expect(config.defaultLevel, equals(ObservabilityLevel.none));
      });

      test('should throw for custom environment', () {
        expect(
          () => ObservabilityEnvironmentPresets.forEnvironment(
            RuntimeEnvironment.custom,
          ),
          throwsArgumentError,
        );
      });
    });
  });

  group('ObservabilityConfiguration', () {
    test('should provide getLevelForCategory()', () {
      const config = ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.info,
        categoryLevels: {
          'domain': ObservabilityLevel.trace,
          'infrastructure': ObservabilityLevel.warning,
        },
      );

      expect(
        config.getLevelForCategory('domain'),
        equals(ObservabilityLevel.trace),
      );
      expect(
        config.getLevelForCategory('infrastructure'),
        equals(ObservabilityLevel.warning),
      );
      expect(
        config.getLevelForCategory('unknown'),
        equals(ObservabilityLevel.info),
      );
    });

    test('should provide shouldLog() with default level', () {
      const config = ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.warning,
      );

      expect(config.shouldLog(ObservabilityLevel.error), isTrue);
      expect(config.shouldLog(ObservabilityLevel.warning), isTrue);
      expect(config.shouldLog(ObservabilityLevel.info), isFalse);
      expect(config.shouldLog(ObservabilityLevel.debug), isFalse);
      expect(config.shouldLog(ObservabilityLevel.trace), isFalse);
    });

    test('should provide shouldLog() with category-specific level', () {
      const config = ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.warning,
        categoryLevels: {'domain': ObservabilityLevel.trace},
      );

      // Domain category should log everything
      expect(
        config.shouldLog(ObservabilityLevel.trace, category: 'domain'),
        isTrue,
      );
      expect(
        config.shouldLog(ObservabilityLevel.debug, category: 'domain'),
        isTrue,
      );
      expect(
        config.shouldLog(ObservabilityLevel.info, category: 'domain'),
        isTrue,
      );

      // Other categories should use default (warning)
      expect(
        config.shouldLog(ObservabilityLevel.info, category: 'infrastructure'),
        isFalse,
      );
      expect(
        config.shouldLog(
          ObservabilityLevel.warning,
          category: 'infrastructure',
        ),
        isTrue,
      );
    });
  });

  group('ObservabilityChannel', () {
    test('ConsoleObservabilityChannel should be const', () {
      const channel1 = ConsoleObservabilityChannel();
      const channel2 = ConsoleObservabilityChannel();
      expect(identical(channel1, channel2), isTrue);
    });
  });
}
