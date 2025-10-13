import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/application/authentication/authentication.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // AuthenticationBloc sẽ tự động check auth status và redirect
    // Không cần làm gì thêm ở đây
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          Future.delayed(const Duration(seconds: 2), () {
            AppNavigator(
              context: context,
            ).pushReplacementNamed(RouterPath.main);
          });
        } else {
          Future.delayed(const Duration(seconds: 2), () {
            AppNavigator(
              context: context,
            ).pushReplacementNamed(RouterPath.signIn);
          });
        }
      },
      child: ColoredBox(
        color: AppColorConstants.primary,
        child: Image.asset(Assets.imagesLogo, fit: BoxFit.contain),
      ),
    );
  }
}
