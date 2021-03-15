import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:manga_reader/constants/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final Future<SharedPreferences> _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // General Methods: ----------------------------------------------------------
  Future<String> get authToken async {
    return _sharedPreference.then((preference) {
      return preference.getString(Preferences.auth_token);
    });
  }

  Future<String> get refreshToken async {
    return _sharedPreference.then((preference) {
      return preference.getString(Preferences.refresh_token);
    });
  }

  Future<void> saveAuthToken(String authToken) async {
    return _sharedPreference.then((preference) {
      preference.setString(Preferences.auth_token, authToken);
    });
  }

  Future<void> saveRefreshToken(String authToken) async {
    return _sharedPreference.then((preference) {
      preference.setString(Preferences.refresh_token, authToken);
    });
  }

  Future<void> removeAuthToken() async {
    return _sharedPreference.then((preference) {
      preference.remove(Preferences.auth_token);
    });
  }

  Future<bool> get isLoggedIn async {
    return _sharedPreference.then((preference) {
      return preference.getString(Preferences.auth_token) == null ? false : true ;
    });
  }

  Future<bool> get firstUsage async {
    return _sharedPreference.then((preference) {
      return preference.getBool(Preferences.first_usage) ?? true;
    });
  }
  Future<void> setFirstUsage() async {
    return _sharedPreference.then((preference) {
      preference.setBool(Preferences.first_usage,false);
    });
  }

  // Theme:------------------------------------------------------
  Future<bool> get isDarkMode {
    return _sharedPreference.then((prefs) {
      return prefs.getBool(Preferences.is_dark_mode) ?? false;
    });
  }

  Future<bool> get isFirstTime {
    return _sharedPreference.then((prefs) {
      return false;
    });
  }

  setBooleanValue(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanValue(String key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }

  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference.then((prefs) {
      return prefs.setBool(Preferences.is_dark_mode, value);
    });
  }

  // Language:---------------------------------------------------
  Future<String> get currentLanguage {
    return _sharedPreference.then((prefs) {
      return prefs.getString(Preferences.current_language);
    });
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.then((prefs) {
      return prefs.setString(Preferences.current_language, language);
    });
  }

  Future<void> storeData(String key, value, String type) {
    switch(type){
      case "string" :
        return _sharedPreference.then((prefs) {
          return prefs.setString(key, value);
        });
        break;
      
      case "int" :
        return _sharedPreference.then((prefs) {
          return prefs.setInt(key, value);
        });
        break;
  
      case "bool" :
        return _sharedPreference.then((prefs) {
          return prefs.setBool(key, value);
        });
        break;
  
      default:
        return _sharedPreference.then((prefs) {
          return prefs.setString(key, value);
        });
     }
  }

  Future<dynamic> getData(String key, String type) {
    
      switch(type){
        case "string" :
          return _sharedPreference.then((prefs) {
            return prefs.getString(key);
          });
          break;
        
        case "int" :
          return _sharedPreference.then((prefs) {
            return prefs.getInt(key);
          });
          break;
    
        case "bool" :
          return _sharedPreference.then((prefs) {
            return prefs.getBool(key);
          });
          break;
    
        default:
          return _sharedPreference.then((prefs) {
            return prefs.getString(key);
          });
     }
  }
}
