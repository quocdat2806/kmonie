import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/tools/tools.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/generated/generated.dart';

class BudgetCategoryCard extends StatelessWidget {
  const BudgetCategoryCard({super.key, required this.category, required this.budget, required this.spent});

  final TransactionCategory category;
  final int budget;
  final int spent;

  @override
  Widget build(BuildContext context) {
    final int remaining = budget - spent;
    final double progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppUIConstants.smallSpacing),
      padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: GradientHelper.fromColorHexList(category.gradientColors)),
                    child: Padding(
                      padding: const EdgeInsets.all(AppUIConstants.smallPadding),
                      child: SvgUtils.icon(assetPath: category.pathAsset.isNotEmpty ? category.pathAsset : Assets.svgsNote, size: SvgSizeType.medium),
                    ),
                  ),
                  const SizedBox(width: AppUIConstants.smallSpacing),
                  Text(category.title, style: AppTextStyle.blackS16Bold),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppUIConstants.defaultSpacing),
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: 0,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(value: progress, strokeWidth: 8, backgroundColor: AppColorConstants.primary, valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? AppColorConstants.red : AppColorConstants.greyWhite), strokeCap: StrokeCap.round),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(remaining >= 0 ? 'Còn lại' : 'Vượt quá', style: TextStyle(fontSize: 10, color: remaining >= 0 ? AppColorConstants.black : AppColorConstants.red)),
                          Text(
                            remaining >= 0 ? '${(100 - progress * 100).toStringAsFixed(1)}%' : '${(progress * 100).toStringAsFixed(1)}%',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: remaining >= 0 ? AppColorConstants.black : AppColorConstants.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppUIConstants.defaultSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBudgetInfoItem('Còn lại :', _formatAmount(remaining.abs()), isOverBudget: remaining < 0, isNegative: remaining < 0),
                    const SizedBox(height: 6),
                    _buildBudgetInfoItem('Ngân sách :', _formatAmount(budget)),
                    const SizedBox(height: 6),
                    _buildBudgetInfoItem('Chi tiêu :', _formatAmount(spent), isOverBudget: remaining < 0),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInfoItem(String label, String value, {bool isOverBudget = false, bool isNegative = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyle.blackS12Medium),
        Text(isNegative ? '-$value' : value, style: AppTextStyle.blackS12.copyWith(color: isOverBudget ? AppColorConstants.red : AppColorConstants.black)),
      ],
    );
  }

  String _formatAmount(int amount) {
    if (amount == 0) return '0';
    return amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }
}
