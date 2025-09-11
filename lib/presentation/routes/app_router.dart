import 'package:kmonie/application/auth/auth_bloc.dart';
import 'package:kmonie/application/auth/auths_state.dart';
import 'package:kmonie/core/enums/auth_mode.dart';
import 'package:kmonie/core/navigation/go_router_refresh.dart';
import 'package:kmonie/presentation/pages/auth/auth_page.dart';
import 'package:kmonie/presentation/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmonie/presentation/pages/splash/splash_page.dart';

class AppRouter {
  AppRouter(this.authBloc);

  final AuthBloc authBloc;

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    errorBuilder: (_, GoRouterState state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
    routes: <RouteBase>[
      GoRoute(path: '/splash', builder: (_, _) => const SplashPage()),
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
      GoRoute(path: '/main', builder: (_, _) => const MainPage()),
    ],
    redirect: (_, GoRouterState state) {
      final AuthState authState = authBloc.state;
      final String location = state.matchedLocation;
      final bool inAuth = location.startsWith('/auth');
      final bool atSplash = location == '/splash';

      if (authState is AuthLoading) {
        return atSplash ? null : '/splash';
      }

      if (authState is AuthUnauthenticated) {
        if (atSplash || inAuth) return null;
        final Uri from = state.uri;
        final bool fromIsAuth = from.path.startsWith('/auth');
        final String? fromParam = fromIsAuth ? null : from.toString();
        if (fromParam == null) return '/auth/signin';
        return Uri(
          path: '/auth/signin',
          queryParameters: <String, String>{'from': fromParam},
        ).toString();
      }

      if (authState is AuthAuthenticated) {
        if (inAuth || atSplash) {
          final String? from = state.uri.queryParameters['from'];
          if (from != null && from.isNotEmpty && !from.startsWith('/auth')) {
            return from;
          }
          return '/main';
        }
      }

      return null;
    },
  );
}
