import 'package:flutter/material.dart';
import '../../pages/export.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/enum/export.dart';
import '../../../../core/navigation/export.dart';
import '../../../../generated/export.dart';

class AddTransactionButton extends StatelessWidget {
  final DateTime? initialDate;
  const AddTransactionButton({super.key, this.initialDate});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToAddTransactionPage(context),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorConstants.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.defaultPadding),
          child: SvgConstants.icon(
            assetPath: Assets.svgsPlus,
            size: SvgSizeType.large,
          ),
        ),
      ),
    );
  }

  void _navigateToAddTransactionPage(BuildContext context) {
    AppNavigator(context: context).push(RouterPath.transactionActions, extra: TransactionActionsPageArgs(selectedDate: initialDate));
  }
}
