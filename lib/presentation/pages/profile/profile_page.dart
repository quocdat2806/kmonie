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
        padding: const EdgeInsets.all(AppUIConstants.largePadding),
        child: Row(children: [Text('KMonie - Xin chào', style: AppTextStyle.blackS20Bold)]),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const MenuItem(iconAsset: Assets.svgsLike, title: 'Giới thiệu cho bạn bè'),
        const AppDivider(),
        MenuItem(iconAsset: Assets.svgsSetting, title: 'Cài đặt', onTap: () => context.push(RouterPath.settings)),
        const AppDivider(),
        MenuItem(iconAsset: Assets.svgsNote, title: 'Ứng dụng của chúng tôi', onTap: () => context.push(RouterPath.myApp)),
      ],
    );
  }
}
