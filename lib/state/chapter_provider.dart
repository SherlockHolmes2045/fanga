import 'package:dartz/dartz.dart';
import 'package:manga_reader/models/Chapter.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class ChapterProvider extends BaseProvider {
  Either<NException,List<Chapter>> mangaChapters = Right([]);

  getChapters(String catalogName,Manga manga){
    this.toggleLoadingState();
    lelscanService.mangaChapters(manga, catalogName).then((value){
      mangaChapters = Right(value);
      this.toggleLoadingState();
    }).catchError((error){
      print(error);
      mangaChapters = Left(error);
      this.toggleLoadingState();
    });
  }
}