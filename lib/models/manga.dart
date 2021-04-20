class Manga {
  String id;
  String title;
  String catalog;
  int catalogId;
  bool inLibrary;
  bool detailsFetched;
  String url;
  String thumbnailUrl;
  String author;
  String artist;
  String genre;
  String description;
  String status;
  String rating;

  Manga({
    this.id,
    this.title,
    this.catalog,
    this.catalogId,
    this.inLibrary,
    this.detailsFetched,
    this.url,
    this.thumbnailUrl,
    this.author,
    this.artist,
    this.genre,
    this.description,
    this.status,
    this.rating
  });

  factory Manga.fromJson(Map<String, dynamic> json) {
    return Manga(
        id: json['id'],
        title: json['title'],
        catalog: json['catalog'],
        catalogId: json['catalogId'],
        inLibrary: json['inLibrary'],
        detailsFetched: json['detailsFetched'],
        url: json['url'],
      thumbnailUrl: json['thumbnailUrl'],
      author: json['author'],
      artist: json['artist'],
      genre: json['genre'],
      description: json['description'],
      status: json['status'],
      rating: json['rating']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'catalog': catalog,
      'inLibrary': inLibrary,
      "detailsFetched": detailsFetched,
      "url": url,
      "thumbnailUrl": thumbnailUrl,
      "author": author,
      "artist": artist,
      "genre" : genre,
      "description": description,
      "status": status,
      "rating": rating
    };
  }
}