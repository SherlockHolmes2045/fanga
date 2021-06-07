import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

class Di {
  final String apiUrl = "http://178.128.155.160:3000";

  final Dio dio = new Dio();

  final DioCacheManager dioCacheManager = DioCacheManager(CacheConfig());
}
