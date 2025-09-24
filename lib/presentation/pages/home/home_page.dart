import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/exports.dart';
import '../../widgets/exports.dart';
import '../../../generated/assets.dart';
import 'widgets/monthly_expense_summary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: <Widget>[
           MonthlyExpenseSummary(
            onCalendarTap: (){},
            onSearchTap: (){},
          ),
          Expanded(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList.list(
                  children: <Widget>[
                    _buildTransactionDate(
                      dateLabel: '15 thg 9',
                      weekday: 'Thứ hai',
                      totalLabel: 'Thu nhập: 11.300.000',
                    ),
                    _buildTransactionDateDetail(
                      icon: Assets.svgsChecklist,
                      title: 'học bổng',
                      amount: '200.000',
                    ),
                    _buildTransactionDateDetail(
                      icon: Assets.svgsChecklist,
                      title: 'hs giỏi',
                      amount: '100.000',
                    ),
                    _buildTransactionDateDetail(
                      icon: Assets.svgsNote,
                      title: 'Lương',
                      amount: '11.000.000',
                      accent: ColorConstants.secondary,
                    ),
                    _buildTransactionDate(
                      dateLabel: '13 thg 9',
                      weekday: 'Thứ bảy',
                      totalLabel: 'Thu nhập: 240.000',
                    ),
                    _buildTransactionDateDetail(
                      icon: Assets.svgsChecklist,
                      title: 'Giải thưởng',
                      amount: '240.000',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionDate({
    required String dateLabel,
    required String weekday,
    required String totalLabel,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: UIConstants.smallSpacing,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Text(dateLabel, style: AppTextStyle.blackS12),
                const SizedBox(width: UIConstants.smallSpacing),
                Text(weekday, style: AppTextStyle.blackS12),
                const Spacer(),
                Text(totalLabel, style: AppTextStyle.blackS12),
              ],
            ),
          ),
        ),
        const AppDivider(),
      ],
    );
  }

  Widget _buildTransactionDateDetail({
    required String icon,
    required String title,
    required String amount,
    Color? accent,
  }) {
    final Color iconColor = accent ?? ColorConstants.black;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: ColorConstants.grey,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    icon,
                    width: UIConstants.mediumIconSize,
                    height: UIConstants.mediumIconSize,
                    colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(width: UIConstants.defaultSpacing),
              Expanded(child: Text(title, style: AppTextStyle.blackS14)),
              Text(amount, style: AppTextStyle.blackS14),
            ],
          ),
        ),
        const Divider(height: 1, color: ColorConstants.divider),
      ],
    );
  }
}
