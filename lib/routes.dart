import 'package:flutter/material.dart';
import 'file:///H:/dev/Programmes/AndroidStudioProjects/manga_reader/lib/screens/Lelscan/lelscan_home.dart';
import 'package:manga_reader/screens/splashscreen.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String lelscan = '/lelscan';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    lelscan: (BuildContext context) => LelScan(),
  };
}



