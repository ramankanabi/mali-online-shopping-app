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

  Future<void> getImageCache() async {
    final imageCache = await DefaultCacheManager()
        .getFileFromMemory("364585489EE200ABE6DF2530C07F4B97");
    print(imageCache?.file);
    // if (imageCache==null) {
    //   print("dont have cache");
    // } else {
    //   print("have cache");
    // }
  }
}
