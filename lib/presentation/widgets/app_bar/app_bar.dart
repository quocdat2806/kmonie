import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/navigation/navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title, this.leading, this.actions, this.onLeadingTap, this.centerTitle = true});

  final dynamic title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLeadingTap;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title is String ? Text(title as String, style: AppTextStyle.blackS18Bold) : title as Widget,
      centerTitle: centerTitle,
      backgroundColor: AppColorConstants.primary,
      titleSpacing: 0,
      elevation: 0,
      leading:
          leading ??
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColorConstants.black),
            onPressed: onLeadingTap ?? () => _handleBack(context),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleBack(BuildContext context) {
    AppNavigator(context: context).maybePop();
  }
}
