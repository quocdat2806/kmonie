import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/services/budget.dart';
import 'package:kmonie/core/services/transaction_category.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/bloc/budget/budget_bloc.dart';
import 'package:kmonie/presentation/bloc/budget/budget_event.dart';
import 'package:kmonie/presentation/bloc/budget/budget_state.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/navigation/router_path.dart';
import 'package:go_router/go_router.dart';
// import 'package:kmonie/core/tools/tools.dart';

import '../../../entities/transaction_category/transaction_category.dart';
import 'widgets/budget_category_card.dart';
import 'widgets/budget_monthly_card.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    return BlocProvider<BudgetBloc>(
      create: (_) => BudgetBloc(sl<TransactionCategoryService>(), sl<BudgetService>())..add(BudgetEvent.init(period: now)),
      child: const _BudgetPageChild(),
    );
  }
}

class _BudgetPageChild extends StatefulWidget {
  const _BudgetPageChild();

  @override
  State<_BudgetPageChild> createState() => _BudgetPageChildState();
}

class _BudgetPageChildState extends State<_BudgetPageChild> {
  @override
  void initState() {
    super.initState();
    final now = DateTime(DateTime.now().year, DateTime.now().month);
    context.read<BudgetBloc>().add(BudgetEvent.setSelectedPeriod(period: now));
  }

  void _showMonthPicker() async {
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
        final s = context.read<BudgetBloc>().state;
        final sp = s.selectedPeriod ?? DateTime.now();
        return MonthPickerDialog(initialMonth: sp.month, initialYear: sp.year);
      },
    );

    if (result != null && mounted) {
      final newP = DateTime(result['year']!, result['month']!);
      context.read<BudgetBloc>().add(BudgetEvent.setSelectedPeriod(period: newP));
      context.read<BudgetBloc>().add(BudgetEvent.changePeriod(period: newP));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Ngân sách',
        actions: [
          GestureDetector(
            onTap: _showMonthPicker,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.defaultPadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Builder(
                    builder: (context) {
                      final sp = context.select((BudgetBloc b) => b.state.selectedPeriod ?? DateTime.now());
                      return Text('thg ${sp.month} ${sp.year}', style: AppTextStyle.blackS14Medium);
                    },
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: AppColorConstants.black, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<BudgetBloc, BudgetState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                    child: Column(children: [...state.expenseCategories.where((TransactionCategory c) => (state.categoryBudgets[c.id!] ?? 0) > 0).map((TransactionCategory c) => _buildCategoryCard(c, state))]),
                  ),
                ),
                // Bottom button
                Padding(
                  padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                  child: AppButton(
                    text: '+ Cài đặt ngân sách',
                    onPressed: () {
                      context.push(RouterPath.addBudget);
                    },
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget extracted to widgets/budget_monthly_card.dart
  // ignore: unused_element
  Widget _buildMonthlyBudgetCard(BudgetState state) {
    return BudgetMonthlyCard(monthlyBudget: state.monthlyBudget, totalSpent: state.totalSpent);
  }

  Widget _buildCategoryCard(TransactionCategory category, BudgetState state) {
    final budget = state.categoryBudgets[category.id!] ?? 0;
    final spent = state.categorySpent[category.id!] ?? 0;
    return BudgetCategoryCard(category: category, budget: budget, spent: spent, onEdit: () => _showBudgetDialog(category));
  }

  // kept for small inline rows
  // ignore: unused_element
  Widget _buildBudgetInfoItem(String label, String value, {bool isOverBudget = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.blackS12Medium),
        Text(value, style: AppTextStyle.blackS12.copyWith(color: isOverBudget ? AppColorConstants.red : AppColorConstants.black)),
      ],
    );
  }

  void _showBudgetDialog(TransactionCategory category) async {
    await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        context.read<BudgetBloc>().add(const BudgetEvent.resetInput());
        return Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nhập ngân sách cho ${category.title}', style: AppTextStyle.blackS16Bold),
              const SizedBox(height: AppUIConstants.smallSpacing),
              StatefulBuilder(
                builder: (context, setSheet) => Column(
                  children: [
                    Builder(
                      builder: (context) {
                        final input = context.select((BudgetBloc b) => b.state.currentInput);
                        return Text('$input', style: AppTextStyle.blackS20);
                      },
                    ),
                    const SizedBox(height: AppUIConstants.smallSpacing),
                    AppKeyboard(
                      onValueChanged: (v) {
                        if (v == 'DONE') {
                          final val = context.read<BudgetBloc>().state.currentInput;
                          Navigator.of(context).pop(val);
                          return;
                        }
                        context.read<BudgetBloc>().add(BudgetEvent.inputKey(key: v));
                        setSheet(() {});
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value is int && mounted) {
        final s = context.read<BudgetBloc>().state;
        final p = s.period ?? DateTime.now();
        context.read<BudgetBloc>().add(BudgetEvent.setBudget(period: DateTime(p.year, p.month), categoryId: category.id!, amount: value));
      }
    });
  }

  // small formatter used in this file
  // ignore: unused_element
  String _formatAmount(int amount) {
    if (amount == 0) return '0';
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  // ignore: unused_element
  Widget _buildEmptyBudgetMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding * 2),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.account_balance_wallet_outlined, size: 48, color: Colors.grey.withValues(alpha: 0.6)),
          const SizedBox(height: AppUIConstants.defaultSpacing),
          Text(
            'Chưa có ngân sách nào được thiết lập',
            style: AppTextStyle.blackS16Bold.copyWith(color: Colors.grey.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppUIConstants.smallSpacing),
          Text(
            'Nhấn nút "Cài đặt ngân sách" bên dưới để bắt đầu',
            style: AppTextStyle.blackS14.copyWith(color: Colors.grey.withValues(alpha: 0.6)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
