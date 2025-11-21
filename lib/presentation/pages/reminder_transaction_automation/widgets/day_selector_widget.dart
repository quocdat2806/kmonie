import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';

class DaySelectorWidget extends StatelessWidget {
  final Set<int> selectedDays;
  final ValueChanged<int> onDayToggled;

  const DaySelectorWidget({
    super.key,
    required this.selectedDays,
    required this.onDayToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDayButton(2, '2'),
        _buildDayButton(3, '3'),
        _buildDayButton(4, '4'),
        _buildDayButton(5, '5'),
        _buildDayButton(6, '6'),
        _buildDayButton(7, '7'),
        _buildDayButton(0, 'CN'),
      ],
    );
  }

  Widget _buildDayButton(int day, String label) {
    final isSelected = selectedDays.contains(day);
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => onDayToggled(day),
      borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
      child: Container(
        width: AppUIConstants.defaultContainerSize,
        height: AppUIConstants.defaultContainerSize,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColorConstants.primary : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(
            AppUIConstants.extraLargeBorderRadius,
          ),
        ),
        child: Center(child: Text(label, style: AppTextStyle.blackS16Medium)),
      ),
    );
  }
}
