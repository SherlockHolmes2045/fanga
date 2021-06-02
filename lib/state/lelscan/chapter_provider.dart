import 'package:dartz/dartz.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class ChapterProvider extends BaseProvider {
  Either<NException,List<Chapter>> mangaChapters = Right([]);
  bool isFiltered = false;
  List<Chapter> filteredChapters = List<Chapter>();

  bool downloaded = false;
  bool nonreaded = false;
  bool readed = false;
  bool marked = false;

  filterDownloaded(bool value){
    downloaded = value;
    notifyListeners();
  }
  filterNonReaded(bool value){
    nonreaded = value;
    notifyListeners();
  }

  filterReaded(bool value){
    readed = value;
    notifyListeners();
  }

  filterMarked(bool value){
    marked = value;
    notifyListeners();
  }


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