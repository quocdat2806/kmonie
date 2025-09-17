import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/enums/main_tabs.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/bloc/main/main_bloc.dart';
import 'package:kmonie/presentation/pages/chart/chart_page.dart';
import 'package:kmonie/presentation/pages/home/home_page.dart';
import 'package:kmonie/presentation/pages/main/widgets/floating_add_button.dart';
import 'package:kmonie/presentation/pages/main/widgets/navigation_item.dart';
import 'package:kmonie/presentation/pages/profile/profile_page.dart';
import 'package:kmonie/presentation/pages/report/report_page.dart';

import '../../bloc/main/main_event.dart';
import '../../bloc/main/main_state.dart';

final List<Widget> pageList = <Widget>[
  const HomePage(),
  const ChartPage(),
  const ReportPage(),
  const ProfilePage(),
];

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (_) => MainBloc(),
      child: const MainPageChild(),
    );
  }
}

class MainPageChild extends StatelessWidget {
  const MainPageChild({super.key});

  void _onTabSelected(BuildContext context, int index) {
    context.read<MainBloc>().add(MainSwitchTab(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (BuildContext context, MainState state) {
        final int currentIndex = state.selectedIndex;
        return Scaffold(
          body: pageList[currentIndex],
          bottomNavigationBar: _buildBottomNavigationBar(context, currentIndex),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: UIConstants.bottomNavigationHeight,
        child: ColoredBox(
          color: AppColors.bottomNavigationColor,
          child: Row(
            children: [
              _buildNavItem(
                context: context,
                index: MainTabs.home.tabIndex,
                currentIndex: currentIndex,
                iconPath: Assets.svgsNote,
                label: MainTabs.home.label,
              ),
              _buildNavItem(
                context: context,
                index: MainTabs.chart.tabIndex,
                currentIndex: currentIndex,
                iconPath: Assets.svgsTime,
                label: MainTabs.chart.label,
                iconMargin: const EdgeInsets.only(
                  left: UIConstants.extraSmallSpacing,
                ),
              ),
              FloatingAddButton(currentIndex: currentIndex),
              _buildNavItem(
                context: context,
                index: MainTabs.report.index,
                currentIndex: currentIndex,
                iconPath: Assets.svgsReport,
                label: MainTabs.report.label,
                iconMargin: const EdgeInsets.only(
                  left:
                      UIConstants.smallPadding + UIConstants.extraSmallSpacing,
                ),
              ),
              _buildNavItem(
                context: context,
                index: MainTabs.profile.index,
                currentIndex: currentIndex,
                iconPath: Assets.svgsProfile,
                label: MainTabs.profile.label,
                textMargin: const EdgeInsets.only(
                  right: UIConstants.extraSmallSpacing / 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required String iconPath,
    required String label,
    EdgeInsets iconMargin = EdgeInsets.zero,
    EdgeInsets textMargin = EdgeInsets.zero,
  }) {
    return NavigationItem(
      index: index,
      currentIndex: currentIndex,
      iconPath: iconPath,
      label: label,
      iconMargin: iconMargin,
      textMargin: textMargin,
      onTap: () => _onTabSelected(context, index),
    );
  }
}
