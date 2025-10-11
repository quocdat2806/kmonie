import 'package:kmonie/core/constants/constants.dart';

enum MainTabs {
  home(0, AppTextConstants.home),
  chart(1, AppTextConstants.chart),
  report(2, AppTextConstants.report),
  profile(3, AppTextConstants.profile);

  const MainTabs(this.tabIndex, this.label);

  final int tabIndex;
  final String label;

  static MainTabs fromIndex(int index) {
    return MainTabs.values.firstWhere(
      (type) => type.tabIndex == index,
      orElse: () => MainTabs.home,
    );
  }

  static const int totalTypes = 4;
}
