import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:rxdart/rxdart.dart';
EventTransformer<T> restartableDebounce<T>(Duration d) {
  return (Stream<T> events, mapper) => restartable<T>()(
    events.debounceTime(d),
    mapper,
  );
}
