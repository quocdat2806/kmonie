import 'package:flutter/material.dart';
import '../../../../core/constant/export.dart';
import '../../../widgets/export.dart';

class MainNavigationAddTransactionButton extends StatelessWidget {
  const MainNavigationAddTransactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -UIConstants.topAddTransactionButtonOffset,
            child: AddTransactionButton(),
          ),
        ],
      ),
    );
  }


}
