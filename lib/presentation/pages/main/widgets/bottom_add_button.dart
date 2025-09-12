import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kmonie/core/constants/color_constants.dart';
import 'package:kmonie/generated/assets.dart';

class BottomAddButton extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onTab;
  const BottomAddButton({
    super.key,
    required this.currentIndex,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 16,
            child: GestureDetector(
              onTap: onTab,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.yellow,
                ),
                child: SvgPicture.asset(Assets.svgsAdd, width: 28, height: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
