import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/navigation/app_navigation.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/presentation/widgets/widgets.dart';

class AppDevelopmentProcessDialog extends StatelessWidget {
  const AppDevelopmentProcessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppUIConstants.defaultBorderRadius),
      ),
      actionsAlignment: MainAxisAlignment.center,
      content: Text(
        AppTextConstants.developmentProcess,
        style: AppTextStyle.redS14,
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Row(
          spacing: AppUIConstants.smallSpacing,
          children: [
            Expanded(
              child: AppButton(
                onPressed: () => {AppNavigator(context: context).pop()},
                text: AppTextConstants.confirm,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
