import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/generated/generated.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      final bool isAuthenticated = await sl<SecureStorageService>().isLoggedIn();
      if (!mounted) return;
      if (isAuthenticated) {
        AppNavigator(context: context).goNamed(RouterPath.main);
        return;
      }
      AppNavigator(context: context).goNamed(RouterPath.main);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.primary,
      body: Center(child: Image.asset(Assets.imagesLogo, fit: BoxFit.cover)),
    );
  }
}
