import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_event.freezed.dart';

@freezed
abstract class MainEvent with _$MainEvent {
  const factory MainEvent.switchTab(int index) = MainSwitchTab;
}
