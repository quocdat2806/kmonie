import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/widgets/app_divider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList.list(
                children: <Widget>[
                  _buildDaySectionHeader(
                    dateLabel: '15 thg 9',
                    weekday: 'Thứ hai',
                    totalLabel: 'Thu nhập: 11.300.000',
                  ),
                  _buildTransactionTile(
                    icon: Assets.svgsChecklist,
                    title: 'học bổng',
                    amount: '200.000',
                  ),
                  _buildTransactionTile(
                    icon: Assets.svgsChecklist,
                    title: 'hs giỏi',
                    amount: '100.000',
                  ),
                  _buildTransactionTile(
                    icon: Assets.svgsNote,
                    title: 'Lương',
                    amount: '11.000.000',
                    accent: AppColors.secondary,
                  ),
                  _buildDaySectionHeader(
                    dateLabel: '13 thg 9',
                    weekday: 'Thứ bảy',
                    totalLabel: 'Thu nhập: 240.000',
                  ),
                  _buildTransactionTile(
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
    );
  }

  Widget _buildHeader() {
    return ColoredBox(
      color: AppColors.yellow,
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SvgPicture.asset(Assets.svgsMenu),
                Text('Sổ Thu Chi', style: AppTextStyle.blackS18Bold),
                Row(
                  children: <Widget>[
                    SvgPicture.asset(Assets.svgsSearch),
                    const SizedBox(width: UIConstants.defaultSpacing),
                    SvgPicture.asset(Assets.svgsCalendar),
                  ],
                ),
              ],
            ),
            const SizedBox(height: UIConstants.defaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('2025', style: AppTextStyle.blackS14),
                      Row(
                        children: <Widget>[
                          Text('Thg 9', style: AppTextStyle.blackS14Medium),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.black,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildSummaryItem('Chi tiêu', '0')),
                Expanded(child: _buildSummaryItem('Thu nhập', '11.340.000')),
                Expanded(child: _buildSummaryItem('Số dư', '11.340.000')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: <Widget>[
        Text(label, style: AppTextStyle.blackS14),
        Text(
          value,
          style: AppTextStyle.blackS14Medium.copyWith(
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildDaySectionHeader({
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

  Widget _buildTransactionTile({
    required String icon,
    required String title,
    required String amount,
    Color? accent,
  }) {
    final Color iconColor = accent ?? AppColors.black;

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.red,
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
        const Divider(height: 1, color: AppColors.divider),
      ],
    );
  }
}
