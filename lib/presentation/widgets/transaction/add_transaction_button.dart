import 'package:flutter/material.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/generated/export.dart';

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
          color: AppColorConstants.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: SvgUtils.icon(
            assetPath: Assets.svgsPlus,
            size: SvgSizeType.large,
          ),
        ),
      ),
    );
  }

  void _navigateToAddTransactionPage(BuildContext context) {
    AppNavigator(context: context).push(
      RouterPath.transactionActions,
      extra: TransactionActionsPageArgs(selectedDate: initialDate),
    );
  }
}
