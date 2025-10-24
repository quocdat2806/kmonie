import 'package:flutter/material.dart';

import 'package:kmonie/core/constants/constants.dart';
import 'package:kmonie/core/text_style/text_style.dart';
import 'package:kmonie/core/utils/utils.dart';

class AppKeyboard extends StatelessWidget {
  final void Function(String value)? onValueChanged;
  final DateTime? selectDate;

  const AppKeyboard({super.key, this.onValueChanged, this.selectDate});

  @override
  Widget build(BuildContext context) {
    final List<_KeySpec> items = [
      _KeySpec.text('7'),
      _KeySpec.text('8'),
      _KeySpec.text('9'),
      _KeySpec.widget(
        value: 'SELECT_DATE',
        child: Wrap(
          children: [
            const Icon(Icons.calendar_month, color: AppColorConstants.primary, size: AppUIConstants.smallIconSize),
            Text(AppDateUtils.formatDateMonthAndDay(selectDate ?? DateTime.now()), style: AppTextStyle.blackS12Medium.copyWith(color: AppColorConstants.primary)),
          ],
        ),
      ),
      _KeySpec.text('4'),
      _KeySpec.text('5'),
      _KeySpec.text('6'),
      _KeySpec.text('+'),
      _KeySpec.text('1'),
      _KeySpec.text('2'),
      _KeySpec.text('3'),
      _KeySpec.text('-'),
      _KeySpec.text(','),
      _KeySpec.text('0'),
      _KeySpec.widget(value: 'CLEAR', child: const Icon(Icons.backspace_outlined)),
      _KeySpec.widget(value: 'DONE', child: const Icon(Icons.check)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = AppUIConstants.smallGridSpacing * (AppUIConstants.defaultGridCrossAxisCount - 1);
        final itemWidth = (constraints.maxWidth - totalSpacing) / AppUIConstants.defaultGridCrossAxisCount;
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: AppUIConstants.defaultGridCrossAxisCount, mainAxisSpacing: AppUIConstants.smallGridSpacing, crossAxisSpacing: AppUIConstants.smallGridSpacing, childAspectRatio: itemWidth / AppUIConstants.largeButtonHeight),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final spec = items[index];
            return InkWell(
              onTap: () => onValueChanged?.call(spec.value),
              child: _KeyButton(spec: spec),
            );
          },
        );
      },
    );
  }
}

class _KeyButton extends StatelessWidget {
  final _KeySpec spec;

  const _KeyButton({required this.spec});

  @override
  Widget build(BuildContext context) {
    final bgColor = spec.value == 'DONE' ? AppColorConstants.grey : AppColorConstants.white;
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(AppUIConstants.smallBorderRadius)),
      child: Center(child: spec.child ?? Text(spec.value, style: AppTextStyle.blackS20)),
    );
  }
}

class _KeySpec {
  final String value;
  final Widget? child;

  _KeySpec._({required this.value, this.child});

  factory _KeySpec.text(String value) => _KeySpec._(value: value);

  factory _KeySpec.widget({required String value, required Widget child}) => _KeySpec._(value: value, child: child);
}
