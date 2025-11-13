import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/args/args.dart';
import 'widgets/budget_category_card.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BudgetPageChild();
  }
}

class BudgetPageChild extends StatefulWidget {
  const BudgetPageChild({super.key});

  @override
  State<BudgetPageChild> createState() => _BudgetPageChildState();
}

class _BudgetPageChildState extends State<BudgetPageChild> {
  void _showMonthPicker() async {
    final bloc = context.read<BudgetBloc>();
    final sp = bloc.state.period ?? DateTime.now();

    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) {
        return MonthPickerDialog(initialMonth: sp.month, initialYear: sp.year);
      },
    );

    if (result != null && mounted) {
      final newP = DateTime(result['year']!, result['month']!);
      context.read<BudgetBloc>().add(BudgetEvent.changePeriod(period: newP));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppTextConstants.budget,
        actions: [_buildAppBarActions()],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state) {
                  final List<TransactionCategory> listBudget = state
                      .expenseCategories
                      .where((c) => (state.categoryBudgets[c.id!] ?? 0) > 0)
                      .toList();
                  return ListView.builder(
                    itemCount: listBudget.length,
                    itemBuilder: (context, index) {
                      final category = listBudget[index];
                      final budget = state.categoryBudgets[category.id!] ?? 0;
                      final spent = state.categorySpent[category.id!] ?? 0;
                      return _buildCategoryCard(category, budget, spent);
                    },
                  );
                },
              ),
            ),
            BlocBuilder<BudgetBloc, BudgetState>(
              builder: (context, state) {
                return Positioned(
                  bottom: AppUIConstants.defaultPadding,
                  left: AppUIConstants.defaultPadding,
                  right: AppUIConstants.defaultPadding,
                  child: AppButton(
                    text: AppTextConstants.settingBudget,
                    onPressed: () {
                      context.push(
                        RouterPath.addBudget,
                        extra: AddBudgetArgs(
                          monthlyBudget: state.monthlyBudget,
                          categoryBudgets: state.categoryBudgets,
                          expenseCategories: state.expenseCategories,
                        ),
                      );
                    },
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarActions() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: _showMonthPicker,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppUIConstants.defaultPadding,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                final sp = context.select(
                  (BudgetBloc b) => b.state.period ?? DateTime.now(),
                );
                return Text(
                  '${AppTextConstants.month} ${sp.month} ${sp.year}',
                  style: AppTextStyle.blackS14Medium,
                );
              },
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColorConstants.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    TransactionCategory category,
    int budget,
    int spent,
  ) {
    return BudgetCategoryCard(category: category, budget: budget, spent: spent);
  }
}
