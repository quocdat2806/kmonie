import 'package:flutter/material.dart';
import 'package:kmonie/lib.dart';
import '../../../core/text_style/exports.dart';

class CustomKeyboard extends StatefulWidget {
  final void Function(String value)? onValueChanged;
  final void Function()? onConfirm;

  const CustomKeyboard({super.key, this.onValueChanged, this.onConfirm});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  String _value = '0';
  final TextEditingController _noteController = TextEditingController();

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
    return _buildKeypad();
  }

  Widget _buildKeypad() {
    final keys = [
      ["7", "8", "9",'OK'],
      ["4", "5", "6",'+'],
      ["1", "2", "3",'-'],
      [",", "0", "⌫",'V'],
    ];

    return Column(
      children: [
        for (var row in keys)
          Row(
            children: [
              for (var key in row)
                Expanded(
                  child: InkWell(
                    onTap: () => _onKeyTap(key),
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(key, style: AppTextStyle.blackS18Bold),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
