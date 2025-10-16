import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/application/authentication/authentication.dart';
import 'package:kmonie/application/user/user.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/di/di.dart' as di;

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationBloc _authBloc;
  late final UserBloc _userBloc;
  late final AppRouter _appRouter;

  Future<void> _initializeApp() async {
    _userBloc = UserBloc(di.sl<UserService>());
    _authBloc = AuthenticationBloc(di.sl<SecureStorageService>(), _userBloc, di.sl<UserService>());
    _authBloc.add(const AuthenticationEvent.checkAuthStatus());
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>.value(value: _authBloc),
        BlocProvider<UserBloc>.value(value: _userBloc),
      ],
      child: GestureDetector(
        onTap: () => KeyboardUtils.hideKeyboard(context),
        child: MaterialApp.router(
          scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
          theme: ThemeData(useMaterial3: true, fontFamily: AppConfigs.fontFamily),
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
