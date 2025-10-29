import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class DailyTransactionPageArgs {
  final DateTime selectedDate;
  final Map<String, List<Transaction>> groupedTransactions;
  final Map<int, TransactionCategory> categoriesMap;

  const DailyTransactionPageArgs({required this.selectedDate, required this.groupedTransactions, required this.categoriesMap});
}

class DailyTransactionPage extends StatelessWidget {
  final DailyTransactionPageArgs args;

  const DailyTransactionPage({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return DailyTransactionPageChild(args: args);
  }
}

class DailyTransactionPageChild extends StatefulWidget {
  final DailyTransactionPageArgs args;

  const DailyTransactionPageChild({super.key, required this.args});

  @override
  State<DailyTransactionPageChild> createState() => _DailyTransactionPageChildState();
}

class _DailyTransactionPageChildState extends State<DailyTransactionPageChild> {
  @override
  void initState() {
    super.initState();
    final a = widget.args;
    context.read<DailyTransactionBloc>().add(DailyTransactionEvent.loadDailyTransactions(selectedDate: a.selectedDate, groupedTransactions: a.groupedTransactions, categoriesMap: a.categoriesMap));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyTransactionBloc, DailyTransactionState>(
      builder: (context, state) {
        if (state.selectedDate == null) {
          return const SizedBox.shrink();
        }

        return Scaffold(
          appBar: CustomAppBar(title: 'Giao dịch ${AppDateUtils.formatDate(widget.args.selectedDate)}'),
          body: SafeArea(
            child: state.isEmpty
                ? _buildEmptyState(context)
                : TransactionList(
                    groupedTransactions: state.groupedTransactions,
                    categoriesMap: state.categoriesMap,
                    dailyTotalWidgetBuilder: (dateKey) {
                      final dailyTotal = state.dailyTotals[dateKey];
                      if (dailyTotal == null) return const SizedBox();
                      return Text(FormatUtils.formatDailyTransactionTotal(dailyTotal.income, dailyTotal.expense, dailyTotal.transfer), style: AppTextStyle.blackS12);
                    },
                  ),
          ),
          floatingActionButton: AddTransactionButton(initialDate: widget.args.selectedDate),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        spacing: AppUIConstants.defaultSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long, size: AppUIConstants.largeIconSize, color: AppColorConstants.grey),
          Text('Chưa có giao dịch trong ngày này', style: AppTextStyle.greyS12),
        ],
      ),
    );
  }
}
