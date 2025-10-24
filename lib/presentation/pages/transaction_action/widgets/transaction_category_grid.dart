import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/entities/entities.dart';
import 'package:kmonie/presentation/blocs/transaction_actions/transaction_actions.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';
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
            final itemWidth = constraints.maxWidth / AppUIConstants.defaultGridCrossAxisCount;
            return AppGrid(
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              crossAxisCount: AppUIConstants.defaultGridCrossAxisCount,
              itemCount: data.categories.length,
              itemBuilder: (context, index) {
                final category = data.categories[index];
                return TransactionCategoryItem(
                  category: category,
                  isSelected: category.id == data.selectedId,
                  itemWidth: itemWidth,
                  onTap: () {
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
