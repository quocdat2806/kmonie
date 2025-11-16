import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/entities/entities.dart';

import 'account_item.dart';

class AccountsList extends StatelessWidget {
  final List<Account>? accounts;
  final void Function(Account)? onAccountTap;
  final String? title;
  final bool showTitle;

  const AccountsList({
    super.key,
    this.accounts,
    this.onAccountTap,
    this.title,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    if (accounts == null || accounts!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Text(
            title ?? AppTextConstants.accountList,
            style: AppTextStyle.blackS14Bold,
          ),
        Expanded(
          child: ListView.builder(
            itemCount: accounts!.length,
            itemBuilder: (context, index) {
              final account = accounts![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AccountItem(
                  account: account,
                  onTap: onAccountTap != null
                      ? () => onAccountTap!(account)
                      : null,
                  showPinned: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
