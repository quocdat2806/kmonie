import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';
import 'package:kmonie/generated/generated.dart';
import 'package:kmonie/presentation/blocs/blocs.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class ChartTransactionTypeDropdown extends StatelessWidget {
  final GlobalKey dropdownKey;

  const ChartTransactionTypeDropdown({super.key, required this.dropdownKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChartBloc, ChartState>(
      buildWhen: (previous, current) => previous.selectedTransactionType != current.selectedTransactionType,
      builder: (context, state) {
        return InkWell(
          splashColor: Colors.transparent,
          key: dropdownKey,
          onTap: () => _showTransactionTypeDropdown(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppUIConstants.smallSpacing,
            children: [
              Text(state.selectedTransactionType.displayName, style: AppTextStyle.blackS18Bold),
              SvgUtils.icon(assetPath: Assets.svgsArrowDown, size: SvgSizeType.medium),
            ],
          ),
        );
      },
    );
  }

  void _showTransactionTypeDropdown(BuildContext context) {
    const allowedTypes = [TransactionType.expense, TransactionType.income];
    final options = List<String>.generate(allowedTypes.length, (index) => allowedTypes[index].displayName);

    AppDropdown.show<String>(
      context: context,
      targetKey: dropdownKey,
      items: options,
      itemBuilder: (item) => Padding(
        padding: const EdgeInsets.all(AppUIConstants.smallPadding),
        child: Text(item, style: AppTextStyle.blackS14Medium),
      ),
      onItemSelected: (value) {
        final selectedType = allowedTypes.firstWhere((t) => t.displayName == value, orElse: () => TransactionType.expense);
        context.read<ChartBloc>().add(ChangeTransactionType(selectedType));
      },
    );
  }
}
