import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/cloudfare_service.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/screens/reader.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class LelscanReaderProvider extends BaseProvider {
  List<String?> pages = [];
  NException? exception;


  getPages(String? catalogName,Chapter? chapter,BuildContext context,Manga? manga,bool forceRefresh) async{
    toggleLoadingState();
    this.exception = null;
    if(catalogName != Assets.mangakawaiiCatalogName){
      lelscanService.chapterPages(catalogName, chapter!,forceRefresh).then((value) {
        toggleLoadingState();
        List<String> downloadedPages = <String>[];
        Directory chapterDir;
        if(chapter.title == "" || chapter.title == null){
          chapterDir = Directory("storage/emulated/0/${Assets.appName}/$catalogName/${manga!.title}/Chapitre ${chapter.number}");
        }else{
          chapterDir = Directory("storage/emulated/0/${Assets.appName}/$catalogName/${manga!.title}/${chapter.title}");
        }
        // should only check for image file
        if(chapterDir.existsSync()){
          if(chapterDir.listSync().length - 1 == value.length){
            chapterDir.listSync().forEach((element) {
              downloadedPages.add(element.path);
            });
            downloadedPages.sort();
            downloadedPages.removeAt(0);
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(downloadedPages,manga,chapter)));
          }else if(chapterDir.listSync().length == 0){
            this.pages = value;
            precacheImage(NetworkImage(pages[0]!), context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(this.pages,manga,chapter)));
          }else{

            //To Do
            // replace already existing file url with it's path from phone
          }
        }else{
          this.pages = value;
          precacheImage(NetworkImage(pages[0]!), context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(this.pages,manga,chapter)));
        }
      }).catchError((onError){
        toggleLoadingState();
        exception = onError;
        notifyListeners();
      });
    }else{
       cloudfareService.chapterPages(catalogName, chapter!).then((value) {
        toggleLoadingState();
        print(value);
        List<String> downloadedPages = <String>[];
        final chapterDir = Directory("storage/emulated/0/${Assets.appName}/$catalogName/${manga!.title}/${chapter.title}");
        if(chapterDir.existsSync()){
          if(chapterDir.listSync().length == value.length){
            chapterDir.listSync().forEach((element) {
              downloadedPages.add(element.path);
            });
            downloadedPages.sort();
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(downloadedPages,manga,chapter)));
          }else if(chapterDir.listSync().length == 0){
            this.pages = value;
            precacheImage(NetworkImage(pages[0]!), context);
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(this.pages,manga,chapter)));
          }else{
            //To Do
            // replace already existing file url with it's path from phone
          }
        }else{
          this.pages = value;
          precacheImage(NetworkImage(pages[0]!), context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder:(BuildContext context) => Reader(this.pages,manga,chapter)));
        }
      }).catchError((onError){
        toggleLoadingState();
        exception = NException(onError);
        notifyListeners();
      });
    }
  }
}