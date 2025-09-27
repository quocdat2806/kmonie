import 'package:flutter/material.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/exports.dart';

class AppTabView<T> extends StatelessWidget {
  final List<T> types;
  final int selectedIndex;
  final String Function(T) getDisplayName;
  final int Function(T) getTypeIndex;
  final void Function(int index) onTabSelected;

  const AppTabView({
    super.key,
    required this.types,
    required this.selectedIndex,
    required this.getDisplayName,
    required this.getTypeIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(types.length, (i) {
        final type = types[i];
        final int index = getTypeIndex(type);
        final bool isSelected = index == selectedIndex;
        final bool isFirst = i == 0;
        final bool isLast = i == types.length - 1;

        final BorderRadius borderRadius = BorderRadius.only(
          topLeft: isFirst
              ? const Radius.circular(UIConstants.defaultBorderRadius)
              : Radius.zero,
          bottomLeft: isFirst
              ? const Radius.circular(UIConstants.defaultBorderRadius)
              : Radius.zero,
          topRight: isLast
              ? const Radius.circular(UIConstants.defaultBorderRadius)
              : Radius.zero,
          bottomRight: isLast
              ? const Radius.circular(UIConstants.defaultBorderRadius)
              : Radius.zero,
        );

        return Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorConstants.black
                    : ColorConstants.primary,
                border: Border(
                  top: const BorderSide(color: ColorConstants.black),
                  bottom: const BorderSide(color: ColorConstants.black),
                  left: isFirst
                      ? const BorderSide(color: ColorConstants.black)
                      : BorderSide.none,
                  right: const BorderSide(color: ColorConstants.black),
                ),
                borderRadius: borderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical:
                      UIConstants.smallPadding + UIConstants.extraSmallSpacing,
                ),
                child: Text(
                  getDisplayName(type),
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? AppTextStyle.yellowS14Medium
                      : AppTextStyle.blackS14Medium,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
