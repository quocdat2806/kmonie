import 'package:flutter/material.dart';
import '../../../../core/exports.dart';

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
      children: types.map((type) {
        final int index = getTypeIndex(type);
        final bool isSelected = index == selectedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                UIConstants.defaultBorderRadius,
              ),
              child: ColoredBox(
                color: isSelected
                    ? ColorConstants.yellow
                    : ColorConstants.neutralGray200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical:
                        UIConstants.smallPadding +
                        UIConstants.extraSmallSpacing,
                  ),
                  child: Text(
                    getDisplayName(type),
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? AppTextStyle.blackS14Medium
                        : AppTextStyle.blackS14Medium.copyWith(
                            color: ColorConstants.earthyBrown,
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
