import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/di/di.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/streams/streams.dart';
import 'package:kmonie/repositories/repositories.dart';

class SettingsPage extends StatelessWidget {
  final DataRepository dataRepository;
  const SettingsPage({super.key, required this.dataRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.white,
      appBar: const CustomAppBar(title: AppTextConstants.settings),
      body: SafeArea(
        child: Column(
          children: [
            _buildSettingsItem(
              iconAsset: Assets.svgsReport,
              title: AppTextConstants.deleteAllData,
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AppDeleteAllDataDialog(
                      onConfirm: () async {
                        AppNavigator(context: dialogContext).pop();
                        final result = await dataRepository.deleteAllUserData();
                        result.fold(
                          (failure) {
                            logger.e(
                              'Error deleting all data: ${failure.message}',
                            );
                          },
                          (_) {
                            AppStreamEvent.deleteAllDataStatic();
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            const AppDivider(),
            _buildSettingsItem(
              iconAsset: Assets.svgsGroup,
              title: AppTextConstants.reminder,
              onTap: () {
                AppNavigator(context: context).push(RouterPath.reminder);
              },
            ),
            const AppDivider(),
            _buildSettingsItem(
              iconAsset: Assets.svgsNote,
              title: AppTextConstants.autoSchedule,
              onTap: () {
                AppNavigator(
                  context: context,
                ).push(RouterPath.reminderTransactionAutomation);
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
