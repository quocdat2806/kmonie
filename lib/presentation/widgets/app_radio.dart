import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/color_constants.dart';

class AppSelectTile<T> extends StatelessWidget {
  const AppSelectTile({
    super.key,
    this.checked,
    this.value,
    this.groupValue,
    this.onTap,
    this.onChanged,
    required this.label,
    this.activeColor = AppColors.pink,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.spacing = 12,
  });
  final bool? checked;
  final T? value;
  final T? groupValue;
  final VoidCallback? onTap;
  final ValueChanged<T?>? onChanged;
  final Widget label;
  final Color activeColor;
  final EdgeInsets padding;
  final double spacing;

  bool get _isRadio => value != null && groupValue != null && onChanged != null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isRadio ? () => onChanged!(value) : onTap,
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            _isRadio ? _buildRadio() : _buildCheckbox(),
            SizedBox(width: spacing),
            Expanded(child: label),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio() {
    return RadioGroup<T>(
      groupValue: groupValue as T,
      onChanged: onChanged!,
      child: Radio<T>(value: value as T, activeColor: activeColor),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: checked! ? activeColor : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: checked! ? null : Border.all(color: activeColor, width: 2),
      ),
      child: checked!
          ? const Icon(Icons.check, size: 18, color: AppColors.white)
          : null,
    );
  }
}
