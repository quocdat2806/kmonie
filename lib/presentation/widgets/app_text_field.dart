import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kmonie/core/constants/color_constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: editAble,
      style: style,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      readOnly: readOnly,
      maxLength: maxLength,
      textAlign: textAlign,
      focusNode: focusNode,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      decoration: decoration ?? _buildDefaultDecoration(),
    );
  }

  InputDecoration _buildDefaultDecoration() {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      isDense: isDense ?? true,
      prefixIcon: prefixIcon == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 12),
              child: prefixIcon,
            ),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: InkWell(
                onTap: onClear,
                child: const Icon(
                  Icons.clear,
                  size: 18,
                  color: AppColors.black,
                ),
              ),
            ),
          if (suffixIcon != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffixIcon,
            ),
        ],
      ),
      prefixIconConstraints: const BoxConstraints(),
      suffixIconConstraints: const BoxConstraints(),
      border:
          border ??
          UnderlineInputBorder(
            borderSide: BorderSide(color: borderBottomColor ?? AppColors.error),
          ),
      contentPadding:
          contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
