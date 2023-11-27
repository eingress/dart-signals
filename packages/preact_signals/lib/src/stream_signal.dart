import 'dart:async';

import 'package:preact_signals/preact_signals.dart';

/// A [Signal] that wraps a [Stream]
///
/// The [StreamSignal] will return [SignalState] for the value. To react to
/// the various states you can use a switch statement:
///
/// ```dart
/// final s = StreamSignal(...);
/// final result = (switch(s.value) {
///   SignalValue result => print('value: ${result.value}'),
///   SignalError result => print('error: ${result.error}'),
///   SignalLoading _ => print('loading'),
/// });
/// ```
class StreamSignal<T> extends Signal<SignalState> {
  /// If true then the stream will be cancelled on error
  final bool? cancelOnError;

  /// Creates a [StreamSignal] that wraps a [Stream]
  StreamSignal(
    this._getStream, {
    this.cancelOnError,
  }) : super(SignalLoading()) {
    _init();
  }

  final Stream<T> Function() _getStream;
  StreamSubscription<T>? _subscription;

  /// Resets the signal by calling the [Stream] again
  void reset() {
    _subscription?.cancel();
    _init();
  }

  /// Stop stream subscription
  void close() {
    _subscription?.cancel();
  }

  void _init() {
    if (peek() is! SignalLoading) {
      value = SignalLoading();
    }
    var s = _getStream();
    _subscription = s.listen(
      (value) {
        this.value = SignalValue(value);
      },
      onError: (error) {
        if (error is SignalTimeout) {
          value = error;
        } else {
          value = SignalError(error);
        }
      },
      cancelOnError: cancelOnError,
    );
  }
}

/// Create a [StreamSignal] from a [Stream]
StreamSignal<T> streamSignal<T>(
  Stream<T> Function() stream, {
  bool? cancelOnError,
}) {
  return StreamSignal(stream, cancelOnError: cancelOnError);
}