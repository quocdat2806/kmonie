import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/di/injection_container.dart';
import 'package:kmonie/presentation/bloc/account_actions/account_actions.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/pages/manage_account/manage_account_page.dart';
import 'package:kmonie/repositories/repositories.dart';

class AccountActionsPage extends StatefulWidget {
  final AccountActionsPageArgs? args;

  const AccountActionsPage({super.key, this.args});

  @override
  State<AccountActionsPage> createState() => _AccountActionsPageState();
}

class _AccountActionsPageState extends State<AccountActionsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  String _selectedType = 'Tiết kiệm';
  Bank? _selectedBank;
  int? _selectedBankId;
  bool _submitted = false;

  final List<String> _accountTypes = ['Tiết kiệm', 'Đầu tư', 'Tín dụng'];
  late final List<Bank> _banks;

  bool get _isEditMode => widget.args?.account != null;

  void _clearFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void initState() {
    super.initState();
    _banks = BankConstants.vietNamBanks;

    if (_isEditMode) {
      final account = widget.args!.account!;
      _nameController.text = account.name;
      _accountNumberController.text = account.accountNumber;
      _balanceController.text = account.balance.toString();
      _selectedType = account.type;
      _selectedBankId = account.bankId;
      // Find bank from bankId for UI display
      if (account.bankId != null) {
        _selectedBank = BankConstants.vietNamBanks.firstWhere(
          (b) => b.id == account.bankId,
          orElse: () => Bank(id: account.bankId!, name: 'Unknown Bank', code: '', shortName: ''),
        );
      } else {
        _selectedBank = null;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _balanceController.dispose();
    _notesController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountActionsBloc(sl<AccountRepository>()),
      child: BlocListener<AccountActionsBloc, AccountActionsState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            loading: () {},
            loaded: (accounts) {
              if (_submitted) {
                _submitted = false;
                Navigator.of(context).pop();
              }
            },
            error: (message) {},
          );
        },
        child: Builder(builder: (context) => _buildScaffold(context)),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.greyWhite,
      appBar: CustomAppBar(
        title: _isEditMode ? 'Sửa tài khoản' : AppTextConstants.addAccount,
        actions: [
          IconButton(
            onPressed: () => _saveAccount(context),
            icon: const Icon(Icons.check, color: AppColorConstants.black),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                label: AppTextConstants.accountName,
                child: AppTextField(controller: _nameController, hintText: AppTextConstants.accountNameHint, filledColor: AppColorConstants.white),
              ),
              _buildInputField(
                label: AppTextConstants.accountNumber,
                child: AppTextField(controller: _accountNumberController, hintText: AppTextConstants.accountNumberHint, filledColor: AppColorConstants.white),
              ),
              _buildInputField(
                label: 'Số dư',
                child: AppTextField(controller: _balanceController, hintText: 'Nhập số dư tài khoản', filledColor: AppColorConstants.white),
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildInputField(
                label: AppTextConstants.accountType,
                child: GestureDetector(
                  onTap: () {
                    _clearFocus();
                    _showTypePicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: AppUIConstants.defaultSpacing),
                    decoration: BoxDecoration(color: AppColorConstants.white, borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedType, style: AppTextStyle.blackS14Medium),
                        const Icon(Icons.keyboard_arrow_down, color: AppColorConstants.black, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildInputField(
                label: 'Ngân hàng',
                child: GestureDetector(
                  onTap: () {
                    _clearFocus();
                    _showBankPicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: AppUIConstants.defaultSpacing),
                    decoration: BoxDecoration(color: AppColorConstants.white, borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if ((_selectedBank?.logo ?? '').isNotEmpty) ...[Image.network(_selectedBank!.logo, width: 40, height: 40), const SizedBox(width: 8)],
                              Flexible(
                                child: Text(_selectedBank?.name ?? 'Chưa chọn ngân hàng', style: AppTextStyle.blackS14Medium, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: AppColorConstants.black, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              // Pinned status indicator (only show in edit mode)
              if (_isEditMode) ...[
                Container(
                  padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: widget.args!.account!.isPinned ? Colors.orange.withValues(alpha: 0.1) : AppColorConstants.greyWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: widget.args!.account!.isPinned ? Colors.orange : AppColorConstants.grey),
                  ),
                  child: Row(
                    children: [
                      Icon(widget.args!.account!.isPinned ? Icons.push_pin : Icons.push_pin_outlined, color: widget.args!.account!.isPinned ? Colors.orange : AppColorConstants.grey, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.args!.account!.isPinned ? 'Tài khoản đã được ghim' : 'Tài khoản chưa được ghim',
                        style: TextStyle(color: widget.args!.account!.isPinned ? Colors.orange : AppColorConstants.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppUIConstants.defaultSpacing),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            Text(label, style: AppTextStyle.blackS14Medium),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  void _showBankPicker() {
    _clearFocus();
    showModalBottomSheet<Bank>(
      context: context,
      backgroundColor: AppColorConstants.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(),
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chọn ngân hàng', style: AppTextStyle.blackS16Bold),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _banks
                    .map(
                      (b) => ListTile(
                        leading: b.logo.isNotEmpty ? Image.network(b.logo, width: 80, height: 80) : const SizedBox(width: 24, height: 24),
                        title: Text(b.shortName, style: AppTextStyle.blackS14Medium),
                        subtitle: Text(b.code, style: AppTextStyle.grayS12Medium),
                        onTap: () {
                          setState(() {
                            _selectedBank = b;
                            _selectedBankId = b.id;
                          });
                          _clearFocus();
                          Navigator.pop(context);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTypePicker() {
    _clearFocus();
    showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColorConstants.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(),
      builder: (context) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTextConstants.accountType, style: AppTextStyle.blackS16Bold),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _accountTypes
                    .map(
                      (type) => ListTile(
                        title: Text(type, style: AppTextStyle.blackS14Medium),
                        onTap: () {
                          setState(() {
                            _selectedType = type;
                          });
                          _clearFocus();
                          Navigator.pop(context);
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAccount(BuildContext context) {
    if (_nameController.text.trim().isEmpty) {
      return;
    }

    final account = Account(id: _isEditMode ? widget.args!.account!.id : null, name: _nameController.text.trim(), type: _selectedType, amount: int.tryParse(_amountController.text) ?? 0, balance: int.tryParse(_balanceController.text) ?? 0, accountNumber: _accountNumberController.text.trim(), bankId: _selectedBankId);
    _submitted = true;
    if (_isEditMode) {
      context.read<AccountActionsBloc>().add(AccountActionsEvent.updateAccount(account));
    } else {
      context.read<AccountActionsBloc>().add(AccountActionsEvent.createAccount(account));
    }
  }
}
