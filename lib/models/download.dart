import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fanga/models/chapter.dart';
import 'package:fanga/models/manga.dart';

class Download {

  Chapter? chapter;
  Manga? manga;
  String? taskId;

  bool operator == (o) => o is Download && taskId == taskId;

  Download({
    this.chapter,
    this.manga,
    this.taskId
  });

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(
      chapter: Chapter.fromJson(json['chapter']),
      manga: Manga.fromJson(json['manga']),
      taskId: json['taskId'],
    );
  }
  static void callback(String id, DownloadTaskStatus status, int progress) {}
  Map<String, dynamic> toMap() {
    return {
      'chapter': chapter!.toMap(),
      'manga': manga!.toMap(),
      'taskId': taskId,
    };
  }
  @override
  int get hashCode => taskId.hashCode;
}