import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/custom_notification_animation.dart';
import 'package:manga_reader/di.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/service_locator.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';


class ActionProvider extends BaseProvider{
  List<Chapter>  selectedItems = List<Chapter>();
  List<DownloadTask> downloadTasks = new List<DownloadTask>();

  getAllDownloads() async {
    final tasks = await FlutterDownloader.loadTasks();
    downloadTasks = tasks;
    notifyListeners();
  }

  downloadChapter(Chapter chapter,String catalogName,String title,Size size){

    lelscanService.downloadChapter(chapter, catalogName,title).then((value) async{
      final lelscanPath = Directory(
          "storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title");
      if(!lelscanPath.existsSync()){
        lelscanPath.create(recursive: true);
      }
      final taskId = await FlutterDownloader.enqueue(
        url: locator<Di>().apiUrl + value,
        savedDir: lelscanPath.path,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        requiresStorageNotLow: false
      );
      BotToast.showSimpleNotification(
        align: Alignment.bottomRight,
        duration: Duration(seconds: 4),
        wrapToastAnimation: (controller, cancel, child) =>
            CustomOffsetAnimation(
                reverse: true,
                controller: controller,
                child: Container(
                  width: size.width * 0.85,
                  height: size.height / 10,
                  child: child,
                )),
        title:   "Le téléchargement de ${chapter.title}",
        crossPage: true,
        subTitle: "vient de commencer",
      );
      Timer.periodic(Duration(seconds: 1),(timer) async {
        final tasks = await FlutterDownloader.loadTasks();
        print(tasks);
        final task = tasks.where((element) => element.taskId == taskId).first;
        print(task);
        if(task.status == DownloadTaskStatus.complete){
          final File zipFile = File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/${chapter.title}.zip");
          final destinationDir = Directory("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/${chapter.title}");
          File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/${chapter.title}/.nomedia").create(recursive: true);
          try {
            ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir).then((value) async{
              final zip = File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/${chapter.title}.zip");
              await zip.delete();
            });
          } catch (e) {
            print(e);
          }
          timer.cancel();
        }
      });
    }).catchError((error){
      print("erreur du provider");
      BotToast.showSimpleNotification(
        align: Alignment.bottomRight,
        duration: Duration(seconds: 4),
        wrapToastAnimation: (controller, cancel, child) =>
            CustomOffsetAnimation(
                reverse: true,
                controller: controller,
                child: Container(
                  width: size.width * 0.85,
                  height: size.height / 10,
                  child: child,
                )),
        title:   "Erreur lors du lancement du téléchargement",
        crossPage: true,
        subTitle: error.message,
      );
      NException exception = NException(error);
    });
  }
  downloadMultipleChapters(String catalogName, String mangaTitle,Size size){

    this.selectedItems.forEach((element) {
      final lelscanPath = Directory(
          "storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$mangaTitle");
      if(!lelscanPath.existsSync()){
        lelscanPath.create(recursive: true);
      }
      lelscanService.downloadChapter(element, catalogName,mangaTitle).then((value) async{
        final taskId = await FlutterDownloader.enqueue(
            url: locator<Di>().apiUrl + value,
            savedDir: lelscanPath.path,
            showNotification: true, // show download progress in status bar (for Android)
            openFileFromNotification: true, // click on notification to open downloaded file (for Android)
            requiresStorageNotLow: false
        );
        BotToast.showSimpleNotification(
          align: Alignment.bottomRight,
          duration: Duration(seconds: 4),
          wrapToastAnimation: (controller, cancel, child) =>
              CustomOffsetAnimation(
                  reverse: true,
                  controller: controller,
                  child: Container(
                    width: size.width * 0.85,
                    height: size.height / 10,
                    child: child,
                  )),
          title:   "Le téléchargement de ${element.title}",
          crossPage: true,
          subTitle: "vient de commencer.",
        );
        Timer.periodic(Duration(seconds: 1),(timer) async {
          final tasks = await FlutterDownloader.loadTasks();
          final task = tasks.where((element) => element.taskId == taskId).first;
          if(task.status == DownloadTaskStatus.complete){
            final File zipFile = File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$mangaTitle/${element.title}.zip");
            final destinationDir = Directory("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$mangaTitle/${element.title}");
            File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$mangaTitle/${element.title}/.nomedia").create(recursive: true);
            try {
              ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir).then((value) async{
                final zip = File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$mangaTitle/${element.title}.zip");
                await zip.delete();
              });
            } catch (e) {
              print(e);
            }
            timer.cancel();
          }
        });
      }).catchError((error){
        print(error);
        NException exception = NException(error);
      });
    });
  }
  selectItems(Chapter value){
    selectedItems.add(value);
    notifyListeners();
  }
  emptyItems(){
    selectedItems.clear();
    notifyListeners();
  }
  removeItem(Chapter value){
    selectedItems.remove(value);
    notifyListeners();
  }
}