import 'package:manga_reader/database/app_database.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:sembast/sembast.dart';

class MangaDao {

  static const String MANGA_STORE_NAME = 'mangas';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _mangaStore = intMapStoreFactory.store(MANGA_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Manga manga) async {
    await _mangaStore.add(await _db, manga.toMap());
  }

  Future update(Manga manga) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(manga.id));
    await _mangaStore.update(
      await _db,
      manga.toMap(),
      finder: finder,
    );
  }

  Future delete(String url) async {
    final finder = Finder(filter: Filter.and([
      Filter.equals("url",url),
    ])
    );
    await _mangaStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Manga>> getAllSortedByName() async {
    // Finder object can also sort data.
    final recordSnapshots = await _mangaStore.find(
      await _db,
    );

    // Making a List<Fruit> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final fruit = Manga.fromJson(snapshot.value);
      return fruit;
    }).toList();
  }
  Future<List<Manga>> searchManga(String searchTerm) async{
    final finder = Finder(
      filter: Filter.and([
        Filter.custom((record) => Manga.fromJson(record.value).title.toLowerCase().contains(searchTerm))
      ])
    );
    final recordSnapshots = await _mangaStore.find(
        await _db,
        finder: finder
    );
    return recordSnapshots.map((snapshot) {
      final mangas = Manga.fromJson(snapshot.value);
      return mangas;
    }).toList();
  }
  Future<List<Manga>> findManga(String url) async {

    final finder = Finder(
        filter: Filter.and([
          Filter.equals("url",url),
        ])
    );
    final recordSnapshots = await _mangaStore.find(
        await _db,
        finder: finder
    );
    return recordSnapshots.map((snapshot) {
      final fruit = Manga.fromJson(snapshot.value);
      return fruit;
    }).toList();
  }
}