import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/export.dart';
import '../../../core/navigation/export.dart';
import '../../../core/text_style/export.dart';
import '../../../core/service/export.dart';
import '../../../core/constant/export.dart';
import '../../../core/util/export.dart';
import '../../bloc/export.dart';
import '../../widgets/export.dart';
import '../../pages/export.dart';

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
                      const SizedBox(width: UIConstants.smallSpacing),
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
