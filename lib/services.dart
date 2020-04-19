import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manga_reader/Manga.dart';
import 'package:manga_reader/Catalog.dart';
import 'package:dio/dio.dart';
import 'package:manga_reader/Chapter.dart';
import 'dart:io';
import 'package:manga_reader/custom_exception.dart';

final String apiUrl = "https://ebd48dde.ngrok.io";

Future<List<Manga>> fetchPopularManga(String catalog,String page) async {

  final JsonDecoder _decoder = new JsonDecoder();

  http.Response response = await http.get(
    Uri.encodeFull(apiUrl+"/manga/"+catalog+"/popularMangaList/"+page),headers: {
    "Content-Type":"application/json"
  },);
  print("Respone ${response.statusCode.toString()}");
  if(response.statusCode == 200) {
    dynamic body = _decoder.convert(response.body);
    final items = body['data']['mangas'].cast<Map<String, dynamic>>();
    List<Manga> listOfMangas = items.map<Manga>((json) {
      return Manga.fromJson(json);
    }).toList();
    return listOfMangas;
  } else{
    print('hey');
    throw Exception('Please verify your Internet connection');
  }
}

Future<dynamic> getCatalogues() async {

  final JsonDecoder _decoder = new JsonDecoder();
  http.Response response;
  try{
     response = await http.get(
      Uri.encodeFull(apiUrl+"/manga/catalogs"),headers: {
      "Content-Type":"application/json"
    },);
    print("Respone ${response.statusCode.toString()}");

  } on SocketException{
    print('hey');
    throw FetchDataException('Verifiez votre connexion Internet');
  }
  if(response.statusCode == 200) {
    dynamic body = _decoder.convert(response.body);
    final items = body['catalogs'].cast<Map<String, dynamic>>();
    List<Catalog> listOfCatalog = items.map<Catalog>((json) {
      return Catalog.fromJson(json);
    }).toList();
    return listOfCatalog;
  }else{
    throw FetchDataException();
  }
}


Future<Manga> getMangaDetails(String catalog,Manga manga) async {

  Dio dio = new Dio();

  Response response = await dio.post(apiUrl+"/manga/details",
      options: Options(
        headers: {
          "content-type":"application/json"
        }
      ),
      data:{
    "catalog":catalog,
    "manga":{
      "inLibrary": manga.inLibrary,
      "url": manga.url,
      "title": manga.title,
      "thumbnailUrl": manga.thumbnailUrl,
      "catalogId": manga.catalogId,
      "catalog": manga.catalog,
      "id": manga.id
    }
  }
  );
  print("Respone ${response.statusCode.toString()}");
  if(response.statusCode == 200) {
    Manga listOfMangas = new Manga(
      id:response.data["manga"]["id"],
      title: response.data["manga"]["title"],
      catalog: response.data["manga"]["catalog"],
      catalogId: response.data["manga"]["catalogId"],
      thumbnailUrl: response.data["manga"]["thumbnailUrl"],
      url: response.data["manga"]["url"],
      inLibrary: response.data["manga"]["inLibrary"],
      detailsFetched: response.data["manga"]["detailsFetched"],
      description: response.data["manga"]["description"],
      genre: response.data["manga"]["genre"],
      author: response.data["manga"]["author"],
      artist: response.data["manga"]["artist"],
      status: response.data["manga"]["status"]
    );
    return listOfMangas;
  } else{
    print('hey');
    throw Exception('Please verify your Internet connection');
  }

}

Future<List<Chapter>> getChapters(String catalog,Manga manga) async {

  Dio dio = new Dio();

  Response response = await dio.post(apiUrl + "/manga/chapters",
      options: Options(
          headers: {
            "content-type": "application/json"
          }
      ),
      data: {
        "catalog": catalog,
        "manga": {
          "inLibrary": manga.inLibrary,
          "url": manga.url,
          "title": manga.title,
          "thumbnailUrl": manga.thumbnailUrl,
          "catalogId": manga.catalogId,
          "catalog": manga.catalog,
          "id": manga.id
        }
      }
  );
  print("Respone ${response.statusCode.toString()}");
  if (response.statusCode == 200) {

    final items = response.data["chapters"].cast<Map<String, dynamic>>();
    List<Chapter> listOfChapter = List<Chapter>();
    for(var i =0;i<items.length;i++){
      Chapter chapter = new Chapter(
        id: items[i]["id"],
        title: items[i]["title"],
        url: items[i]["url"],
        publishedAt: items[i]["publishedAt"],
        number: items[i]["numnber"]
      );
      listOfChapter.add(
        chapter
      );
    }
    return listOfChapter;
  } else {
    print('hey');
    throw Exception('Please verify your Internet connection');
  }
}

Future getPages(String catalog,Chapter chapter) async{

  Dio dio = new Dio();

  Response response = await dio.post(apiUrl + "/manga/pages",
      options: Options(
          headers: {
            "content-type": "application/json"
          }
      ),
      data: {
        "catalog": catalog,
        "chapter": {
          "url": chapter.url,
          "title": chapter.title,
          "publishedAt": chapter.publishedAt,
          "id": chapter.id,
          "number": chapter.number
        }
      }
  );
  print("Respone ${response.statusCode.toString()}");
  if (response.statusCode == 200) {

    final items = response.data["pages"];
    return items;
  } else {
    print('hey');
    throw Exception('Please verify your Internet connection');
  }
}

Future getImageUrl(String catalog,String page) async{
  Dio dio = new Dio();

  Response response = await dio.post(apiUrl + "/manga/images",
      options: Options(
          headers: {
            "content-type": "application/json"
          }
      ),
      data: {
        "catalog": catalog,
        "page": page
      }
  );
  print("Respone ${response.statusCode.toString()}");
  if (response.statusCode == 200) {

    final items = response.data["images"];
    print(items);
    return items;
  } else {
    print('hey');
    throw Exception('Please verify your Internet connection');
  }
}

Future<dynamic> search(String source,String manga) async {

  Dio dio = new Dio();
  Response response;
  try{
    response = await dio.post(apiUrl + "/manga/search",
        options: Options(
            headers: {
              "content-type": "application/json"
            }
        ),
        data: {
          "source": source,
          "manga": manga
        }
    );
  } on SocketException{
    throw FetchDataException('Verifiez votre connexion Internet');
  }

  print("Respone ${response.statusCode.toString()}");
  if (response.statusCode == 200) {
    final items = response.data["data"]["mangas"];
    List<Manga> listOfMangas = items.map<Manga>((json) {
      return Manga.fromJson(json);
    }).toList();
    print(listOfMangas.toString());
    return listOfMangas;

  } else {
    print('hey');
    throw Exception('Verifiez votre connexion Internet');
  }
}