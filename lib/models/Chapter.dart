class Chapter {
  String id;
  String title;
  String url;
  String publishedAt;
  double number;

  Chapter({
    this.id,
    this.title,
    this.url,
    this.publishedAt,
    this.number,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      publishedAt: json['publishedAt'],
      number: json['number'],
    );
  }
}