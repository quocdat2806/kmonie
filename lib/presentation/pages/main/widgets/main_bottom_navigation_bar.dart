import 'package:flutter/material.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/enum/exports.dart';


import '../../../../generated/assets.dart';
import '../../../widgets/exports.dart';
import 'main_navigation_item.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const MainBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: UIConstants.bottomNavigationHeight,
        child: ColoredBox(
          color: ColorConstants.bottomNavigationColor,
          child: Row(
            children: [
              _buildNavItem(
                index: MainTabs.home.tabIndex,
                iconPath: Assets.svgsNote,
                label: MainTabs.home.label,
              ),
              _buildNavItem(
                index: MainTabs.chart.tabIndex,
                iconPath: Assets.svgsTime,
                label: MainTabs.chart.label,
              ),
              const AddTransactionButtonFloating(),
              _buildNavItem(
                index: MainTabs.report.index,
                iconPath: Assets.svgsReport,
                label: MainTabs.report.label,
              ),
              _buildNavItem(
                index: MainTabs.profile.index,
                iconPath: Assets.svgsProfile,
                label: MainTabs.profile.label,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    return NavigationItem(
      index: index,
      currentIndex: currentIndex,
      iconPath: iconPath,
      label: label,
      onTap: () => onTabSelected(index),
    );
  }
}
