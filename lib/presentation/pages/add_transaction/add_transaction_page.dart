import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/core/constants/ui_constants.dart';
import 'package:kmonie/presentation/bloc/add_transaction/add_transaction_bloc.dart';
import 'package:kmonie/presentation/pages/add_transaction/widgets/add_transaction_category_grid.dart';
import 'package:kmonie/presentation/pages/add_transaction/widgets/add_transaction_header.dart';
import 'package:kmonie/presentation/pages/add_transaction/widgets/add_transaction_tab_bar.dart';

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
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        child: Column(
          children: [
            const AddTransactionHeader(),
            const AddTransactionTabBar(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(
                      UIConstants.extraLargeBorderRadius,
                    ),
                    topRight: Radius.circular(
                      UIConstants.extraLargeBorderRadius,
                    ),
                  ),
                ),
                child: const AddTransactionCategoryGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
