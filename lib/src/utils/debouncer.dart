import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class to debounce actions.
class Debouncer {
  /// Creates a debouncer that waits for [duration] before firing.
  Debouncer({required this.duration});

  /// The wait period before an action is executed.
  final Duration duration;

  Timer? _timer;

  /// Cancels any pending action and starts a new countdown.
  /// When [duration] elapses, [action] is executed.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  /// Cancels any pending action.
  void cancel() {
    _timer?.cancel();
  }

  /// Disposes the debouncer, cleaning up its resources.
  void dispose() {
    cancel();
  }
}
