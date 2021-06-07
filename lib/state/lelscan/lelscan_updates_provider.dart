import 'package:dartz/dartz.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/lelscan_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';

class LelscanUpdatesProvider extends BaseProvider{

  Either<NException,List<Manga>> updatedMangaList = Right([]);

  getUpdatedMangaList(String catalogName,int page,bool forceRefresh){
    this.toggleLoadingState();
    lelscanService.updatedMangaList(catalogName, page,forceRefresh).then((mangas){
      this.toggleLoadingState();
      updatedMangaList = Right(mangas);
    }).catchError((error){
      this.toggleLoadingState();
      print(error);
      updatedMangaList = Left(error);
    });
  }
}