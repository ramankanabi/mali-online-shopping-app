import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheManager {
  final _cacheManager = CacheManager(
    Config(
      "productImages",
      stalePeriod: const Duration(days: 7),
    ),
  );

  CacheManager get cacheManager => _cacheManager;

  Future<void> resetImageCache() async {
    DefaultCacheManager().removeFile("productImages");
  }
}
