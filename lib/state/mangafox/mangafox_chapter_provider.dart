import 'package:dartz/dartz.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

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