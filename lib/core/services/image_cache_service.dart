import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kmonie/core/constants/banks.dart';

class ImageCacheService {
  ImageCacheService._();

  static final ImageCacheService instance = ImageCacheService._();

  Future<void> preloadBankLogos() async {
    try {
      for (final bank in BankConstants.vietNamBanks) {
        if (bank.logo.isNotEmpty) {
          try {
            CachedNetworkImageProvider(bank.logo, maxHeight: 80, maxWidth: 80, cacheKey: bank.logo).resolve(const ImageConfiguration());
          } catch (e) {
            continue;
          }
        }
      }
    } catch (e) {
      return;
    }
  }
}
