import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/export.dart';
import '../../../../core/enum/export.dart';
import '../../../../entity/export.dart';
import '../../../bloc/export.dart';
import '../../../widgets/export.dart';
import 'transaction_category_item.dart';

class TransactionCategoryGrid extends StatelessWidget {
  const TransactionCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionActionsBloc, TransactionActionsState, ({TransactionType type, List<TransactionCategory> categories, int? selectedId})>(
      selector: (state) => (type: state.currentType, categories: state.categoriesFor(state.currentType), selectedId: state.selectedCategoryIdFor(state.currentType)),
      builder: (context, data) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / UIConstants.defaultGridCrossAxisCount;
            return AppGrid(
              mainAxisSpacing: UIConstants.zeroInsets,
              crossAxisSpacing: UIConstants.zeroInsets,
              crossAxisCount: UIConstants.defaultGridCrossAxisCount,
              itemCount: data.categories.length,
              itemBuilder: (context, index) {
                final category = data.categories[index];
                return TransactionCategoryItem(
                  category: category,
                  isSelected: category.id == data.selectedId,
                  itemWidth: itemWidth,
                  onTap: () {
                    if (category.isCreateNewCategory) {
                      ///todo
                      // AppNavigator(
                      //   context: context,
                      // ).push(RouterPath.addTransactionCategory);
                      return;
                    }
                    context.read<TransactionActionsBloc>().add(CategoryChanged(type: data.type, categoryId: category.id!));
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
