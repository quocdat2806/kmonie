import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/navigation/router_path.dart';
import 'package:kmonie/presentation/presentation.dart';
import 'package:kmonie/generated/assets.dart';
import 'widgets/menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColorConstants.white,
      child: Column(
        children: [
          _buildHeader(),
          ColoredBox(color: AppColorConstants.white, child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ColoredBox(
      color: AppColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.defaultPadding),
        child: Row(
          children: [
            // const AppCircleImage(
            //   fallbackIcon: Icon(Icons.person, color: AppColorConstants.black),
            //   imageUrl: 'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/11/tai-hinh-nen-dep-mien-phi.jpg',
            // ),
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

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const MenuItem(iconAsset: Assets.svgsKing, title: 'Thành viên premium Chặn quảng cáo'),
        const AppDivider(),
        const MenuItem(iconAsset: Assets.svgsLike, title: 'Giới thiệu cho bạn bè'),
        const AppDivider(),
        MenuItem(iconAsset: Assets.svgsSetting, title: 'Cài đặt', onTap: () => context.push(RouterPath.settings)),
        const AppDivider(),
        MenuItem(iconAsset: Assets.svgsNote, title: 'Ứng dụng của chúng tôi', onTap: () => context.push(RouterPath.myApp)),
      ],
    );
  }
}
