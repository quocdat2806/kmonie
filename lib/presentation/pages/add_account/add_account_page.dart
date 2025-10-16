import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  String _selectedType = AppTextConstants.accountTypeDefault;
  BankInfo? _selectedBank;

  final List<String> _accountTypes = [AppTextConstants.accountTypeDefault, 'Tiết kiệm', 'Đầu tư', 'Thanh toán'];
  late final List<BankInfo> _banks;

  @override
  void initState() {
    super.initState();
    _banks = BankService.vietNamBanks;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.greyWhite,
      appBar: CustomAppBar(
        title: AppTextConstants.add,
        actions: [
          IconButton(
            onPressed: _saveAccount,
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
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildInputField(
                label: AppTextConstants.accountType,
                child: GestureDetector(
                  onTap: _showTypePicker,
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
                  onTap: _showBankPicker,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding, vertical: AppUIConstants.defaultSpacing),
                    decoration: BoxDecoration(color: AppColorConstants.white, borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              if (_selectedBank?.logo != null && _selectedBank!.logo.isNotEmpty) ...[SvgPicture.network(_selectedBank!.logo, width: 24, height: 24), const SizedBox(width: 8)],
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
    showModalBottomSheet<BankInfo>(
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
                          setState(() => _selectedBank = b);
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

  void _saveAccount() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập tên tài khoản')));
      return;
    }

    // TODO: Save account to database
    // final account = Account(
    //   name: _nameController.text.trim(),
    //   type: _selectedType,
    //   currency: 'VND', // Mặc định là VND
    //   amount: int.tryParse(_amountController.text) ?? 0,
    //   iconPath: _selectedIcon,
    //   notes: _notesController.text.trim(),
    // );

    Navigator.of(context).pop();
  }
}
