import 'package:manga_reader/database/dao/page_dao.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/page.dart';
import 'package:manga_reader/state/base_provider.dart';

class PageProvider extends BaseProvider{
  List<Page> pages = [];
  PageDao pageDao = PageDao();

  loadAllPages(){
    toggleLoadingState();
    pageDao.getAll().then((value) {
      toggleLoadingState();
      pages = value;
      notifyListeners();
    });
  }

  markAsRead(Chapter chapter,int page,bool finished){

  }
}