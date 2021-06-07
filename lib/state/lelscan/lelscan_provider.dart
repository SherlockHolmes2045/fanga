import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/lelscan_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';
import 'package:dartz/dartz.dart';

class LelscanProvider extends BaseProvider{

  Either<NException,List<Manga>> popularMangaList = Right([]);

  getPopularMangaList(String catalogName,int page,bool forceRefresh){
     this.toggleLoadingState();
     lelscanService.popularMangaList(catalogName, page,forceRefresh).then((mangas){
       popularMangaList = Right(mangas);
       this.toggleLoadingState();
     }).catchError((error){
       popularMangaList = Left(error);
       this.toggleLoadingState();
     });
  }
}