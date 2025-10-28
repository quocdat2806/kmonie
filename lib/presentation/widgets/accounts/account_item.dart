import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';

class AccountItem extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;
  final VoidCallback? onPinTap;
  final VoidCallback? onEditTap;
  final bool showPinned;
  final bool showUnpinnedIcon;
  final bool showEditButton;

  const AccountItem({super.key, required this.account, this.onTap, this.onPinTap, this.onEditTap, this.showPinned = false, this.showUnpinnedIcon = false, this.showEditButton = false});

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
          // Bank logo with pinned indicator - có thể click để pinned/unpinned
          GestureDetector(
            onTap: onPinTap,
            child: SizedBox(
              width: 80,
              height: 80,
              child: Stack(
                children: [
                  bank.logo.isNotEmpty
                      ? Image.network(
                          bank.logo,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance, size: 40, color: AppColorConstants.primary),
                        )
                      : const Icon(Icons.account_balance, size: 40, color: AppColorConstants.primary),
                  if (showPinned || showUnpinnedIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: account.isPinned ? Colors.orange : AppColorConstants.grey, shape: BoxShape.circle),
                        child: const Icon(Icons.push_pin, size: 12, color: AppColorConstants.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppUIConstants.smallSpacing,
              children: [
                const SizedBox(height: AppUIConstants.smallSpacing),
                Text('${AppTextConstants.accountNameLabel}: ${account.name}', style: AppTextStyle.grayS12Medium),
                Text(bank.name, style: AppTextStyle.grayS12Medium),
                if (account.accountNumber.isNotEmpty) Text('${AppTextConstants.accountNumberLabel}: ${account.accountNumber}', style: AppTextStyle.grayS12Medium),
                Text('${AppTextConstants.accountTypeLabel}: ${account.type}', style: AppTextStyle.grayS12Medium),
                Text('${AppTextConstants.accountBalanceLabel}: ${FormatUtils.formatCurrency(account.balance)} ${AppTextConstants.currency}', style: AppTextStyle.grayS12Medium),
                const SizedBox.shrink(),
                const SizedBox.shrink(),
              ],
            ),
          ),
          if (showEditButton)
            GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: AppColorConstants.primary, borderRadius: BorderRadius.circular(4)),
                child: Text(AppTextConstants.editAccountText, style: AppTextStyle.whiteS12Medium),
              ),
            ),
        ],
      ),
    );
  }
}
