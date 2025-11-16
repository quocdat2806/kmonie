import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/args/args.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  List<Account>? _localAccounts;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountActionsBloc(sl<AccountRepository>())
            ..add(const AccountActionsEvent.loadAllAccounts()),
      child: BlocListener<AccountActionsBloc, AccountActionsState>(
        listener: (context, state) {},
        child: Builder(builder: (context) => _buildScaffold(context)),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: CustomAppBar(
        title: AppTextConstants.manageAccount,
        actions: [
          IconButton(
            onPressed: () => _navigateToAddAccount(context),
            icon: const Icon(Icons.add, color: AppColorConstants.black),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocListener<AccountActionsBloc, AccountActionsState>(
          listener: (context, state) {
            setState(() {
              _localAccounts = List.from(state.accounts);
            });
          },
          child: BlocBuilder<AccountActionsBloc, AccountActionsState>(
            builder: (context, state) {
              return _buildAccountList(context, state.accounts);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAccountList(BuildContext context, List<Account> accounts) {
    _localAccounts ??= List.from(accounts);

    final displayAccounts = accounts;

    if (displayAccounts.isEmpty) {
      return Center(
        child: Column(
          spacing: AppUIConstants.smallSpacing,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppTextConstants.noAccount, style: AppTextStyle.grayS16Medium),
            Text(AppTextConstants.addAccountText, style: AppTextStyle.grayS14),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppUIConstants.smallPadding),
      child: ListView.builder(
        itemCount: displayAccounts.length,
        itemBuilder: (context, index) {
          final account = displayAccounts[index];
          return AccountItem(
            key: ValueKey(account.id),
            account: account,
            onTap: () => _editAccount(context, account),
            onPinTap: () =>
                _togglePinAccount(context, account, displayAccounts),
            onEditTap: () => _editAccount(context, account),
            showPinned: true,
            showUnpinnedIcon: true,
            showEditButton: true,
          );
        },
      ),
    );
  }

  void _navigateToAddAccount(BuildContext context) {
    AppNavigator(context: context).push(RouterPath.accountActions);
  }

  void _editAccount(BuildContext context, Account account) {
    AppNavigator(context: context).push(
      RouterPath.accountActions,
      extra: AccountActionsPageArgs(account: account),
    );
  }

  void _togglePinAccount(
    BuildContext context,
    Account account,
    List<Account> allAccounts,
  ) {
    if (account.id == null) return;

    for (final acc in allAccounts) {
      if (acc.isPinned && acc.id != null && acc.id != account.id) {
        context.read<AccountActionsBloc>().add(
          AccountActionsEvent.unpinAccount(acc.id!),
        );
      }
    }

    if (!account.isPinned) {
      context.read<AccountActionsBloc>().add(
        AccountActionsEvent.pinAccount(account.id!),
      );
    }
  }
}
