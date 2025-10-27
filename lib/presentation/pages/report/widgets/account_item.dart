import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';

class AccountItem extends StatelessWidget {
  final Account account;

  const AccountItem({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final bank = BankConstants.vietNamBanks.firstWhere(
      (b) => b.id == account.bankId,
      orElse: () => Bank(id: account.bankId!, name: 'Unknown Bank', code: '', shortName: ''),
    );
    return Container(
      margin: const EdgeInsets.only(bottom: AppUIConstants.defaultSpacing, top: AppUIConstants.smallSpacing),
      decoration: BoxDecoration(
        color: AppColorConstants.white,
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.4), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        spacing: AppUIConstants.smallSpacing,
        children: [
          Image.network(bank.logo, width: 80, height: 80),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.smallSpacing,
              children: [
                Text(account.name, style: AppTextStyle.blackS16Medium),
                Text(bank.name, style: AppTextStyle.grayS12Medium),
                if (account.accountNumber.isNotEmpty) Text('${AppTextConstants.accountNumberLabel}: ${account.accountNumber}', style: AppTextStyle.grayS12Medium),
                Text('${AppTextConstants.accountTypeLabel}: ${account.type}', style: AppTextStyle.grayS12Medium),
                Text('Số dư: ${FormatUtils.formatCurrency(account.balance)} ${AppTextConstants.currency}', style: AppTextStyle.grayS12Medium),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
