import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/database/app_database.dart';
import 'package:Fanga/models/page.dart';
import 'package:sembast/sembast.dart';

class PageDao {


  final _pageStore = intMapStoreFactory.store(Assets.PAGE_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Page page) async {
    await _pageStore.add(await _db, page.toMap());
  }

  Future update(Page page) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.and([
      Filter.equals("chapter.url",page.chapter.url),
    ])
    );
    await _pageStore.update(
      await _db,
      page.toMap(),
      finder: finder,
    );
  }

  Future delete(String url) async {
    final finder = Finder(filter: Filter.and([
      Filter.equals("chapter.url",url),
    ])
    );
    await _pageStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Page>> getAll() async {
    final recordSnapshots = await _pageStore.find(
      await _db,
    );
    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final fruit = Page.fromJson(snapshot.value);
      return fruit;
    }).toList();
  }

  Future<Page> findPage(String url) async {
    final finder = Finder(
        filter: Filter.and([
          Filter.equals("chapter.url",url),
        ])
    );
    final recordSnapshots = await _pageStore.findFirst(
        await _db,
        finder: finder
    );
    if(recordSnapshots == null){
      return null;
    }else{
      return Page.fromJson(recordSnapshots.value);
    }
  }
}