import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';

import 'widgets/chart_content.dart';
import 'widgets/chart_period_selector.dart';
import 'widgets/chart_tab_bar.dart';
import 'widgets/chart_transaction_type_dropdown.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ChartPageChild();
  }
}

class ChartPageChild extends StatefulWidget {
  const ChartPageChild({super.key});

  @override
  State<ChartPageChild> createState() => _ChartPageChildState();
}

class _ChartPageChildState extends State<ChartPageChild> {
  final GlobalKey _dropdownKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorConstants.white,
      child: Column(
        children: [
          ColoredBox(
            color: AppColorConstants.primary,
            child: Padding(
              padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
              child: Column(
                spacing: AppUIConstants.defaultSpacing,
                children: [
                  ChartTransactionTypeDropdown(dropdownKey: _dropdownKey),
                  const ChartTabBar(),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Column(
              children: [
                ChartPeriodSelector(),
                Expanded(child: ChartContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
