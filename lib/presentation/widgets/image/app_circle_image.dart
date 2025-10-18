import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:kmonie/core/constants/constants.dart';

class AppCircleImage extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color backgroundColor;
  final Widget? fallbackIcon;

  const AppCircleImage({super.key, required this.imageUrl, this.size = 56, this.backgroundColor = AppColorConstants.white, this.fallbackIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        image: imageUrl != null && imageUrl!.isNotEmpty ? DecorationImage(image: CachedNetworkImageProvider(imageUrl!), fit: BoxFit.cover) : null,
      ),
      child: imageUrl == null || imageUrl!.isEmpty ? Center(child: fallbackIcon ?? const Icon(Icons.person)) : null,
    );
  }
}
