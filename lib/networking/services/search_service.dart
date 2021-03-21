import 'package:dio/dio.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/utils/n_exception.dart';
import '../../di.dart';
import '../../service_locator.dart';

class SearchService{
  Future<List<Manga>> searchManga(String catalogName,String searchTerms,int page) async{
    try {
      final String uri = locator<Di>().apiUrl + "/manga/search";
      Response response = await locator<Di>().dio.post(
        uri,
        data: {'manga': searchTerms, 'source': catalogName,"page": page},
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      print(response.data);
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