import 'package:flutter/foundation.dart';
import 'package:manga_reader/task_info.dart';


class Downloads extends ChangeNotifier{
  var downloads = [];

  void addTask(List<TaskInfo> tasks,String manga,String chapter,double items){
    print(tasks);

    downloads.add({
      'manga': manga,
      'chapitre':chapter,
      'tasks': tasks,
      'count': items,
      'percentage':0
    });
    notifyListeners();
  }
  getDownloads(){
    return downloads;
  }
}