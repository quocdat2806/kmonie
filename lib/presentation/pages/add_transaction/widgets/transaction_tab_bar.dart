import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/export.dart';
import '../../../../core/enum/export.dart';
import '../../../bloc/export.dart';
import '../../../widgets/export.dart';

class TransactionTabBar extends StatelessWidget {
  const TransactionTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddTransactionBloc, AddTransactionState, int>(
      selector: (state) => state.selectedIndex,
      builder: (context, selectedIndex) {
        final transactionTypes = ExTransactionType.transactionTypes;
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: UIConstants.smallPadding,
          ),
          child: AppTabView<TransactionType>(
            types: transactionTypes,
            selectedIndex: selectedIndex,
            getDisplayName: (t) => t.displayName,
            getTypeIndex: (t) => t.typeIndex,
            onTabSelected: (index) {
              context.read<AddTransactionBloc>().add(SwitchTab(index));
            },
          ),
        );
      },
    );
  }
}
