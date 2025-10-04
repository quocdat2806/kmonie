import '../constant/export.dart';

enum MainTabs {
  home(0, TextConstants.home),
  chart(1, TextConstants.chart),
  report(2, TextConstants.report),
  profile(3, TextConstants.profile);

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
