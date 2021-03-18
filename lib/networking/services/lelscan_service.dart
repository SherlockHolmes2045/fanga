import 'package:dio/dio.dart';
import 'package:manga_reader/models/Chapter.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/utils/n_exception.dart';
import '../../di.dart';
import '../../service_locator.dart';

class LelscanService {
  Future<List<Manga>> popularMangaList(String catalogName, int page) async {
    try {
      final String uri =
          locator<Di>().apiUrl + "/manga/$catalogName/popularMangaList/$page";
      Response response = await locator<Di>().dio.get(
            uri,
            options: Options(headers: {
              'Content-Type': "application/json",
            }),
          );
      final items =
          response.data["data"]["mangas"].cast<Map<String, dynamic>>();
      List<Manga> mangas = items.map<Manga>((json) {
        return Manga.fromJson(json);
      }).toList();
      return mangas;
    } on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }

  Future<Manga> mangaDetails(Manga manga, String catalogName) async {
    try {
      final String uri = locator<Di>().apiUrl + "/manga/details";
      Response response = await locator<Di>().dio.post(
            uri,
            data: {'manga': manga.toMap(), 'catalog': catalogName},
            options: Options(headers: {
              'Content-Type': "application/json",
            }),
          );
      print(response.data["manga"]);
      //final items = response.data["manga"].cast<Map<String, dynamic>>();
      Manga result = Manga.fromJson(response.data["manga"]);
      return result;
    } on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }

  Future<List<Chapter>> mangaChapters(Manga manga,String catalogName) async {
    try {
      final String uri = locator<Di>().apiUrl + "/manga/chapters";
      Response response = await locator<Di>().dio.post(
        uri,
        data: {'manga': manga, 'catalog': catalogName},
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      final items = response.data["data"]["chapters"].cast<Map<String, dynamic>>();
      List<Chapter> result = items.map<Chapter>((json) {
        return Chapter.fromJson(json);
      }).toList();
    }on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }
}

final LelscanService lelscanService = LelscanService();
