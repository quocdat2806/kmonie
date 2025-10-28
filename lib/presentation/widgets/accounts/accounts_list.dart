import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/entities/entities.dart';
import 'account_item.dart';

class AccountsList extends StatelessWidget {
  final List<Account>? accounts;
  final void Function(Account)? onAccountTap;
  final String? title;
  final bool showTitle;

  const AccountsList({super.key, this.accounts, this.onAccountTap, this.title, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    // If accounts list is provided, use it; otherwise use BlocBuilder
    if (accounts != null) {
      if (accounts!.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        spacing: AppUIConstants.defaultSpacing,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) Text(title ?? AppTextConstants.accountList, style: AppTextStyle.blackS14Bold),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: accounts!.length,
            itemBuilder: (context, index) {
              final account = accounts![index];
              return AccountItem(account: account, onTap: onAccountTap != null ? () => onAccountTap!(account) : null, showPinned: true);
            },
          ),
        ],
      );
    }

    // Default: use ReportBloc
    return BlocBuilder<ReportBloc, ReportState>(
      builder: (context, state) {
        if (state.accounts.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          spacing: AppUIConstants.defaultSpacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppTextConstants.accountList, style: AppTextStyle.blackS14Bold),
            Expanded(
              child: ListView.builder(
                itemCount: state.accounts.length,
                itemBuilder: (context, index) {
                  final account = state.accounts[index];
                  return AccountItem(account: account);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
