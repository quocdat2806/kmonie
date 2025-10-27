import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'monthly_statistics_event.dart';
import 'monthly_statistics_state.dart';

class MonthlyStatisticsBloc extends Bloc<MonthlyStatisticsEvent, MonthlyStatisticsState> {
  MonthlyStatisticsBloc({TransactionRepository? repository}) : _repository = repository ?? sl<TransactionRepository>(), super(const MonthlyStatisticsState()) {
    on<LoadMonthlyStatistics>(_onLoad);
  }

  final TransactionRepository _repository;

  Future<void> _onLoad(LoadMonthlyStatistics event, Emitter<MonthlyStatisticsState> emit) async {
    emit(state.copyWith(isLoading: true, selectedYear: event.year));

    final allTransactionsResult = await _repository.getAllTransactions();

    await allTransactionsResult.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, months: [], availableYears: []));
      },
      (transactions) async {
        final years = transactions.map((t) => t.date.year).toSet().toList()..sort((a, b) => b.compareTo(a));

        final result = await _repository.getAllMonthlyStatistics(year: event.year);

        result.fold((failure) => emit(state.copyWith(isLoading: false, months: [], availableYears: years)), (months) => emit(state.copyWith(isLoading: false, months: months, availableYears: years)));
      },
    );
  }
}
