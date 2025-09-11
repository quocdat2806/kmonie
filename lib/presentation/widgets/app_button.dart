import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {

  const AppButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.height = 56.0,
    this.borderRadius = 8.0,
    required this.onPressed,
    this.icon,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.bold,
    this.hasShadow = true,
    this.shadowColor = Colors.grey,
    this.shadowOffset = const Offset(0, 4),
    this.shadowBlurRadius = 4.0,
    this.shadowSpreadRadius = 0.0,
    this.isDisable = false,
  });
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double height;
  final double borderRadius;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final EdgeInsets padding;
  final double fontSize;
  final FontWeight fontWeight;
  final bool hasShadow;
  final Color shadowColor;
  final Offset shadowOffset;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: _buildShadow(),
      child: ElevatedButton(
        onPressed: isDisable ? () {} : onPressed,
        style: _buildButtonStyle(),
        child: _buildContent(),
      ),
    );
  }

  BoxDecoration? _buildShadow() {
    if (!hasShadow) {
      return null;
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: shadowColor,
          offset: shadowOffset,
          blurRadius: shadowBlurRadius,
          spreadRadius: shadowSpreadRadius,
        ),
      ],
    );
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor:
          isDisable ? backgroundColor.withValues(alpha: 0.8) : backgroundColor,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderColor != null ? 1.5 : 0,
        ),
      ),
      elevation: 0,
      overlayColor: isDisable ? Colors.transparent : null,
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, color: textColor),
          const SizedBox(width: 8.0),
        ],
        Text(
          text,
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
