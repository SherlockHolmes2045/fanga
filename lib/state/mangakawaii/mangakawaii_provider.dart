import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/cloudfare_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:dartz/dartz.dart';

class MangakawaiiProvider extends BaseProvider{

  Either<NException,List<Manga>> popularMangaList = Right([]);

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