import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/enums/enums.dart';

class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _scaffoldMessengerKey;

  static void showSnackBar({
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
  }) {
    final scaffoldMessenger = _scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null) return;

    final snackBar = SnackBar(
      content: _SnackBarContent(message: message, type: type),
      duration: duration,
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppUIConstants.defaultPadding),
      padding: EdgeInsets.zero,
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  // static Color _getActionColor(SnackBarType type) {
  //   switch (type) {
  //     case SnackBarType.success:
  //       return ColorConstants.green;
  //     case SnackBarType.error:
  //       return ColorConstants.red;
  //     case SnackBarType.warning:
  //       return ColorConstants.primary;
  //     case SnackBarType.info:
  //       return ColorConstants.secondary;
  //   }
  // }

  static void showSuccess(String message) {
    showSnackBar(message: message, type: SnackBarType.success);
  }

  static void showError(String message) {
    showSnackBar(message: message, type: SnackBarType.error);
  }

  static void showWarning(String message) {
    showSnackBar(message: message, type: SnackBarType.warning);
  }

  static void showInfo(String message) {
    showSnackBar(message: message);
  }
}

class _SnackBarContent extends StatelessWidget {
  final String message;
  final SnackBarType type;

  const _SnackBarContent({required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // return Container(
    //   padding: const EdgeInsets.symmetric(
    //     horizontal: UIConstants.defaultPadding,
    //     vertical: UIConstants.smallPadding,
    //   ),
    //   decoration: BoxDecoration(
    //     color: _getBackgroundColor(),
    //     borderRadius: BorderRadius.circular(UIConstants.defaultBorderRadius),
    //     border: Border.all(color: _getBorderColor()),
    //   ),
    //   child: Row(
    //     children: [
    //       Icon(
    //         _getIcon(),
    //         color: _getIconColor(),
    //         size: UIConstants.defaultIconSize,
    //       ),
    //       const SizedBox(width: UIConstants.smallPadding),
    //       Expanded(
    //         child: Text(
    //           message,
    //           style: _getTextStyle(),
    //           maxLines: UIConstants.defaultMaxLines,
    //           overflow: TextOverflow.ellipsis,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  // Color _getBackgroundColor() {
  //   switch (type) {
  //     case SnackBarType.success:
  //       return ColorConstants.green.withAlpha(10);
  //     case SnackBarType.error:
  //       return ColorConstants.red.withAlpha(10);
  //     case SnackBarType.warning:
  //       return ColorConstants.primary.withAlpha(10);
  //     case SnackBarType.info:
  //       return ColorConstants.secondary.withAlpha(10);
  //   }
  // }
  //
  // Color _getBorderColor() {
  //   switch (type) {
  //     case SnackBarType.success:
  //       return ColorConstants.green.withAlpha(30);
  //     case SnackBarType.error:
  //       return ColorConstants.red.withAlpha(30);
  //     case SnackBarType.warning:
  //       return ColorConstants.primary.withAlpha(30);
  //     case SnackBarType.info:
  //       return ColorConstants.secondary.withAlpha(30);
  //   }
  // }
  //
  // Color _getIconColor() {
  //   switch (type) {
  //     case SnackBarType.success:
  //       return ColorConstants.green;
  //     case SnackBarType.error:
  //       return ColorConstants.red;
  //     case SnackBarType.warning:
  //       return ColorConstants.primary;
  //     case SnackBarType.info:
  //       return ColorConstants.secondary;
  //   }
  // }
  //
  // IconData _getIcon() {
  //   switch (type) {
  //     case SnackBarType.success:
  //       return Icons.check_circle;
  //     case SnackBarType.error:
  //       return Icons.error;
  //     case SnackBarType.warning:
  //       return Icons.warning;
  //     case SnackBarType.info:
  //       return Icons.info;
  //   }
  // }
  //
  // TextStyle _getTextStyle() {
  //   switch (type) {
  //     case SnackBarType.success:
  //       return AppTextStyle.greenS14Medium;
  //     case SnackBarType.error:
  //       return AppTextStyle.redS14Medium;
  //     case SnackBarType.warning:
  //       return AppTextStyle.yellowS14Medium;
  //     case SnackBarType.info:
  //       return AppTextStyle.secondaryS14Medium;
  //   }
  // }
}
