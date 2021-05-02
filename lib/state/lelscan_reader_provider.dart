import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/screens/reader.dart';
import 'package:manga_reader/state/base_provider.dart';

class LelscanReaderProvider extends BaseProvider {
  List<String> pages = [];


  getPages(String catalogName,Chapter chapter,BuildContext context,Manga manga) async{
    lelscanService.chapterPages(catalogName, chapter).then((value) {
      print(value);
      List<String> downloadedPages = List<String>();
      final chapterDir = Directory("storage/emulated/0/${Assets.appName}/$catalogName/${manga.title}/${chapter.title}");
      if(chapterDir.existsSync()){
        if(chapterDir.listSync().length == value.length){
          chapterDir.listSync().forEach((element) {
            downloadedPages.add(element.path);
          });
        downloadedPages.sort();
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(downloadedPages,manga,chapter)));
        }else if(chapterDir.listSync().length == 0){
          this.pages = value;
          precacheImage(NetworkImage(pages[0]), context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(this.pages,manga,chapter)));
        }else{
          //To Do
          // replace already existing file url with it's path from phone
        }
      }else{
        this.pages = value;
        precacheImage(NetworkImage(pages[0]), context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(this.pages,manga,chapter)));
      }
    }).catchError((onError){
      print(onError);
    });
  }
}