import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/util/export.dart';
import '../../../bloc/export.dart';
import 'chart_list_selector.dart';

class ChartYearSelector extends StatelessWidget {
  const ChartYearSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        return ChartListSelector(itemCount: state.years.length, selectedIndex: state.selectedYearIndex, labelBuilder: (actualIndex) => ChartFormatUtils.formatYearLabel(state.years[actualIndex]), onLoadMore: () => context.read<ChartBloc>().add(const LoadMoreYears()), onSelect: (actualIndex) => context.read<ChartBloc>().add(SelectYear(actualIndex)));
      },
    );
  }
}
