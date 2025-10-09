import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/navigation/app_navigation.dart';
import '../../../core/navigation/router_path.dart';
import '../../../core/text_style/export.dart';
import '../../../core/service/export.dart';
import '../../bloc/calendar_monthly_transaction/calendar_monthly_transaction_bloc.dart';
import '../../bloc/calendar_monthly_transaction/calendar_monthly_transaction_event.dart';
import '../../bloc/calendar_monthly_transaction/calendar_monthly_transaction_state.dart';
import '../../widgets/export.dart';

import '../daily_transactions/daily_transaction_page.dart';
import 'widgets/weekday_header.dart';
import 'widgets/calendar_monthly_transaction_grid.dart';
import 'widgets/add_transaction_button.dart';

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
          final selectedDate = state.selectedDate;
          return Scaffold(
            appBar: CustomAppBar(
              title: 'Lịch',
              centerTitle: false,
              actions: [
                GestureDetector(
                  onTap: () => _showMonthPicker(context, selectedDate),
                  child: Row(
                    children: [
                      Text('Tháng ${selectedDate.month} ${selectedDate.year}', style: AppTextStyle.blackS14Medium),
                      const Icon(Icons.keyboard_arrow_down),
                      const SizedBox(width: 8),
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

                          // First update the selected date in the bloc
                          bloc.add(CalendarMonthlyTransactionEvent.changeSelectedDate(date));
                          final dateKey =
                              '${date.day.toString().padLeft(2, '0')}/'
                              '${date.month.toString().padLeft(2, '0')}/'
                              '${date.year.toString()}';

                          final transactions = state.groupedTransactions[dateKey] ?? [];
                          AppNavigator(context: context).push(
                            RouterPath.dailyTransactions,
                            extra: DailyTransactionPageArgs(
                              selectedDate: date,
                              groupedTransactions: {dateKey: transactions},
                              categoriesMap: state.categoriesMap,
                              dailyTotalBuilder: (_) {
                                final total = state.dailyTotals[date.day];
                                if (total == null) return const SizedBox.shrink();
                                return Text('+${total.income.toStringAsFixed(0)} / -${total.expense.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500));
                              },
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            floatingActionButton: const AddTransactionButton(),
          );
        },
      ),
    );
  }
}
