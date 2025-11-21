import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';

class TimePickerWidget extends StatefulWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay>? onTimeChanged;
  const TimePickerWidget({super.key, this.selectedTime, this.onTimeChanged});
  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  late final ScrollController _hoursScrollController;
  late final ScrollController _minutesScrollController;
  late final ScrollController _timeTypeScrollController;
  static const double listHeight = 160;
  static const double _itemHeight = listHeight / 3;
  static const int _virtualMultiplier = 1000;
  bool _isScrolling = false;
  Timer? _scrollEndTimer;
  int _lastHourIndex = -1;
  int _lastMinuteIndex = -1;

  @override
  void initState() {
    super.initState();
    _hoursScrollController = ScrollController();
    _minutesScrollController = ScrollController();
    _timeTypeScrollController = ScrollController();
    _hoursScrollController.addListener(
      () => _onScroll(_hoursScrollController, _updateHourFromScroll),
    );
    _minutesScrollController.addListener(
      () => _onScroll(_minutesScrollController, _updateMinuteFromScroll),
    );
    _timeTypeScrollController.addListener(
      () => _onScroll(_timeTypeScrollController, _updatePeriodFromScroll),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentTime();
    });
  }

  @override
  void dispose() {
    _scrollEndTimer?.cancel();
    _hoursScrollController.dispose();
    _minutesScrollController.dispose();
    _timeTypeScrollController.dispose();
    super.dispose();
  }

  void _onScroll(ScrollController controller, VoidCallback updateCallback) {
    if (!controller.hasClients || _isScrolling) return;
    _scrollEndTimer?.cancel();
    _scrollEndTimer = Timer(const Duration(milliseconds: 100), () {
      _snapToNearestItem(controller, updateCallback);
    });
  }

  void _snapToNearestItem(
    ScrollController controller,
    VoidCallback updateCallback,
  ) async {
    if (!controller.hasClients || _isScrolling) return;
    final scrollOffset = controller.offset;
    final centerIndex = _getCenterIndex(scrollOffset);

    final targetScrollPosition = (centerIndex - 1) * _itemHeight;

    if ((controller.offset - targetScrollPosition).abs() > 0.5) {
      _isScrolling = true;
      await Future<void>.delayed(AppUIConstants.shortAnimationDuration);
      controller.animateTo(
        targetScrollPosition,
        duration: AppUIConstants.shortAnimationDuration,
        curve: Curves.easeOut,
      );
      _isScrolling = false;
      updateCallback();
      return;
    }
    updateCallback();
  }

  void _updateHourFromScroll() {
    if (!_hoursScrollController.hasClients) return;
    final scrollOffset = _hoursScrollController.offset;
    final centerIndex = _getCenterIndex(scrollOffset);
    final hours = AppDateUtils.generateAllHoursOfDay();
    final actualIndex = centerIndex % hours.length;

    if (_lastHourIndex != actualIndex) {
      _lastHourIndex = actualIndex;
      final newHour = hours[actualIndex];
      final currentTime = widget.selectedTime ?? TimeOfDay.now();
      widget.onTimeChanged?.call(
        TimeOfDay(hour: newHour, minute: currentTime.minute),
      );
    }
  }

  void _updateMinuteFromScroll() {
    if (!_minutesScrollController.hasClients) return;
    final scrollOffset = _minutesScrollController.offset;
    final centerIndex = _getCenterIndex(scrollOffset);
    final minutes = AppDateUtils.generateAllMinutesOfDay();
    final actualIndex = centerIndex % minutes.length;

    if (_lastMinuteIndex != actualIndex) {
      _lastMinuteIndex = actualIndex;
      final newMinute = minutes[actualIndex];
      final currentTime = widget.selectedTime ?? TimeOfDay.now();
      widget.onTimeChanged?.call(
        TimeOfDay(hour: currentTime.hour, minute: newMinute),
      );
    }
  }

  void _updatePeriodFromScroll() {
    if (!_timeTypeScrollController.hasClients) return;
    final scrollOffset = _timeTypeScrollController.offset;
    final centerIndex = _getCenterIndex(scrollOffset);
    final timeTypes = AppDateUtils.generateTimeType();

    final actualIndex = centerIndex.clamp(0, timeTypes.length - 1);

    final currentTime = widget.selectedTime ?? TimeOfDay.now();
    final currentHour = currentTime.hour;
    final currentMinute = currentTime.minute;
    final isAM = actualIndex == 0;
    final hour12 = currentHour % 12;
    final newHour = isAM ? hour12 : (hour12 == 0 ? 12 : hour12 + 12);

    if (currentHour != newHour) {
      widget.onTimeChanged?.call(
        TimeOfDay(hour: newHour, minute: currentMinute),
      );
    }
  }

  int _getCenterIndex(double scrollOffset) {
    return ((scrollOffset / _itemHeight) + 1).round();
  }

  void _scrollToCurrentTime() {
    final now = widget.selectedTime ?? TimeOfDay.now();
    final hours = AppDateUtils.generateAllHoursOfDay();
    final minutes = AppDateUtils.generateAllMinutesOfDay();

    final currentHourIndex = now.hour;
    final hourVirtualIndex =
        (_virtualMultiplier ~/ 2) * hours.length + currentHourIndex;
    final hourScrollPosition = (hourVirtualIndex - 1) * _itemHeight;
    _hoursScrollController.jumpTo(hourScrollPosition);

    final currentMinuteIndex = now.minute;
    final minuteVirtualIndex =
        (_virtualMultiplier ~/ 2) * minutes.length + currentMinuteIndex;
    final minuteScrollPosition = (minuteVirtualIndex - 1) * _itemHeight;
    _minutesScrollController.jumpTo(minuteScrollPosition);

    final currentPeriodIndex = now.hour < 12 ? 0 : 1;
    final periodScrollPosition = (currentPeriodIndex - 1) * _itemHeight;
    _timeTypeScrollController.jumpTo(periodScrollPosition.clamp(0, 0));
  }

  @override
  Widget build(BuildContext context) {
    final selectedTime = widget.selectedTime ?? TimeOfDay.now();
    return SizedBox(
      height: listHeight,
      child: Row(
        children: [
          Expanded(child: _buildHoursList(selectedTime)),
          _buildSeparator(),
          Expanded(child: _buildMinutesList(selectedTime)),
          Expanded(child: _buildTimeTypeList(selectedTime)),
        ],
      ),
    );
  }

  Widget _buildHoursList(TimeOfDay selectedTime) {
    final hours = AppDateUtils.generateAllHoursOfDay();
    final virtualCount = hours.length * _virtualMultiplier;

    return ListView.builder(
      controller: _hoursScrollController,
      physics: const BouncingScrollPhysics(),
      itemExtent: _itemHeight,
      itemCount: virtualCount,
      itemBuilder: (context, index) {
        final actualIndex = index % hours.length;
        final scrollOffset = _hoursScrollController.hasClients
            ? _hoursScrollController.offset
            : 0;
        final centerIndex = _getCenterIndex(scrollOffset.toDouble());
        final currentCenterActualIndex = centerIndex % hours.length;
        final isSelected = actualIndex == currentCenterActualIndex;

        return Center(
          child: Text(
            hours[actualIndex].toString().padLeft(2, '0'),
            style: isSelected
                ? AppTextStyle.blackS28Bold
                : AppTextStyle.greyS28Bold.copyWith(
                    color: AppColorConstants.greyWhite,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildMinutesList(TimeOfDay selectedTime) {
    final minutes = AppDateUtils.generateAllMinutesOfDay();
    final virtualCount = minutes.length * _virtualMultiplier;

    return ListView.builder(
      controller: _minutesScrollController,
      physics: const BouncingScrollPhysics(),
      itemExtent: _itemHeight,
      itemCount: virtualCount,
      itemBuilder: (context, index) {
        final actualIndex = index % minutes.length;
        final scrollOffset = _minutesScrollController.hasClients
            ? _minutesScrollController.offset
            : 0;
        final centerIndex = _getCenterIndex(scrollOffset.toDouble());
        final currentCenterActualIndex = centerIndex % minutes.length;
        final isSelected = actualIndex == currentCenterActualIndex;

        return Center(
          child: Text(
            minutes[actualIndex].toString().padLeft(2, '0'),
            style: isSelected
                ? AppTextStyle.blackS28Bold
                : AppTextStyle.greyS28Bold.copyWith(
                    color: AppColorConstants.greyWhite,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTimeTypeList(TimeOfDay selectedTime) {
    final timeTypes = AppDateUtils.generateTimeType();

    return ListView.builder(
      controller: _timeTypeScrollController,
      physics: const BouncingScrollPhysics(),
      itemExtent: _itemHeight,
      itemCount: timeTypes.length,
      itemBuilder: (context, index) {
        final currentHour = selectedTime.hour;
        final currentPeriodIndex = currentHour < 12 ? 0 : 1;
        final isSelected = index == currentPeriodIndex;

        return Center(
          child: Text(
            timeTypes[index],
            style: isSelected
                ? AppTextStyle.blackS28Bold
                : AppTextStyle.greyS28Bold.copyWith(
                    color: AppColorConstants.greyWhite,
                  ),
          ),
        );
      },
    );
  }

  Widget _buildSeparator() {
    return SizedBox(
      height: listHeight,
      child: Center(child: Text(':', style: AppTextStyle.blackS28Bold)),
    );
  }
}
