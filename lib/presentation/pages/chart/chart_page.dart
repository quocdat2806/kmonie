import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/presentation/bloc/bloc.dart';
import 'widgets/chart_tab_bar.dart';
import 'widgets/chart_month_selector.dart';
import 'widgets/chart_year_selector.dart';
import 'widgets/chart_content.dart';
import 'widgets/chart_transaction_type_dropdown.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChartBloc(sl<TransactionService>(), sl<TransactionCategoryService>()),
      child: const _ChartPageView(),
    );
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
          color: AppColorConstants.white,
          child: Column(
            children: [
              ColoredBox(
                color: AppColorConstants.primary,
                child: Column(
                  children: [
                    const SizedBox(height: AppUIConstants.defaultSpacing),
                    ChartTransactionTypeDropdown(dropdownKey: _dropdownKey),
                    const SizedBox(height: AppUIConstants.defaultSpacing),
                    const ChartTabBar(),
                    const SizedBox(height: AppUIConstants.defaultSpacing),
                  ],
                ),
              ),
              state.selectedPeriodType == IncomeType.month
                  ? const ChartMonthSelector()
                  : const ChartYearSelector(),
              const Expanded(child: ChartContent()),
            ],
          ),
        );
      },
    );
  }
}
