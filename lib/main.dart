import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:me_medical_app/l10n/app_localization.dart';
import 'package:me_medical_app/l10n/app_localization_provider.dart';
import 'package:me_medical_app/models/user.dart';
import 'package:me_medical_app/services/auth.dart';
import 'package:me_medical_app/services/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Settings.init(cacheProvider: SharePreferenceCache());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser?>.value(
        initialData: null,
        catchError: (User, theUser) => null,
        value: AuthService().user,
        child: ChangeNotifierProvider(
            create: (context) => LocaleNotifier(),
            builder: (context, child) {
              final appLocaleProvider = Provider.of<LocaleNotifier>(context);
              return MaterialApp(
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.grey[200],
                  // Define the default brightness and colors.
                  brightness: Brightness.light,
                  appBarTheme: const AppBarTheme(color: Colors.indigo),

                  // Define the default font family.
                  fontFamily: GoogleFonts.montserrat().fontFamily,

                  // Define the default `TextTheme`. Use this to specify the default
                  // text styling for headlines, titles, bodies of text, and more.
                  textTheme: TextTheme(
                    bodyText1: TextStyle(
                        fontFamily: GoogleFonts.comicNeue().fontFamily),
                    bodyText2: const TextStyle(),
                  ).apply(
                    bodyColor: Colors.black,
                    displayColor: Colors.blue,
                  ),
                ),
                locale: appLocaleProvider.locale,
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalization.delegate
                ],
                supportedLocales: const [
                  Locale('en', 'US'),
                  Locale('zh', 'CN'),
                ],
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (locale.languageCode == deviceLocale!.languageCode &&
                        locale.countryCode == deviceLocale.countryCode) {
                      return deviceLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                home: Wrapper(),
              );
            }));
  }
}
/*
class _MyAppState extends State<MyApp> {
  Locale? _locale;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser?>.value(
        initialData: null,
        catchError: (User, theUser) => null,
        value: AuthService().user,
        child: ChangeNotifierProvider(
            create: (context) => LocaleNotifier(),
            builder: (context, child) {
              final appLocaleProvider = Provider.of<LocaleNotifier>(context);
              child:
              MaterialApp(
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (locale.languageCode == deviceLocale!.languageCode &&
                        locale.countryCode == deviceLocale.countryCode) {
                      return deviceLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                locale: appLocaleProvider.locale,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.grey[200],
                  // Define the default brightness and colors.
                  brightness: Brightness.light,
                  appBarTheme: AppBarTheme(color: Colors.indigo),

                  // Define the default font family.
                  fontFamily: GoogleFonts.montserrat().fontFamily,

                  // Define the default `TextTheme`. Use this to specify the default
                  // text styling for headlines, titles, bodies of text, and more.
                  textTheme: TextTheme(
                    bodyText1: TextStyle(
                        fontFamily: GoogleFonts.comicNeue().fontFamily),
                    bodyText2: const TextStyle(),
                  ).apply(
                    bodyColor: Colors.black,
                    displayColor: Colors.blue,
                  ),
                ),
                supportedLocales: [
                  Locale('en', 'US'),
                  Locale('zh', 'CN'),
                ],
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalization.delegate
                ],
                localeListResolutionCallback: (deviceLocale, supportedLocales) {
                  for (var locale in supportedLocales) {
                    if (locale.languageCode == deviceLocale!.language &&
                        locale.countryCode == deviceLocale.countryCode) {
                      return deviceLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                home: Wrapper(),
              );
            }));
  }
 
}
 */
