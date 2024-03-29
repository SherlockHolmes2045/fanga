import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fanga/constants/assets.dart';
import 'package:fanga/models/chapter.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/networking/services/cloudfare_service.dart';
import 'package:fanga/networking/services/lelscan_service.dart';
import 'package:fanga/screens/reader.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';
import 'package:package_info/package_info.dart';
import '../../di.dart';
import '../../service_locator.dart';

class LelscanReaderProvider extends BaseProvider {
  List<String?> pages = [];
  NException? exception;


  getPages(String? catalogName,Chapter? chapter,BuildContext context,Manga? manga,bool forceRefresh) async{
    toggleLoadingState();
    this.exception = null;
    PackageInfo info = await PackageInfo.fromPlatform();
    if(catalogName != Assets.mangakawaiiCatalogName){
      lelscanService.chapterPages(catalogName, chapter!,forceRefresh).then((value) {
        toggleLoadingState();
        List<String> downloadedPages = <String>[];
        Directory chapterDir;
        if(chapter.title == "" || chapter.title == null){
          chapterDir = Directory("${locator<Di>().rootDir}${info.packageName}/${Assets.appName}/$catalogName/${manga!.title}/Chapitre ${chapter.number}");
        }else{
          chapterDir = Directory("${locator<Di>().rootDir}${info.packageName}/${Assets.appName}/$catalogName/${manga!.title}/${chapter.title}");
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
        final chapterDir = Directory("storage/emulated/0/Android/media/${info.packageName}${Assets.appName}/$catalogName/${manga!.title}/${chapter.title}");
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