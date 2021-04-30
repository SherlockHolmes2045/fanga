import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/localization/locale_constant.dart';
import 'package:manga_reader/localization/localizations_delegate.dart';
import 'package:manga_reader/routes.dart';
import 'package:manga_reader/service_locator.dart';
import 'package:manga_reader/state/action_provider.dart';
import 'package:manga_reader/state/chapter_provider.dart';
import 'package:manga_reader/state/details_provider.dart';
import 'package:manga_reader/state/lelscan_manga_list_provider.dart';
import 'package:manga_reader/state/lelscan_provider.dart';
import 'package:manga_reader/state/lelscan_reader_provider.dart';
import 'package:manga_reader/state/lelscan_top_manga_provider.dart';
import 'package:manga_reader/state/lelscan_updates_provider.dart';
import 'package:manga_reader/state/library_provider.dart';
import 'package:manga_reader/state/search_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  createDb();
  await createFolders(Assets.appName);
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  Moment.setLocaleGlobally(new LocaleFr());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.grey,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create:(_) => LelscanProvider()),
          ChangeNotifierProvider(create:(_) => DetailsProvider()),
          ChangeNotifierProvider(create:(_) => ChapterProvider()),
          ChangeNotifierProvider(create: (_)=> SearchProvider()),
          ChangeNotifierProvider(create: (_)=> ActionProvider()),
          ChangeNotifierProvider(create: (_)=> LelscanReaderProvider()),
          ChangeNotifierProvider(create: (_)=> LelscanMangaListProvider()),
          ChangeNotifierProvider(create: (_)=> LibraryProvider()),
          ChangeNotifierProvider(create: (_)=> LelscanUpdatesProvider()),
          ChangeNotifierProvider(create: (_)=> LelscanTopMangaProvider()),
        ],
        child: MyApp(),
      )
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
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()], //2. registered route observer
      initialRoute: Routes.splash,
      //home: CarouselDemo(),
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

Future<void> createFolders(String folderName) async {
  if(Platform.isAndroid) {
    final path = Directory("storage/emulated/0/$folderName");
    final lelscanPath = Directory(
        "storage/emulated/0/$folderName/${Assets.lelscanCatalogName}");
    final mangaHerePath = Directory(
        "storage/emulated/0/$folderName/${Assets.lelscanCatalogName}");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await path.exists())) {} else {
      path.create();
    }
    if ((await lelscanPath.exists())) {} else {
      lelscanPath.create();
    }
    if ((await mangaHerePath.exists())) {} else {
      mangaHerePath.create();
    }
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
