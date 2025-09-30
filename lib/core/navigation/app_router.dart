import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmonie/presentation/pages/calendar_monthly_transaction/calendar_monthly_transaction.dart';
import '../../application/auth/auth_export.dart';
import '../navigation/exports.dart';
import '../enum/exports.dart';
import '../../presentation/pages/exports.dart';

class AppRouter {
  AppRouter(this.authBloc);

  final AuthBloc authBloc;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouterPath.splash,
    refreshListenable: RouterRefresh(authBloc.stream),
    errorBuilder: (_, GoRouterState state) =>
    const Scaffold(body: Center(child: Text('Page not found'))),
    routes: <RouteBase>[
      GoRoute(path: RouterPath.splash, builder: (_, _) => const SplashPage()),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            child,
        routes: <RouteBase>[
          GoRoute(
            path: '/auth/signin',
            builder: (_, _) => const AuthScreen(mode: AuthMode.signIn),
          ),
          GoRoute(
            path: '/auth/signup',
            builder: (_, _) => const AuthScreen(mode: AuthMode.signUp),
          ),
        ],
      ),
      GoRoute(name: RouterPath.main,path: RouterPath.main, builder: (_, _) => const MainPage()),
      GoRoute(
        path: RouterPath.searchTransaction,
        builder: (_, _) => const SearchScreen(),
      ),
      // GoRoute(
      //   path: RouterPath.addTransactionCategory,
      //   builder: (_, _) => const AddTransactionCategoryPage(),
      // ),

      GoRoute(
        path: RouterPath.calendarMonthlyTransaction,
        builder: (_, _) => const CalendarMonthlyTransaction(),
      ),
      GoRoute(
        path: RouterPath.addTransaction,
        builder: (_, _) => const AddTransactionPage(),
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
