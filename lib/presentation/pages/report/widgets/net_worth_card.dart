import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/generated/generated.dart';

class NetWorthCard extends StatelessWidget {
  const NetWorthCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBloc, ReportState>(
      buildWhen: (previous, current) => previous.accounts != current.accounts,
      builder: (context, state) {
        final totalAccountBalance = state.totalAccountBalance;
        return Container(
          padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
          decoration: BoxDecoration(
            color: AppColorConstants.primary,
            borderRadius: BorderRadius.circular(
              AppUIConstants.defaultBorderRadius,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppUIConstants.smallSpacing,
                      children: [
                        Text(
                          AppTextConstants.netWorth,
                          style: AppTextStyle.greyS14Medium,
                        ),
                        Text(
                          FormatUtils.formatCurrency(totalAccountBalance),
                          style: AppTextStyle.blackS18Bold,
                        ),
                        Text(
                          AppTextConstants.asset,
                          style: AppTextStyle.greyS14Medium,
                        ),
                        Text(
                          FormatUtils.formatCurrency(totalAccountBalance),
                          style: AppTextStyle.blackS18Bold,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    spacing: AppUIConstants.smallSpacing,
                    children: [
                      SvgUtils.icon(
                        assetPath: Assets.svgsMoney,
                        size: SvgSizeType.extraLarge,
                      ),
                      Text(
                        AppTextConstants.debt,
                        style: AppTextStyle.greyS14Medium,
                      ),
                      Text('0', style: AppTextStyle.blackS18Bold),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
