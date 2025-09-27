import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constant/exports.dart';
import 'package:kmonie/presentation/pages/add_transaction/widgets/transaction_category_item.dart';
import '../../../../core/enum/transaction_type.dart';
import '../../../../entity/transaction_category/transaction_category.dart';
import '../../../../presentation/bloc/add_transaction/add_transaction_export.dart';
import '../../../widgets/grid/app_grid.dart';

class TransactionCategoryGrid extends StatelessWidget {
  const TransactionCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (BuildContext context, AddTransactionState state) {
        final TransactionType type = state.currentType;
        final List<TransactionCategory> categories = state.categoriesFor(type);
        final int? selectedId = state.selectedCategoryIdFor(type);

        if (state.isLoading && categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return AppGrid(
          mainAxisSpacing: UIConstants.zeroInsets,
          crossAxisSpacing: UIConstants.zeroInsets,
          crossAxisCount: UIConstants.defaultGridCrossAxisCount,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final itemWidth =
                MediaQuery.of(context).size.width / UIConstants.defaultGridCrossAxisCount;
            return TransactionCategoryItem(
              category: category,
              isSelected: category.id == selectedId,
              itemWidth: itemWidth,
              onTap: () {
                context.read<AddTransactionBloc>().add(
                  AddTransactionCategoryChanged(
                    type: type,
                    categoryId: category.id!,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
