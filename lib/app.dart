import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/auth/auth_export.dart';
import 'core/config/export.dart';
import 'core/navigation/export.dart';
import 'core/service/export.dart';
import 'core/theme/export.dart';
import 'core/util/export.dart';

class App extends StatelessWidget {
  const App({super.key, required this.authBloc, required this.appRouter});
  final AuthBloc authBloc;
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => authBloc,
      child: GestureDetector(
        onTap: () => KeyboardUtils.hideKeyboard(context),
        child: MaterialApp.router(
          scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
          theme: ThemeData(useMaterial3: true, inputDecorationTheme: AppInputTheme.defaultInput, fontFamily: AppConfigs.fontFamily),
          routerConfig: appRouter.router,
        ),
      ),
    );
  }
}
