import 'package:flutter/material.dart';
import 'package:manga_reader/Home.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader/ctalogs_provider.dart';
import 'package:manga_reader/downloads.dart';
import 'package:manga_reader/mangaDetailsprovider.dart';
import 'package:manga_reader/popularMangaProvider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();

  createDb();

  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(
            create: (context) => Downloads(),//CartModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CatalogsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PopularMangaProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MangaDetailsProvider(),
        )
      ] ,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color.fromRGBO(32, 32, 32, 1)
        ),
        home: Home(),
      ),
    ),
  );
}

createDb() async{
  Directory tempDir = await getApplicationDocumentsDirectory();

  final File file = File('${tempDir.path}/subae.db');

  file.exists().then((isThere) {

    if (!isThere) {
      file.create();
    }

  });
}