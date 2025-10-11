import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/services/transaction_category.dart';
import 'package:kmonie/core/services/budget.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/bloc/add_budget/add_budget_bloc.dart';
import 'package:kmonie/presentation/bloc/add_budget/add_budget_event.dart';
import 'package:kmonie/presentation/bloc/add_budget/add_budget_state.dart';
import 'package:kmonie/entity/entity.dart';
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
  int _currentInput = 0;

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
                  // Ngân sách hàng tháng
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppUIConstants.smallSpacing),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
          child: Container(
            padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
              boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                // Remove button (gray minus circle for categories, hidden for monthly budget)
                if (!isMonthlyBudget) ...[
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: hasAmount ? Colors.red : Colors.grey, shape: BoxShape.circle),
                    child: const Icon(Icons.remove, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: AppUIConstants.smallSpacing),
                ],
                // Category icon with gradient (only for categories)
                if (!isMonthlyBudget) ...[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: category.gradientColors.isNotEmpty ? GradientHelper.fromColorHexList(category.gradientColors) : null, color: category.gradientColors.isEmpty ? AppColorConstants.primary : null),
                    child: Padding(
                      padding: const EdgeInsets.all(AppUIConstants.smallPadding),
                      child: SvgUtils.icon(assetPath: category.pathAsset.isNotEmpty ? category.pathAsset : Assets.svgsNote, size: SvgSizeType.medium),
                    ),
                  ),
                  const SizedBox(width: AppUIConstants.smallSpacing),
                ],
                // Category title
                Expanded(child: Text(title, style: AppTextStyle.blackS16Bold)),
                // Amount or Arrow
                if (hasAmount) Text(currentAmount, style: AppTextStyle.blackS14Medium) else const Icon(Icons.arrow_forward_ios, color: AppColorConstants.grey, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBudgetBottomSheet(String itemTitle) async {
    _currentInput = 0;

    await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppUIConstants.defaultBorderRadius)),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: AppUIConstants.defaultPadding, right: AppUIConstants.defaultPadding, top: AppUIConstants.defaultPadding, bottom: MediaQuery.of(context).viewInsets.bottom + AppUIConstants.defaultPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nhập ngân sách cho $itemTitle', style: AppTextStyle.blackS16Bold),
                const SizedBox(height: AppUIConstants.smallSpacing),
                StatefulBuilder(
                  builder: (context, setSheet) => Column(
                    children: [
                      Text(_formatAmount(_currentInput), style: AppTextStyle.blackS20),
                      const SizedBox(height: AppUIConstants.smallSpacing),
                      AppKeyboard(
                        onValueChanged: (v) {
                          if (v == 'DONE') {
                            Navigator.of(context).pop(_currentInput);
                            return;
                          }
                          if (v == 'CLEAR') {
                            setState(() => _currentInput = _currentInput ~/ 10);
                            setSheet(() {});
                            return;
                          }
                          if (RegExp(r'^\d+?$').hasMatch(v)) {
                            final digit = int.tryParse(v) ?? 0;
                            setState(() => _currentInput = _currentInput * 10 + digit);
                            setSheet(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value is int && value > 0 && mounted) {
        // Handle budget setting logic here
        context.read<AddBudgetBloc>().add(AddBudgetEvent.setBudget(itemTitle: itemTitle, amount: value));
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
