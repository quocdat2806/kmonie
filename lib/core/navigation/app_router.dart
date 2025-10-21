import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kmonie/presentation/pages/pages.dart';
import './router_path.dart';

class AppRouter {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouterPath.splash,
    errorBuilder: (_, GoRouterState state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
    routes: <RouteBase>[
      GoRoute(
        name: RouterPath.splash,
        path: RouterPath.splash,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        name: RouterPath.main,
        path: RouterPath.main,
        builder: (_, _) => const MainPage(),
      ),
      GoRoute(
        path: RouterPath.searchTransaction,
        builder: (_, _) => const SearchTransactionPage(),
      ),
      GoRoute(
        path: RouterPath.upgradeVip,
        builder: (_, _) => const VipUpgradePage(),
      ),
      GoRoute(
        path: RouterPath.calendarMonthlyTransaction,
        builder: (_, _) => const CalendarMonthlyTransaction(),
      ),
      GoRoute(
        path: RouterPath.transactionActions,
        builder: (_, GoRouterState state) {
          final TransactionActionsPageArgs? args =
              state.extra as TransactionActionsPageArgs?;
          return TransactionActionsPage(args: args);
        },
      ),
      GoRoute(
        path: RouterPath.detailTransaction,
        builder: (_, GoRouterState state) {
          final DetailTransactionArgs args =
              state.extra as DetailTransactionArgs;
          return DetailTransactionPage(args: args);
        },
      ),
      GoRoute(
        path: RouterPath.dailyTransactions,
        builder: (_, GoRouterState state) {
          final DailyTransactionPageArgs args =
              state.extra as DailyTransactionPageArgs;
          return DailyTransactionPage(args: args);
        },
      ),
      GoRoute(
        path: RouterPath.budget,
        builder: (_, GoRouterState state) => const BudgetPage(),
      ),
      GoRoute(
        name: RouterPath.addBudget,
        path: RouterPath.addBudget,
        builder: (_, GoRouterState state) => const AddBudgetPage(),
      ),
      GoRoute(
        path: RouterPath.addAccount,
        builder: (_, GoRouterState state) {
          final AccountActionsPageArgs? args =
              state.extra as AccountActionsPageArgs?;
          return AccountActionsPage(args: args);
        },
      ),
      GoRoute(
        path: RouterPath.manageAccount,
        builder: (_, GoRouterState state) => const ManageAccountPage(),
      ),
      GoRoute(
        path: RouterPath.monthlyStatistics,
        builder: (_, GoRouterState state) => const MonthlyStatisticsPage(),
      ),
      GoRoute(
        name: RouterPath.myApp,
        path: RouterPath.myApp,
        builder: (_, GoRouterState state) => const MyAppPage(),
      ),
      GoRoute(
        name: RouterPath.settings,
        path: RouterPath.settings,
        builder: (_, GoRouterState state) => const SettingsPage(),
      ),
    ],
  );
}
