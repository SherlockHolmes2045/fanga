import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:manga_reader/localization/locale_constant.dart';
import 'package:manga_reader/localization/localizations_delegate.dart';
import 'package:manga_reader/routes.dart';
import 'package:manga_reader/service_locator.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  createDb();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyApp(),
      ),
    );
  });
}
class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fanga',
      routes: Routes.routes,
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale('fr', ''),
        Locale('en', ''),
      ],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale?.languageCode == locale?.languageCode &&
              supportedLocale?.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales?.first;
      },
    );
  }
}


createDb() async {
  Directory tempDir = await getApplicationDocumentsDirectory();

  final File file = File('${tempDir.path}/fanga.db');

  file.exists().then((isThere) {
    if (!isThere) {
      file.create();
    }
  });
}
