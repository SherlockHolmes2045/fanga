import 'dart:collection';

import 'package:dartz/dartz.dart';
import 'package:manga_reader/database/dao/chapter_bookmark_dao.dart';
import 'package:manga_reader/database/dao/download_dao.dart';
import 'package:manga_reader/database/dao/page_dao.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/lelscan_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/extensions.dart';

class ReadmangatodayChapterProvider extends BaseProvider {
  Either<NException, List<Chapter>> mangaChapters = Right([]);
  bool isFiltered = false;
  List<Chapter> filteredChapters = List<Chapter>();
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
        List<Chapter> matchingList =
            value.map((downloaded) => downloaded.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r.where((item) => matchingSet.contains(item));
          filteredChapters.addAll(result);
          filteredChapters = filteredChapters.unique();
        });
        notifyListeners();
      });
    } else {
      if (!readed && !nonreaded && !marked) {
        isFiltered = false;
      }
      downloadDao.getAll().then((value) {
        List<Chapter> matchingList =
            value.map((download) => download.chapter).toList();

        final matchingSet = HashSet.from(matchingList);
        mangaChapters.fold((l) => null, (r) {
          final result = r.where((item) => matchingSet.contains(item));
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
          final result = r.where((item) => matchingSet.contains(item));
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
          final result = r.where((item) => matchingSet.contains(item));
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
          final result = r.where((item) => matchingSet.contains(item));
          filteredChapters.addAll(result);
          filteredChapters = filteredChapters.unique();
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
          final result = r.where((item) => matchingSet.contains(item));
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
          final result = r.where((item) => matchingSet.contains(item));
          filteredChapters.addAll(result);
          filteredChapters = filteredChapters.unique();
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
          final result = r.where((item) => matchingSet.contains(item));
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
}
