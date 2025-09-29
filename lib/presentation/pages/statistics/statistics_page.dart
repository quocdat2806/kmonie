import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/export.dart';
import '../../../core/di/export.dart';
import '../../../core/service/exports.dart';
import '../../../core/enum/exports.dart';
import '../../bloc/exports.dart';
import 'widgets/statistics_header.dart';
import 'widgets/statistics_chart.dart';
import 'widgets/statistics_list.dart';

class StatisticsPage extends StatelessWidget {
  final TransactionType transactionType;

  const StatisticsPage({super.key, required this.transactionType});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticsBloc>(
      create: (_) => StatisticsBloc(
        sl<TransactionService>(),
        sl<TransactionCategoryService>(),
      )..add(StatisticsLoadData(transactionType)),
      child: StatisticsPageChild(transactionType: transactionType),
    );
  }
}

class StatisticsPageChild extends StatelessWidget {
  final TransactionType transactionType;

  const StatisticsPageChild({super.key, required this.transactionType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorConstants.primary,
        foregroundColor: Colors.white,
        title: Text(_getTitle(), style: AppTextStyle.whiteS18Bold),
        elevation: 0,
      ),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.message != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message!,
                    style: AppTextStyle.greyS14,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: UIConstants.smallPadding),
                  ElevatedButton(
                    onPressed: () {
                      context.read<StatisticsBloc>().add(
                        StatisticsLoadData(transactionType),
                      );
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Header với tổng số tiền
              SliverToBoxAdapter(
                child: StatisticsHeader(
                  transactionType: transactionType,
                  totalAmount: state.totalAmount,
                  transactionCount: state.transactionCount,
                ),
              ),

              // Chart thống kê
              SliverToBoxAdapter(
                child: StatisticsChart(
                  groupedTransactions: state.groupedTransactions,
                  categoriesMap: state.categoriesMap,
                  transactionType: transactionType,
                ),
              ),

              // Danh sách giao dịch
              SliverToBoxAdapter(
                child: StatisticsList(
                  groupedTransactions: state.groupedTransactions,
                  categoriesMap: state.categoriesMap,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getTitle() {
    switch (transactionType) {
      case TransactionType.income:
        return 'Thống kê Thu nhập';
      case TransactionType.expense:
        return 'Thống kê Chi tiêu';
      case TransactionType.transfer:
        return 'Thống kê Chuyển khoản';
    }
  }
}
