import 'package:flutter/material.dart';
import 'package:kmonie/core/utils/utils.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/generated/export.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class VipUpgradePage extends StatelessWidget {
  const VipUpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTextConstants.cancel,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppUIConstants.smallPadding),
          child: Column(
            spacing: AppUIConstants.defaultSpacing,
            children: [
              _buildHeader(),
              _buildFeatureList(),
              Text(
                AppTextConstants.feeForYear,
                style: AppTextStyle.blackS14,
                textAlign: TextAlign.center,
              ),
              AppButton(
                onPressed: () {},
                text: AppTextConstants.register,
                width: double.infinity,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      spacing: AppUIConstants.defaultSpacing,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgUtils.icon(
          assetPath: Assets.svgsKing,
          color: AppColorConstants.primary,
          size: SvgSizeType.large,
        ),
        Text(
          AppTextConstants.changeToVipPackage,
          style: AppTextStyle.blackS24Bold,
        ),
      ],
    );
  }

  Widget _buildFeatureList() {
    final features = [
      AppTextConstants.unlockFeatureAndRemoveAds,
      AppTextConstants.moreTopicAndCustomize,
      AppTextConstants.makeLifeBeautiful,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppUIConstants.defaultPadding,
      ),
      child: Column(
        children: features.map((text) => _buildFeatureItem(text)).toList(),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppUIConstants.largePadding),
      child: Row(
        spacing: AppUIConstants.smallSpacing,
        children: [
          const Icon(Icons.check, color: AppColorConstants.primary),
          Expanded(child: Text(text, style: AppTextStyle.blackS14Medium)),
        ],
      ),
    );
  }
}
