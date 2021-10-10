import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/custom/widgets/custom_notification_animation.dart';
import 'package:manga_reader/database/dao/page_dao.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/models/page.dart' as Model;
import 'package:manga_reader/state/base_provider.dart';

class PageProvider extends BaseProvider {
  List<Model.Page> pages = [];
  PageDao pageDao = PageDao();

  loadAllPages() {
    toggleLoadingState();
    pageDao.getAll().then((value) {
      toggleLoadingState();
      pages = value;
      notifyListeners();
    });
  }

  Future<Model.Page?> findChapter(Chapter chapter) async {
    return await pageDao.findPage(chapter.url);
  }

  updatePage(Chapter chapter, int page, bool finished,Manga? manga) {
    pageDao.findPage(chapter.url).then((value) async {
      if (value == null) {
        await pageDao.insert(
            Model.Page(chapter: chapter, finished: finished, page: page,manga: manga));
        loadAllPages();
      } else {
        if(value.page! < page){
          await pageDao.update(
              Model.Page(chapter: chapter, finished: finished, page: page,manga: manga));
          loadAllPages();
        }
      }
    });
  }

  markAsRead(Chapter chapter, Size size,Manga? manga,bool notify) {
    pageDao.findPage(chapter.url).then((value) {
      if (value == null) {
        pageDao
            .insert(Model.Page(
                chapter: chapter, finished: true, page: Random().nextInt(100),manga: manga))
            .then((value) {
          loadAllPages();
          if(notify){
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
              title: chapter.title!.isEmpty ? "Chapitre ${chapter.number}" : chapter.title!,
              crossPage: true,
              subTitle: "a été marqué comme lu",
            );
          }
        });
      } else {
        pageDao.delete(chapter.url).then((value) {
          loadAllPages();
          if(notify){
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
              title: chapter.title!.isEmpty ? "Chapitre ${chapter.number}" : chapter.title!,
              crossPage: true,
              subTitle: "a été marqué comme non lu",
            );
          }
        });
      }
    });
  }
  markAsReadSelected(List<Chapter> chapters,Manga? manga,Size size){
    chapters.forEach((element) {
      markAsRead(element, size, manga,false);
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
        title: "${chapters.length} chapitres ont été marqué comme lus",
        crossPage: true,
      );
    });
  }
}
