import 'package:flutter/material.dart';
import 'package:kmonie/lib.dart';
import '../../../core/constant/exports.dart';
import '../../../core/text_style/exports.dart';

class CustomKeyboard extends StatefulWidget {
  final void Function(String value)? onValueChanged;
  final void Function()? onConfirm;

  const CustomKeyboard({super.key, this.onValueChanged, this.onConfirm});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  String _value = "0";
  final TextEditingController _noteController = TextEditingController();

  void _onKeyTap(String key) {
    setState(() {
      if (key == "⌫") {
        if (_value.length > 1) {
          _value = _value.substring(0, _value.length - 1);
        } else {
          _value = "0";
        }
      } else if (key == "✓") {
        widget.onConfirm?.call();
      } else {
        if (_value == "0") {
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
    return ColoredBox(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(UIConstants.smallPadding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.center_focus_weak_rounded),
                Text("0", style: AppTextStyle.blackS20Bold),
              ],
            ),
            ColoredBox(
              color: ColorConstants.white,
              child: Row(
                children: [
                  Text('Ghi chú: ', style: AppTextStyle.greyS14),
                  Expanded(
                    child: AppTextField(
                      border: InputBorder.none,
                      borderBottomColor: Colors.transparent,
                      controller: _noteController,
                      hintText: "Ghi chu",
                    ),
                  ),
                  Icon(Icons.camera_alt),
                ],
              ),
            ),

            // Row(
            //   children: [
            //     IconButton(
            //       icon: const Icon(Icons.image),
            //       onPressed: () {},
            //     ),
            //     Expanded(
            //       child: TextField(
            //         controller: _noteController,
            //         decoration: const InputDecoration(
            //           hintText: 'Ghi chú: Nhập ghi chú...',
            //           border: InputBorder.none,
            //         ),
            //       ),
            //     ),
            //     Text(
            //       _value,
            //       style: AppTextStyle.blackS18Bold,
            //     ),
            //     IconButton(
            //       icon: const Icon(Icons.camera_alt_outlined),
            //       onPressed: () {},
            //     ),
            //   ],
            // ),
            // const Divider(height: 1),

            // --- Grid phím ---
            // _buildKeypad(),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ["7", "8", "9"],
      ["4", "5", "6"],
      ["1", "2", "3"],
      [",", "0", "⌫"],
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
        // --- Hàng confirm ---
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _onKeyTap("✓"),
                child: Container(
                  height: 60,
                  color: ColorConstants.yellow,
                  alignment: Alignment.center,
                  child: const Icon(Icons.check, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
