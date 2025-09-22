import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/enum/exports.dart';
import '../../../../core/service/exports.dart';
import '../../../../core/text_style/exports.dart';
import '../../../../entity/exports.dart';
import '../../../../presentation/bloc/add_transaction/add_transaction_export.dart';
import '../../../../presentation/widgets/exports.dart';

class AddTransactionCategoryGrid extends StatelessWidget {
  const AddTransactionCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (context, state) {
        if (state.message != null && state.message!.isNotEmpty) {
          return AppErrorWidget(message: state.message!);
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

  Widget _buildCategoryItem({
    required BuildContext context,
    required TransactionCategory category,
    required TransactionType transactionType,
    required bool isSelected,
  }) {
    final Color backgroundColor = isSelected
        ? ColorConstants.yellow
        : ColorConstants.neutralGray200;

    return InkWell(
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
            borderRadius: BorderRadius.circular(UIConstants.maxBorderRadius),
            child: ColoredBox(
              color: backgroundColor,
              child: const SizedBox(
                width: UIConstants.largeContainerSize,
                height: UIConstants.largeContainerSize,
                child: Icon(Icons.category),
              ),
            ),
          ),
          const SizedBox(height: UIConstants.smallSpacing),
          Text(
            category.title,
            textAlign: TextAlign.center,
            style: AppTextStyle.blackS12Medium,
            maxLines: UIConstants.defaultMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
