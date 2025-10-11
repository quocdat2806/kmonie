import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/presentation/bloc/chart/chart_export.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class ChartTabBar extends StatelessWidget {
  const ChartTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChartBloc, ChartState, int>(
      selector: (state) => state.selectedPeriodType.typeIndex,
      builder: (context, selectedIndex) {
        final types = ExIncomeType.incomeTypes;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppUIConstants.smallPadding,
          ),
          child: AppTabView<IncomeType>(
            types: types,
            selectedIndex: selectedIndex,
            getDisplayName: (t) => t.displayName,
            getTypeIndex: (t) => t.typeIndex,
            onTabSelected: (index) {
              context.read<ChartBloc>().add(
                ChangePeriodType(IncomeType.fromIndex(index)),
              );
            },
          ),
        );
      },
    );
  }
}
