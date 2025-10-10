import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/export.dart';
import '../../../bloc/export.dart';
import 'chart_list_selector.dart';

class ChartMonthSelector extends StatelessWidget {
  const ChartMonthSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        return ChartListSelector(itemCount: state.months.length, selectedIndex: state.selectedMonthIndex, labelBuilder: (actualIndex) => ChartFormatUtils.formatMonthLabel(state.months[actualIndex]), onLoadMore: () => context.read<ChartBloc>().add(const LoadMoreMonths()), onSelect: (actualIndex) => context.read<ChartBloc>().add(SelectMonth(actualIndex)));
      },
    );
  }
}
