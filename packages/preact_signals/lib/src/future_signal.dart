import 'package:preact_signals/preact_signals.dart';

/// A [Signal] that wraps a [Future]
///
/// The [FutureSignal] will return [SignalState] for the value. To react to
/// the various states you can use a switch statement:
///
/// ```dart
/// final s = FutureSignal(...);
/// final result = (switch(s.value) {
///   SignalValue result => print('value: ${result.value}'),
///   SignalTimeout _ => print('timeout error'),
///   SignalError result => print('error: ${result.error}'),
///   SignalLoading _ => print('loading'),
/// });
/// ```
class FutureSignal<T> extends Signal<SignalState> {
  /// Future [Duration] to wait before timing out
  final Duration? timeout;

  /// Creates a [FutureSignal] that wraps a [Future]
  FutureSignal(this._getFuture, {this.timeout}) : super(SignalLoading()) {
    _init();
  }

  final Future<T> Function() _getFuture;

  /// Resets the signal by calling the [Future] again
  void reset() {
    _init();
  }

  void _init() {
    if (peek() is! SignalLoading) {
      value = SignalLoading();
    }
    var f = _getFuture();
    if (timeout != null) {
      f = f.timeout(timeout!, onTimeout: () {
        throw SignalTimeout();
      });
    }
    f.then((value) {
      this.value = SignalValue(value);
    }).catchError((error) {
      if (error is SignalTimeout) {
        value = error;
      } else {
        value = SignalError(error);
      }
    });
  }
}

/// Create a [FutureSignal] from a [Future]
FutureSignal<T> futureSignal<T>(
  Future<T> Function() compute, {
  Duration? timeout,
}) {
  return FutureSignal(compute, timeout: timeout);
}
