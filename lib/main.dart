import 'package:flutter/material.dart';
import 'package:manga_reader/Home.dart';
import 'package:flutter_downloader/flutter_downloader.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Color.fromRGBO(32, 32, 32, 1)
    ),
    home: Home(),
  ));
}
