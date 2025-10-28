import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/services/budget.dart';
import 'package:kmonie/core/services/transaction_category.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/budget/budget_bloc.dart';
import 'package:kmonie/presentation/blocs/budget/budget_event.dart';
import 'package:kmonie/presentation/blocs/budget/budget_state.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/navigation/router_path.dart';
import 'package:go_router/go_router.dart';

import '../../../entities/transaction_category/transaction_category.dart';
import 'widgets/budget_category_card.dart';

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
    final bloc = context.read<BudgetBloc>();
    final sp = bloc.state.selectedPeriod ?? DateTime.now();

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
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
        child: Stack(
          children: [
            Positioned.fill(
              child: BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
                    child: Column(children: [...state.expenseCategories.where((TransactionCategory c) => (state.categoryBudgets[c.id!] ?? 0) > 0).map((TransactionCategory c) => _buildCategoryCard(c, state))]),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 20,
              left: AppUIConstants.defaultPadding,
              right: AppUIConstants.defaultPadding,
              child: AppButton(
                text: '+ Cài đặt ngân sách',
                onPressed: () {
                  context.push(RouterPath.addBudget);
                },
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(TransactionCategory category, BudgetState state) {
    final budget = state.categoryBudgets[category.id!] ?? 0;
    final spent = state.categorySpent[category.id!] ?? 0;
    return BudgetCategoryCard(category: category, budget: budget, spent: spent, onEdit: () => _showBudgetDialog(category));
  }

  void _showBudgetDialog(TransactionCategory category) async {
    final bloc = context.read<BudgetBloc>()..add(const BudgetEvent.resetInput());

    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: bloc,
          child: Padding(
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
          ),
        );
      },
    );

    if (result is int && mounted) {
      final s = context.read<BudgetBloc>().state;
      final p = s.selectedPeriod ?? DateTime.now();
      context.read<BudgetBloc>().add(BudgetEvent.setBudget(period: DateTime(p.year, p.month), categoryId: category.id!, amount: result));
    }
  }
}
