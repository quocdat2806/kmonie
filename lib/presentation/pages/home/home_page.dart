import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/entity/transaction/transaction.dart';
import 'package:kmonie/entity/transaction_category/transaction_category.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/export.dart';
import '../../../core/di/export.dart';
import '../../../core/service/exports.dart';
import '../../bloc/exports.dart';
import 'widgets/monthly_expense_summary.dart';
import 'widgets/transaction_date_group.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) =>
          HomeBloc(sl<TransactionService>(), sl<TransactionCategoryService>())
            ..add(const HomeLoadTransactions()),
      child: const HomePageChild(),
    );
  }
}

class HomePageChild extends StatelessWidget {
  const HomePageChild({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          MonthlyExpenseSummary(
            onDateChanged: (DateTime selectedDate) {
              context.read<HomeBloc>().add(HomeEvent.changeDate(selectedDate));
            },
          ),
          Expanded(
            child:
                BlocSelector<
                  HomeBloc,
                  HomeState,
                  ({
                    Map<String, List<Transaction>> groupedTransactions,
                    Map<int, TransactionCategory> categoriesMap,
                  })
                >(
                  selector: (state) => (
                    groupedTransactions: state.groupedTransactions,
                    categoriesMap: state.categoriesMap,
                  ),
                  builder: (context, data) {
                    if (data.groupedTransactions.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Chưa có giao dịch nào',
                              style: AppTextStyle.greyS14,
                            ),
                            const SizedBox(height: UIConstants.smallPadding),
                            Text(
                              'Hãy thêm giao dịch đầu tiên của bạn',
                              style: AppTextStyle.greyS12,
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<HomeBloc>().add(
                          const HomeRefreshTransactions(),
                        );
                      },
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              final dateKey = data.groupedTransactions.keys
                                  .elementAt(index);
                              final transactions =
                                  data.groupedTransactions[dateKey]!;

                              return TransactionDateGroup(
                                dateKey: dateKey,
                                transactions: transactions,
                                categoriesMap: data.categoriesMap,
                              );
                            }, childCount: data.groupedTransactions.length),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
