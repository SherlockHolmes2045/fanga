import 'package:manga_reader/models/chapter.dart';

class Page {

  Chapter chapter;
  int page;
  bool finished;

  bool operator == (o) => o is Chapter && chapter.url == o.url;

  Page({
    this.chapter,
    this.page,
    this.finished
  });

  factory Page.fromJson(Map<String, dynamic> json) {
    return Page(
      chapter: Chapter.fromJson(json['chapter']),
      page: json['page'],
      finished: json['finished'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'chapter': chapter.toMap(),
      'page': page,
      'finished': finished,
    };
  }
  @override
  int get hashCode => chapter.url.hashCode;
}