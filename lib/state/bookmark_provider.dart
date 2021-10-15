import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:fanga/custom/widgets/custom_notification_animation.dart';
import 'package:fanga/database/dao/chapter_bookmark_dao.dart';
import 'package:fanga/models/chapter.dart';
import 'package:fanga/state/base_provider.dart';
import 'package:fanga/utils/n_exception.dart';


class BookmarkProvider extends BaseProvider{

  List<Chapter> bookmarked = <Chapter>[];

  bool fetched = false;
  ChapterBookmarkDao chapterBookmarkDao = ChapterBookmarkDao();

  loadBookmarked(){
    toggleLoadingState();
    fetched = true;
    chapterBookmarkDao.loadAllBookMarked().then((value){
      fetched = true;
      toggleLoadingState();
      bookmarked = value;
      notifyListeners();
    }).catchError((error){
      toggleLoadingState();
      NException exception = NException(error);
    });
  }

  checkBookmark(Chapter chapter) async {
    return await chapterBookmarkDao.findChapter(chapter.url);
  }

  bookmark(Chapter chapter, Size size,bool notify){
    chapterBookmarkDao.findChapter(chapter.url).then((value){
      if(value == null){
        chapterBookmarkDao.insert(chapter).then((value){
          loadBookmarked();
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
              title:  chapter.title!.isEmpty ? "Chapitre ${chapter.number}" : chapter.title!,
              crossPage: true,
              subTitle: "a été ajouté à votre marque page",
            );
          }
        });
        loadBookmarked();
      } else {
        chapterBookmarkDao.delete(chapter.url).then((value) {
          loadBookmarked();
          if(notify){
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
              title:  chapter.title!.isEmpty ? "Chapitre ${chapter.number}" : chapter.title!,
              crossPage: true,
              subTitle: "a été retiré de votre marque page",
            );
          }
        });
      }
    });
  }
  bookmarkSelected(List<Chapter> chapters,Size size){
    chapters.forEach((element) {
      bookmark(element, size,false);
    });
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
      title:  "${chapters.length} chapitres ajoutés à votre marque page",
      crossPage: true,
    );
  }
}