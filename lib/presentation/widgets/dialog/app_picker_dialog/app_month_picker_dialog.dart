import 'package:flutter/material.dart';

import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../presentation/widgets/export.dart';

class MonthPickerDialog extends StatefulWidget {
  final int initialMonth;
  final int initialYear;

  const MonthPickerDialog({
    super.key,
    required this.initialMonth,
    required this.initialYear,
  });

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
      insetPadding: EdgeInsets.all(UIConstants.smallPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tháng ${selectedMonth} năm ${selectedYear}",
                style: AppTextStyle.blackS18Bold,
              ),
              SizedBox(height: UIConstants.smallSpacing,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/4 -16
                  ,child: Text('$selectedYear', style: AppTextStyle.blackS14Medium)),
                  Container(
                    width: MediaQuery.of(context).size.width/4 -16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: UIConstants.smallSpacing,
                      children: [
                      Icon(
                          Icons.arrow_back_ios,
                          size: UIConstants.smallIconSize,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: UIConstants.smallIconSize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: UIConstants.defaultGridCrossAxisCount,
                  childAspectRatio: 0.8,
                ),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == selectedMonth;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMonth = month),
                    child: Center(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color:isSelected?ColorConstants.primary: Colors.transparent,
                          border: isSelected?Border.all(color: ColorConstants.black):null,
                          borderRadius: BorderRadius.all(Radius.circular(16))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                          child: Text(
                            'Thg $month',
                            style: AppTextStyle.blackS14Medium,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: UIConstants.defaultSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                    onPressed: () => Navigator.pop(context),
                    textColor: ColorConstants.orange,
                    text: TextConstants.cancel,
                    backgroundColor: Colors.transparent,
                  ),
                  AppButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'month': selectedMonth,
                        'year': selectedYear,
                      });
                    },
                    textColor: ColorConstants.orange,
                    text: TextConstants.confirm,
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
