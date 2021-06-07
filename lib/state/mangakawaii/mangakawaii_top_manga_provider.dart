import 'package:dartz/dartz.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/cloudfare_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';

class MangakawaiiTopMangaProvider extends BaseProvider{

  Either<NException,List<Manga>> topMangaList = Right([]);

  getTopMangaList(String catalogName,int page){
    this.toggleLoadingState();
    cloudfareService.topMangaList(catalogName, page).then((mangas){
      this.toggleLoadingState();
      topMangaList = Right(mangas);
    }).catchError((error){
      this.toggleLoadingState();
      print(error);
      topMangaList = Left(error);
    });
  }
}