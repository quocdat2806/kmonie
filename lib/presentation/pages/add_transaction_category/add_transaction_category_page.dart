import 'package:flutter/material.dart';
import 'package:kmonie/presentation/pages/add_transaction/widgets/transaction_tab_bar.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/export.dart';
import '../../../core/navigation/exports.dart';
import '../../widgets/exports.dart';

class AddTransactionCategoryPage extends StatelessWidget {
  const AddTransactionCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Column(
          children: [_buildAppBar(context), const TransactionTabBar()],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: TextConstants.addTransactionTitle,
      leading: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: UIConstants.mediumContainerSize,
          minHeight: UIConstants.mediumContainerSize,
        ),
        child: Ink(
          decoration: const ShapeDecoration(shape: StadiumBorder()),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () => AppNavigator(context: context).pop(),
            child: Center(
              child: Text(
                TextConstants.cancelButtonText,
                style: AppTextStyle.blackS14Medium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
