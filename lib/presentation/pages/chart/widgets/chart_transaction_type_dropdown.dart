import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/text_style/export.dart';
import '../../../../core/enum/export.dart';
import '../../../../core/constant/export.dart';
import '../../../bloc/export.dart';
import '../../../widgets/export.dart';

class ChartTransactionTypeDropdown extends StatelessWidget {
  final GlobalKey dropdownKey;

  const ChartTransactionTypeDropdown({super.key, required this.dropdownKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      builder: (context, state) {
        return InkWell(
          key: dropdownKey,
          onTap: () => _showTransactionTypeDropdown(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: UIConstants.smallSpacing,
            children: [
              Text(state.selectedTransactionType.displayName, style: AppTextStyle.blackS16Bold),
              const Icon(Icons.arrow_drop_down, color: ColorConstants.black, size: UIConstants.mediumIconSize),
            ],
          ),
        );
      },
    );
  }

  void _showTransactionTypeDropdown(BuildContext context) {
    const allowedTypes = [TransactionType.expense, TransactionType.income];
    final options = allowedTypes.map((t) => t.displayName).toList();

    AppDropdown.show<String>(
      context: context,
      targetKey: dropdownKey,
      items: options,
      itemBuilder: (item) => Padding(
        padding: const EdgeInsets.all(UIConstants.smallPadding),
        child: Text(item, style: AppTextStyle.blackS14Medium),
      ),
      onItemSelected: (value) {
        final selectedType = allowedTypes.firstWhere((t) => t.displayName == value, orElse: () => TransactionType.expense);
        context.read<ChartBloc>().add(ChangeTransactionType(selectedType));
      },
    );
  }
}
