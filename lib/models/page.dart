import 'package:fanga/models/chapter.dart';
import 'manga.dart';

class Page {

  Manga? manga;
  Chapter chapter;
  int? page;
  bool? finished;

  bool operator == (o) => o is Chapter && chapter.url == o.url;

  Page({
    required this.chapter,
    required this.page,
    required this.finished,
    required this.manga
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
        chapter: Chapter.fromJson(json['chapter']),
        page: json['page'],
        finished: json['finished'],
        manga: Manga.fromJson(json['manga'])
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'chapter': chapter.toMap(),
      'page': page,
      'finished': finished,
      'manga': manga!.toMap()
    };
  }
  @override
  int get hashCode => chapter.url.hashCode;
}