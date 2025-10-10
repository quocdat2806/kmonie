import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/export.dart';
import '../../../../core/enum/export.dart';
import '../../../bloc/export.dart';
import '../../../widgets/export.dart';

class ChartTabBar extends StatelessWidget {
  const ChartTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ChartBloc, ChartState, int>(
      selector: (state) => state.selectedPeriodType.typeIndex,
      builder: (context, selectedIndex) {
        final types = ExIncomeType.incomeTypes;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: UIConstants.smallPadding),
          child: AppTabView<IncomeType>(
            types: types,
            selectedIndex: selectedIndex,
            getDisplayName: (t) => t.displayName,
            getTypeIndex: (t) => t.typeIndex,
            onTabSelected: (index) {
              context.read<ChartBloc>().add(ChangePeriodType(IncomeType.fromIndex(index)));
            },
          ),
        );
      },
    );
  }
}
