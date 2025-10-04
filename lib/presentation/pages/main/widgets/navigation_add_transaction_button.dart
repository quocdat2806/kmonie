import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/navigation/export.dart';
import '../../../../generated/assets.dart';

class MainNavigationAddTransactionButton extends StatelessWidget {

  const MainNavigationAddTransactionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -UIConstants.topAddTransactionButtonOffset,
            child: InkWell(
              onTap: () => _navigateToAddTransactionPage(context),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(UIConstants.defaultPadding),
                  child: SvgPicture.asset(
                    Assets.svgsPlus,
                    width: UIConstants.largeIconSize,
                    height: UIConstants.largeIconSize,
                  ),
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
