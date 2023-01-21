import 'package:dartz/dartz.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/networking/services/search_service.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';

class LelscanSearchProvider extends BaseProvider{
  Either<NException,List<Manga>?> searchResults = Right([]);

  getSearchResults(String catalogName,String searchTerms,int page){
    this.toggleLoadingState();
    searchService.searchManga(catalogName,searchTerms,page).then((mangas){
      searchResults = Right(mangas);
      this.toggleLoadingState();
    }).catchError((error){
      print(error);
      searchResults = Left(error);
      this.toggleLoadingState();
    });
  }
}