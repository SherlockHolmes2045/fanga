import 'package:dio/dio.dart';
import 'package:fanga/di.dart';
import 'package:fanga/models/chapter.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/service_locator.dart';
import 'package:fanga/utils/n_exception.dart';

class CloudfareService {

  Future<List<Manga>?> popularMangaList(String catalogName, int page) async {
    try {
      final String uri =
          locator<Di>().apiUrl + "/cloudfare/$catalogName/popularMangaList/$page";
      print(uri);
      Response response = await locator<Di>().dio.get(
        uri,
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      final items =
      response.data["data"]["mangas"].cast<Map<String, dynamic>>();
      List<Manga>? mangas = items.map<Manga>((json) {
        return Manga.fromJson(json);
      }).toList();
      return mangas;
    } on DioError catch (e) {
      print(e.response);
      throw new NException(e);
    }
  }

  Future<List<Manga>?> topMangaList(String catalogName, int page) async {
    try {
      final String uri =
          locator<Di>().apiUrl + "/cloudfare/$catalogName/top/$page";
      Response response = await locator<Di>().dio.get(
        uri,
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      final items =
      response.data["data"]["mangas"].cast<Map<String, dynamic>>();
      List<Manga>? mangas = items.map<Manga>((json) {
        return Manga.fromJson(json);
      }).toList();
      return mangas;
    } on DioError catch (e) {
      print(e);
      throw new NException(e);
    }
  }

  Future<Response> mangaList(String catalogName, int? page) async {
    try {
      final String uri =
          locator<Di>().apiUrl + "/cloudfare/$catalogName/mangalist/$page";
      Response response = await locator<Di>().dio.get(
        uri,
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      return response;
    } on DioError catch (e) {
      print(e);
      throw new NException(e);
    }
  }
  Future<List<Manga>?> updatedMangaList(String catalogName, int page) async {
    try {
      final String uri =
          locator<Di>().apiUrl + "/cloudfare/$catalogName/latest/$page";
      print(uri);
      Response response = await locator<Di>().dio.get(
        uri,
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      final items =
      response.data["mangas"]["mangas"].cast<Map<String, dynamic>>();
      List<Manga>? mangas = items.map<Manga>((json) {
        return Manga.fromJson(json);
      }).toList();
      return mangas;
    } on DioError catch (e) {
      print(e);
      throw new NException(e);
    }
  }

  Future<Manga> mangaDetails(Manga manga, String catalogName) async {
    try {
      final String uri = locator<Di>().apiUrl + "/cloudfare/details";
      Response response = await locator<Di>().dio.post(
        uri,
        data: {'manga': manga.toMap(), 'catalog': catalogName},
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      Manga result = Manga.fromJson(response.data["manga"]);
      return result;
    } on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }

  Future<List<Chapter>?> mangaChapters(Manga manga,String catalogName) async {
    try {
      final String uri = locator<Di>().apiUrl + "/cloudfare/chapters";
      Response response = await locator<Di>().dio.post(
        uri,
        data: {'manga': manga.toMap(), 'catalog': catalogName},
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      final items = response.data["chapters"].cast<Map<String, dynamic>>();
      print(items);
      List<Chapter>? result = items.map<Chapter>((json) {
        return Chapter.fromJson(json);
      }).toList();
      return result;
    }on DioError catch (e) {
      print("catch de dio");
      print(e.message);
      throw new NException(e);
    }
  }

  Future<List<String?>> chapterPages(String? catalogName, Chapter chapter) async{
    try {
      final String uri = locator<Di>().apiUrl + "/cloudfare/pages";
      Response response = await locator<Di>().dio.post(
        uri,
        data: {'chapter': chapter.toMap(), 'catalog': catalogName},
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      List<String?> result = [];
      for(int i = 0; i< response.data["images"].length;i++){
        result.add(response.data["images"][i]);
      }
      return result;
    }on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }

  Future<String?> downloadChapter(Chapter chapter, String catalogName, String mangaName) async{
    try {
      print("on entre ici");
      final String uri = locator<Di>().apiUrl + "/cloudfare/chapterArchive";
      Response response = await locator<Di>().dio.post(
        uri,
        data: {'chapter': chapter.toMap(), 'catalog': catalogName,'manga': mangaName},
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      print(response.data);
      final String? items = response.data["file"];
      return items;
    }on DioError catch (e) {
      print("erreur api");
      throw new NException(e);
    }
  }
}

final CloudfareService cloudfareService = CloudfareService();