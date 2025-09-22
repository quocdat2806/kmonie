import 'package:flutter/material.dart';

import '../../../../core/exports.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, color: ColorConstants.divider);
  }
}
