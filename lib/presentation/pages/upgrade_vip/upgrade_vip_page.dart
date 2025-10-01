import 'package:flutter/material.dart';

import '../../../core/cache/export.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/export.dart';
import '../../../generated/assets.dart';
import '../../widgets/exports.dart';

class VipUpgradePage extends StatelessWidget {
  const VipUpgradePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: TextConstants.cancel, centerTitle: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(UIConstants.smallPadding),
          child: ListView(
            children: [
              const SizedBox(height: UIConstants.largePadding),
              _buildHeader(),
              const SizedBox(height: UIConstants.largePadding),
              _buildFeatureList(),
              const SizedBox(height: UIConstants.largePadding),
              _buildPricingSection(),
              const SizedBox(height: UIConstants.largePadding),
              _buildContinueButton(),
              const SizedBox(height: UIConstants.largePadding),
              _buildTermsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgCacheManager().getSvg(Assets.svgsKing, UIConstants.extraLargeIconSize, UIConstants.extraLargeIconSize, color: ColorConstants.primary),
        const SizedBox(height: UIConstants.defaultPadding),
        Text('Chuyển lên Premium', style: AppTextStyle.blackS24Bold),
      ],
    );
  }

  Widget _buildFeatureList() {
    final features = [TextConstants.unlockFeatureAndRemoveAds, TextConstants.moreTopicAndCustomise, TextConstants.makeLifeBeautiful];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: UIConstants.defaultPadding),
      child: Column(children: features.map((text) => _buildFeatureItem(text)).toList()),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: UIConstants.largePadding),
      child: Row(
        children: [
          SvgCacheManager().getSvg(Assets.svgsCheck, UIConstants.mediumIconSize, UIConstants.mediumIconSize, color: ColorConstants.primary),
          const SizedBox(width: UIConstants.smallPadding),
          Expanded(child: Text(text, style: AppTextStyle.blackS14Medium)),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Text(TextConstants.feeForYear, style: AppTextStyle.blackS14Medium, textAlign: TextAlign.center);
  }

  Widget _buildContinueButton() {
    return AppButton(onPressed: () {}, text: TextConstants.continueRegister, width: double.infinity, fontWeight: FontWeight.bold);
  }

  Widget _buildTermsSection() {
    return Column(
      children: [
        const Text(TextConstants.termPolicy, textAlign: TextAlign.justify),
        const SizedBox(height: UIConstants.smallPadding),
        Row(
          children: [
            Expanded(
              child: Text(TextConstants.termText, style: AppTextStyle.yellowS12, textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text(TextConstants.policyText, style: AppTextStyle.yellowS12, textAlign: TextAlign.center),
            ),
          ],
        ),
      ],
    );
  }
}
