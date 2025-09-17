import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/enums/transaction_type.dart';
import 'package:kmonie/entities/transaction_category.dart';
import 'package:kmonie/core/services/transaction_category_service.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';
import 'package:kmonie/presentation/bloc/add_transaction/add_transaction_bloc.dart';

import '../../../bloc/add_transaction/add_transaction_event.dart';
import '../../../bloc/add_transaction/add_transaction_state.dart';

class AddTransactionCategoryGrid extends StatelessWidget {
  const AddTransactionCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (context, state) {
        if (state.message != null && state.message!.isNotEmpty) {
          return _buildErrorWidget(state.message!);
        }
        return _buildCategoryGrid(context, state.selectedIndex);
      },
    );
  }

  Widget _buildCategoryGrid(BuildContext context, int selectedIndex) {
    final transactionType = TransactionType.fromIndex(selectedIndex);
    final categories = TransactionCategoryService.getCategories(
      transactionType,
    );
    final String? selectedId = context.select<AddTransactionBloc, String?>(
      (AddTransactionBloc b) =>
          b.state.selectedCategoryForType(transactionType),
    );

    return Padding(
      padding: const EdgeInsets.all(UIConstants.defaultPadding),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: UIConstants.defaultGridCrossAxisCount,
          crossAxisSpacing: UIConstants.defaultGridCrossAxisSpacing,
          mainAxisSpacing: UIConstants.defaultGridMainAxisSpacing,
          childAspectRatio: UIConstants.defaultGridChildAspectRatio,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final bool isSelected = category.id == selectedId;
          return _buildCategoryItem(
            context: context,
            category: category,
            transactionType: transactionType,
            isSelected: isSelected,
          );
        },
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: UIConstants.extraLargeIconSize,
            color: AppColors.red,
          ),
          const SizedBox(height: UIConstants.defaultSpacing),
          Text(
            message,
            style: AppTextStyle.redS14,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required TransactionCategory category,
    required TransactionType transactionType,
    required bool isSelected,
  }) {
    final Color backgroundColor = isSelected
        ? AppColors.yellow
        : AppColors.neutralGray200;
    final Color iconColor = isSelected
        ? AppColors.black
        : AppColors.earthyBrown;

    return GestureDetector(
      onTap: () {
        context.read<AddTransactionBloc>().add(
          AddTransactionCategoryChanged(
            type: transactionType,
            categoryId: category.id,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              UIConstants.defaultBorderRadius,
            ),
            child: ColoredBox(
              color: backgroundColor,
              child: SizedBox(
                width: UIConstants.largeContainerSize,
                height: UIConstants.largeContainerSize,
                child: Icon(
                  Icons.category,
                  color: iconColor,
                  size: UIConstants.largeIconSize,
                ),
              ),
            ),
          ),
          const SizedBox(height: UIConstants.smallSpacing),
          Text(
            category.title,
            textAlign: TextAlign.center,
            style: isSelected
                ? AppTextStyle.blackS12Medium
                : AppTextStyle.blackS12Medium.copyWith(
                    color: AppColors.earthyBrown,
                  ),
            maxLines: UIConstants.defaultMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
