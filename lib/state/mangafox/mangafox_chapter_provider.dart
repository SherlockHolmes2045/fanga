import 'package:dartz/dartz.dart';
import 'package:Fanga/models/chapter.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/lelscan_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';

class MangafoxChapterProvider extends BaseProvider {
  Either<NException,List<Chapter>> mangaChapters = Right([]);

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