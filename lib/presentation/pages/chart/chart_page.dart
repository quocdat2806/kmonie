import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'widgets/chart_tab_bar.dart';
import 'widgets/chart_period_selector.dart';
import 'widgets/chart_content.dart';
import 'widgets/chart_transaction_type_dropdown.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => ChartBloc(sl<TransactionRepository>(), sl<TransactionCategoryRepository>()), child: const _ChartPageView());
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
    return ColoredBox(
      color: AppColorConstants.white,
      child: Column(
        children: [
          ColoredBox(
            color: AppColorConstants.primary,
            child: Column(
              spacing: AppUIConstants.defaultSpacing,
              children: [
                const SizedBox(),
                ChartTransactionTypeDropdown(dropdownKey: _dropdownKey),
                const ChartTabBar(),
                const SizedBox(),
              ],
            ),
          ),
          BlocBuilder<ChartBloc, ChartState>(
            builder: (context, state) {
              return Expanded(
                child: Column(
                  children: [
                    ChartPeriodSelector(periodType: state.selectedPeriodType == IncomeType.month ? PeriodType.month : PeriodType.year),
                    const Expanded(child: ChartContent()),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
