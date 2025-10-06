import 'dart:async';
import '../enum/export.dart';

class AppStreamData {
  final AppEvent event;
  final dynamic payload;

  AppStreamData(this.event, {this.payload});
}
class AppStreamEvent {
  static final AppStreamEvent _instance = AppStreamEvent._internal();
  factory AppStreamEvent() => _instance;
  AppStreamEvent._internal();

  final StreamController<AppStreamData> _eventController =
  StreamController<AppStreamData>.broadcast();

  Stream<AppStreamData> get eventStream => _eventController.stream;

  void triggerEvent(AppEvent event, {dynamic payload}) {
    _eventController.add(AppStreamData(event, payload: payload));
  }

  void insertLatestTransactionIntoList() {
    triggerEvent(AppEvent.loadItemLatestTransaction);
  }

  void updateTransaction(int transactionId) {
    triggerEvent(AppEvent.updateExistItemTransaction, payload: transactionId);
  }

  void dispose() {
    _eventController.close();
  }

  static void insertLatestTransactionIntoListStatic() {
    _instance.insertLatestTransactionIntoList();
  }

  static void updateTransactionStatic(int transactionId) {
    _instance.updateTransaction(transactionId);
  }

  static Stream<AppStreamData> get eventStreamStatic => _instance.eventStream;
}