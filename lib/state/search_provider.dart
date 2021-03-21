import 'package:dartz/dartz.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/networking/services/search_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class SearchProvider extends BaseProvider{
  Either<NException,List<Manga>> searchResults = Right([]);

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