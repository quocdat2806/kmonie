import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/services/services.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/bloc/calendar_monthly_transaction/calendar_monthly_transaction_bloc.dart';
import 'package:kmonie/presentation/bloc/calendar_monthly_transaction/calendar_monthly_transaction_event.dart';
import 'package:kmonie/presentation/bloc/calendar_monthly_transaction/calendar_monthly_transaction_state.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/presentation/pages/pages.dart';

import 'widgets/weekday_header.dart';
import 'widgets/calendar_monthly_transaction_grid.dart';

class CalendarMonthlyTransaction extends StatefulWidget {
  const CalendarMonthlyTransaction({super.key});

  @override
  State<CalendarMonthlyTransaction> createState() => _CalendarMonthlyTransactionState();
}

class _CalendarMonthlyTransactionState extends State<CalendarMonthlyTransaction> {
  void _showMonthPicker(BuildContext context, DateTime currentDate) async {
    final bloc = context.read<CalendarMonthlyTransactionBloc>();
    final result = await showDialog<Map<String, int>>(
      context: context,
      builder: (context) => MonthPickerDialog(initialMonth: currentDate.month, initialYear: currentDate.year),
    );

    if (result != null && mounted) {
      bloc.add(CalendarMonthlyTransactionEvent.changeMonthYear(year: result['year']!, month: result['month']!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarMonthlyTransactionBloc(sl<TransactionService>(), sl<TransactionCategoryService>()),
      child: BlocBuilder<CalendarMonthlyTransactionBloc, CalendarMonthTransactionState>(
        builder: (context, state) {
          final selectedDate = state.selectedDate ?? DateTime.now();
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Lịch',
              centerTitle: false,
              actions: [
                InkWell(
                  onTap: () => _showMonthPicker(context, selectedDate),
                  child: Row(
                    children: [
                      Text('Tháng ${selectedDate.month} ${selectedDate.year}', style: AppTextStyle.blackS14Medium),
                      const Icon(Icons.keyboard_arrow_down),
                      const SizedBox(width: AppUIConstants.smallSpacing),
                    ],
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const WeekdayHeader(),
                  if (state.isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator()))
                  else
                    Expanded(
                      child: CalendarGrid(
                        selectedDate: selectedDate,
                        dailyTotals: state.dailyTotals,
                        onDateSelected: (date) {
                          final bloc = context.read<CalendarMonthlyTransactionBloc>();
                          final state = bloc.state;
                          bloc.add(CalendarMonthlyTransactionEvent.changeSelectedDate(date));
                          final dateKey = AppDateUtils.formatDateKey(date);
                          final transactions = state.groupedTransactions[dateKey] ?? [];
                          AppNavigator(context: context).push(
                            RouterPath.dailyTransactions,
                            extra: DailyTransactionPageArgs(selectedDate: date, groupedTransactions: {dateKey: transactions}, categoriesMap: state.categoriesMap),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            floatingActionButton: AddTransactionButton(initialDate: selectedDate),
          );
        },
      ),
    );
  }
}
