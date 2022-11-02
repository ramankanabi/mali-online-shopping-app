import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class DioOptions {
  final Options _dioOptions = buildCacheOptions(
    const Duration(days: 7),
    forceRefresh: true,
    maxStale: const Duration(
      days: 10,
    ),
  );

  Options get dioOptions => _dioOptions;

  final DioCacheManager _dioCacheManager = DioCacheManager(
    CacheConfig(baseUrl: "https://gentle-crag-94785.herokuapp.com"),
  );

  DioCacheManager get dioCacheManager => _dioCacheManager;
}
