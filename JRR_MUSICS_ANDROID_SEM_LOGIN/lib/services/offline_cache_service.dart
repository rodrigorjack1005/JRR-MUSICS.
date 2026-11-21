import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class OfflineCacheService {
  static final CacheManager cache = CacheManager(
    Config(
      'jrrMusicCache',
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 100,
    ),
  );

  Future<String> download(String url) async {
    final file = await cache.getSingleFile(url);
    return file.path;
  }

  Future<void> clear() => cache.emptyCache();
}
