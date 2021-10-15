import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/custom/widgets/custom_notification_animation.dart';
import 'package:Fanga/database/dao/download_dao.dart';
import 'package:Fanga/di.dart';
import 'package:Fanga/models/chapter.dart';
import 'package:Fanga/models/download.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/lelscan_service.dart';
import 'package:Fanga/service_locator.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:path_provider/path_provider.dart';

class ActionProvider extends BaseProvider {

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    print(progress);
  }
  List<Chapter> selectedItems = <Chapter>[];
  List<DownloadTask?> downloadTasks = <DownloadTask?>[];
  DownloadDao downloadDao = DownloadDao();

  getAllDownloads() async {
    final tasks = await FlutterDownloader.loadTasks();
    downloadTasks = tasks!.reversed.toList();
    notifyListeners();
  }

  Future<Download?> findDownload(String taskId) async{
    return await downloadDao.findDownload(taskId);
  }

  Future<void> updateDownload(Download download,String taskId) async{
    await downloadDao.update(download, taskId);
  }

  downloadChapter(
      Chapter chapter, String catalogName, Manga manga, Size size,) {
    lelscanService
        .downloadChapter(chapter, catalogName, manga.title)
        .then((value) async {
      final lelscanPath =
      Directory("storage/emulated/0/${Assets.appName}/$catalogName/${manga.title}");
      if (!lelscanPath.existsSync()) {
        await lelscanPath.create(recursive: true);
      }
      final taskId = await FlutterDownloader.enqueue(
          url: locator<Di>().apiUrl + value!,
          savedDir: lelscanPath.path,
          showNotification:
          true, // show download progress in status bar (for Android)
          openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
          requiresStorageNotLow: false);
      // prevent loading the pages again before reading the chapter
      try {
        lelscanService.chapterPages(catalogName, chapter, false);
      } catch (e) {}
      try{
        downloadDao.insert(Download(chapter: chapter,taskId: taskId,manga: manga));
      }catch(e){}
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
        title: "Le téléchargement de ${chapter.title!.isNotEmpty ? chapter.title : "Chapitre ${chapter.number}"}",
        crossPage: true,
        subTitle: "vient de commencer",
      );
      Timer.periodic(Duration(seconds: 1), (timer) async {
        final tasks = await FlutterDownloader.loadTasks();
        final task = tasks!.where((element) => element.taskId == taskId).first;
        if (task.status == DownloadTaskStatus.complete) {
          final File zipFile = File( task.savedDir + "/" + task.filename!);
          final destinationDir = Directory(
              task.savedDir + "/" + task.filename!.substring(0, task.filename!.length - 4));
          File(task.savedDir + "/" +task.filename!.substring(0, task.filename!.length - 4) + "/.nomedia")
              .create(recursive: true);
          try {
            ZipFile.extractToDirectory(
                zipFile: zipFile, destinationDir: destinationDir)
                .then((value) async {
              await zipFile.delete();
            });
          } catch (e) {
            print(e);
          }
          timer.cancel();
        }else if(task.status == DownloadTaskStatus.canceled || task.status == DownloadTaskStatus.paused || task.status == DownloadTaskStatus.failed || task.status == DownloadTaskStatus.undefined){
          timer.cancel();
        }
      });
    }).catchError((error) {
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
        title: "Erreur lors du lancement du téléchargement",
        crossPage: true,
        subTitle: error.message,
      );
    });
  }

  downloadMultipleChapters(String catalogName, Manga? manga, Size size) {
    this.selectedItems.forEach((element) {
      final lelscanPath = Directory(
          "storage/emulated/0/${Assets.appName}/$catalogName/${manga!.title}");
      if (!lelscanPath.existsSync()) {
        lelscanPath.create(recursive: true);
      }
      lelscanService
          .downloadChapter(element, catalogName, manga.title)
          .then((value) async {
        final taskId = await FlutterDownloader.enqueue(
            url: locator<Di>().apiUrl + value!,
            savedDir: lelscanPath.path,
            showNotification:
            true, // show download progress in status bar (for Android)
            openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
            requiresStorageNotLow: false);
        try {
          lelscanService.chapterPages(catalogName, element, false);
        } catch (e) {}
        try{
          downloadDao.insert(Download(chapter:element,taskId: taskId,manga: manga));
        }catch(e){}

        try {
          lelscanService.chapterPages(catalogName, element, false);
        } catch (e) {}
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
          title: "Le téléchargement de ${element.title}",
          crossPage: true,
          subTitle: "vient de commencer.",
        );
        Timer.periodic(Duration(seconds: 1), (timer) async {
          final tasks = await FlutterDownloader.loadTasks();
          final task = tasks!.where((element) => element.taskId == taskId).first;
          if (task.status == DownloadTaskStatus.complete) {
            final File zipFile = File(
                task.savedDir + "/" + task.filename!);
            final destinationDir = Directory(
                task.savedDir + "/" + task.filename!.substring(0, task.filename!.length - 4));
            File(task.savedDir + "/" +task.filename!.substring(0, task.filename!.length - 4) + "/.nomedia")
                .create(recursive: true);
            try {
              ZipFile.extractToDirectory(
                  zipFile: zipFile, destinationDir: destinationDir)
                  .then((value) async {
                await zipFile.delete();
              });
            } catch (e) {
              print(e);
            }
            timer.cancel();
          }else if(task.status == DownloadTaskStatus.canceled || task.status == DownloadTaskStatus.paused || task.status == DownloadTaskStatus.failed || task.status == DownloadTaskStatus.undefined){
            timer.cancel();
          }
        });
      }).catchError((error) {
      });
    });
  }

  selectItems(Chapter value) {
    selectedItems.add(value);
    notifyListeners();
  }

  emptyItems() {
    selectedItems.clear();
    notifyListeners();
  }

  removeItem(Chapter value) {
    selectedItems.remove(value);
    notifyListeners();
  }
}