/// Helper utilities for deterministic async testing
import 'dart:async';

class AsyncTestHelpers {
  /// Wait for a condition to be true with deterministic timeout
  static Future<void> waitForCondition(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration checkInterval = const Duration(milliseconds: 10),
    String? description,
  }) async {
    final stopwatch = Stopwatch()..start();

    while (!condition() && stopwatch.elapsed < timeout) {
      await Future.delayed(checkInterval);
    }

    if (!condition()) {
      throw TimeoutException(
        'Condition not met within ${timeout.inMilliseconds}ms: ${description ?? 'unknown condition'}',
        timeout,
      );
    }
  }

  /// Wait for async operation with proper subscription setup
  static Future<T> waitForAsyncResult<T>(
    Stream<T> stream, {
    Duration timeout = const Duration(seconds: 5),
    String? description,
  }) async {
    final completer = Completer<T>();

    late StreamSubscription<T> subscription;
    Timer? timeoutTimer;

    void cleanup() {
      subscription.cancel();
      timeoutTimer?.cancel();
    }

    subscription = stream.listen(
      (data) {
        if (!completer.isCompleted) {
          completer.complete(data);
          cleanup();
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
          cleanup();
        }
      },
    );

    timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException(
            'Stream did not emit value within ${timeout.inMilliseconds}ms: ${description ?? 'unknown stream'}',
            timeout,
          ),
        );
        cleanup();
      }
    });

    return completer.future;
  }

  /// Wait for multiple async results with proper coordination
  static Future<List<T>> waitForMultipleResults<T>(
    Stream<T> stream,
    int expectedCount, {
    Duration timeout = const Duration(seconds: 5),
    String? description,
  }) async {
    final completer = Completer<List<T>>();
    final results = <T>[];

    late StreamSubscription<T> subscription;
    Timer? timeoutTimer;

    void cleanup() {
      subscription.cancel();
      timeoutTimer?.cancel();
    }

    subscription = stream.listen(
      (data) {
        results.add(data);
        if (results.length >= expectedCount && !completer.isCompleted) {
          completer.complete(List.from(results));
          cleanup();
        }
      },
      onError: (error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
          cleanup();
        }
      },
    );

    timeoutTimer = Timer(timeout, () {
      if (!completer.isCompleted) {
        completer.completeError(
          TimeoutException(
            'Stream emitted ${results.length}/${expectedCount} values within ${timeout.inMilliseconds}ms: ${description ?? 'unknown stream'}',
            timeout,
          ),
        );
        cleanup();
      }
    });

    return completer.future;
  }

  /// Setup subscription before triggering action
  static Future<T> subscribeBeforeAction<T>(
    Stream<T> stream,
    Future<void> Function() action, {
    Duration timeout = const Duration(seconds: 5),
    String? description,
  }) async {
    final resultFuture = waitForAsyncResult(
      stream,
      timeout: timeout,
      description: description,
    );

    // Small delay to ensure subscription is active
    await Future.delayed(const Duration(milliseconds: 1));

    // Execute the action
    await action();

    // Wait for result
    return resultFuture;
  }

  /// Deterministic polling with exponential backoff
  static Future<T> pollUntilResult<T>(
    Future<T?> Function() pollFunction, {
    Duration timeout = const Duration(seconds: 5),
    Duration initialDelay = const Duration(milliseconds: 10),
    Duration maxDelay = const Duration(milliseconds: 100),
    String? description,
  }) async {
    final stopwatch = Stopwatch()..start();
    var currentDelay = initialDelay;

    while (stopwatch.elapsed < timeout) {
      final result = await pollFunction();
      if (result != null) {
        return result;
      }

      await Future.delayed(currentDelay);
      currentDelay = Duration(
        milliseconds: (currentDelay.inMilliseconds * 1.5).round().clamp(
          initialDelay.inMilliseconds,
          maxDelay.inMilliseconds,
        ),
      );
    }

    throw TimeoutException(
      'Polling did not return result within ${timeout.inMilliseconds}ms: ${description ?? 'unknown poll'}',
      timeout,
    );
  }
}
