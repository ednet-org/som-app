import 'dart:io';
import 'package:ednet_core/ednet_core.dart';

part 'helpers/test_observability_config.dart';

/// Test helper utilities for EDNet Core testing
class TestHelpers {
  /// Setup default test environment
  static void setupDefaults() {
    TestObservabilityConfig.setupFromEnvironment();
  }
}
