import '../constant/exports.dart';

enum MainTabs {
  home(0, TextConstants.homeLabel),
  chart(1, TextConstants.chartLabel),
  report(2, TextConstants.reportLabel),
  profile(3, TextConstants.profileLabel);

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
