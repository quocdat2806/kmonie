import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/config/config.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/repositories/repositories.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'widgets/monthly_expense_summary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(create: (_) => HomeBloc(sl<TransactionRepository>(), sl<TransactionCategoryRepository>()), child: const HomePageChild());
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
    final position = _scrollController.position;
    if (position.maxScrollExtent == 0) return;
    final scrollPercent = position.pixels / position.maxScrollExtent;
    if (scrollPercent >= AppConfigs.scrollThreshold && !position.outOfRange && !context.read<HomeBloc>().state.isLoadingMore) {
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
      color: AppColorConstants.white,
      child: Column(
        children: <Widget>[
          MonthlyExpenseSummary(
            onDateChanged: (DateTime selectedDate) {
              context.read<HomeBloc>().add(HomeEvent.changeDate(selectedDate));
            },
          ),
          Expanded(
            child: BlocSelector<HomeBloc, HomeState, ({Map<String, List<Transaction>> groupedTransactions, Map<int, TransactionCategory> categoriesMap, Map<String, DailyTransactionTotal> dailyTotals})>(
              selector: (state) => (groupedTransactions: state.groupedTransactions, categoriesMap: state.categoriesMap, dailyTotals: state.dailyTotals),
              builder: (context, data) {
                return TransactionList(
                  scrollController: _scrollController,
                  dailyTotalWidgetBuilder: (dateKey) {
                    final daily = data.dailyTotals[dateKey];
                    if (daily == null) return const SizedBox();
                    return Text(FormatUtils.formatDailyTransactionTotal(daily.income, daily.expense, daily.transfer), style: AppTextStyle.blackS12);
                  },
                  emptyWidget: _buildEmptyState(),
                  groupedTransactions: data.groupedTransactions,
                  categoriesMap: data.categoriesMap,
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
        spacing: AppUIConstants.smallSpacing,
        children: [
          Text(AppTextConstants.emptyTransaction, style: AppTextStyle.greyS14),
          Text(AppTextConstants.addTransactionAdvice, style: AppTextStyle.greyS12),
        ],
      ),
    );
  }
}
