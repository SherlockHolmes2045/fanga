import 'dart:io';
import 'package:dio/dio.dart';
import '../../di.dart';
import '../../service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manga_reader/utils/shared_preference_helper.dart';


class UserService {

  Future<dynamic> registerUser(phone, phonewrite) async {
    var data = {
      "phone": phone == '' ? phonewrite : phone,
      "type": "user",
      "password": "12345678",
    };
    try {
      Response response =
          await locator<Di>().dio.post(locator<Di>().apiUrl + "/signup",
              options: Options(headers: {
                'Content-Type': "application/json",
              }),
              data: data);

      if (response.statusCode == 200) {
        final test = "";
        response.data["user"].forEach((key, val) {
          if (key == "_id") {
            Future<SharedPreferences> instance =
                SharedPreferences.getInstance();
            SharedPreferenceHelper(instance)
                .storeData("user_info", val, "string");
          }
          if (key == "phone") {
            Future<SharedPreferences> instance =
                SharedPreferences.getInstance();
            SharedPreferenceHelper(instance)
                .storeData("user_phone", val, "string");
          }
        });
        return response.data["message"];
      } else {
        return response;
      }
    } on SocketException {
      return null;
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

final UserService userService = UserService();
