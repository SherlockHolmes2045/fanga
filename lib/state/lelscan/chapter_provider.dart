import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:manga_reader/database/dao/page_dao.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class ChapterProvider extends BaseProvider {
  Either<NException,List<Chapter>> mangaChapters = Right([]);
  bool isFiltered = false;
  List<Chapter> filteredChapters = List<Chapter>();
  PageDao pageDao = PageDao();

  bool downloaded = false;
  bool nonreaded = false;
  bool readed = false;
  bool marked = false;



  filterDownloaded(bool value){
    if(value){
      isFiltered = true;
      downloaded = value;
      notifyListeners();
    }else{
      isFiltered = false;
      downloaded = value;
      notifyListeners();
    }
  }
  filterNonReaded(bool value){
    nonreaded = value;
    notifyListeners();
  }

  filterReaded(bool value){
    if(value) {
      isFiltered = true;
      readed = value;
      pageDao.getAll().then((value) {
        //List<SomeClass> list = list to search;
        List<Chapter> matchingList = value.map((page) => page.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r){
          final result = r.where((item) => matchingSet.contains(item));
          filteredChapters.addAll(result);
        });
        notifyListeners();
      });
    }else{
      isFiltered = false;
      filteredChapters.clear();
      readed = value;
      notifyListeners();
    }

  }

  filterMarked(bool value){
    marked = value;
    notifyListeners();
  }
  clearAllFilters(){
    isFiltered = false;
    downloaded = false;
    readed = false;
    nonreaded = false;
    marked = false;
    notifyListeners();
  }

  getChapters(String catalogName,Manga manga,bool forceRefresh){
    this.toggleLoadingState();
    lelscanService.mangaChapters(manga, catalogName,forceRefresh).then((value){
      mangaChapters = Right(value);
      this.toggleLoadingState();
    }).catchError((error){
      this.toggleLoadingState();
      print(error);
      mangaChapters = Left(error);

    });
  }
}