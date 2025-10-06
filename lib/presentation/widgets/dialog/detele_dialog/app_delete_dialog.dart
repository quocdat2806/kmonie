import 'package:flutter/material.dart';
import 'package:kmonie/lib.dart';

class AppDeleteDialog extends StatelessWidget {
  final VoidCallback? onConfirm;
  const AppDeleteDialog({super.key,this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      content:  Text('Ban co chan muon xoa khong',style: AppTextStyle.redS14, textAlign: TextAlign.center,),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => Navigator.of(context).pop(),
                text: "Hủy",
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                onPressed: onConfirm ?? () {},
                text: "Xác nhận",
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
