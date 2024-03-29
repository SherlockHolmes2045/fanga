import 'package:dartz/dartz.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/networking/services/cloudfare_service.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';

class MangakawaiiTopMangaProvider extends BaseProvider{

  Either<NException,List<Manga>?> topMangaList = Right([]);

  getTopMangaList(String catalogName,int page){
    this.toggleLoadingState();
    cloudfareService.topMangaList(catalogName, page).then((mangas){
      this.toggleLoadingState();
      topMangaList = Right(mangas);
    }).catchError((error){
      this.toggleLoadingState();
      topMangaList = Left(error);
    });
  }
}