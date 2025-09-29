import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/cache/export.dart';
import '../../../../core/constant/exports.dart';
import '../../../../core/text_style/export.dart';
import '../../../bloc/exports.dart';
import '../../../widgets/exports.dart';

import '../../../../generated/assets.dart';

class AddTransactionInputHeader extends StatelessWidget {
  final TextEditingController noteController;
  final FocusNode noteFocusNode;

  const AddTransactionInputHeader({
    super.key,
    required this.noteController,
    required this.noteFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddTransactionBloc, AddTransactionState, int>(
      selector: (state) => state.amount,
      builder: (context, amount) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgCacheManager().getSvg(
                  Assets.svgsCccd,
                  UIConstants.largeIconSize,
                  UIConstants.largeIconSize,
                ),
                Text(amount.toString(), style: AppTextStyle.blackS20Bold),
              ],
            ),
            const SizedBox(height: UIConstants.smallPadding),
            Container(
              decoration: BoxDecoration(
                color: ColorConstants.white,
                borderRadius: BorderRadius.circular(
                  UIConstants.smallBorderRadius,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: UIConstants.smallPadding,
              ),
              child: Row(
                children: [
                  Text(TextConstants.noteLabel, style: AppTextStyle.greyS14),
                  Expanded(
                    child: AppTextField(
                      controller: noteController,
                      focusNode: noteFocusNode,
                      onChanged: (value) => context
                          .read<AddTransactionBloc>()
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
                          vertical: UIConstants.smallPadding,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: SvgCacheManager().getSvg(
                      Assets.svgsCamera,
                      UIConstants.smallIconSize,
                      UIConstants.smallIconSize,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: UIConstants.smallPadding),
          ],
        );
      },
    );
  }
}
