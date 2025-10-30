import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/repositories/repositories.dart';

import 'widgets/bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Map<int, Widget> _pageCache = {};

  final Set<int> _initializedPages = {};

  Widget _buildPage(int index) {
    if (_pageCache.containsKey(index)) {
      return _pageCache[index]!;
    }

    Widget page;
    switch (index) {
      case 0:
        page = BlocProvider(
          create: (_) {
            return HomeBloc(sl<TransactionRepository>(), sl<TransactionCategoryRepository>());
          },
          child: const _KeepAliveWrapper(child: HomePage()),
        );
        break;
      case 1:
        page = BlocProvider(
          create: (_) {
            return ChartBloc(sl<TransactionRepository>(), sl<TransactionCategoryRepository>());
          },
          child: const _KeepAliveWrapper(child: ChartPage()),
        );
        break;
      case 2:
        page = BlocProvider(
          create: (_) {
            return ReportBloc(sl<BudgetRepository>(), sl<TransactionRepository>(), sl<TransactionCategoryRepository>(), sl<AccountRepository>());
          },
          child: const _KeepAliveWrapper(child: ReportPage()),
        );
        break;
      case 3:
        page = const _KeepAliveWrapper(child: ProfilePage());
        break;
      default:
        page = const SizedBox.shrink();
    }

    _pageCache[index] = page;
    _initializedPages.add(index);
    return page;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
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
                    child: IndexedStack(
                      index: currentIndex,
                      children: List.generate(MainTabs.totalTypes, (index) {
                        if (index == currentIndex || _initializedPages.contains(index)) {
                          return _buildPage(index);
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: MainBottomNavigationBar(
                    currentIndex: currentIndex,
                    onTabSelected: (i) {
                      context.read<MainBloc>().add(MainSwitchTab(i));
                    },
                  ),
                ),
                const Positioned(
                  bottom: AppUIConstants.topAddTransactionButtonOffset,
                  left: 0,
                  right: 0,
                  child: Center(child: AddTransactionButton()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
