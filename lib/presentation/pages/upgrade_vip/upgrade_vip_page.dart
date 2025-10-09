import 'package:flutter/material.dart';

import '../../../core/constant/export.dart';
import '../../../core/text_style/export.dart';
import '../../../generated/export.dart';
import '../../../core/enum/export.dart';
import '../../widgets/export.dart';

class VipUpgradePage extends StatelessWidget {
  const VipUpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: TextConstants.cancel,
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.smallPadding),
          child: Column(
            spacing: UIConstants.defaultSpacing,
            children: [
              _buildHeader(),
              _buildFeatureList(),
              Text(
                TextConstants.feeForYear,
                style: AppTextStyle.blackS14,
                textAlign: TextAlign.center,
              ),
              AppButton(
                onPressed: () {},
                text: TextConstants.register,
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
      spacing: UIConstants.defaultSpacing,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgConstants.icon(assetPath: Assets.svgsKing,color: ColorConstants.primary, size: SvgSizeType.large),
        Text(
          TextConstants.changeToVipPackage,
          style: AppTextStyle.blackS24Bold,
        ),
      ],
    );
  }

  Widget _buildFeatureList() {
    final features = [
      TextConstants.unlockFeatureAndRemoveAds,
      TextConstants.moreTopicAndCustomize,
      TextConstants.makeLifeBeautiful,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: UIConstants.defaultPadding,
      ),
      child: Column(
        children: features.map((text) => _buildFeatureItem(text)).toList(),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.largePadding),
      child: Row(
        spacing: UIConstants.smallSpacing,
        children: [
          const Icon(Icons.check, color: ColorConstants.primary),
          Expanded(child: Text(text, style: AppTextStyle.blackS14Medium)),
        ],
      ),
    );
  }

}
