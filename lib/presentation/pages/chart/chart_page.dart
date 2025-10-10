import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/export.dart';
import '../../../core/enum/export.dart';
import '../../../core/service/export.dart';
import '../../../core/constant/export.dart';
import '../../bloc/export.dart';
import 'widgets/chart_tab_bar.dart';
import 'widgets/chart_month_selector.dart';
import 'widgets/chart_year_selector.dart';
import 'widgets/chart_content.dart';
import 'widgets/chart_transaction_type_dropdown.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ChartBloc(sl<TransactionService>(), sl<TransactionCategoryService>()), child: const _ChartPageView());
  }
}

class _ChartPageView extends StatefulWidget {
  const _ChartPageView();

  @override
  State<_ChartPageView> createState() => _ChartPageViewState();
}

class _ChartPageViewState extends State<_ChartPageView> {
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        return ColoredBox(
          color: ColorConstants.white,
          child: Column(
            children: [
              ColoredBox(
                color: ColorConstants.primary,
                child: Column(
                  children: [
                    const SizedBox(height: UIConstants.defaultSpacing),
                    ChartTransactionTypeDropdown(dropdownKey: _dropdownKey),
                    const SizedBox(height: UIConstants.defaultSpacing),
                    const ChartTabBar(),
                    const SizedBox(height: UIConstants.defaultSpacing),
                  ],
                ),
              ),
              state.selectedPeriodType == IncomeType.month ? const ChartMonthSelector() : const ChartYearSelector(),
              const Expanded(child: ChartContent()),
            ],
          ),
        );
      },
    );
  }
}
