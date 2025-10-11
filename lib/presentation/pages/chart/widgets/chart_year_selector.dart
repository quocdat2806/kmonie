import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/bloc/chart/chart_export.dart';
import 'chart_list_selector.dart';

class ChartYearSelector extends StatelessWidget {
  const ChartYearSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        return ChartListSelector(
          itemCount: state.years.length,
          selectedIndex: state.selectedYearIndex,
          labelBuilder: (actualIndex) =>
              FormatUtils.formatCurrentYearLabel(state.years[actualIndex]),
          onLoadMore: () =>
              context.read<ChartBloc>().add(const LoadMoreYears()),
          onSelect: (actualIndex) =>
              context.read<ChartBloc>().add(SelectYear(actualIndex)),
        );
      },
    );
  }
}
