import 'package:flutter/material.dart';
import 'package:Fanga/screens/Lelscan/manga_details.dart';
import 'package:Fanga/screens/download.dart';
import 'package:Fanga/screens/library.dart';
import 'package:Fanga/screens/mangafox/mangafox_home.dart';
import 'package:Fanga/screens/mangahere/mangahere_home.dart';
import 'package:Fanga/screens/mangakawaii/mangakawaii_home.dart';
import 'package:Fanga/screens/readmangatoday/readmangatoday_home.dart';
import 'file:///H:/dev/Programmes/AndroidStudioProjects/Fanga/lib/screens/Lelscan/lelscan_home.dart';
import 'package:Fanga/screens/splashscreen.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String lelscan = '/lelscan';
  static const String mangakawaii = '/mangakawaii';
  static const String readmangatoday = '/readmangatoday';
  static const String mangahere = '/mangahere';
  static const String mangafox = '/mangafox';
  static const String lelscanDetails = '/lelscanDetails';
  static const String downloads = '/dowloads';
  static const String library = '/library';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    lelscan: (BuildContext context) => LelScan(),
    lelscanDetails: (BuildContext context) => LelscanDetail(),
    downloads: (BuildContext context) => Download(),
    library: (BuildContext context) => Library(),
    mangakawaii: (BuildContext context) => Mangakawaii(),
    readmangatoday: (BuildContext context) => Readmangatoday(),
    mangahere: (BuildContext context) => Mangahere(),
    mangafox: (BuildContext context) => Mangafox()
  };
}
