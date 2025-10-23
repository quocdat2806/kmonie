import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'daily_transaction_event.dart';
import 'daily_transaction_state.dart';

class DailyTransactionBloc extends Bloc<DailyTransactionEvent, DailyTransactionState> {
  StreamSubscription<AppStreamData>? _streamSub;

  DailyTransactionBloc() : super(const DailyTransactionState()) {
    on<LoadDailyTransactions>(_onLoadDailyTransactions);
    on<InsertTransaction>(_onInsertTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);

    _streamSub = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
          if (data.payload is Transaction) {
            add(InsertTransaction(data.payload as Transaction));
          }
          break;
        case AppEvent.updateTransaction:
          if (data.payload is Transaction) {
            add(UpdateTransaction(data.payload as Transaction));
          }
          break;
        case AppEvent.deleteTransaction:
          if (data.payload is int) {
            add(DeleteTransaction(data.payload as int));
          }
          break;
        default:
          break;
      }
    });
  }

  void _onLoadDailyTransactions(LoadDailyTransactions event, Emitter<DailyTransactionState> emit) {
    emit(state.copyWith(selectedDate: event.selectedDate, groupedTransactions: Map.of(event.groupedTransactions), categoriesMap: Map.of(event.categoriesMap)));
  }

  void _onInsertTransaction(InsertTransaction event, Emitter<DailyTransactionState> emit) {
    final tx = event.transaction;
    if (!_isSameDate(tx.date, state.selectedDate!)) return;

    final dateKey = AppDateUtils.formatDateKey(tx.date);
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(state.groupedTransactions);

    final list = updatedGroupedTransactions[dateKey] ?? [];
    if (!list.any((e) => e.id == tx.id)) {
      list.insert(0, tx);
      updatedGroupedTransactions[dateKey] = list;
    }

    emit(state.copyWith(groupedTransactions: updatedGroupedTransactions));
  }

  void _onUpdateTransaction(UpdateTransaction event, Emitter<DailyTransactionState> emit) {
    final tx = event.transaction;
    final isSameDay = _isSameDate(tx.date, state.selectedDate!);
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(state.groupedTransactions);

    if (!isSameDay) {
      // Remove transaction from all groups if date changed
      for (final key in updatedGroupedTransactions.keys) {
        final list = updatedGroupedTransactions[key]!;
        updatedGroupedTransactions[key] = list.where((e) => e.id != tx.id).toList();
      }
      updatedGroupedTransactions.removeWhere((_, list) => list.isEmpty);
    } else {
      // Update transaction in the same day
      final key = AppDateUtils.formatDateKey(tx.date);
      final list = updatedGroupedTransactions[key];
      if (list != null) {
        final index = list.indexWhere((e) => e.id == tx.id);
        if (index != -1) {
          list[index] = tx;
          updatedGroupedTransactions[key] = List.of(list);
        }
      }
    }

    emit(state.copyWith(groupedTransactions: updatedGroupedTransactions));
  }

  void _onDeleteTransaction(DeleteTransaction event, Emitter<DailyTransactionState> emit) {
    final transactionId = event.transactionId;
    final updatedGroupedTransactions = Map<String, List<Transaction>>.from(state.groupedTransactions);

    for (final key in updatedGroupedTransactions.keys) {
      final list = updatedGroupedTransactions[key]!;
      final newList = list.where((e) => e.id != transactionId).toList();
      updatedGroupedTransactions[key] = newList;
    }
    updatedGroupedTransactions.removeWhere((_, list) => list.isEmpty);

    emit(state.copyWith(groupedTransactions: updatedGroupedTransactions));
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Future<void> close() {
    _streamSub?.cancel();
    return super.close();
  }
}
