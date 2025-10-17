import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/generated/assets.dart';
import 'package:kmonie/presentation/bloc/transaction_actions/transaction_actions.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class TransactionActionsInputHeader extends StatelessWidget {
  final TextEditingController noteController;
  final FocusNode noteFocusNode;

  const TransactionActionsInputHeader({
    super.key,
    required this.noteController,
    required this.noteFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TransactionActionsBloc, TransactionActionsState, int>(
      selector: (state) => state.amount,
      builder: (context, amount) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  Assets.svgsCccd,
                  width: AppUIConstants.largeIconSize,
                  height: AppUIConstants.largeIconSize,
                ),
                Text(amount.toString(), style: AppTextStyle.blackS20Bold),
              ],
            ),
            const SizedBox(height: AppUIConstants.smallPadding),
            Container(
              decoration: BoxDecoration(
                color: AppColorConstants.white,
                borderRadius: BorderRadius.circular(
                  AppUIConstants.smallBorderRadius,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppUIConstants.smallPadding,
              ),
              child: Row(
                children: [
                  Text(AppTextConstants.note, style: AppTextStyle.greyS14),
                  Expanded(
                    child: AppTextField(
                      textInputAction: TextInputAction.done,
                      controller: noteController,
                      focusNode: noteFocusNode,
                      onChanged: (value) => context
                          .read<TransactionActionsBloc>()
                          .add(NoteChanged(value)),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: true,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppUIConstants.smallPadding,
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.camera_alt_outlined),
                ],
              ),
            ),
            const SizedBox(height: AppUIConstants.smallPadding),
          ],
        );
      },
    );
  }
}
