import 'package:flutter/cupertino.dart';
import 'package:me_medical_app/util/user_preferences.dart';

class LocaleNotifier extends ChangeNotifier {
  LocaleNotifier() {
    initLocale();
  }

  initLocale() async {
    Locale appLocale = await UserPreferences().getLocale();
    _locale = appLocale;
    notifyListeners();
  }

  late Locale _locale = const Locale("en");

  Locale get locale => _locale;

  void setLocale(Locale locale) async {
    _locale = locale;
    await UserPreferences().setLocale(locale.languageCode);
    notifyListeners();
  }
}
