import 'package:flutter/foundation.dart';
import 'package:manga_reader/task_info.dart';


class Downloads extends ChangeNotifier{
  var downloads = [];

  void addTask(List<TaskInfo> tasks,String manga,String chapter,int items){
    print(tasks);
    double count = items.toDouble()/100.0;
    print(count);
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