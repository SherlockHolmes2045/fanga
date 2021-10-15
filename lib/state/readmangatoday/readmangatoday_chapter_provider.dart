import 'dart:collection';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:Fanga/custom/widgets/scale_route_transition.dart';
import 'package:Fanga/database/dao/chapter_bookmark_dao.dart';
import 'package:Fanga/database/dao/download_dao.dart';
import 'package:Fanga/database/dao/page_dao.dart';
import 'package:Fanga/models/chapter.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/networking/services/lelscan_service.dart';
import 'package:Fanga/screens/reader_loader.dart';
import 'package:Fanga/state/base_provider.dart';
import 'package:Fanga/utils/n_exception.dart';
import 'package:Fanga/utils/extensions.dart';
import 'package:Fanga/models/page.dart' as Model;

class ReadmangatodayChapterProvider extends BaseProvider {
  Either<NException, List<Chapter>?> mangaChapters = Right([]);
  bool isFiltered = false;
  List<Chapter> filteredChapters = <Chapter>[];
  PageDao pageDao = PageDao();
  ChapterBookmarkDao chapterBookmarkDao = ChapterBookmarkDao();
  DownloadDao downloadDao = DownloadDao();

  bool downloaded = false;
  bool nonreaded = false;
  bool readed = false;
  bool marked = false;

  filterDownloaded(bool value) {
    if (value) {
      isFiltered = true;
      downloaded = value;
      downloadDao.getAll().then((value) {
        List<Chapter?> matchingList =
        value.map((downloaded) => downloaded.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          filteredChapters.addAll(result);
          filteredChapters = filteredChapters.unique() as List<Chapter>;
        });
        notifyListeners();
      });
    } else {
      if (!readed && !nonreaded && !marked) {
        isFiltered = false;
      }
      downloadDao.getAll().then((value) {
        List<Chapter?> matchingList =
        value.map((download) => download.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          var set1 = Set.from(filteredChapters);
          var set2 = Set.from(result);
          filteredChapters = List.from(set1.difference(set2));
        });
      });
      downloaded = value;
      notifyListeners();
    }
  }

  filterNonReaded(bool value) {
    if (value) {
      isFiltered = true;
      nonreaded = value;
      pageDao.getAll().then((value) {
        List<Chapter> matchingList = value.map((page) => page.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          var set1 = Set.from(r);
          var set2 = Set.from(result);
          filteredChapters.addAll(List.from(set1.difference(set2)));
          filteredChapters.unique();
        });
        notifyListeners();
      });
    } else {
      if (!downloaded && !readed && !marked) {
        isFiltered = false;
      }
      pageDao.getAll().then((value) {
        List<Chapter> matchingList = value.map((page) => page.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          var set1 = Set.from(r);
          var set2 = Set.from(result);
          var set3 = Set.from(filteredChapters);
          var set4 = Set.from(List.from(set1.difference(set2)));
          filteredChapters = List.from(set3.difference(set4));
        });
      });
      nonreaded = value;
      notifyListeners();
    }
  }

  filterReaded(bool value) {
    if (value) {
      isFiltered = true;
      readed = value;
      pageDao.getAll().then((value) {
        List<Chapter> matchingList = value.map((page) => page.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          filteredChapters.addAll(result);
          filteredChapters = filteredChapters.unique() as List<Chapter>;
        });
        notifyListeners();
      });
    } else {
      if (!downloaded && !nonreaded && !marked) {
        isFiltered = false;
      }
      pageDao.getAll().then((value) {
        List<Chapter> matchingList = value.map((page) => page.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          var set1 = Set.from(filteredChapters);
          var set2 = Set.from(result);
          filteredChapters = List.from(set1.difference(set2));
        });
      });
      readed = value;
      notifyListeners();
    }
  }

  filterMarked(bool value) {
    if (value) {
      isFiltered = true;
      marked = true;
      chapterBookmarkDao.loadAllBookMarked().then((bookmarked) {
        final matchingSet = HashSet.from(bookmarked);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          filteredChapters.addAll(result);
          filteredChapters = filteredChapters.unique() as List<Chapter>;
        });
        notifyListeners();
      });
    } else {
      if (!downloaded && !readed && !nonreaded) {
        isFiltered = false;
      }
      chapterBookmarkDao.loadAllBookMarked().then((bookmarked) {
        final matchingSet = HashSet.from(bookmarked);
        mangaChapters.fold((l) => null, (r) {
          final result = r!.where((item) => matchingSet.contains(item));
          var set1 = Set.from(filteredChapters);
          var set2 = Set.from(result);
          filteredChapters = List.from(set1.difference(set2));
        });
      });
      marked = value;
      notifyListeners();
    }
  }

  clearAllFilters() {
    isFiltered = false;
    downloaded = false;
    readed = false;
    nonreaded = false;
    marked = false;
    notifyListeners();
  }

  getChapters(String catalogName, Manga manga, bool forceRefresh) {
    this.toggleLoadingState();
    lelscanService
        .mangaChapters(manga, catalogName, forceRefresh)
        .then((value) {
      mangaChapters = Right(value);
      this.toggleLoadingState();
    }).catchError((error) {
      this.toggleLoadingState();
      print(error);
      mangaChapters = Left(error);
    });
  }
  resumeChapter(Manga? manga, BuildContext context) {
    pageDao.getAll().then((value) {
      List<Model.Page> mangaPages =
      value.where((page) => page.manga == manga).toList();
      mangaPages.sort((a, b) =>
          int.parse(a.chapter.number!).compareTo(int.parse(b.chapter.number!)));
      if(mangaPages.isNotEmpty){
        Navigator.push(
            context,
            ScaleRoute(
                page: ReaderLoader(
                  manga: mangaPages.last.manga,
                  catalog: mangaPages.last.manga!.catalog,
                  chapter: mangaPages.last.chapter,
                )));

      }else{
        mangaChapters.fold((l){
          BotToast.showText(
            text:
            "Les chapitres ne sont pas encore chargés",
          );
        }, (r){
          if(r!.isEmpty){
            BotToast.showText(
              text:
              "Les chapitres ne sont pas encore chargés",
            );
          }else{
            Navigator.push(
                context,
                ScaleRoute(
                    page: ReaderLoader(
                      manga: manga,
                      catalog: manga!.catalog,
                      chapter: r.last,
                    )));
          }
        });
      }
    });
  }
}