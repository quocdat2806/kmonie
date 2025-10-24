import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

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
                iconAsset: Assets.svgsLock,
                title: 'Mật khẩu',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColorConstants.primary, borderRadius: BorderRadius.circular(4)),
                      child: Text('VIP', style: AppTextStyle.whiteS10Bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                  ],
                ),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsNotification,
                title: 'Phím tắt thông báo',
                trailing: Switch(value: true, onChanged: (value) {}, activeThumbColor: AppColorConstants.primary),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsMicro,
                title: 'Hiệu ứng âm thanh',
                trailing: Switch(value: true, onChanged: (value) {}, activeThumbColor: AppColorConstants.primary),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsDollar,
                title: 'Dấu phân cách hàng nghìn',
                trailing: Switch(value: true, onChanged: (value) {}, activeThumbColor: AppColorConstants.primary),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsDollar,
                title: 'Dạng hiển thị số',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsCalendar,
                title: 'Lịch',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsCommand,
                title: 'Thanh công cụ nhập liệu AI',
                trailing: Switch(value: false, onChanged: (value) {}, activeThumbColor: AppColorConstants.primary),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsReport,
                title: 'Xóa tất cả dữ liệu',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsNote,
                title: 'Dữ liệu được sao lưu tự động',
                subtitle: '18 thg 10 8:58',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsTelephone,
                title: 'Ngôn ngữ',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsCommand,
                title: 'Giao diện lập trình ứng dụng',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppColorConstants.primary, borderRadius: BorderRadius.circular(4)),
                      child: Text('VIP', style: AppTextStyle.whiteS10Bold),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                  ],
                ),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsNote,
                title: 'Điều khoản sử dụng',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsLock,
                title: 'Chính sách bảo mật',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsGroup,
                title: 'Về chúng tôi',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
              const AppDivider(),
              _buildSettingsItem(
                iconAsset: Assets.svgsNote,
                title: 'Nhận xét',
                trailing: const Icon(Icons.chevron_right, color: AppColorConstants.grey),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem({required String iconAsset, required String title, String? subtitle, required Widget trailing, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.extraLargePadding, vertical: AppUIConstants.defaultPadding),
        child: Row(
          children: [
            SvgPicture.asset(iconAsset, width: AppUIConstants.mediumIconSize, height: AppUIConstants.mediumIconSize, colorFilter: const ColorFilter.mode(AppColorConstants.primary, BlendMode.srcIn)),
            const SizedBox(width: AppUIConstants.defaultSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyle.blackS14Medium),
                  if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle, style: AppTextStyle.greyS12)],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
