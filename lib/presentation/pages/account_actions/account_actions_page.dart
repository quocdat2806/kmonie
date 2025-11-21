import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/args/args.dart';

class AccountActionsPage extends StatelessWidget {
  final AccountActionsPageArgs? args;

  const AccountActionsPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return AccountActionsPageChild(args: args);
  }
}

class AccountActionsPageChild extends StatefulWidget {
  final AccountActionsPageArgs? args;

  const AccountActionsPageChild({super.key, this.args});

  @override
  State<AccountActionsPageChild> createState() => _AccountActionsPageState();
}

class _AccountActionsPageState extends State<AccountActionsPageChild> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

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
      if (account.bankId != null) {
        _selectedBank = BankConstants.vietNamBanks.firstWhere(
          (b) => b.id == account.bankId,
          orElse: () => Bank(
            id: account.bankId!,
            name: 'Unknown Bank',
            code: '',
            shortName: '',
          ),
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
    return BlocListener<AccountActionsBloc, AccountActionsState>(
      listener: (context, state) {
        if (_submitted && state.accounts.isNotEmpty) {
          _submitted = false;
          Navigator.of(context).pop();
        }
      },
      child: _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.greyWhite,
      appBar: CustomAppBar(
        title: _isEditMode
            ? AppTextConstants.editAccount
            : AppTextConstants.addAccount,
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
            spacing: AppUIConstants.defaultSpacing,
            children: [
              _buildInputField(
                label: AppTextConstants.accountName,
                child: AppTextField(
                  controller: _nameController,
                  hintText: AppTextConstants.accountNameHint,
                  filledColor: AppColorConstants.white,
                ),
              ),
              _buildInputField(
                label: AppTextConstants.accountNumber,
                child: AppTextField(
                  controller: _accountNumberController,
                  keyboardType: TextInputType.number,
                  hintText: AppTextConstants.accountNumberHint,
                  filledColor: AppColorConstants.white,
                ),
              ),
              _buildInputField(
                label: 'Số dư',
                child: AppTextField(
                  controller: _balanceController,
                  keyboardType: TextInputType.number,
                  hintText: 'Nhập số dư tài khoản',
                  filledColor: AppColorConstants.white,
                ),
              ),
              // const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildInputField(
                label: AppTextConstants.accountType,
                child: GestureDetector(
                  onTap: () {
                    _clearFocus();
                    _showTypePicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppUIConstants.defaultPadding,
                      vertical: AppUIConstants.defaultSpacing,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorConstants.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_selectedType, style: AppTextStyle.blackS14Medium),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColorConstants.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildInputField(
                label: 'Ngân hàng',
                child: GestureDetector(
                  onTap: () {
                    _clearFocus();
                    _showBankPicker();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppUIConstants.defaultPadding,
                      vertical: AppUIConstants.defaultSpacing,
                    ),
                    decoration: BoxDecoration(
                      color: AppColorConstants.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if ((_selectedBank?.logo ?? '').isNotEmpty) ...[
                                Image.network(
                                  _selectedBank!.logo,
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(width: 8),
                              ],
                              Flexible(
                                child: Text(
                                  _selectedBank?.name ?? 'Chưa chọn ngân hàng',
                                  style: AppTextStyle.blackS14Medium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColorConstants.black,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppUIConstants.smallSpacing,
      children: [
        Text(label, style: AppTextStyle.blackS14Medium),
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppTextConstants.selectBank, style: AppTextStyle.blackS16Bold),
            const SizedBox(height: AppUIConstants.defaultSpacing),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: _banks
                    .map(
                      (b) => ListTile(
                        leading: b.logo.isNotEmpty
                            ? Image.network(b.logo, width: 80, height: 80)
                            : const SizedBox(width: 24, height: 24),
                        title: Text(
                          b.shortName,
                          style: AppTextStyle.blackS14Medium,
                        ),
                        subtitle: Text(
                          b.code,
                          style: AppTextStyle.grayS12Medium,
                        ),
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppTextConstants.accountType,
              style: AppTextStyle.blackS16Bold,
            ),
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

    final account = Account(
      id: _isEditMode ? widget.args!.account!.id : null,
      name: _nameController.text.trim(),
      type: _selectedType,
      amount: int.tryParse(_amountController.text) ?? 0,
      balance: int.tryParse(_balanceController.text) ?? 0,
      accountNumber: _accountNumberController.text.trim(),
      bankId: _selectedBankId,
    );
    _submitted = true;
    if (_isEditMode) {
      context.read<AccountActionsBloc>().add(
        AccountActionsEvent.updateAccount(account),
      );
    } else {
      context.read<AccountActionsBloc>().add(
        AccountActionsEvent.createAccount(account),
      );
    }
  }
}
