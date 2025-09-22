import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/exports.dart';
import '../../../generated/assets.dart';

class AddTransactionButtonFloating extends StatelessWidget {
  final double topAddButtonOffset;
  final double? rightAddButtonOffset;

  const AddTransactionButtonFloating({
    super.key,
    this.topAddButtonOffset = UIConstants.topAddButtonOffset,
    this.rightAddButtonOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: rightAddButtonOffset,
            top: -UIConstants.topAddButtonOffset,
            child: GestureDetector(
              onTap: () => _navigateToAddTransactionPage(context),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorConstants.yellow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(UIConstants.defaultPadding),
                  child: SvgPicture.asset(
                    Assets.svgsAdd,
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
