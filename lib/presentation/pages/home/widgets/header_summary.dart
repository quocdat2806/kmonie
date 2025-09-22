import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/text_style/exports.dart';
import '../../../../core/constant//exports.dart';
import '../../../../core/navigation///exports.dart';
import '../../../../generated/assets.dart';
import '../../../widgets/exports.dart';

class HeaderSummary extends StatelessWidget {
  const HeaderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorConstants.yellow,
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
                    InkWell(
                      onTap: () {
                        AppNavigator(
                          context: context,
                        ).push(RouterPath.searchTransaction);
                      },
                      child: SvgPicture.asset(Assets.svgsSearch),
                    ),
                    const SizedBox(width: UIConstants.defaultSpacing),
                    InkWell(
                      onTap: () {
                        AppNavigator(
                          context: context,
                        ).push(RouterPath.monthCalendar);
                      },
                      child: SvgPicture.asset(Assets.svgsCalendar),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: UIConstants.defaultSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => const MonthPickerDialog(
                          initialMonth: 9,
                          initialYear: 2025,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('2025', style: AppTextStyle.blackS14),
                        Row(
                          children: <Widget>[
                            Text('Thg 9', style: AppTextStyle.blackS14Medium),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: ColorConstants.black,
                            ),
                          ],
                        ),
                      ],
                    ),
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
}
