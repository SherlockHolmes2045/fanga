import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/database/app_database.dart';
import 'package:Fanga/models/chapter.dart';
import 'package:sembast/sembast.dart';

class ChapterBookmarkDao {

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _chapterBookmarkStore = intMapStoreFactory.store(Assets.CHAPTER_BOOKMARK_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Chapter chapter) async {
    await _chapterBookmarkStore.add(await _db, chapter.toMap());
  }

  Future update(Chapter chapter) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(chapter.url));
    await _chapterBookmarkStore.update(
      await _db,
      chapter.toMap(),
      finder: finder,
    );
  }

  Future delete(String? url) async {
    final finder = Finder(filter: Filter.and([
      Filter.equals("url",url),
    ])
    );
    await _chapterBookmarkStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Chapter>> loadAllBookMarked() async{
    final recordSnapshots = await _chapterBookmarkStore.find(await _db);
    return recordSnapshots.map((e){
      final fruit = Chapter.fromJson(e.value);
      return fruit;
    }).toList();
  }

  Future<Chapter?> findChapter(String? url) async {
    final finder = Finder(
        filter: Filter.and([
          Filter.equals("url",url),
        ])
    );
    final recordSnapshots = await _chapterBookmarkStore.findFirst(
        await _db,
        finder: finder
    );
    if(recordSnapshots == null){
      return null;
    }else{
      return Chapter.fromJson(recordSnapshots.value);
    }
  }
}