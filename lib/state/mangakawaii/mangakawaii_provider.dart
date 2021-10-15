import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/cloudfare_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';
import 'package:dartz/dartz.dart';

class MangakawaiiProvider extends BaseProvider{

  Either<NException,List<Manga>?> popularMangaList = Right([]);

  getPopularMangaList(String catalogName,int page){
    this.toggleLoadingState();
    cloudfareService.popularMangaList(catalogName, page).then((mangas){
      popularMangaList = Right(mangas);
      this.toggleLoadingState();
    }).catchError((error){
      popularMangaList = Left(error);
      this.toggleLoadingState();
    });
  }
}