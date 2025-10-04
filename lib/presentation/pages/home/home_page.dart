import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constant/export.dart';
import '../../../core/config/export.dart';
import '../../../core/di/export.dart';
import '../../../core/service/export.dart';
import '../../../core/text_style/export.dart';
import '../../../core/util/export.dart';
import '../../bloc/export.dart';
import '../../../entity/export.dart';
import 'widgets/monthly_expense_summary.dart';
import 'widgets/transaction_date_group.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(create: (_) => HomeBloc(sl<TransactionService>(), sl<TransactionCategoryService>()), child: const HomePageChild());
  }
}

class HomePageChild extends StatefulWidget {
  const HomePageChild({super.key});

  @override
  State<HomePageChild> createState() => _HomePageChildState();
}

class _HomePageChildState extends State<HomePageChild> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    PermissionUtils.requestNotificationService();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent == 0) return;
    final position = _scrollController.position;
    final scrollPercent = position.pixels / position.maxScrollExtent;

    if (scrollPercent >= AppConfigs.scrollThreshold && !position.outOfRange) {
      context.read<HomeBloc>().add(const HomeEvent.loadMore());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorConstants.white,
      child: Column(
        children: <Widget>[
          MonthlyExpenseSummary(
            onDateChanged: (DateTime selectedDate) {
              context.read<HomeBloc>().add(HomeEvent.changeDate(selectedDate));
            },
          ),
          Expanded(
            child: BlocSelector<HomeBloc, HomeState, ({Map<String, List<Transaction>> groupedTransactions, Map<int, TransactionCategory> categoriesMap})>(
              selector: (state) => (groupedTransactions: state.groupedTransactions, categoriesMap: state.categoriesMap),
              builder: (context, data) {
                if (data.groupedTransactions.isEmpty) {
                  return _buildEmptyState();
                }
                return CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final dateKey = data.groupedTransactions.keys.elementAt(index);
                        final transactions = data.groupedTransactions[dateKey]!;
                        return TransactionDateGroup(dateKey: dateKey, transactions: transactions, categoriesMap: data.categoriesMap);
                      }, childCount: data.groupedTransactions.length),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(TextConstants.emptyTransaction, style: AppTextStyle.greyS14),
          const SizedBox(height: UIConstants.smallPadding),
          Text(TextConstants.addTransactionAdvice, style: AppTextStyle.greyS12),
        ],
      ),
    );
  }
}
