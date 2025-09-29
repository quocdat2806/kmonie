import 'package:flutter/material.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/enum/exports.dart';
import '../../../pages/statistics/statistics_page.dart';

class TransactionFilterButtons extends StatelessWidget {
  final TransactionType? selectedType;
  final ValueChanged<TransactionType?> onTypeChanged;

  const TransactionFilterButtons({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: UIConstants.smallPadding,
        vertical: UIConstants.smallPadding / 2,
      ),
      child: Row(
        children: [
          _buildFilterButton(
            label: 'Tất cả',
            isSelected: selectedType == null,
            onTap: () => onTypeChanged(null),
          ),
          const SizedBox(width: UIConstants.smallPadding),
          _buildFilterButton(
            label: 'Thu nhập',
            isSelected: selectedType == TransactionType.income,
            onTap: () => _navigateToStatistics(context, TransactionType.income),
            color: ColorConstants.secondary,
          ),
          const SizedBox(width: UIConstants.smallPadding),
          _buildFilterButton(
            label: 'Chi tiêu',
            isSelected: selectedType == TransactionType.expense,
            onTap: () =>
                _navigateToStatistics(context, TransactionType.expense),
            color: ColorConstants.primary,
          ),
          const SizedBox(width: UIConstants.smallPadding),
          _buildFilterButton(
            label: 'Chuyển khoản',
            isSelected: selectedType == TransactionType.transfer,
            onTap: () =>
                _navigateToStatistics(context, TransactionType.transfer),
            color: ColorConstants.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? ColorConstants.grey;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: UIConstants.smallPadding,
            horizontal: UIConstants.smallPadding / 2,
          ),
          decoration: BoxDecoration(
            color: isSelected ? buttonColor : Colors.transparent,
            borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius),
            border: Border.all(color: buttonColor, width: 1),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyle.blackS12.copyWith(
                color: isSelected ? Colors.white : buttonColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToStatistics(BuildContext context, TransactionType type) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => StatisticsPage(transactionType: type),
      ),
    );
  }
}
