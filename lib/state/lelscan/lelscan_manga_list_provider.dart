import 'package:fanga/models/manga.dart';
import 'package:fanga/networking/services/lelscan_service.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';
import 'package:dartz/dartz.dart';

class LelscanMangaListProvider extends BaseProvider{

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
  getMangaList(String catalogName,int? page,bool forceRefresh){
    if(page == 1)
      this.toggleLoadingState();
    lelscanService.mangaList(catalogName, page, forceRefresh).then((response){
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