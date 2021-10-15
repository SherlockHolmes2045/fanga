import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fanga/constants/assets.dart';
import 'package:fanga/localization/locale_constant.dart';
import 'package:fanga/localization/localizations_delegate.dart';
import 'package:fanga/models/download.dart';
import 'package:fanga/routes.dart';
import 'package:fanga/service_locator.dart';
import 'package:fanga/state/action_provider.dart';
import 'package:fanga/state/bookmark_provider.dart';
import 'package:fanga/state/lelscan/chapter_provider.dart';
import 'package:fanga/state/lelscan/details_provider.dart';
import 'package:fanga/state/lelscan/lelscan_manga_list_provider.dart';
import 'package:fanga/state/lelscan/lelscan_provider.dart';
import 'package:fanga/state/lelscan/lelscan_reader_provider.dart';
import 'package:fanga/state/lelscan/lelscan_top_manga_provider.dart';
import 'package:fanga/state/lelscan/lelscan_updates_provider.dart';
import 'package:fanga/state/library_provider.dart';
import 'package:fanga/state/mangafox/mangafox_chapter_provider.dart';
import 'package:fanga/state/mangafox/mangafox_details_provider.dart';
import 'package:fanga/state/mangafox/mangafox_provider.dart';
import 'package:fanga/state/mangahere/mangahere_chapter_provider.dart';
import 'package:fanga/state/mangahere/mangahere_details_provider.dart';
import 'package:fanga/state/mangahere/mangahere_provider.dart';
import 'package:fanga/state/mangakawaii/mangakawaii_chapter_provider.dart';
import 'package:fanga/state/mangakawaii/mangakawaii_details_provider.dart';
import 'package:fanga/state/mangakawaii/mangakawaii_manga_list_provider.dart';
import 'package:fanga/state/mangakawaii/mangakawaii_provider.dart';
import 'package:fanga/state/mangakawaii/mangakawaii_top_manga_provider.dart';
import 'package:fanga/state/mangakawaii/mangakawaii_updates_provider.dart';
import 'package:fanga/state/page_provider.dart';
import 'package:fanga/state/lelscan/lelscan_search_provider.dart';
import 'package:fanga/state/readmangatoday/readmangatoday_chapter_provider.dart';
import 'package:fanga/state/readmangatoday/readmangatoday_details_provider.dart';
import 'package:fanga/state/readmangatoday/readmangatoday_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';
import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  locator<Di>().dio.interceptors.add(locator<Di>().dioCacheManager.interceptor);
  createDb();
  await createFolders(Assets.appName);

  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
  );
  FlutterDownloader.registerCallback(Download.callback);
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
            ChangeNotifierProvider(create: (_)=> LelscanSearchProvider()),
            ChangeNotifierProvider(create: (_)=> ActionProvider()),
            ChangeNotifierProvider(create: (_)=> LelscanReaderProvider()),
            ChangeNotifierProvider(create: (_)=> LelscanMangaListProvider()),
            ChangeNotifierProvider(create: (_)=> LibraryProvider()),
            ChangeNotifierProvider(create: (_)=> LelscanUpdatesProvider()),
            ChangeNotifierProvider(create: (_)=> LelscanTopMangaProvider()),
            ChangeNotifierProvider(create: (_)=> BookmarkProvider()),
            ChangeNotifierProvider(create: (_)=> PageProvider()),
            /*ChangeNotifierProvider(create: (_)=> MangakawaiiProvider()),
          ChangeNotifierProvider(create: (_)=> MangakawaiiUpdatesProvider()),
          ChangeNotifierProvider(create: (_)=> MangakawaiiMangaListProvider()),
          ChangeNotifierProvider(create: (_)=> MangakawaiiTopMangaProvider()),
          ChangeNotifierProvider(create: (_)=> MangakawaiiDetailsProvider()),
          ChangeNotifierProvider(create: (_)=> MangakawaiiChapterProvider()),*/
            ChangeNotifierProvider(create: (_)=> ReadmangatodayProvider()),
            ChangeNotifierProvider(create: (_)=> ReadmangatodayChapterProvider()),
            ChangeNotifierProvider(create: (_)=> ReadmangatodayDetailsProvider()),
            /*ChangeNotifierProvider(create: (_)=> MangahereDetailsProvider()),
          ChangeNotifierProvider(create: (_)=> MangahereChapterProvider()),
          ChangeNotifierProvider(create: (_)=> MangahereProvider()),
          ChangeNotifierProvider(create: (_)=> MangafoxProvider()),
          ChangeNotifierProvider(create: (_)=> MangafoxDetailsProvider()),
          ChangeNotifierProvider(create: (_)=> MangafoxChapterProvider()),*/
          ],
          child: MyApp(),
        )
    );
  });
}


class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

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
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
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
    var external = await Permission.manageExternalStorage.status;
    await getExternalStorageDirectory();
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if(!external.isGranted){
      await Permission.manageExternalStorage.request();
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

  final File file = File('${tempDir.path}/Fanga.db');

  file.exists().then((isThere) {
    if (!isThere) {
      file.create().then((value){

      }).catchError((onError){
        BotToast.showText(text: "Impossible de créer la base de données");
      });
    }
  });
}