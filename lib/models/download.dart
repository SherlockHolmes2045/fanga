import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';

class Download {

  Chapter chapter;
  Manga manga;
  String taskId;

  bool operator == (o) => o is Chapter && chapter.url == o.url;

  Download({
    this.chapter,
    this.manga,
    this.taskId
  });

  factory Download.fromJson(Map<String, dynamic> json) {
    return Download(
      chapter: Chapter.fromJson(json['chapter']),
      manga: json['manga'],
      taskId: json['taskId'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'chapter': chapter.toMap(),
      'manga': manga.toMap(),
      'taskId': taskId,
    };
  }
  @override
  int get hashCode => chapter.url.hashCode;
}