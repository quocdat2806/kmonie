import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constant/exports.dart';
import 'package:kmonie/presentation/pages/add_transaction/widgets/transaction_category_item.dart';
import '../../../../core/enum/exports.dart';
import '../../../../core/service/exports.dart';
import '../../../../presentation/bloc/add_transaction/add_transaction_export.dart';
import '../../../widgets/grid/app_grid.dart';

class TransactionCategoryGrid extends StatelessWidget {
  const TransactionCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (context, state) {
        final transactionType = TransactionType.fromIndex(state.selectedIndex);
        final categories = TransactionCategoryService.getCategories(
          transactionType,
        );
        final String? selectedId = context.select<AddTransactionBloc, String?>(
          (AddTransactionBloc b) =>
              b.state.selectedCategoryForType(transactionType),
        );
        return AppGrid(
          mainAxisSpacing: UIConstants.zeroInsets,
          crossAxisSpacing: UIConstants.zeroInsets,
          crossAxisCount: UIConstants.defaultGridCrossAxisCount,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return TransactionCategoryItem(
              category: category,
              transactionType: transactionType,
              isSelected: category.id == selectedId,
              itemWidth:
                  MediaQuery.of(context).size.width /
                  UIConstants.defaultGridCrossAxisCount,
              onTap: () {
                context.read<AddTransactionBloc>().add(
                  AddTransactionCategoryChanged(
                    type: transactionType,
                    categoryId: category.id,
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
