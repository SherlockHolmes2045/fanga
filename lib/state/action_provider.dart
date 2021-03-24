import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/di.dart';
import 'package:manga_reader/models/Chapter.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/service_locator.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:path_provider/path_provider.dart';

class ActionProvider extends BaseProvider{
  List<Chapter>  selectedItems = List<Chapter>();
  List<DownloadTask> downloadTasks = new List<DownloadTask>();

  getAllDownloads() async {
    final tasks = await FlutterDownloader.loadTasks();
    downloadTasks = tasks;
    notifyListeners();
  }

  downloadChapter(Chapter chapter,String catalogName,String title){
    lelscanService.downloadChapter(chapter, catalogName).then((value) async{
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
      );
      print("finished download");
    }).catchError((error){
      print(error);
      NException exception = NException(error);
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