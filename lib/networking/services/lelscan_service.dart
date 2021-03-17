import 'dart:io';
import 'package:dio/dio.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/utils/n_exception.dart';
import '../../di.dart';
import '../../service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manga_reader/utils/shared_preference_helper.dart';


class LelscanService {

  Future<List<Manga>> popularMangaList(String catalogName,int page) async {

    try {
      final String uri = locator<Di>().apiUrl + "/manga/$catalogName/popularMangaList/$page";
      Response response =
      await locator<Di>().dio.get(
       uri,
        options: Options(headers: {
          'Content-Type': "application/json",
        }),
      );
      final items = response.data["data"]["mangas"].cast<Map<String, dynamic>>();
      List<Manga> mangas = items.map<Manga>((json) {
        return Manga.fromJson(json);
      }).toList();
      return mangas;
    }on DioError catch (e) {
      print(e.message);
      throw new NException(e);
    }
  }

  Future<dynamic> getUserInfoShared() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String userId = await _preferences.get('user_info');
    String userPhone = await _preferences.get('user_phone');
    String userDomicile = await _preferences.get('user_domicile');
    return userDomicile;
  }

  Future<dynamic> updateHouse(phone, phonewrite, domicile) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String userId = await _preferences.get('user_info');
    String userPhone = await _preferences.get('user_phone');
    String userDomicile = await _preferences.get('user_domicile');
    userDomicile = userDomicile == null ? '':userDomicile;
    var data = {};
    if (phone == 0) {
      data = {
        "phone": userPhone,
        "residence": domicile == 0 ? userDomicile : domicile,
      };
    } else {
      data = {
        "phone": phone == '' ? phonewrite : phone,
        "residence": domicile == 0 ? userDomicile : domicile,
      };
    }
    // print(data);
    try {
      Response response =
          phone == 0 ? await locator<Di>().dio.put(locator<Di>().apiUrl + "/residence/"+userId,
              options: Options(headers: {
                'Content-Type': "application/json",
              }),
              data: data) : await locator<Di>().dio.put(locator<Di>().apiUrl + "/edit/"+userId,
              options: Options(headers: {
                'Content-Type': "application/json",
              }),
              data: data);

      if (response.statusCode == 200) {
        Future<SharedPreferences> instance = SharedPreferences.getInstance();
        if (phone == 0) {
          SharedPreferenceHelper(instance)
              .storeData("user_domicile", domicile == 0 ? userDomicile : domicile, "string");
        } else {
          SharedPreferenceHelper(instance)
              .storeData("user_domicile", domicile == 0 ? userDomicile : domicile, "string");
          SharedPreferenceHelper(instance)
              .storeData("user_phone", phone == '' ? phonewrite : phone, "string");
        }
        return response.data["message"];
      } else {
        return response;
      }
    } on SocketException {
      return null;
    }
  }
}

final LelscanService lelscanService = LelscanService();
