import 'package:dartz/dartz.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/cloudfare_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';

class MangakawaiiUpdatesProvider extends BaseProvider{

  Either<NException,List<Manga>> updatedMangaList = Right([]);

  getUpdatedMangaList(String catalogName,int page){
    this.toggleLoadingState();
    cloudfareService.updatedMangaList(catalogName, page).then((mangas){
      this.toggleLoadingState();
      updatedMangaList = Right(mangas);
    }).catchError((error){
      this.toggleLoadingState();
      print(error);
      updatedMangaList = Left(error);
    });
  }
}