import 'core/config/app_config.dart';
import 'core/theme/input_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'application/auth/auth_bloc.dart';
import 'core/navigation/app_router.dart';

class App extends StatelessWidget {
  const App({super.key, required this.authBloc, required this.appRouter});
  final AuthBloc authBloc;
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => authBloc,
      child: MaterialApp.router(
        theme: ThemeData(
          useMaterial3: true,
          inputDecorationTheme: AppInputTheme.defaultInput,
          fontFamily: AppConfigs.fontFamily,
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
      ),
    );
  }
}

