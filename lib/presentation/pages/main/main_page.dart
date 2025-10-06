import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/export.dart';
import '../../../presentation/bloc/export.dart';
import '../../../presentation/pages/export.dart';
import 'widgets/bottom_navigation_bar.dart';

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
            backgroundColor: ColorConstants.primary,
            body: SafeArea(
              child: IndexedStack(index: currentIndex, children: pageList),
            ),
            bottomNavigationBar: MainBottomNavigationBar(
              currentIndex: currentIndex,
              onTabSelected: (i) => _onTabSelected(context: context, index: i),
            ),
          );
        },
      ),
    );
  }
}
