import 'package:test/test.dart';
import '../lib/ednet_core.dart';

void main() {
  group('Role-Based Policy Meta-Modeling Tests', () {
    // Configure comprehensive observability for debugging
    setUpAll(() {
      // Configure global observability with minimal logging
      final observabilityConfig = ObservabilityConfiguration(
        defaultLevel: ObservabilityLevel.error, // Minimal logging for tests
        channels: [
          ConsoleObservabilityChannel(), // Output to console for debugging
        ],
      );

      // Configure global observability for all components
      ObservabilityMixin.configureGlobalObservability(observabilityConfig);

      print('\n🎯 MINIMAL OBSERVABILITY ENABLED 🎯');
      print('Level: ERROR (errors only)');
      print('Reduced logging to prevent excessive test output\n');
    });

    setUp(() {
      // ... existing code ...
    });
  });
}
