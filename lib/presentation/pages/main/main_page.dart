import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'widgets/bottom_navigation_bar.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

final List<Widget> pageList = const <Widget>[HomePage(), ChartPage(), ReportPage(), ProfilePage()];

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  void _onTabSelected({required BuildContext context, required int index}) {
    context.read<MainBloc>().add(MainSwitchTab(index));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      create: (_) => MainBloc(),
      child: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          final int currentIndex = state.selectedIndex;
          return Scaffold(
            backgroundColor: AppColorConstants.primary,
            body: SafeArea(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppUIConstants.bottomNavigationHeight),
                      child: pageList[currentIndex],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: MainBottomNavigationBar(
                      currentIndex: currentIndex,
                      onTabSelected: (i) => _onTabSelected(context: context, index: i),
                    ),
                  ),
                  const Positioned(bottom: 0 + AppUIConstants.topAddTransactionButtonOffset, left: 0, right: 0, child: AddTransactionButton()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
