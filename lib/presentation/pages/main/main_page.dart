import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/navigation_constants.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/bloc/main/main_bloc.dart';
import 'package:kmonie/presentation/pages/category/category_page.dart';
import 'package:kmonie/presentation/pages/chart/chart_page.dart';
import 'package:kmonie/presentation/pages/home/home_page.dart';
import 'package:kmonie/presentation/pages/main/widgets/bottom_add_button.dart';
import 'package:kmonie/presentation/pages/main/widgets/bottom_nav_item.dart';
import 'package:kmonie/presentation/pages/profile/profile_page.dart';
import 'package:kmonie/presentation/pages/report/report_page.dart';

final List<Widget> pageList = <Widget>[
  const HomePage(),
  const ChartPage(),
  const CategoryPage(),
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
          body: _buildBody(currentIndex),
          bottomNavigationBar: _buildBottomNavigationBar(context, currentIndex),
        );
      },
    );
  }

  Widget _buildBody(int currentIndex) {
    return pageList[currentIndex];
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        height: 60,
        color: AppColors.bottomNavigationColor,
        child: Row(
          children: [
            _buildNavItem(
              context: context,
              index: NavigationConstants.homeIndex,
              currentIndex: currentIndex,
              iconPath: Assets.svgsNote,
              label: NavigationConstants.homeLabel,
            ),
            _buildNavItem(
              context: context,
              index: NavigationConstants.chartIndex,
              currentIndex: currentIndex,
              iconPath: Assets.svgsTime,
              label: NavigationConstants.chartLabel,
              iconMargin: const EdgeInsets.only(left: 4),
            ),
            BottomAddButton(
              currentIndex: currentIndex,
              onTab: () =>
                  _onTabSelected(context, NavigationConstants.categoryIndex),
            ),
            _buildNavItem(
              context: context,
              index: NavigationConstants.reportIndex,
              currentIndex: currentIndex,
              iconPath: Assets.svgsReport,
              label: NavigationConstants.reportLabel,
              iconMargin: const EdgeInsets.only(left: 12),
            ),
            _buildNavItem(
              context: context,
              index: NavigationConstants.profileIndex,
              currentIndex: currentIndex,
              iconPath: Assets.svgsProfile,
              label: NavigationConstants.profileLabel,
              textMargin: const EdgeInsets.only(right: 2),
            ),
          ],
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
    return BottomNavItem(
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
