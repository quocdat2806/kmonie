part of 'main_bloc.dart';

 class MainState extends Equatable {
  const MainState({
    this.selectedIndex = 0,
  });
  final int selectedIndex;
  MainState copyWith({int? selectedIndex}) {
    return MainState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => <Object?>[selectedIndex];
}
