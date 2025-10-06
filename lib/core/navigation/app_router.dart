import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../application/auth/auth_export.dart';
import '../../presentation/pages/export.dart';
import '../enum/export.dart';
import './router_path.dart';
import './router_refresh.dart';

class AppRouter {
  AppRouter(this.authBloc);

  final AuthBloc authBloc;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouterPath.splash,
    refreshListenable: RouterRefresh(authBloc.stream),
    errorBuilder: (_, GoRouterState state) => const Scaffold(body: Center(child: Text('Page not found'))),
    routes: <RouteBase>[
      GoRoute(path: RouterPath.splash, builder: (_, _) => const SplashPage()),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) => child,
        routes: <RouteBase>[
          GoRoute(
            path: RouterPath.signIn,
            builder: (_, _) => const AuthScreen(mode: AuthMode.signIn),
          ),
          GoRoute(
            path: RouterPath.signUp,
            builder: (_, _) => const AuthScreen(mode: AuthMode.signUp),
          ),
        ],
      ),
      GoRoute(name: RouterPath.main, path: RouterPath.main, builder: (_, _) => const MainPage()),
      GoRoute(path: RouterPath.searchTransaction, builder: (_, _) => const SearchTransactionPage()),
      GoRoute(path: RouterPath.upgradeVip, builder: (_, _) => const VipUpgradePage()),
      GoRoute(path: RouterPath.calendarMonthlyTransaction, builder: (_, _) => const CalendarMonthlyTransaction()),
      GoRoute(
        path: RouterPath.transaction_actions,
        builder: (_, state) {
          final args = state.extra as TransactionActionsPageArgs?;
          return TransactionActionsPage(args: args);
        },
      ),
    ],
    // redirect: (_, GoRouterState state) {
    //   final AuthState authState = authBloc.state;
    //   final String location = state.matchedLocation;
    //   final bool inAuth = location.startsWith('/auth');
    //   final bool atSplash = location == RouterPath.splash;
    //
    //   if (authState is AuthLoading) {
    //     return atSplash ? null : RouterPath.splash;
    //   }
    //
    //   if (authState is AuthUnauthenticated) {
    //     if (atSplash || inAuth) return null;
    //     final Uri from = state.uri;
    //     final bool fromIsAuth = from.path.startsWith('/auth');
    //     final String? fromParam = fromIsAuth ? null : from.toString();
    //     if (fromParam == null) return '/auth/signin';
    //     return Uri(
    //       path: '/auth/signin',
    //       queryParameters: <String, String>{'from': fromParam},
    //     ).toString();
    //   }
    //
    //   if (authState is AuthAuthenticated) {
    //     if (inAuth || atSplash) {
    //       final String? from = state.uri.queryParameters['from'];
    //       if (from != null && from.isNotEmpty && !from.startsWith('/auth')) {
    //         return from;
    //       }
    //       return RouterPath.main;
    //     }
    //   }
    //
    //   return null;
    // },
  );
}
