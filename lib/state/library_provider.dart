import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fanga/custom/widgets/custom_notification_animation.dart';
import 'package:fanga/database/dao/manga_dao.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';


class LibraryProvider extends BaseProvider{

  Either<NException,List<Manga>> library = Right([]);
  List<Manga> libraryList = <Manga>[];

  bool fetched = false;
  MangaDao mangaDao = MangaDao();

  loadLibrary(){
    toggleLoadingState();
    fetched = true;
    mangaDao.getAllSortedByName().then((value){
      fetched = true;
      toggleLoadingState();
      library = Right(value);
      libraryList = value;
      notifyListeners();
    }).catchError((error){
      toggleLoadingState();
      NException exception = NException(error);
    });
  }

  addToLibrary(Manga manga, Size size){
    mangaDao.findManga(manga.url).then((value){
      if(value.isEmpty){
        mangaDao.insert(manga).then((value){
          loadLibrary();
          BotToast.showSimpleNotification(
            align: Alignment.bottomRight,
            duration: Duration(seconds: 4),
            wrapToastAnimation: (controller, cancel, child) =>
                CustomOffsetAnimation(
                    reverse: true,
                    controller: controller,
                    child: Container(
                      width: size.width * 0.85,
                      height: size.height / 10,
                      child: child,
                    )),
            title:  manga.title!,
            crossPage: true,
            subTitle: "a été ajouté à votre bibliothèque",
          );
        });
        loadLibrary();
      } else {
        mangaDao.delete(manga.url).then((value) {
          loadLibrary();
          BotToast.showSimpleNotification(
            align: Alignment.bottomRight,
            duration: Duration(seconds: 3),
            wrapToastAnimation: (controller, cancel, child) =>
                CustomOffsetAnimation(
                    reverse: true,
                    controller: controller,
                    child: Container(
                      width: size.width * 0.85,
                      height: size.height / 10,
                      child: child,
                    )),
            title:  manga.title!,
            crossPage: true,
            subTitle: "a été retiré de votre bibliothèque",
          );
        });
      }
    });
  }

  Future<List<Manga>> findManga(String searchTerms) async {
    return await mangaDao.searchManga(searchTerms);
  }
}