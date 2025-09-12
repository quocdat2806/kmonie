part of 'main_bloc.dart';

sealed class MainEvent extends Equatable {
  const MainEvent();
}
final class MainSwitchTab extends MainEvent {
  const MainSwitchTab(this.index);
  final int index;

  @override
  List<Object?> get props => <Object?>[index];
}
