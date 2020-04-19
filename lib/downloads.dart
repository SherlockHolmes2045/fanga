import 'package:flutter/foundation.dart';
import 'package:manga_reader/task_info.dart';


class Downloads extends ChangeNotifier{
  var downloads = [];

  void addTask(List<TaskInfo> tasks,String manga,String chapter){
    double count = tasks.length/100;
    downloads.add({
      'manga': manga,
      'chapitre':chapter,
      'tasks': tasks,
      'count': count,
      'percentage':0
    });
    notifyListeners();
  }
  getDownloads(){
    return downloads;
  }
}