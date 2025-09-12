import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.onLeadingTap,
    this.backgroundColor = Colors.white,
    this.elevation = 0.0,
    this.centerTitle = true,
    this.titleTextStyle,
    this.haveBackIcon = true,
  });

  final dynamic title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onLeadingTap;
  final Color backgroundColor;
  final double elevation;
  final bool centerTitle;
  final TextStyle? titleTextStyle;
  final bool haveBackIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title is String
          ? Text(
              title as String,
              style: titleTextStyle ?? AppTextStyle.blackS18Bold,
            )
          : title as Widget,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      titleSpacing: 0,
      elevation: elevation,
      leading: haveBackIcon
          ? (leading ??
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.black),
                  onPressed:
                      onLeadingTap ?? () => Navigator.of(context).maybePop(),
                ))
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
