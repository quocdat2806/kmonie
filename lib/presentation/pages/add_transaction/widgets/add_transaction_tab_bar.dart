import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/enum/exports.dart';
import '../../../../core/text_style/exports.dart';
import '../../../bloc/add_transaction/add_transaction_export.dart';

class AddTransactionTabBar extends StatelessWidget {
  const AddTransactionTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (context, state) {
        final transactionTypes = TransactionConstants.transactionTypes;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: List.generate(transactionTypes.length, (index) {
              final transactionType = transactionTypes[index];
              final bool isFirst = index == 0;
              final bool isLast = index == transactionTypes.length - 1;
              final bool isSelected =
                  transactionType.typeIndex == state.selectedIndex;

              return Expanded(
                child: _TransactionTabItem(
                  transactionType: transactionType,
                  isSelected: isSelected,
                  isFirst: isFirst,
                  isLast: isLast,
                  onTap: () {
                    context.read<AddTransactionBloc>().add(
                      AddTransactionSwitchTab(transactionType.typeIndex),
                    );
                  },
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _TransactionTabItem extends StatelessWidget {
  final TransactionType transactionType;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  const _TransactionTabItem({
    required this.transactionType,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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

    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? ColorConstants.black : ColorConstants.yellow,
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
            vertical: UIConstants.smallPadding + UIConstants.extraSmallSpacing,
          ),
          child: Center(
            child: Text(
              transactionType.displayName,
              style: isSelected
                  ? AppTextStyle.yellowS14Medium
                  : AppTextStyle.blackS14Medium,
            ),
          ),
        ),
      ),
    );
  }
}
