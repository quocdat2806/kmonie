import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: AppColorConstants.divider);
  }
}
