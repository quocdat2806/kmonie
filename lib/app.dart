import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/application/authentication/authentication.dart';
import 'package:kmonie/application/user/user.dart';
import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'package:kmonie/core/di/di.dart' as di;
import 'package:kmonie/database/database.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationBloc _authBloc;
  late final UserBloc _userBloc;
  late final AppRouter _appRouter;
  bool _isInitialized = false;

  Future<void> _initializeApp() async {
    _userBloc = UserBloc(di.sl<UserService>());
    _authBloc = AuthenticationBloc(di.sl<SecureStorageService>(), _userBloc);

    _authBloc.add(const AuthenticationEvent.checkAuthStatus());
    _appRouter = AppRouter(_authBloc);
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    // if (!_isInitialized) {
    //   return const MaterialApp(home: SplashPage());
    // }
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>.value(value: _authBloc),
        BlocProvider<UserBloc>.value(value: _userBloc),
      ],
      child: GestureDetector(
        onTap: () => KeyboardUtils.hideKeyboard(context),
        child: MaterialApp.router(
          scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: AppConfigs.fontFamily,
          ),
          routerConfig: _appRouter.router,
        ),
      ),
    );
  }
}
