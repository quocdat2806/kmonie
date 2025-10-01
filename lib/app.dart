import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/auth/auth_export.dart';
import 'core/config/export.dart';
import 'core/navigation/exports.dart';
import 'core/service/exports.dart';
import 'core/theme/exports.dart';
import 'core/util/exports.dart';

class App extends StatelessWidget {
  const App({super.key, required this.authBloc, required this.appRouter});
  final AuthBloc authBloc;
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => authBloc,
      child: GestureDetector(
        onTap: () => KeyboardHelper.hideKeyboard(context),
        child: MaterialApp.router(
          scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
          theme: ThemeData(useMaterial3: true, inputDecorationTheme: AppInputTheme.defaultInput, fontFamily: AppConfigs.fontFamily),
          routerConfig: appRouter.router,
        ),
      ),
    );
  }
}
