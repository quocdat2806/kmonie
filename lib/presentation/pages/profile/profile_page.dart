import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/presentation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/config/config.dart';
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
          ColoredBox(
            color: AppColorConstants.white,
            child: _buildBody(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return ColoredBox(
      color: AppColorConstants.primary,
      child: Padding(
        padding: const EdgeInsets.all(AppUIConstants.largePadding),
        child: Row(
          children: [
            Text(AppTextConstants.hello, style: AppTextStyle.blackS20Bold),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        MenuItem(
          iconAsset: Assets.svgsLike,
          title: 'Giới thiệu cho bạn bè',
          onTap: () {
            SharePlus.instance.share(
              ShareParams(
                text: 'Tải ứng dụng Kmonie tại ${AppConfigs.appLink}',
              ),
            );
          },
        ),
        const AppDivider(),
        MenuItem(
          iconAsset: Assets.svgsSetting,
          title: AppTextConstants.settings,
          onTap: () {
            AppNavigator(context: context).push(RouterPath.settings);
          },
        ),
      ],
    );
  }
}
