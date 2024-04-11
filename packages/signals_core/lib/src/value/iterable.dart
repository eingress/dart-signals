part of 'value.dart';

/// A [Signal] that holds a [Iterable].
class IterableSignal<E> extends _IterableSignal<E, Iterable<E>>
    with ValueSignalMixin
    implements Signal<Iterable<E>> {
  /// Creates a [IterableSignal] with the given [value].
  IterableSignal(
    super.value, {
    super.debugLabel,
    super.autoDispose,
  });

  @override
  bool operator ==(Object other) {
    return other is IterableSignal<E> && value == other.value;
  }

  @override
  int get hashCode {
    return Object.hashAll([
      globalId.hashCode,
      value.hashCode,
      for (final item in value) item.hashCode
    ]);
  }
}

class _IterableSignal<E, V extends Iterable<E>> extends Signal<V>
    implements Iterable<E> {
  _IterableSignal(
    super.value, {
    super.debugLabel,
    super.autoDispose,
  });

  @override
  bool any(bool Function(E element) test) {
    return value.any(test);
  }

  @override
  Iterable<R> cast<R>() {
    return value.cast<R>();
  }

  @override
  bool contains(Object? value) {
    return this.value.contains(value);
  }

  @override
  E elementAt(int index) {
    return value.elementAt(index);
  }

  @override
  bool every(bool Function(E element) test) {
    return value.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) {
    return value.expand(toElements);
  }

  @override
  E get first => value.first;

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    return value.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    return value.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return value.followedBy(other);
  }

  @override
  void forEach(void Function(E element) action) {
    value.forEach(action);
    set(value, force: true);
  }

  @override
  bool get isEmpty => value.isEmpty;

  @override
  bool get isNotEmpty => value.isNotEmpty;

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  String join([String separator = ""]) {
    return value.join(separator);
  }

  @override
  E get last => value.last;

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    return value.lastWhere(test, orElse: orElse);
  }

  @override
  int get length => value.length;

  @override
  Iterable<T> map<T>(T Function(E e) toElement) {
    return value.map<T>(toElement);
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    return value.reduce(combine);
  }

  @override
  E get single => value.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    return value.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return value.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    return value.skipWhile(test);
  }

  @override
  Iterable<E> take(int count) {
    return value.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    return value.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return value.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  Iterable<E> where(bool Function(E element) test) {
    return value.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return value.whereType<T>();
  }
}

/// Create an [IterableSignal] from [Iterable]
IterableSignal<T> iterableSignal<T>(
  Iterable<T> iterable, {
  String? debugLabel,
  bool autoDispose = false,
}) {
  return IterableSignal<T>(
    iterable,
    debugLabel: debugLabel,
    autoDispose: autoDispose,
  );
}

/// Extension on future to provide helpful methods for signals
extension SignalIterableUtils<T> on Iterable<T> {
  /// Convert an existing list to [IterableSignal]
  IterableSignal<T> toSignal({
    String? debugLabel,
    bool autoDispose = false,
  }) {
    return IterableSignal<T>(
      this,
      debugLabel: debugLabel,
      autoDispose: autoDispose,
    );
  }
}
