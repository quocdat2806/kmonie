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
      appBar: const CustomAppBar(title: 'Cài đặt'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSettingsItem(
                iconAsset: Assets.svgsReport,
                title: 'Xóa tất cả dữ liệu',
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsGroup,
                title: 'Lời nhắc nhở ',
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsNote,
                title: 'Nhận xét',
                onTap: () {},
              ),
                       const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsNote,
                title: 'Đặt lịch tự động',
                onTap: () {},
              ),
                            const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsNote,
                title: 'Sử dụng AI',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({required String iconAsset, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.extraLargePadding, vertical: AppUIConstants.defaultPadding),
        child: Row(
          children: [
            SvgUtils.icon(assetPath: iconAsset, size: SvgSizeType.medium, color: AppColorConstants.primary),
            const SizedBox(width: AppUIConstants.defaultSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.blackS14Medium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColorConstants.grey),
          ],
        ),
      ),
    );
  }
}
