import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/application/auth/auth.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';

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
          theme: ThemeData(useMaterial3: true, fontFamily: AppConfigs.fontFamily),
          routerConfig: appRouter.router,
        ),
      ),
    );
  }
}
