import 'package:dartz/dartz.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class LelscanTopMangaProvider extends BaseProvider{

  Either<NException,List<Manga>?> topMangaList = Right([]);

  getTopMangaList(String catalogName,int page,bool forceRefresh){
    this.toggleLoadingState();
    lelscanService.topMangaList(catalogName, page,forceRefresh).then((mangas){
      this.toggleLoadingState();
      topMangaList = Right(mangas);
    }).catchError((error){
      this.toggleLoadingState();
      print(error);
      topMangaList = Left(error);
    });
  }
}