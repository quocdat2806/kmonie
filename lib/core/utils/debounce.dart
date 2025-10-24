import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:rxdart/rxdart.dart';

class DebounceUtils {
  DebounceUtils._();

  static EventTransformer<T> restartableDebounce<T>(Duration duration) {
    return (Stream<T> events, EventMapper<T> mapper) => restartable<T>()(events.debounceTime(duration), mapper);
  }
}
