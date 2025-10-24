import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/blocs/chart/chart.dart';
import 'chart_list_selector.dart';
import 'package:kmonie/core/enums/enums.dart';

class ChartPeriodSelector extends StatelessWidget {
  final PeriodType periodType;

  const ChartPeriodSelector({super.key, required this.periodType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        switch (periodType) {
          case PeriodType.month:
            return ChartListSelector(itemCount: state.months.length, selectedIndex: state.selectedMonthIndex, labelBuilder: (actualIndex) => FormatUtils.formatCurrentMonthLabel(state.months[actualIndex]), onLoadMore: () => context.read<ChartBloc>().add(const LoadMoreMonths()), onSelect: (actualIndex) => context.read<ChartBloc>().add(SelectMonth(actualIndex)));
          case PeriodType.year:
            return ChartListSelector(itemCount: state.years.length, selectedIndex: state.selectedYearIndex, labelBuilder: (actualIndex) => FormatUtils.formatCurrentYearLabel(state.years[actualIndex]), onLoadMore: () => context.read<ChartBloc>().add(const LoadMoreYears()), onSelect: (actualIndex) => context.read<ChartBloc>().add(SelectYear(actualIndex)));
        }
      },
    );
  }
}
