import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/lib.dart';
import 'package:kmonie/presentation/widgets/keyboard/app_keyboard.dart';
import 'widgets/transaction_category_grid.dart';
import 'widgets/transaction_tab_bar.dart';

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

      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstants.yellow,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                CustomAppBar(
                  title: 'Thêm',
                  leading: Center(
                    child: Text('Hủy', style: AppTextStyle.blackS14Medium),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {},
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstants.divider,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                            UIConstants.smallPadding,
                          ),
                          child: SvgPicture.asset(Assets.svgsChecklist),
                        ),
                      ),
                    ),
                    const SizedBox(width: UIConstants.defaultPadding),
                  ],
                ),
                const TransactionTabBar(),
                const SizedBox(height: UIConstants.defaultPadding),
               const Expanded(
                  child: ColoredBox(
                    color: ColorConstants.white,
                    child: Padding(
                      padding: EdgeInsets.all(UIConstants.smallPadding),
                      child: TransactionCategoryGrid(),
                    ),
                  ),
                ),
              ],
            ),
            BlocBuilder<AddTransactionBloc, AddTransactionState>(
              builder: (context, state) {
                return state.isKeyboardVisible==true ?AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  bottom:  0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.red,
                    height: MediaQuery.sizeOf(context).height * 0.45,
                    width: double.infinity,
                    child: const CustomKeyboard(),
                  ),
                ):const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
