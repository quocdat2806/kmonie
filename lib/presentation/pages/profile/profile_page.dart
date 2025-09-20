import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/pages/profile/widgets/menu_item.dart';
import 'package:kmonie/presentation/widgets/app_circle_image.dart';
import 'package:kmonie/presentation/widgets/app_divider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildHeader(), _buildBody()]);
  }

  Widget _buildHeader() {
    return ColoredBox(
      color: AppColors.yellow,
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.defaultPadding),
        child: Row(
          children: [
            const AppCircleImage(
              backgroundColor: AppColors.yellow,
              fallbackIcon: Icon(Icons.person, color: AppColors.black),
              imageUrl:
                  'https://hoanghamobile.com/tin-tuc/wp-content/uploads/2024/11/tai-hinh-nen-dep-mien-phi.jpg',
            ),
            const SizedBox(width: UIConstants.defaultSpacing),
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
