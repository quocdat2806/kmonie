import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/presentation/blocs/transaction_actions/transaction_actions.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class TransactionActionsTabBar extends StatelessWidget {
  const TransactionActionsTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionActionsBloc, TransactionActionsState, int>(
      selector: (state) => state.selectedIndex,
      builder: (context, selectedIndex) {
        final transactionTypes = ExTransactionType.transactionTypes;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppUIConstants.smallPadding),
          child: AppTabView<TransactionType>(
            types: transactionTypes,
            selectedIndex: selectedIndex,
            getDisplayName: (t) => t.displayName,
            getTypeIndex: (t) => t.typeIndex,
            onTabSelected: (index) {
              context.read<TransactionActionsBloc>().add(SwitchTab(index));
            },
          ),
        );
      },
    );
  }
}
