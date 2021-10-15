import 'package:fanga/database/app_database.dart';
import 'package:fanga/models/download.dart';
import 'package:sembast/sembast.dart';

class DownloadDao {

  static const String DOWNLOAD_STORE_NAME = 'downloads';
  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are Fruit objects converted to Map
  final _downloadStore = intMapStoreFactory.store(DOWNLOAD_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Download download) async {
    await _downloadStore.add(await _db, download.toMap());
  }

  Future update(Download download,String taskId) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(taskId));
    await _downloadStore.update(
      await _db,
      download.toMap(),
      finder: finder,
    );
  }

  Future delete(String taskId) async {
    final finder = Finder(filter: Filter.and([
      Filter.equals("taskId",taskId),
    ])
    );
    await _downloadStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Download>> getAll() async {

    final recordSnapshots = await _downloadStore.find(
      await _db,
    );

    // Making a List<Download> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final download = Download.fromJson(snapshot.value);
      return download;
    }).toList();
  }

  Future<Download?> findDownload(String value) async {

    final finder = Finder(
        filter: Filter.and([
          Filter.equals("taskId",value),
        ])
    );
    final recordSnapshots = await _downloadStore.findFirst(
        await _db,
        finder: finder
    );
    if(recordSnapshots == null){
      return null;
    }else{
      return Download.fromJson(recordSnapshots.value);
    }
  }
}