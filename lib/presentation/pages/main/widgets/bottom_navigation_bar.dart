import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/generated/generated.dart';
import 'navigation_add_transaction_button.dart';
import 'navigation_item.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const MainBottomNavigationBar({super.key, required this.currentIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: AppUIConstants.bottomNavigationHeight,
        child: ColoredBox(
          color: AppColorConstants.bottomNavigationColor,
          child: Row(
            children: [
              MainNavigationItem(currentIndex: currentIndex, index: MainTabs.home.tabIndex, iconPath: Assets.svgsNote, label: MainTabs.home.label, onTap: () => onTabSelected(MainTabs.home.tabIndex)),
              MainNavigationItem(currentIndex: currentIndex, index: MainTabs.chart.tabIndex, iconPath: Assets.svgsTime, label: MainTabs.chart.label, onTap: () => onTabSelected(MainTabs.chart.tabIndex)),
              const MainNavigationAddTransactionButton(),
              MainNavigationItem(currentIndex: currentIndex, index: MainTabs.report.index, iconPath: Assets.svgsReport, label: MainTabs.report.label, onTap: () => onTabSelected(MainTabs.report.tabIndex)),
              MainNavigationItem(currentIndex: currentIndex, index: MainTabs.profile.index, iconPath: Assets.svgsProfile, label: MainTabs.profile.label, onTap: () => onTabSelected(MainTabs.profile.tabIndex)),
            ],
          ),
        ),
      ),
    );
  }
}
