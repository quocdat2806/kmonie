import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/core/enums/transaction_type.dart';
import 'package:kmonie/entities/transaction_category.dart';
import 'package:kmonie/core/services/transaction_category_service.dart';
import 'package:kmonie/core/text_styles/app_text_styles.dart';
import 'package:kmonie/presentation/bloc/add_transaction/add_transaction_bloc.dart';

class AddTransactionCategoryGrid extends StatelessWidget {
  const AddTransactionCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (context, state) {
        return state.when(
          initial: (selectedIndex) => _buildCategoryGrid(selectedIndex),
          loaded: (selectedIndex) => _buildCategoryGrid(selectedIndex),
          error: (selectedIndex, message) => _buildErrorWidget(message),
        );
      },
    );
  }

  Widget _buildCategoryGrid(int selectedIndex) {
    final transactionType = TransactionType.fromIndex(selectedIndex);
    final categories = TransactionCategoryService.getCategories(
      transactionType,
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
          return _buildCategoryItem(category);
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

  Widget _buildCategoryItem(TransactionCategory category) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: UIConstants.largeContainerSize,
          height: UIConstants.largeContainerSize,
          decoration: BoxDecoration(
            color: category.color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            category.icon,
            color: AppColors.white,
            size: UIConstants.largeIconSize,
          ),
        ),
        const SizedBox(height: UIConstants.smallSpacing),
        Text(
          category.name,
          textAlign: TextAlign.center,
          style: AppTextStyle.blackS12Medium,
          maxLines: UIConstants.defaultMaxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
