import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/enums/enums.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: AppTextConstants.settings),
      body: SafeArea(
        child: Column(
          children: [
            /// TODO: I will implement this later when app publish on google play
            _buildSettingsItem(
              iconAsset: Assets.svgsReport,
              title: AppTextConstants.deleteAllData,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const AppDevelopmentProcessDialog();
                  },
                );
              },
            ),
            const AppDivider(),
            _buildSettingsItem(
              iconAsset: Assets.svgsGroup,
              title: AppTextConstants.reminder,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const AppDevelopmentProcessDialog();
                  },
                );
              },
            ),
            const AppDivider(),
            _buildSettingsItem(
              iconAsset: Assets.svgsNote,
              title: AppTextConstants.autoSchedule,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const AppDevelopmentProcessDialog();
                  },
                );
              },
            ),
            const AppDivider(),
            _buildSettingsItem(
              iconAsset: Assets.svgsNote,
              title: AppTextConstants.useAI,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return const AppDevelopmentProcessDialog();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String iconAsset,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppUIConstants.extraLargePadding,
          vertical: AppUIConstants.defaultPadding,
        ),
        child: Row(
          children: [
            SvgUtils.icon(
              assetPath: iconAsset,
              size: SvgSizeType.medium,
              color: AppColorConstants.primary,
            ),
            const SizedBox(width: AppUIConstants.defaultSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(title, style: AppTextStyle.blackS14Medium)],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColorConstants.grey),
          ],
        ),
      ),
    );
  }
}
