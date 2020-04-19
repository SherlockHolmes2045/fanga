import 'package:flutter/foundation.dart';

class MangaDetailsProvider extends ChangeNotifier{
  var catalog = null;
  var manga = null;
  var chapters = null;

  getCatalog(){
    return catalog;

  }
  setCatalog(catalog){
    this.catalog = catalog;
  }
  getManga(){
    return manga;
  }
  getChapters(){
    return chapters;
  }
  setManga(manga){
    this.manga = manga;
  }
  setChapters(chapters){
    this.chapters = chapters;
  }
}