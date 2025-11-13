import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'monthly_statistics_event.dart';
import 'monthly_statistics_state.dart';

class MonthlyStatisticsBloc
    extends Bloc<MonthlyStatisticsEvent, MonthlyStatisticsState> {
  MonthlyStatisticsBloc({TransactionRepository? repository})
    : _repository = repository ?? sl<TransactionRepository>(),
      super(const MonthlyStatisticsState()) {
    on<LoadMonthlyStatistics>(_onLoad);

    _transactionSub = AppStreamEvent.eventStreamStatic.listen((data) {
      switch (data.event) {
        case AppEvent.insertTransaction:
        case AppEvent.updateTransaction:
        case AppEvent.deleteTransaction:
          add(MonthlyStatisticsEvent.load(year: state.selectedYear));
          break;
        default:
          break;
      }
    });

    add(const MonthlyStatisticsEvent.load());
  }

  final TransactionRepository _repository;
  StreamSubscription<AppStreamData>? _transactionSub;

  Future<void> _onLoad(
    LoadMonthlyStatistics event,
    Emitter<MonthlyStatisticsState> emit,
  ) async {
    emit(state.copyWith(loadStatus: LoadStatus.loading, selectedYear: event.year));

    final allTransactionsResult = await _repository.getAllTransactions();

    await allTransactionsResult.fold(
      (failure) async {
        emit(state.copyWith(loadStatus: LoadStatus.error, months: [], availableYears: []));
      },
      (transactions) async {
        final years = transactions.map((t) => t.date.year).toSet().toList()
          ..sort((a, b) => b.compareTo(a));

        final result = await _repository.getAllMonthlyStatistics(
          year: event.year,
        );

        result.fold(
          (failure) => emit(
            state.copyWith( loadStatus: LoadStatus.error, months: [], availableYears: years),
          ),
          (months) => emit(
            state.copyWith(
              loadStatus: LoadStatus.success,
              months: months,
              availableYears: years,
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    await _transactionSub?.cancel();
    return super.close();
  }
}
