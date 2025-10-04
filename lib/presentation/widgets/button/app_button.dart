import 'package:flutter/material.dart';
import '../../../core/constant/export.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.text,
    this.backgroundColor = ColorConstants.primary,
    this.textColor = ColorConstants.black,
    required this.onPressed,
    this.icon,
    this.iconWidget,
    this.height = UIConstants.defaultButtonHeight,
    this.borderRadius = UIConstants.defaultBorderRadius,
    this.width,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.borderColor,
    this.disabled = false,
  });

  final String? text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  final IconData? icon;

  final Widget? iconWidget;

  final double height;
  final double borderRadius;
  final double? width;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? borderColor;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled
              ? backgroundColor.withAlpha(60)
              : backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderColor != null ? 1 : 0,
            ),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.smallPadding,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final hasText = text != null && text!.isNotEmpty;
    final hasIcon = icon != null || iconWidget != null;

    if (hasIcon && !hasText) {
      return iconWidget ?? Icon(icon, color: textColor, size: 18);
    }

    if (!hasIcon && hasText) {
      return Text(
        text!,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconWidget ?? Icon(icon, color: textColor, size: 18),
        const SizedBox(width: UIConstants.smallPadding),
        Text(
          text!,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ],
    );
  }
}
