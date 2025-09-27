import 'package:flutter/material.dart';

class CustomKeyboard extends StatefulWidget {
  final void Function(String value)? onValueChanged;
  final void Function()? onConfirm;

  const CustomKeyboard({super.key, this.onValueChanged, this.onConfirm});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  String _value = '0';

  void _onKeyTap(String key) {
    setState(() {
      if (key == "⌫") {
        if (_value.length > 1) {
          _value = _value.substring(0, _value.length - 1);
        } else {
          _value = '0';
        }
      } else if (key == '✓') {
        widget.onConfirm?.call();
        return; // không bắn onValueChanged khi confirm
      } else {
        if (_value == '0') {
          _value = key;
        } else {
          _value += key;
        }
      }
    });
    widget.onValueChanged?.call(_value);
  }

  @override
  Widget build(BuildContext context) {
    // 16 ô, 4 cột
    final items = <_KeySpec>[
      _KeySpec.text('7'),
      _KeySpec.text('8'),
      _KeySpec.text('9'),
      _KeySpec.widget(
        value: 'TODAY', // giá trị tượng trưng, không ảnh hưởng số
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.calendar_month, size: 18),
            SizedBox(width: 6),
            Text('Hôm nay'),
          ],
        ),
        onTapOverride: () {
          // Nếu cần xử lý “Hôm nay”, thêm hành vi tại đây.
          // Tạm thời không thay đổi _value.
        },
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
      _KeySpec.widget(
        value: '⌫',
        child: const Icon(Icons.backspace_outlined),
      ),
      _KeySpec.widget(
        value: '✓',
        child: const Icon(Icons.check),
        isCheckKey: true, // Nền xám cho key check
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = 4;
        final spacing = 8.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final itemWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;
        final itemHeight = 56.0;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((spec) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: _KeyButton(
                spec: spec,
                onTap: () {
                  if (spec.onTapOverride != null) {
                    spec.onTapOverride!.call();
                  } else {
                    _onKeyTap(spec.value);
                  }
                },
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
  final VoidCallback onTap;

  const _KeyButton({required this.spec, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bgColor = spec.isCheckKey
        ? Colors.grey.shade200 // chỉ phím check màu xám
        : Colors.white;        // còn lại nền trắng

    final borderColor = Colors.grey.shade300;

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: spec.child ??
              Text(
                spec.value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
        ),
      ),
    );
  }
}

class _KeySpec {
  final String value;
  final Widget? child;
  final bool isCheckKey;
  final VoidCallback? onTapOverride;

  _KeySpec._({
    required this.value,
    this.child,
    this.isCheckKey = false,
    this.onTapOverride,
  });

  factory _KeySpec.text(String value) => _KeySpec._(value: value);

  factory _KeySpec.widget({
    required String value,
    required Widget child,
    bool isCheckKey = false,
    VoidCallback? onTapOverride,
  }) =>
      _KeySpec._(
        value: value,
        child: child,
        isCheckKey: isCheckKey,
        onTapOverride: onTapOverride,
      );
}
