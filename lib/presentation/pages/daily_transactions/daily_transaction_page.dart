import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/args/args.dart';


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
  State<DailyTransactionPageChild> createState() =>
      _DailyTransactionPageChildState();
}

class _DailyTransactionPageChildState extends State<DailyTransactionPageChild> {
  @override
  void initState() {
    super.initState();
    final a = widget.args;
    context.read<DailyTransactionBloc>().add(
      DailyTransactionEvent.loadDailyTransactions(
        selectedDate: a.selectedDate,
        groupedTransactions: a.groupedTransactions,
        categoriesMap: a.categoriesMap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Giao dịch ${AppDateUtils.formatDate(widget.args.selectedDate)}',
      ),
      body: SafeArea(
        child: BlocBuilder<DailyTransactionBloc, DailyTransactionState>(
          builder: (context, state) {
            if (state.isEmpty) {
              return _buildEmptyState();
            }
            return TransactionList(
              groupedTransactions: state.groupedTransactions,
              categoriesMap: state.categoriesMap,
              dailyTotalWidgetBuilder: (dateKey) {
                final dailyTotal = state.dailyTotals[dateKey];
                if (dailyTotal == null) return const SizedBox();
                return Text(
                  FormatUtils.formatDailyTransactionTotal(
                    dailyTotal.income,
                    dailyTotal.expense,
                  ),
                  style: AppTextStyle.blackS12,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: AddTransactionButton(
        initialDate: widget.args.selectedDate,
      ),
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Column(
        spacing: AppUIConstants.smallSpacing,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.receipt_long,
            size: AppUIConstants.extraLargeIconSize,
            color: AppColorConstants.grey,
          ),
          Text(
            AppTextConstants.emptyTransactionCurrentDay,
            style: AppTextStyle.greyS14,
          ),
        ],
      ),
    );
  }
}
