import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/di/injection_container.dart';
import 'package:kmonie/presentation/blocs/account_actions/account_actions.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/repositories/repositories.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountActionsBloc(sl<AccountRepository>())..add(const AccountActionsEvent.loadAccounts()),
      child: BlocListener<AccountActionsBloc, AccountActionsState>(
        listener: (context, state) {
          state.when(initial: () {}, loading: () {}, loaded: (accounts) {}, error: (message) {});
        },
        child: Builder(builder: (context) => _buildScaffold(context)),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.greyWhite,
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
        child: BlocBuilder<AccountActionsBloc, AccountActionsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: Text('Chưa có tài khoản nào')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (accounts) => _buildAccountList(context, accounts),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lỗi: $message'),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: () => context.read<AccountActionsBloc>().add(const AccountActionsEvent.loadAccounts()), child: const Text('Thử lại')),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAccountList(BuildContext context, List<Account> accounts) {
    if (accounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet, size: 64, color: AppColorConstants.grey),
            const SizedBox(height: 16),
            Text('Chưa có tài khoản nào', style: AppTextStyle.grayS16Medium),
            const SizedBox(height: 8),
            Text('Nhấn nút + để thêm tài khoản mới', style: AppTextStyle.grayS14),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        return _buildAccountItem(context, account);
      },
    );
  }

  Widget _buildAccountItem(BuildContext context, Account account) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppUIConstants.defaultSpacing),
      child: Slidable(
        key: ValueKey(account.id),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(onPressed: (context) => _editAccount(context, account), backgroundColor: AppColorConstants.primary, foregroundColor: AppColorConstants.white, icon: Icons.edit, label: 'Sửa'),
            SlidableAction(onPressed: (context) => _togglePinAccount(context, account), backgroundColor: account.isPinned ? Colors.orange : Colors.blue, foregroundColor: AppColorConstants.white, icon: account.isPinned ? Icons.push_pin : Icons.push_pin_outlined, label: account.isPinned ? 'Bỏ ghim' : 'Ghim'),
            SlidableAction(onPressed: (context) => _showDeleteDialog(context, account), backgroundColor: Colors.red, foregroundColor: AppColorConstants.white, icon: Icons.delete, label: 'Xóa'),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          decoration: BoxDecoration(
            color: AppColorConstants.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              // Bank logo or default icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(color: AppColorConstants.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  children: [
                    Center(
                      child: account.bankId != null
                          ? Builder(
                              builder: (context) {
                                final bank = BankConstants.vietNamBanks.firstWhere(
                                  (b) => b.id == account.bankId,
                                  orElse: () => Bank(id: account.bankId!, name: 'Unknown Bank', code: '', shortName: ''),
                                );
                                if (bank.logo.isNotEmpty) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      bank.logo,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance, color: AppColorConstants.primary),
                                    ),
                                  );
                                }
                                return const Icon(Icons.account_balance, color: AppColorConstants.primary);
                              },
                            )
                          : const Icon(Icons.account_balance, color: AppColorConstants.primary),
                    ),
                    if (account.isPinned)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                          child: const Icon(Icons.push_pin, size: 10, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppUIConstants.defaultSpacing),
              // Account info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name, style: AppTextStyle.blackS16Bold),
                    if (account.bankId != null) ...[
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final bank = BankConstants.vietNamBanks.firstWhere(
                            (b) => b.id == account.bankId,
                            orElse: () => Bank(id: account.bankId!, name: 'Unknown Bank', code: '', shortName: ''),
                          );
                          return Text(bank.name, style: AppTextStyle.grayS12Medium);
                        },
                      ),
                    ],
                    if (account.accountNumber.isNotEmpty) ...[const SizedBox(height: 4), Text('Số TK: ${account.accountNumber}', style: AppTextStyle.grayS12Medium)],
                    const SizedBox(height: 4),
                    Text('Loại: ${account.type}', style: AppTextStyle.grayS12Medium),
                  ],
                ),
              ),
              // Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${FormatUtils.formatCurrency(account.balance)} VND', style: AppTextStyle.blackS16Bold),
                  const SizedBox(height: 4),
                  Text('Số dư', style: AppTextStyle.grayS12Medium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToAddAccount(BuildContext context) {
    AppNavigator(context: context).push(RouterPath.addAccount);
  }

  void _editAccount(BuildContext context, Account account) {
    AppNavigator(context: context).push(RouterPath.addAccount, extra: AccountActionsPageArgs(account: account));
  }

  void _togglePinAccount(BuildContext context, Account account) {
    if (account.id != null) {
      if (account.isPinned) {
        context.read<AccountActionsBloc>().add(AccountActionsEvent.unpinAccount(account.id!));
      } else {
        context.read<AccountActionsBloc>().add(AccountActionsEvent.pinAccount(account.id!));
      }
    }
  }

  void _showDeleteDialog(BuildContext context, Account account) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa tài khoản'),
          content: Text('Bạn có chắc chắn muốn xóa tài khoản "${account.name}"?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount(context, account);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount(BuildContext context, Account account) {
    if (account.id != null) {
      context.read<AccountActionsBloc>().add(AccountActionsEvent.deleteAccount(account.id!));
    }
  }
}

class AccountActionsPageArgs {
  final Account? account;

  const AccountActionsPageArgs({this.account});
}
