import 'package:flutter/material.dart';

import '../../../../core/constant/export.dart';
import '../../../../core/text_style/export.dart';
import '../../../widgets/export.dart';

class AppDeleteDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  const AppDeleteDialog({super.key, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius)),
      actionsAlignment: MainAxisAlignment.center,
      content: Text(TextConstants.confirmDeleteTitle, style: AppTextStyle.redS14, textAlign: TextAlign.center),
      actions: <Widget>[
        Row(
          spacing: UIConstants.smallSpacing,
          children: [
            Expanded(
              child: AppButton(onPressed: () => Navigator.of(context).pop(), text: TextConstants.cancel, backgroundColor: Colors.transparent),
            ),
            Expanded(
              child: AppButton(onPressed: onConfirm ?? () {}, text: TextConstants.confirm, backgroundColor: Colors.transparent),
            ),
          ],
        ),
      ],
    );
  }
}
