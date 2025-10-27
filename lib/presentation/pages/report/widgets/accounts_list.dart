import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'account_item.dart';

class AccountsList extends StatelessWidget {
  const AccountsList({super.key});

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.smallPadding),
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
