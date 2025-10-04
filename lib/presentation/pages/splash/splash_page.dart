import 'package:flutter/material.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/navigation/export.dart';
import '../../../generated/assets.dart';

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
        AppNavigator(context: context).pushReplacementNamed(RouterPath.main);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorConstants.primary,
      child: Image.asset(Assets.imagesLogo, fit: BoxFit.contain),
    );
  }
}
