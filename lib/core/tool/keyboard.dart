import 'package:flutter/material.dart';
import 'package:kmonie/core/exports.dart';

class AppKeyboard extends StatelessWidget {
  final void Function(String value)? onValueChanged;

  const AppKeyboard({super.key, this.onValueChanged});

  @override
  Widget build(BuildContext context) {
    final items = <_KeySpec>[
      _KeySpec.text('7'),
      _KeySpec.text('8'),
      _KeySpec.text('9'),
      _KeySpec.widget(
        value: 'TODAY',
        child: const Icon(Icons.calendar_month, color: ColorConstants.primary, size: UIConstants.largeIconSize),
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
        final totalSpacing = UIConstants.smallGridSpacing * (UIConstants.defaultGridCrossAxisCount - 1);
        final itemWidth = (constraints.maxWidth - totalSpacing) / UIConstants.defaultGridCrossAxisCount;
        final itemHeight = UIConstants.largeButtonHeight;
        return Wrap(
          spacing: UIConstants.smallGridSpacing,
          runSpacing: UIConstants.smallGridSpacing,
          children: items.map((spec) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: InkWell(
                onTap: (){
                  onValueChanged?.call(spec.value);
                },
                child: _KeyButton(
                  spec: spec,
                ),
              ),
            );
          }).toList(),
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
    final bgColor = spec.value=='DONE' ? Colors.grey : Colors.white;
    return Container(
      decoration: BoxDecoration(color: bgColor, borderRadius: const BorderRadius.all(Radius.circular(4))),
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
