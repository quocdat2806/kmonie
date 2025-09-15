import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/navigation/app_navigation.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/routes/router_path.dart';

class FloatingAddButton extends StatelessWidget {
  final int currentIndex;
  const FloatingAddButton({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: UIConstants.bottomAddButtonOffset,
            child: GestureDetector(
              onTap: () => _navigateToAddTransactionPage(context),
              child: Container(
                padding: const EdgeInsets.all(
                  UIConstants.smallPadding + UIConstants.extraSmallSpacing,
                ),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.yellow,
                ),
                child: SvgPicture.asset(
                  Assets.svgsAdd,
                  width: UIConstants.largeIconSize,
                  height: UIConstants.largeIconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTransactionPage(BuildContext context) {
    AppNavigator(context: context).push(RouterPath.addTransaction);
  }
}
