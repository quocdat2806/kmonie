import 'package:cached_network_image/cached_network_image.dart';
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

  const AccountItem({
    super.key,
    required this.account,
    this.onTap,
    this.onPinTap,
    this.onEditTap,
    this.showPinned = false,
    this.showUnpinnedIcon = false,
    this.showEditButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final bank = BankConstants.vietNamBanks.firstWhere(
      (b) => b.id == account.bankId,
      orElse: () => Bank(
        id: account.bankId!,
        name: 'Unknown Bank',
        code: '',
        shortName: '',
      ),
    );
    return Container(
      margin: const EdgeInsets.only(
        bottom: AppUIConstants.defaultMargin,
        top: AppUIConstants.smallMargin,
      ),
      decoration: AppUIConstants.defaultShadow(),
      child: Row(
        spacing: AppUIConstants.smallSpacing,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: onPinTap,
            child: SizedBox(
              width: AppUIConstants.extraLargeContainerSize,
              height: AppUIConstants.extraLargeContainerSize,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: bank.logo,
                    maxWidthDiskCache: AppUIConstants.extraLargeContainerSize
                        .toInt(),
                    maxHeightDiskCache: AppUIConstants.extraLargeContainerSize
                        .toInt(),
                    width: AppUIConstants.extraLargeContainerSize,
                    height: AppUIConstants.extraLargeContainerSize,
                  ),
                  if (showPinned || showUnpinnedIcon)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: AnimatedContainer(
                        duration: AppUIConstants.shortAnimationDuration,
                        child: Icon(
                          Icons.push_pin,
                          size: AppUIConstants.smallIconSize,
                          color: account.isPinned
                              ? AppColorConstants.primary
                              : AppColorConstants.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppUIConstants.smallPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppUIConstants.smallSpacing,
                children: [
                  Text(
                    '${AppTextConstants.accountNameLabel}: ${account.name}',
                    style: AppTextStyle.grayS12Medium,
                  ),
                  Text(bank.name, style: AppTextStyle.grayS12Medium),
                  Text(
                    '${AppTextConstants.accountNumberLabel}: ${account.accountNumber}',
                    style: AppTextStyle.grayS12Medium,
                  ),
                  Text(
                    '${AppTextConstants.accountTypeLabel}: ${account.type}',
                    style: AppTextStyle.grayS12Medium,
                  ),
                  Text(
                    '${AppTextConstants.accountBalanceLabel}: ${FormatUtils.formatCurrency(account.balance)} ${AppTextConstants.currency}',
                    style: AppTextStyle.grayS12Medium,
                  ),
                ],
              ),
            ),
          ),
          if (showEditButton)
            InkWell(
              splashColor: Colors.transparent,
              onTap: onEditTap,
              child: Text(
                AppTextConstants.editAccountText,
                style: AppTextStyle.blackS14Medium,
              ),
            ),
          const SizedBox(width: AppUIConstants.smallSpacing),
        ],
      ),
    );
  }
}
