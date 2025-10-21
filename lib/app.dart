import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/config/config.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter().router;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyboardUtils.hideKeyboard(context),
      child: MaterialApp.router(
        scaffoldMessengerKey: SnackBarService.scaffoldMessengerKey,
        theme: ThemeData(useMaterial3: true, fontFamily: AppConfigs.fontFamily),
        routerConfig: _router,
      ),
    );
  }
}
