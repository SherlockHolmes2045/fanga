import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/cloudfare_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';
import 'package:dartz/dartz.dart';

class MangakawaiiMangaListProvider extends BaseProvider{

  Either<NException,List<Manga>> mangaList = Right([]);
  int? currentPage = 1;
  int? nextPage = 1;
  bool? hasNext = false;

  clearList(){
    mangaList.fold((l) => null, (r){
      r.clear();
      currentPage = 1;
      nextPage = 1;
      notifyListeners();
    });
  }
  getMangaList(String catalogName,int? page){
    if(page == 1)
      this.toggleLoadingState();
    cloudfareService.mangaList(catalogName, page).then((response){
      final items =
      response.data["data"]["mangas"].cast<Map<String, dynamic>>();
      List<Manga>? mangas = items.map<Manga>((json) {
        return Manga.fromJson(json);
      }).toList();
      mangaList.fold((l) => null, (r){
        r.addAll(mangas!);
      });
      currentPage = page;
      if(page == 1)
        this.toggleLoadingState();
      hasNext = response.data["data"]["hasNext"];
      if(response.data["data"]["hasNext"]){
        print(response.data["data"]["nextPage"]);
        nextPage = response.data["data"]["nextPage"];
      }
      notifyListeners();
    }).catchError((error){
      mangaList = Left(error);
      if(page == 1)
        this.toggleLoadingState();
    });
  }
}