import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kmonie/core/text_style/app_text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.isDense,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.readOnly = false,
    this.focusNode,
    this.border,
    this.contentPadding,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.decoration,
    this.onChanged,
    this.borderBottomColor,
    this.inputFormatters,
    this.editAble = true,
    this.onClear,
    this.filledColor = Colors.transparent,
    this.onFieldSubmitted,
    this.textInputAction = TextInputAction.search,
  });

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool? isDense;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final bool readOnly;
  final FocusNode? focusNode;
  final InputBorder? border;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLength;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;
  final Color? borderBottomColor;
  final List<TextInputFormatter>? inputFormatters;
  final bool editAble;
  final VoidCallback? onClear;
  final Color filledColor;
  final void Function(String value)? onFieldSubmitted;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(onFieldSubmitted: onFieldSubmitted, enabled: editAble, style: style, controller: controller, obscureText: obscureText, keyboardType: keyboardType, validator: validator, maxLines: maxLines, readOnly: readOnly, textInputAction: textInputAction, maxLength: maxLength, textAlign: textAlign, focusNode: focusNode, onChanged: onChanged, inputFormatters: inputFormatters, decoration: decoration ?? _buildDefaultDecoration());
  }

  InputDecoration _buildDefaultDecoration() {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      isDense: isDense ?? true,
      hintStyle: AppTextStyle.greyS14,
      filled: true,
      fillColor: filledColor,
      suffixIcon: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[if (suffixIcon != null) suffixIcon!]),
      prefixIconConstraints: const BoxConstraints(),
      suffixIconConstraints: const BoxConstraints(),
      border: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      enabledBorder: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      focusedBorder: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      disabledBorder: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      errorBorder: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      focusedErrorBorder: border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
