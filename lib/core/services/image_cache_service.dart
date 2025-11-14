import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/constants.dart';

class ImageCacheService {
  ImageCacheService._();

  static final ImageCacheService instance = ImageCacheService._();

  Future<void> preloadBankLogos() async {
    for (final bank in BankConstants.vietNamBanks) {
      if (bank.logo.isNotEmpty) {
        try {
          CachedNetworkImageProvider(
            bank.logo,
            maxHeight: AppUIConstants.extraLargeContainerSize.toInt(),
            maxWidth: AppUIConstants.extraLargeContainerSize.toInt(),
            cacheKey: bank.logo,
          ).resolve(const ImageConfiguration());
        } catch (e) {
          continue;
        }
      }
    }
  }
}
