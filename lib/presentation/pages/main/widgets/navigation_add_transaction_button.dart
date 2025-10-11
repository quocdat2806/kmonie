import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

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
            top: -AppUIConstants.topAddTransactionButtonOffset,
            child: AddTransactionButton(),
          ),
        ],
      ),
    );
  }
}
