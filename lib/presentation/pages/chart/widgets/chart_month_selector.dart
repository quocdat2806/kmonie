import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/bloc/chart/chart_export.dart';
import 'chart_list_selector.dart';

class ChartMonthSelector extends StatelessWidget {
  const ChartMonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      // buildWhen: (previous, current) =>
      //     previous.localTransactions.length != current.localTransactions.length,
      builder: (context, state) {
        return ChartListSelector(
          itemCount: state.months.length,
          selectedIndex: state.selectedMonthIndex,
          labelBuilder: (actualIndex) =>
              FormatUtils.formatCurrentMonthLabel(state.months[actualIndex]),
          onLoadMore: () =>
              context.read<ChartBloc>().add(const LoadMoreMonths()),
          onSelect: (actualIndex) =>
              context.read<ChartBloc>().add(SelectMonth(actualIndex)),
        );
      },
    );
  }
}
