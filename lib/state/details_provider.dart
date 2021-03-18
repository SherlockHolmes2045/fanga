import 'package:dartz/dartz.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class DetailsProvider extends BaseProvider{

  Either<NException,Manga> mangaDetails= Right(Manga());

  getMangaDetails(String catalogName,Manga manga){
    this.toggleLoadingState();
    lelscanService.mangaDetails(manga, catalogName).then((value){
      mangaDetails = Right(value);
      this.toggleLoadingState();
    }).catchError((error){
      print(error);
      mangaDetails = Left(error);
      this.toggleLoadingState();
    });
  }
}