import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/pages/pages.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

import 'widgets/calendar_monthly_transaction_grid.dart';
import 'widgets/weekday_header.dart';

class CalendarMonthlyTransactionPage extends StatelessWidget {
  const CalendarMonthlyTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CalendarMonthlyTransactionPageChild();
  }
}

class CalendarMonthlyTransactionPageChild extends StatefulWidget {
  const CalendarMonthlyTransactionPageChild({super.key});

  @override
  State<CalendarMonthlyTransactionPageChild> createState() => _CalendarMonthlyTransactionPageChildState();
}

class _CalendarMonthlyTransactionPageChildState extends State<CalendarMonthlyTransactionPageChild> {
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
    return Scaffold(
      appBar: CustomAppBar(
        title: AppTextConstants.calendar,
        centerTitle: false,
        actions: [
          BlocSelector<CalendarMonthlyTransactionBloc, CalendarMonthTransactionState, DateTime>(
            selector: (state) => state.selectedDate ?? DateTime.now(),
            builder: (context, selectedDate) {
              return InkWell(
                splashColor: Colors.transparent,
                onTap: () => _showMonthPicker(context, selectedDate),
                child: Row(
                  children: [
                    Text('${AppTextConstants.month} ${selectedDate.month} ${AppTextConstants.year.toLowerCase()} ${selectedDate.year}', style: AppTextStyle.blackS14Medium),
                    const Icon(Icons.keyboard_arrow_down),
                    const SizedBox(width: AppUIConstants.smallSpacing),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const WeekdayHeader(),
            Expanded(
              child: CalendarGrid(
                onDateSelected: (date) {
                  final bloc = context.read<CalendarMonthlyTransactionBloc>()..add(CalendarMonthlyTransactionEvent.changeSelectedDate(date));
                  final dateKey = AppDateUtils.formatDateKey(date);
                  final currentState = bloc.state;
                  final transactions = currentState.groupedTransactions[dateKey] ?? [];
                  AppNavigator(context: context).push(
                    RouterPath.dailyTransactions,
                    extra: DailyTransactionPageArgs(selectedDate: date, groupedTransactions: {dateKey: transactions}, categoriesMap: currentState.categoriesMap),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocSelector<CalendarMonthlyTransactionBloc, CalendarMonthTransactionState, DateTime>(
        selector: (state) => state.selectedDate ?? DateTime.now(),
        builder: (context, selectedDate) {
          return AddTransactionButton(initialDate: selectedDate);
        },
      ),
    );
  }
}
