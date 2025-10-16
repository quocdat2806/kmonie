import 'dart:async';

import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/enums/enums.dart';

class AppStreamData {
  final AppEvent event;
  final dynamic payload;

  AppStreamData(this.event, {this.payload});
}

class AppStreamEvent {
  static final AppStreamEvent _instance = AppStreamEvent._internal();
  factory AppStreamEvent() => _instance;
  AppStreamEvent._internal();

  final StreamController<AppStreamData> _eventController = StreamController<AppStreamData>.broadcast();

  Stream<AppStreamData> get eventStream => _eventController.stream;

  void triggerEvent(AppEvent event, {dynamic payload}) {
    _eventController.add(AppStreamData(event, payload: payload));
  }

  void insertTransaction(Transaction tx) {
    triggerEvent(AppEvent.insertTransaction, payload: tx);
  }

  void updateTransaction(Transaction tx) {
    triggerEvent(AppEvent.updateTransaction, payload: tx);
  }

  void deleteTransaction(int id) {
    triggerEvent(AppEvent.deleteTransaction, payload: id);
  }

  void budgetChanged() {
    triggerEvent(AppEvent.budgetChanged);
  }

  void dispose() {
    _eventController.close();
  }

  static void insertTransactionStatic(Transaction tx) {
    _instance.insertTransaction(tx);
  }

  static void updateTransactionStatic(Transaction tx) {
    _instance.updateTransaction(tx);
  }

  static void deleteTransactionStatic(int id) {
    _instance.deleteTransaction(id);
  }

  static void budgetChangedStatic() {
    _instance.budgetChanged();
  }

  static Stream<AppStreamData> get eventStreamStatic => _instance.eventStream;
}
