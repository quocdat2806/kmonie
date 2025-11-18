import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/presentation.dart';

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
        /// TODO: I will implement this later when app publish on google play
        MenuItem(
          iconAsset: Assets.svgsLike,
          title: 'Giới thiệu cho bạn bè',
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
        MenuItem(
          iconAsset: Assets.svgsSetting,
          title: AppTextConstants.settings,
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
    );
  }
}
