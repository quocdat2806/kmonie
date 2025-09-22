import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/exports.dart';
import '../../../presentation/bloc/add_transaction/add_transaction_export.dart';
import 'widgets/add_transaction_category_grid.dart';
import 'widgets/add_transaction_header.dart';
import 'widgets/add_transaction_tab_bar.dart';

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTransactionBloc>(
      create: (_) => AddTransactionBloc(),
      child: const AddTransactionPageChild(),
    );
  }
}

class AddTransactionPageChild extends StatelessWidget {
  const AddTransactionPageChild({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: ColorConstants.yellow,
      body: SafeArea(
        child: Column(
          children: [
            AddTransactionHeader(),
            AddTransactionTabBar(),
            SizedBox(height: UIConstants.defaultPadding),
            Expanded(
              child: ColoredBox(
                color: ColorConstants.white,
                child: SizedBox(
                  width: double.infinity,
                  child: AddTransactionCategoryGrid(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
