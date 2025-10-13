import 'package:flutter/material.dart';
import 'package:kmonie/core/config/app_config.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/injection_container.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/database/secure_storage.dart';
import 'package:kmonie/generated/assets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    Future.delayed(const Duration(seconds: 1), () async {
      final String? isAuthenticated = await sl<SecureStorageService>().read(AppConfigs.tokenKey);
      if (!mounted) return;
      if (isAuthenticated != null && isAuthenticated.isNotEmpty) {
        AppNavigator(context: context).goNamed(RouterPath.main);
      } else {
        AppNavigator(context: context).goNamed(RouterPath.signIn);
      }
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
