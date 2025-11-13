import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/args/args.dart';

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
        builder: (_, _) {
          return BlocProvider<MainBloc>(
            create: (_) => MainBloc(),
            child: const MainPage(),
          );
        },
      ),
      GoRoute(
        path: RouterPath.searchTransaction,
        builder: (_, _) {
          return BlocProvider<SearchTransactionBloc>(
            create: (_) => SearchTransactionBloc(
              sl<TransactionRepository>(),
              sl<TransactionCategoryRepository>(),
            ),
            child: const SearchTransactionPage(),
          );
        },
      ),

      GoRoute(
        path: RouterPath.calendarMonthlyTransaction,
        builder: (_, _) {
          return BlocProvider<CalendarMonthlyTransactionBloc>(
            create: (_) => CalendarMonthlyTransactionBloc(
              sl<TransactionRepository>(),
              sl<TransactionCategoryRepository>(),
            ),
            child: const CalendarMonthlyTransactionPage(),
          );
        },
      ),
      GoRoute(
        path: RouterPath.transactionActions,
        builder: (_, GoRouterState state) {
          final TransactionActionsPageArgs? args =
              state.extra as TransactionActionsPageArgs?;
          return BlocProvider<TransactionActionsBloc>(
            create: (_) => TransactionActionsBloc(
              sl<TransactionCategoryRepository>(),
              sl<TransactionRepository>(),
              sl<BudgetRepository>(),
              args,
            ),
            child: TransactionActionsPage(args: args),
          );
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
          return BlocProvider<DailyTransactionBloc>(
            create: (_) => DailyTransactionBloc(),
            child: DailyTransactionPage(args: args),
          );
        },
      ),
      GoRoute(
        path: RouterPath.budget,
        builder: (_, GoRouterState state) {
          return BlocProvider<BudgetBloc>(
            create: (_) => BudgetBloc(
              sl<TransactionCategoryRepository>(),
              sl<BudgetRepository>(),
            ),
            child: const BudgetPage(),
          );
        },
      ),
      GoRoute(
        name: RouterPath.addBudget,
        path: RouterPath.addBudget,
        builder: (_, GoRouterState state) {
          return BlocProvider<AddBudgetBloc>(
            create: (_) => AddBudgetBloc(
              sl<TransactionCategoryRepository>(),
              sl<BudgetRepository>(),
            ),
            child: const AddBudgetPage(),
          );
        },
      ),
      GoRoute(
        path: RouterPath.addAccount,
        builder: (_, GoRouterState state) {
          final AccountActionsPageArgs? args =
              state.extra as AccountActionsPageArgs?;
          return BlocProvider<AccountActionsBloc>(
            create: (_) => AccountActionsBloc(sl<AccountRepository>()),
            child: AccountActionsPage(args: args),
          );
        },
      ),
      GoRoute(
        path: RouterPath.manageAccount,
        builder: (_, GoRouterState state) {
          return BlocProvider<AccountActionsBloc>(
            create: (context) => AccountActionsBloc(sl<AccountRepository>()),
            child: const ManageAccountPage(),
          );
        },
      ),
      GoRoute(
        path: RouterPath.monthlyStatistics,
        builder: (_, GoRouterState state) {
          return BlocProvider<MonthlyStatisticsBloc>(
            create: (_) => MonthlyStatisticsBloc(),
            child: const MonthlyStatisticsPage(),
          );
        },
      ),
      GoRoute(
        name: RouterPath.settings,
        path: RouterPath.settings,
        builder: (_, GoRouterState state) => const SettingsPage(),
      ),
    ],
  );
}
