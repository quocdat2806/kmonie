import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kmonie/core/constants/constants.dart';

class SvgCacheManager {
  static final SvgCacheManager _instance = SvgCacheManager._internal();
  factory SvgCacheManager() => _instance;
  SvgCacheManager._internal();

  final Map<String, SvgPicture> _cache = <String, SvgPicture>{};
  final Map<String, int> _usageCount = <String, int>{};
  static const int _maxCacheSize = 200;

  String _generateKey(String path, double size) {
    return '${path}_${size.toStringAsFixed(1)}';
  }

  SvgPicture getSvg(String path, double width, double height, {Color? color}) {
    final key = _generateKey(path, width);

    _usageCount[key] = (_usageCount[key] ?? 0) + 1;

    return _cache[key] ??= _createSvg(path, width, height, key, color);
  }

  SvgPicture _createSvg(
    String path,
    double width,
    double height,
    String key,
    Color? color,
  ) {
    if (_cache.length >= _maxCacheSize) {
      _evictLeastUsed();
    }

    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
        color ?? AppColorConstants.black,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (context) => const SizedBox(),
    );
  }

  void _evictLeastUsed() {
    if (_usageCount.isEmpty) return;
    String? leastUsedKey;
    int minUsage = double.maxFinite.toInt();

    for (final entry in _usageCount.entries) {
      if (entry.value < minUsage) {
        minUsage = entry.value;
        leastUsedKey = entry.key;
      }
    }

    if (leastUsedKey != null) {
      _cache.remove(leastUsedKey);
      _usageCount.remove(leastUsedKey);
    }
  }

  void clearCache() {
    _cache.clear();
    _usageCount.clear();
  }

  void preloadSvgs(List<String> paths, double size) {
    for (final path in paths) {
      getSvg(path, size, size);
    }
  }

  Map<String, dynamic> getDebugInfo() {
    return {
      'cacheSize': _cache.length,
      'maxSize': _maxCacheSize,
      'usageStats': Map<String, int>.from(_usageCount),
    };
  }
}
