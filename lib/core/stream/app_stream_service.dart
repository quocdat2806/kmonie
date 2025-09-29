import 'dart:async';
import '../enum/exports.dart';

class AppStreamEvent {
  static final AppStreamEvent _instance = AppStreamEvent._internal();
  factory AppStreamEvent() => _instance;
  AppStreamEvent._internal();

  final StreamController<AppEvent> _eventController =
      StreamController<AppEvent>.broadcast();

  Stream<AppEvent> get eventStream => _eventController.stream;

  void triggerEvent(AppEvent event) {
    _eventController.add(event);
  }

  void refreshHomeData() {
    triggerEvent(AppEvent.refreshHomeData);
  }

  void dispose() {
    _eventController.close();
  }

  static void refreshHomeDataStatic() {
    _instance.refreshHomeData();
  }

  static Stream<AppEvent> get eventStreamStatic => _instance.eventStream;
}
