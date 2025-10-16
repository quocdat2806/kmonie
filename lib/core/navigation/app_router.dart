import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kmonie/application/authentication/authentication.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'package:kmonie/core/enums/enums.dart';
import './router_path.dart';
import './router_refresh.dart';

class AppRouter {
  AppRouter(this.authBloc);

  final AuthenticationBloc authBloc;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouterPath.splash,
    refreshListenable: RouterRefresh(authBloc.stream),
    errorBuilder: (_, GoRouterState state) => const Scaffold(body: Center(child: Text('Page not found'))),
    routes: <RouteBase>[
      GoRoute(name: RouterPath.splash, path: RouterPath.splash, builder: (_, _) => const SplashPage()),
      GoRoute(
        name: RouterPath.signIn,
        path: RouterPath.signIn,
        builder: (_, _) => const AuthPage(mode: AuthMode.signIn),
      ),
      GoRoute(
        name: RouterPath.signUp,
        path: RouterPath.signUp,
        builder: (_, _) => const AuthPage(mode: AuthMode.signUp),
      ),
      GoRoute(name: RouterPath.main, path: RouterPath.main, builder: (_, _) => const MainPage()),
      GoRoute(path: RouterPath.searchTransaction, builder: (_, _) => const SearchTransactionPage()),
      GoRoute(path: RouterPath.upgradeVip, builder: (_, _) => const VipUpgradePage()),
      GoRoute(path: RouterPath.calendarMonthlyTransaction, builder: (_, _) => const CalendarMonthlyTransaction()),
      GoRoute(
        path: RouterPath.transactionActions,
        builder: (_, state) {
          final args = state.extra as TransactionActionsPageArgs?;
          return TransactionActionsPage(args: args);
        },
      ),
      GoRoute(
        path: RouterPath.detailTransaction,
        builder: (_, state) {
          final args = state.extra as DetailTransactionArgs;
          return DetailTransactionPage(args: args);
        },
      ),
      GoRoute(
        path: RouterPath.dailyTransactions,
        builder: (_, state) {
          final args = state.extra as DailyTransactionPageArgs;
          return DailyTransactionPage(args: args);
        },
      ),
      GoRoute(path: RouterPath.budget, builder: (_, state) => const BudgetPage()),
      GoRoute(path: RouterPath.addBudget, builder: (_, state) => const AddBudgetPage()),
      GoRoute(path: RouterPath.addAccount, builder: (_, state) => const AddAccountPage()),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   final bool isAuthenticated = authBloc.state.isAuthenticated;
    //   final String location = state.matchedLocation;
    //   final bool isAuthPage = location == RouterPath.signIn || location == RouterPath.signUp;
    //   final bool isSplashPage = location == RouterPath.splash;
    //   if (isSplashPage) {
    //     return null;
    //   }
    //   if (isAuthenticated) {
    //     if (isAuthPage) {
    //       final String? from = state.uri.queryParameters['from'];
    //       if (from != null && from.isNotEmpty) {
    //         return from;
    //       }
    //       return RouterPath.main;
    //     }
    //     return null;
    //   }

    //   if (!isAuthenticated) {
    //     if (isAuthPage) return null;
    //     return Uri(path: RouterPath.signIn, queryParameters: {'from': location}).toString();
    //   }

    //   return null;
    // },
  );
}
