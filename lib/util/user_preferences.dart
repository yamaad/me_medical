import 'dart:ui';
import 'package:me_medical_app/constant/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String appLocale = "app_localization";

  Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(appLocale, languageCode);
    return _locale(languageCode);
  }

  Future<Locale> getLocale() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String languageCode = _prefs.getString(appLocale) ?? english;
    return _locale(languageCode);
  }
}

Locale _locale(String languageCode) {
  Locale _tempLocale;
  switch (languageCode) {
    case english:
      _tempLocale = Locale(languageCode, "US");
      break;
    case chinese:
      _tempLocale = Locale(languageCode, "CN");
      break;
    default:
      _tempLocale = Locale(languageCode, "US");
  }
  return _tempLocale;
}
