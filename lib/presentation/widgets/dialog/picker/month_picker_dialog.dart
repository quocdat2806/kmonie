import 'package:flutter/material.dart';

import '../../../../../generated/assets.dart';
import '../../../../core/cache/export.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header với nút điều hướng năm
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => _changeYear(-1), icon: SvgCacheManager().getSvg(Assets.svgsArrowBack, UIConstants.mediumIconSize, UIConstants.mediumIconSize)),
                  Text('$selectedYear', style: AppTextStyle.blackS18Bold),
                  IconButton(onPressed: () => _changeYear(1), icon: SvgCacheManager().getSvg(Assets.svgsArrowBack, UIConstants.mediumIconSize, UIConstants.mediumIconSize)),
                ],
              ),
              const SizedBox(height: UIConstants.defaultSpacing),

              // Grid tháng
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: UIConstants.smallSpacing, crossAxisSpacing: UIConstants.smallSpacing, childAspectRatio: 2.2),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == selectedMonth;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMonth = month),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? ColorConstants.primary : ColorConstants.greyWhite,
                        borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
                        border: isSelected ? Border.all(color: ColorConstants.black, width: 2) : null,
                      ),
                      child: Text('Thg $month', style: isSelected ? AppTextStyle.whiteS12Medium : AppTextStyle.blackS12Medium),
                    ),
                  );
                },
              ),
              const SizedBox(height: UIConstants.largePadding),

              // Nút hành động
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Hủy', style: AppTextStyle.greyS14Medium),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstants.primary,
                      foregroundColor: ColorConstants.white,
                      padding: const EdgeInsets.symmetric(horizontal: UIConstants.defaultPadding, vertical: UIConstants.smallPadding),
                    ),
                    onPressed: () {
                      Navigator.pop(context, {'month': selectedMonth, 'year': selectedYear});
                    },
                    child: Text('Xác nhận', style: AppTextStyle.whiteS14Medium),
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
