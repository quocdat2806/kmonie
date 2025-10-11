import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class AddAccountPage extends StatefulWidget {
  const AddAccountPage({super.key});

  @override
  State<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedType = AppTextConstants.accountTypeDefault;
  String _selectedIcon = 'money';

  final List<String> _accountTypes = [AppTextConstants.accountTypeDefault, 'Tiết kiệm', 'Đầu tư', 'Thanh toán'];

  final List<Map<String, String>> _icons = [
    {'name': 'money', 'icon': '💰'},
    {'name': 'credit_card', 'icon': '💳'},
    {'name': 'cards', 'icon': '💳'},
    {'name': 'dollar', 'icon': '💲'},
    {'name': 'pound', 'icon': '💷'},
    {'name': 'euro', 'icon': '💶'},
    {'name': 'paypal', 'icon': 'P'},
    {'name': 'bitcoin', 'icon': '₿'},
    {'name': 'bag', 'icon': '👜'},
    {'name': 'bank', 'icon': '🏛️'},
    {'name': 'chart', 'icon': '📊'},
    {'name': 'phone', 'icon': '📱'},
    {'name': 'wallet', 'icon': '👛'},
    {'name': 'piggy', 'icon': '🐷'},
    {'name': 'safe', 'icon': '🔒'},
  ];

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
                label: AppTextConstants.amount,
                child: AppTextField(controller: _amountController, hintText: 'Số tiền', keyboardType: TextInputType.number, filledColor: AppColorConstants.white),
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildInputField(
                label: AppTextConstants.icon,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8),
                  itemCount: _icons.length,
                  itemBuilder: (context, index) {
                    final icon = _icons[index];
                    final isSelected = _selectedIcon == icon['name'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedIcon = icon['name']!;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(color: isSelected ? AppColorConstants.primary : AppColorConstants.white, borderRadius: BorderRadius.circular(4)),
                        child: Center(child: Text(icon['icon']!, style: const TextStyle(fontSize: 24))),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppUIConstants.defaultSpacing),
              _buildInputField(
                label: AppTextConstants.notes,
                child: AppTextField(controller: _notesController, maxLines: 3, filledColor: AppColorConstants.white),
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
