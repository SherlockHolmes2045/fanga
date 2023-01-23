import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class Di {
  final String apiUrl = "https://fanga.ivanlemovou.cm/";

  final String rootDir = "storage/emulated/0/Android/media/";

  final Dio dio = new Dio();

  final DioCacheManager dioCacheManager = DioCacheManager(CacheConfig());
}
