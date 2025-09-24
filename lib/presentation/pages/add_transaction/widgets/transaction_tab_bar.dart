import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/enum/exports.dart';
import '../../../bloc/add_transaction/add_transaction_export.dart';
import '../../../widgets/tab_view/app_tab_view.dart';

class TransactionTabBar extends StatelessWidget {
  const TransactionTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddTransactionBloc, AddTransactionState>(
      builder: (context, state) {
        final transactionTypes = TransactionConstants.transactionTypes;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal:UIConstants.smallPadding),
          child: AppTabView<TransactionType>(
            types: transactionTypes,
            selectedIndex: state.selectedIndex,
            getDisplayName: (t) => t.displayName,
            getTypeIndex: (t) => t.typeIndex,
            onTabSelected: (index) {
              context
                  .read<AddTransactionBloc>()
                  .add(AddTransactionSwitchTab(index));
            },
          ),
        );
      },
    );
  }
}
