import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../../generated/assets.dart';
import '../../../bloc/export.dart';
import '../../../widgets/export.dart';

class AddTransactionInputHeader extends StatelessWidget {
  final TextEditingController noteController;
  final FocusNode noteFocusNode;

  const AddTransactionInputHeader({super.key, required this.noteController, required this.noteFocusNode});

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
                SvgPicture.asset(Assets.svgsCccd, width: UIConstants.largeIconSize, height: UIConstants.largeIconSize),
                Text(amount.toString(), style: AppTextStyle.blackS20Bold),
              ],
            ),
            const SizedBox(height: UIConstants.smallPadding),
            Container(
              decoration: BoxDecoration(color: ColorConstants.white, borderRadius: BorderRadius.circular(UIConstants.smallBorderRadius)),
              padding: const EdgeInsets.symmetric(horizontal: UIConstants.smallPadding),
              child: Row(
                children: [
                  Text(TextConstants.note, style: AppTextStyle.greyS14),
                  Expanded(
                    child: AppTextField(
                      controller: noteController,
                      focusNode: noteFocusNode,
                      onChanged: (value) => context.read<AddTransactionBloc>().add(NoteChanged(value)),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                        filled: true,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: UIConstants.smallPadding),
                      ),
                    ),
                  ),
                  Icon(Icons.camera_alt_outlined),
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
