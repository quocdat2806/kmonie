import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constant/export.dart';
import '../../../core/text_style/export.dart';
import '../../../generated/assets.dart';
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
          child: ListView(
            children: [
              const SizedBox(height: UIConstants.largeSpacing),
              _buildHeader(),
              const SizedBox(height: UIConstants.largeSpacing),
              _buildFeatureList(),
              const SizedBox(height: UIConstants.largeSpacing),
              Text(
                TextConstants.feeForYear,
                style: AppTextStyle.blackS14,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: UIConstants.largeSpacing),
              AppButton(
                onPressed: () {},
                text: TextConstants.register,
                width: double.infinity,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: UIConstants.largeSpacing),
              _buildTermsSection(),
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
        SvgPicture.asset(
          Assets.svgsKing,
          width: UIConstants.extraLargeIconSize,
          colorFilter: ColorFilter.mode(
            ColorConstants.primary,
            BlendMode.srcIn,
          ),
          height: UIConstants.extraLargeIconSize,
        ),
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
      TextConstants.moreTopicAndCustomise,
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
        children: [
          Icon(Icons.check, color: ColorConstants.primary),
          const SizedBox(width: UIConstants.smallSpacing),
          Expanded(child: Text(text, style: AppTextStyle.blackS14Medium)),
        ],
      ),
    );
  }

  Widget _buildTermsSection() {
    return Column(
      spacing: UIConstants.smallSpacing,
      children: [
        Text(
          TextConstants.termPolicy,
          textAlign: TextAlign.justify,
          style: AppTextStyle.blackS14,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                TextConstants.term,
                style: AppTextStyle.yellowS12,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                TextConstants.policy,
                style: AppTextStyle.yellowS12,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
