import 'package:flutter/material.dart';

import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/navigation/router_path.dart';

class AddTransactionButton extends StatelessWidget {
  const AddTransactionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.amber.shade400,
      onPressed: () {
        AppNavigator(context: context).push(
          RouterPath.transactionActions,
        );
      },
      child: const Icon(
        Icons.add,
        color: Colors.black87,
        size: 32,
      ),
    );
  }
}
