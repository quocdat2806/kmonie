enum MainTabs {
  home(0, 'Trang chủ'),
  chart(1, 'Biểu đồ'),
  report(2, 'Báo cáo'),
  profile(3, 'Tôi');
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
