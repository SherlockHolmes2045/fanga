import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/di.dart';
import 'package:manga_reader/models/Chapter.dart';
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

  /*void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    print("ici");
    final SendPort send =
    IsolateNameServer.lookupPortByName('MyAppPrgrss' + id);
    send.send([id, status, progress]);
    if(status == DownloadTaskStatus.complete){
      print("le callback");
      final File zipFile = File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/${chapter.title}.zip");
      final destinationDir = Directory("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/");
      try {
        ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir);
      } catch (e) {
        print(e);
      }
    }
  }*/

  downloadChapter(Chapter chapter,String catalogName,String title){
    final lelscanPath = Directory(
        "storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title");
    if(!lelscanPath.existsSync()){
      lelscanPath.create(recursive: true);
    }
    lelscanService.downloadChapter(chapter, catalogName,title).then((value) async{
      final taskId = await FlutterDownloader.enqueue(
        url: locator<Di>().apiUrl + value,
        savedDir: lelscanPath.path,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        requiresStorageNotLow: false
      );
      print("finished download");
      FlutterDownloader.registerCallback((
          String id, DownloadTaskStatus status, int progress) {
        print("ici");
        final SendPort send =
        IsolateNameServer.lookupPortByName('MyAppPrgrss' + id);
        send.send([id, status, progress]);
        print("le callback");
        if(status == DownloadTaskStatus.complete){
          print("le callback yes");
          final File zipFile = File("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/${chapter.title}.zip");
          final destinationDir = Directory("storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$title/");
          try {
            ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: destinationDir);
          } catch (e) {
            print(e);
          }
        }});
    }).catchError((error){
      print("erreur du provider");
      print(error.message);
      NException exception = NException(error);
    });
  }
  downloadMultipleChapters(String catalogName, String mangaTitle){
    final lelscanPath = Directory(
        "storage/emulated/0/${Assets.appName}/${Assets.lelscanCatalogName}/$mangaTitle");
    if(!lelscanPath.existsSync()){
      lelscanPath.create(recursive: true);
    }
    this.selectedItems.forEach((element) {
      lelscanService.downloadChapter(element, catalogName,mangaTitle).then((value) async{
        print("sucess $value");
        final taskId = await FlutterDownloader.enqueue(
            url: locator<Di>().apiUrl + value,
            savedDir: lelscanPath.path,
            showNotification: true, // show download progress in status bar (for Android)
            openFileFromNotification: true, // click on notification to open downloaded file (for Android)
            requiresStorageNotLow: false
        );
        print("finished download");
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