import 'package:flutter/foundation.dart';

class PopularMangaProvider extends ChangeNotifier{
  var mangas = null;
  String catalog = null;

  getMangas(){
    return mangas;
  }
  getCatalog(){
    return catalog;
  }
  setMangas(mangas){
    this.mangas = mangas;
  }
  setCatalog(catalog){
    this.catalog = catalog;
  }
}