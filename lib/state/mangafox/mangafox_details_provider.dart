import 'package:dartz/dartz.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/networking/services/lelscan_service.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';

class MangafoxDetailsProvider extends BaseProvider {
  Either<NException, Manga> mangaDetails = Right(Manga());

  getMangaDetails(String catalogName, Manga manga, bool forceRefresh) {
    this.toggleLoadingState();
    if (manga.detailsFetched == true) {
      mangaDetails = Right(manga);
      this.toggleLoadingState();
    } else {
      lelscanService
          .mangaDetails(manga, catalogName, forceRefresh)
          .then((value) {
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
