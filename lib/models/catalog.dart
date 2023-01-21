class Catalog {
  int? index;
  bool? hasVolumeInfos;
  String? name;
  String? catalogName;
  String? baseUrl;
  String? lang;

  Catalog({
  this.name,
  this.index,
  this.catalogName,
  this.baseUrl,
  this.lang,
  this.hasVolumeInfos
  });

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
        index: json['index'],
        hasVolumeInfos: json['hasVolumeInfos'],
        name: json['name'],
        catalogName: json['catalogName'],
        baseUrl: json['baseUrl'],
        lang: json['lang'],
    );
  }
}