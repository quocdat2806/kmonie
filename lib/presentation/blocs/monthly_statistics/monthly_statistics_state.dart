import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_statistics_state.freezed.dart';

@freezed
abstract class MonthlyStatisticsState with _$MonthlyStatisticsState {
  const factory MonthlyStatisticsState({@Default(false) bool isLoading, @Default(<MonthlyAgg>[]) List<MonthlyAgg> months, int? selectedYear, @Default(<int>[]) List<int> availableYears}) = _MonthlyStatisticsState;

  const MonthlyStatisticsState._();

  double get totalIncome {
    return months.fold(0.0, (sum, month) => sum + month.income);
  }

  double get totalExpense {
    return months.fold(0.0, (sum, month) => sum + month.expense);
  }

  double get totalBalance {
    return totalIncome - totalExpense;
  }

  Map<int, List<MonthlyAgg>> get monthsByYear {
    final Map<int, List<MonthlyAgg>> grouped = {};
    for (final m in months) {
      grouped.putIfAbsent(m.year, () => []).add(m);
    }
    return grouped;
  }
}

class MonthlyAgg {
  final int year;
  final int month;
  final double income;
  final double expense;
  const MonthlyAgg({required this.year, required this.month, this.income = 0, this.expense = 0});
}
