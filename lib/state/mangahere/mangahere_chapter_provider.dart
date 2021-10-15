import 'package:dartz/dartz.dart';
import 'package:fanga/models/chapter.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/networking/services/lelscan_service.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';

class MangahereChapterProvider extends BaseProvider {
  Either<NException,List<Chapter>?> mangaChapters = Right([]);


  getChapters(String catalogName,Manga manga,bool forceRefresh){
    this.toggleLoadingState();
    lelscanService.mangaChapters(manga, catalogName,forceRefresh).then((value){
      mangaChapters = Right(value);
      this.toggleLoadingState();
    }).catchError((error){
      this.toggleLoadingState();
      print(error);
      mangaChapters = Left(error);

    });
  }
}