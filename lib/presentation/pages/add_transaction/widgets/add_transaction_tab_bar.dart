import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/transaction_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/enums/transaction_type.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';
import 'package:kmonie/presentation/bloc/add_transaction/add_transaction_bloc.dart';

class AddTransactionTabBar extends StatelessWidget {
  const AddTransactionTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (context, state) {
        return state.when(
          initial: (selectedIndex) => _buildTabBar(selectedIndex),
          loaded: (selectedIndex) => _buildTabBar(selectedIndex),
          error: (selectedIndex, message) => _buildTabBar(selectedIndex),
        );
      },
    );
  }

  Widget _buildTabBar(int selectedIndex) {
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: UIConstants.defaultPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
        ),
        child: Row(
          children: TransactionConstants.transactionTypes
              .map(
                (transactionType) => _buildTab(
                  context: context,
                  transactionType: transactionType,
                  currentIndex: selectedIndex,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required TransactionType transactionType,
    required int currentIndex,
  }) {
    final bool isSelected = transactionType.typeIndex == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<AddTransactionBloc>().add(
            AddTransactionEvent.switchTab(transactionType.typeIndex),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: UIConstants.smallPadding + UIConstants.extraSmallSpacing,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.black : AppColors.white,
            borderRadius: BorderRadius.circular(
              UIConstants.defaultBorderRadius,
            ),
          ),
          child: Text(
            transactionType.displayName,
            textAlign: TextAlign.center,
            style: isSelected
                ? AppTextStyle.whiteS14Medium
                : AppTextStyle.blackS14Medium,
          ),
        ),
      ),
    );
  }
}
