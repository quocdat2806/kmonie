import 'package:flutter/material.dart';
import 'app_cached_network_image.dart';
import '../../../core/constant/exports.dart';

class AppCircleImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color backgroundColor;
  final Widget? fallbackIcon;

  const AppCircleImage({
    super.key,
    required this.imageUrl,
    this.size = 56,
    this.backgroundColor = Colors.white,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: ColorConstants.white),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Center(child: fallbackIcon ?? const Icon(Icons.person));
    }
    return AppCachedNetworkImage(
      imageUrl: imageUrl!,
      width: size,
      height: size,
    );
  }
}
