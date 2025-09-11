import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/navigation/app_navigation.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/routes/router_path.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        AppNavigator(context: context).push(RouterPath.main);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.yellow,
      child:  Image.asset(Assets.imagesLogo,fit: BoxFit.contain),
    );
  }
}
