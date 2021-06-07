import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/utils/n_exception.dart';
import '../../di.dart';
import '../../service_locator.dart';

class SearchService{
  Future<List<Manga>> searchManga(String catalogName,String searchTerms,int page) async{
    try {
      final String uri = locator<Di>().apiUrl + "/manga/search";
      Response response = await locator<Di>().dio.post(
        uri,
        data: {'manga': searchTerms, 'source': catalogName,"page": page},
        options: buildCacheOptions(Duration(days: 7),
            maxStale: Duration(days: 7),
            forceRefresh: false,
            options: Options(headers: {
              'Content-Type': "application/json",
            })),
      );
      final items = response.data["data"].cast<Map<String, dynamic>>();
      List<Manga> result = items.map<Manga>((json) {
        return Manga.fromJson(json);
      }).toList();
      return result;
    }on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }
}
final SearchService searchService = SearchService();