import 'package:flutter/foundation.dart';

class CatalogsProvider extends ChangeNotifier{
  var catalogs = null;

  getCatalogs(){
    return catalogs;
  }
  setCatalogs(catalogs){
    this.catalogs = catalogs;
  }
}