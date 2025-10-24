import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/services/transaction.dart';
import 'monthly_statistics_event.dart';
import 'monthly_statistics_state.dart';

class MonthlyStatisticsBloc extends Bloc<MonthlyStatisticsEvent, MonthlyStatisticsState> {
  MonthlyStatisticsBloc() : super(const MonthlyStatisticsState()) {
    on<LoadMonthlyStatistics>(_onLoad);
  }

  final TransactionService _service = sl<TransactionService>();

  Future<void> _onLoad(LoadMonthlyStatistics event, Emitter<MonthlyStatisticsState> emit) async {
    emit(state.copyWith(isLoading: true, selectedYear: event.year));
    final now = DateTime.now();
    final years = event.year != null ? <int>[event.year!] : List<int>.generate(10, (i) => now.year - i);
    final List<MonthlyAgg> list = [];
    for (final y in years) {
      final items = await _service.getTransactionsInYear(y);
      final Map<int, MonthlyAgg> byMonth = {};
      for (final t in items) {
        final key = t.date.month;
        final cur = byMonth[key] ?? MonthlyAgg(year: t.date.year, month: t.date.month);
        final inc = t.transactionType == 1 ? cur.income + t.amount.toDouble() : cur.income;
        final exp = t.transactionType == 0 ? cur.expense + t.amount.toDouble() : cur.expense;
        byMonth[key] = MonthlyAgg(year: t.date.year, month: t.date.month, income: inc, expense: exp);
      }
      list.addAll(byMonth.values);
    }
    list.sort((a, b) => (b.year * 100 + b.month).compareTo(a.year * 100 + a.month));
    emit(state.copyWith(isLoading: false, months: list));
  }
}
