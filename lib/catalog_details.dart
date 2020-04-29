import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/Catalog.dart';
import 'package:manga_reader/error.dart';
import 'package:manga_reader/popularMangaProvider.dart';
import 'package:manga_reader/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:manga_reader/manga_details.dart';
import 'package:manga_reader/Manga.dart';

class CatalogDetails extends StatefulWidget {
  final Catalog catalog;
  const CatalogDetails(this.catalog);
  @override
  _CatalogDetailsState createState() => _CatalogDetailsState();
}

class _CatalogDetailsState extends State<CatalogDetails> {
  bool searchMode = false;
  String mangaSearch = "";
  List<Widget> result= [];
  buildPopularManga(data){
    result = [];
    for(var i =0;i<data.length;i++){
      result.add(
        InkWell(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.2)
                  ]
                ),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        data[i].thumbnailUrl
                    ),
                    fit: BoxFit.cover
                ),
              ),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/120),
                    child: Text(
                      data[i].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width/30,
                      ),
                    ),
                  )
              )
          ),
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(
                builder:  (c) => MangaDetails(widget.catalog.catalogName,data[i])
            ));
          },
        )
      );
    }
    return result;
  }
  Future<Null> getRefresh() async{
    await Future.delayed (Duration(seconds:1));
    setState(() {
      searchMode = false;
      fetchPopularManga(widget.catalog.catalogName,"1");
    });
  }

  final AppBarController appBarController = AppBarController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(widget.catalog.name),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                showSearch(context: context,delegate: DataSearch(widget.catalog.catalogName));
              },
            ),
          ],
        ),
        body: Provider.of<PopularMangaProvider>(context,listen:false).getCatalog() == null || Provider.of<PopularMangaProvider>(context,listen:false).getCatalog() != widget.catalog.catalogName ?
        FutureBuilder(
          future: !searchMode ? fetchPopularManga(widget.catalog.catalogName,"1") : search(widget.catalog.catalogName,mangaSearch),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else{
              if(snapshot.data == null){
                return Container(
                    color: Color.fromRGBO(20, 20, 20, 1),
                    child: Error(
                        errorMessage: "Verifiez votre connexion Internet",
                        onRetryPressed: (){
                          print("retry");
                          getRefresh();
                        }
                    )
                );
              }else if(snapshot.data.length == 0){
                return Container(
                color: Color.fromRGBO(20, 20, 20, 1),
                  child: Text(
                    !searchMode ?"Le service est indisponible pour l'instant réessayez plus tard":"Aucun résulat pour votre recherche",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                );
              }else{
                buildPopularManga(snapshot.data);
                Provider.of<PopularMangaProvider>(context,listen: false).setCatalog(widget.catalog.catalogName);
                Provider.of<PopularMangaProvider>(context,listen: false).setMangas(snapshot.data);
                return RefreshIndicator(
                onRefresh: getRefresh,
                  child: Container(
                      color: Color.fromRGBO(20, 20, 20, 1),
                      child:GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: result
                      )
                  ),
                );
              }
            }
          },
        ) : !searchMode ? RefreshIndicator(
            onRefresh: getRefresh,
          child: Consumer<PopularMangaProvider>(
            builder: (context,popularManga,child) => Container(
              color: Color.fromRGBO(20, 20, 20, 1),
              child:GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: buildPopularManga(popularManga.getMangas())
              )
          ),
        )
        ): FutureBuilder(
          future: search(widget.catalog.catalogName,mangaSearch),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Container(
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else{
              if(snapshot.data == null){
                return Container(
                    color: Color.fromRGBO(20, 20, 20, 1),
                    child: Error(
                        errorMessage: "Verifiez votre connexion Internet",
                        onRetryPressed: (){
                          print("retry");
                          getRefresh();
                        }
                    )
                );
              }else if(snapshot.data.length == 0){
                return Container(
                  color: Color.fromRGBO(20, 20, 20, 1),
                  child: Text(
                    !searchMode ?"Le service est indisponible pour l'instant réessayez plus tard":"Aucun résulat pour votre recherche",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                );
              }else{
                buildPopularManga(snapshot.data);
                Provider.of<PopularMangaProvider>(context,listen: false).setCatalog(widget.catalog.catalogName);
                Provider.of<PopularMangaProvider>(context,listen: false).setMangas(snapshot.data);
                return RefreshIndicator(
                  onRefresh: getRefresh,
                  child: Container(
                      color: Color.fromRGBO(20, 20, 20, 1),
                      child:GridView.count(
                          primary: false,
                          padding: const EdgeInsets.all(10),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: result
                      )
                  ),
                );
              }
            }
          },
        ),
    );
  }
}


class DataSearch extends SearchDelegate{
  String source;
  DataSearch(this.source);

  List<Widget> result= [];
  buildPopularManga(data,BuildContext context){
    result = [];
    for(var i =0;i<data.length;i++){
      result.add(
          InkWell(
            child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.2)
                      ]
                  ),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          data[i].thumbnailUrl
                      ),
                      fit: BoxFit.cover
                  ),
                ),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/120),
                      child: Text(
                        data[i].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width/30,
                        ),
                      ),
                    )
                )
            ),
            onTap: (){
              Navigator.of(context).push(new MaterialPageRoute(
                  builder:  (c) => MangaDetails(source,data[i])
              ));
            },
          )
      );
    }
    return result;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }
  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 1));
      search(source,query);
  }
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: search(source,query),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Container(
            color: Color.fromRGBO(20, 20, 20, 1),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }else{
          if(snapshot.data == null){
            return Container(
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Error(
                    errorMessage: "Verifiez votre connexion Internet",
                    onRetryPressed: (){
                      print("retry");
                      getRefresh();
                    }
                )
            );
          }else if(snapshot.data.length == 0){
            return Container(
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Center(
                  child: Text(
                    "Aucun résulat pour votre recherche",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                )
              );
          }else{
            buildPopularManga(snapshot.data,context);
            return RefreshIndicator(
              onRefresh: getRefresh,
              child: Container(
                  color: Color.fromRGBO(20, 20, 20, 1),
                  child:GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(10),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: result
                  )
              ),
            );
          }
        }
      },
    ) ;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Color.fromRGBO(20, 20, 20, 1),
    );
  }
}
