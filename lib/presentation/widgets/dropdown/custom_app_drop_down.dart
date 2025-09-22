import 'package:flutter/material.dart';

class CustomDropdownOverlay {
  static OverlayEntry? _overlayEntry;

  static void show<T>({
    required BuildContext context,
    required GlobalKey targetKey,
    required List<T> items,
    required Widget Function(T item) itemBuilder,
    required void Function(T item) onItemSelected,
    double verticalOffset = 4,
    double maxHeight = 200,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4)),
  }) {
    _remove();

    final RenderBox renderBox =
    targetKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _remove,
              ),
            ),

            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + verticalOffset,
              width: size.width,
              child: Material(
                elevation: 1,
                borderRadius: borderRadius,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: items.map((item) {
                      return InkWell(
                        onTap: () {
                          onItemSelected(item);
                          _remove();
                        },
                        child: itemBuilder(item),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void _remove() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  static void hide() => _remove();
}
