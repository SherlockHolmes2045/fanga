import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/custom/widgets/custom_notification_animation.dart';
import 'package:manga_reader/database/dao/chapter_bookmark_dao.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';


class BookmarkProvider extends BaseProvider{

  List<Chapter> bookmarked = List<Chapter>();

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

  bookmark(Chapter chapter, Size size){
    chapterBookmarkDao.findChapter(chapter.url).then((value){
      if(value == null){
        chapterBookmarkDao.insert(chapter).then((value){
          loadBookmarked();
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
            title:  chapter.title,
            crossPage: true,
            subTitle: "a été ajouté à votre marque page",
          );
        });
        loadBookmarked();
      } else {
        chapterBookmarkDao.delete(chapter.url).then((value) {
          loadBookmarked();
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
            title:  chapter.title,
            crossPage: true,
            subTitle: "a été retiré de votre marque page",
          );
        });
      }
    });
  }
}