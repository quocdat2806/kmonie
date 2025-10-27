import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class AddBudgetPage extends StatelessWidget {
  const AddBudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBudgetBloc>(create: (_) => AddBudgetBloc(sl<TransactionCategoryService>(), sl<BudgetService>())..add(const AddBudgetEvent.init()), child: const _AddBudgetPageChild());
  }
}

class _AddBudgetPageChild extends StatefulWidget {
  const _AddBudgetPageChild();

  @override
  State<_AddBudgetPageChild> createState() => _AddBudgetPageChildState();
}

class _AddBudgetPageChildState extends State<_AddBudgetPageChild> {
  // ignore: unused_field
  bool _hasChanges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Cài đặt ngân sách'),
      body: SafeArea(
        child: BlocBuilder<AddBudgetBloc, AddBudgetState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
              child: Column(
                children: [
                  _buildMonthlyBudgetItem(state),
                  const SizedBox(height: AppUIConstants.defaultSpacing),
                  // Danh sách categories
                  ...state.expenseCategories.map((TransactionCategory category) => _buildCategoryItem(category, state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthlyBudgetItem(AddBudgetState state) {
    final monthlyAmount = state.budgets['Ngân sách hàng tháng'];
    final currentAmount = monthlyAmount != null && monthlyAmount > 0 ? _formatAmount(monthlyAmount) : '';

    return _buildBudgetItem(title: 'Ngân sách hàng tháng', currentAmount: currentAmount, onTap: () => _showBudgetBottomSheet('Ngân sách hàng tháng'));
  }

  Widget _buildCategoryItem(TransactionCategory category, AddBudgetState state) {
    return _buildBudgetItem(title: category.title, category: category, currentAmount: _getCategoryCurrentAmount(category.title, state), onTap: () => _showBudgetBottomSheet(category.title));
  }

  Widget _buildBudgetItem({required String title, TransactionCategory? category, required String currentAmount, required VoidCallback onTap}) {
    final bool isMonthlyBudget = category == null;
    final bool hasAmount = currentAmount.isNotEmpty && currentAmount != 'Sửa';

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppUIConstants.smallPadding),
        child: Row(
          children: [
            if (!isMonthlyBudget) ...[
              Container(
                width: AppUIConstants.smallContainerSize,
                height: AppUIConstants.smallContainerSize,
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: category.gradientColors.isNotEmpty ? GradientHelper.fromColorHexList(category.gradientColors) : null, color: category.gradientColors.isEmpty ? AppColorConstants.primary : null),
                child: Padding(
                  padding: const EdgeInsets.all(AppUIConstants.smallPadding),
                  child: SvgUtils.icon(assetPath: category.pathAsset.isNotEmpty ? category.pathAsset : Assets.svgsNote, size: SvgSizeType.medium),
                ),
              ),
              const SizedBox(width: AppUIConstants.smallSpacing),
            ],
            Expanded(child: Text(title, style: AppTextStyle.blackS14Medium)),
            if (hasAmount) Text(currentAmount, style: AppTextStyle.blackS14Medium) else const Icon(Icons.arrow_forward_ios, color: AppColorConstants.grey, size: AppUIConstants.smallIconSize),
          ],
        ),
      ),
    );
  }

  void _showBudgetBottomSheet(String itemTitle) async {
    context.read<AddBudgetBloc>().add(const AddBudgetEvent.resetInput());

    await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocProvider.value(
          value: context.read<AddBudgetBloc>(),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppUIConstants.defaultBorderRadius)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: AppUIConstants.defaultPadding, right: AppUIConstants.defaultPadding, top: AppUIConstants.defaultPadding, bottom: MediaQuery.of(modalContext).viewInsets.bottom + AppUIConstants.defaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nhập ngân sách cho $itemTitle', style: AppTextStyle.blackS16Bold),
                  const SizedBox(height: AppUIConstants.smallSpacing),
                  StatefulBuilder(
                    builder: (context, setSheet) => Column(
                      children: [
                        Builder(
                          builder: (context) {
                            final input = context.select((AddBudgetBloc b) => b.state.currentInput);
                            return Text(_formatAmount(input), style: AppTextStyle.blackS20);
                          },
                        ),
                        const SizedBox(height: AppUIConstants.smallSpacing),
                        AppKeyboard(
                          onValueChanged: (v) {
                            if (v == 'DONE') {
                              final val = context.read<AddBudgetBloc>().state.currentInput;
                              Navigator.of(context).pop(val);
                              return;
                            }
                            context.read<AddBudgetBloc>().add(AddBudgetEvent.inputKey(key: v));
                            setSheet(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      if (value is int && value > 0 && mounted) {
        // Handle budget setting logic here
        context.read<AddBudgetBloc>().add(AddBudgetEvent.setBudget(itemTitle: itemTitle, amount: value));
        setState(() => _hasChanges = true);
      }
    });
  }

  String _formatAmount(int amount) {
    if (amount == 0) return '0';
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  String _getCategoryCurrentAmount(String title, AddBudgetState state) {
    // Lấy amount từ state.budgets map
    final amount = state.budgets[title];
    if (amount != null && amount > 0) {
      return _formatAmount(amount);
    }
    return ''; // Empty để hiển thị arrow
  }
}
