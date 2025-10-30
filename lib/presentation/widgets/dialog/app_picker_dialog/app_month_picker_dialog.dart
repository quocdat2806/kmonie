import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/navigation/app_navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class MonthPickerDialog extends StatefulWidget {
  final int initialMonth;
  final int initialYear;

  const MonthPickerDialog({super.key, required this.initialMonth, required this.initialYear});

  @override
  State<MonthPickerDialog> createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late int selectedMonth;
  late int selectedYear;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
    selectedYear = widget.initialYear;
  }

  void _changeYear(int delta) {
    setState(() {
      selectedYear += delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppUIConstants.smallPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${AppTextConstants.month} $selectedMonth ${AppTextConstants.year.toLowerCase()} $selectedYear', style: AppTextStyle.blackS18Bold),
              const SizedBox(height: AppUIConstants.smallSpacing),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.smallPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,

                      onTap: () => _changeYear(-1),
                      child: const Icon(Icons.arrow_back_ios, size: AppUIConstants.smallIconSize),
                    ),
                    Text('$selectedYear', style: AppTextStyle.blackS14Medium),
                    InkWell(
                      splashColor: Colors.transparent,

                      onTap: () => _changeYear(1),
                      child: const Icon(Icons.arrow_forward_ios, size: AppUIConstants.smallIconSize),
                    ),
                  ],
                ),
              ),
              AppGrid(
                crossAxisCount: AppUIConstants.defaultGridCrossAxisCount,
                itemCount: 12,
                shrinkWrap: true,
                itemHeightFactor: 1,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == selectedMonth;
                  return InkWell(
                    splashColor: Colors.transparent,
                    onTap: () => setState(() => selectedMonth = month),
                    child: Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColorConstants.primary : Colors.transparent,
                          border: isSelected ? Border.all(color: AppColorConstants.black) : null,
                          borderRadius: BorderRadius.circular(AppUIConstants.extraLargeBorderRadius),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.smallPadding, vertical: AppUIConstants.extraSmallSpacing),
                          child: Text('Thg $month', style: AppTextStyle.blackS14Medium),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                    onPressed: () => AppNavigator(context: context).pop(),
                    text: AppTextConstants.cancel,
                    backgroundColor: Colors.transparent,
                  ),
                  AppButton(
                    onPressed: () => AppNavigator(context: context).pop({'month': selectedMonth, 'year': selectedYear}),
                    text: AppTextConstants.confirm,
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
