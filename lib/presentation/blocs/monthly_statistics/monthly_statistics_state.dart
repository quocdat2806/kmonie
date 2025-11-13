import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/args/args.dart';
part 'monthly_statistics_state.freezed.dart';

@freezed
abstract class MonthlyStatisticsState with _$MonthlyStatisticsState {
  const factory MonthlyStatisticsState({
    @Default(LoadStatus.initial) LoadStatus loadStatus,
    @Default(<MonthlyArgs>[]) List<MonthlyArgs> months,
    int? selectedYear,
    @Default(<int>[]) List<int> availableYears,
  }) = _MonthlyStatisticsState;

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

  Map<int, List<MonthlyArgs>> get monthsByYear {
    final Map<int, List<MonthlyArgs>> grouped = {};
    for (final m in months) {
      grouped.putIfAbsent(m.year, () => []).add(m);
    }
    return grouped;
  }
}

