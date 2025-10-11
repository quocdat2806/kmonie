import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/presentation.dart';
import 'package:kmonie/generated/assets.dart';
import 'widgets/menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildHeader(), _buildBody()]);
  }

  Widget _buildHeader() {
    return ColoredBox(
      color: AppColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Row(
          children: [
            const AppCircleImage(
              backgroundColor: AppColorConstants.primary,
              fallbackIcon: Icon(Icons.person, color: AppColorConstants.black),
              imageUrl:
                  'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/11/tai-hinh-nen-dep-mien-phi.jpg',
            ),
            const SizedBox(width: AppUIConstants.defaultSpacing),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quốc ĐẠT', style: AppTextStyle.blackS18Bold),
                const SizedBox(height: 2),
                Text('ID:1959355', style: AppTextStyle.grayS12),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return const Column(
      children: [
        MenuItem(iconAsset: Assets.svgsKing, title: 'Thành viên premium'),
        AppDivider(),
        MenuItem(iconAsset: Assets.svgsLike, title: 'Giới thiệu cho bạn bè'),
        AppDivider(),
        MenuItem(iconAsset: Assets.svgsSetting, title: 'Cài đặt'),
        AppDivider(),
        MenuItem(iconAsset: Assets.svgsNote, title: 'Ứng dụng của chúng tôi'),
      ],
    );
  }
}
