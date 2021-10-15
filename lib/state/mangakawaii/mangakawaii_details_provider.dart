import 'package:dartz/dartz.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/cloudfare_service.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';

class MangakawaiiDetailsProvider extends BaseProvider {
  Either<NException, Manga> mangaDetails = Right(Manga());

  getMangaDetails(String catalogName, Manga manga) {
    this.toggleLoadingState();
    if (manga.detailsFetched == true) {
      mangaDetails = Right(manga);
      this.toggleLoadingState();
    } else {
      cloudfareService.mangaDetails(manga, catalogName).then((value) {
        mangaDetails = Right(value);
        this.toggleLoadingState();
      }).catchError((error) {
        print(error);
        mangaDetails = Left(error);
        this.toggleLoadingState();
      });
    }
  }
}
