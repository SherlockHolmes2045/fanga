import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/Catalog.dart';
import 'package:manga_reader/error.dart';
import 'package:manga_reader/popularMangaProvider.dart';
import 'package:manga_reader/services.dart';
import 'package:provider/provider.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:manga_reader/manga_details.dart';


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
      fetchPopularManga(widget.catalog.catalogName,"1");
    });
  }

  final AppBarController appBarController = AppBarController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: SearchAppBar(
          primary: Color.fromRGBO(32, 32, 32, 1),
          appBarController: appBarController,
          // You could load the bar with search already active
          autoSelected: false,
          searchHint: "Rechercher...",
          mainTextColor: Colors.white,
          onChange: (String value) {
             print(value);

             setState(() {
               searchMode = value != "" ? true : false;
               mangaSearch = value;
             });
          },
          //Will show when SEARCH MODE wasn't active
          mainAppBar: AppBar(
            title: Text(widget.catalog.name),
            actions: <Widget>[
              InkWell(
                child: Icon(
                  Icons.search,
                ),
                onTap: () {
                  //This is where You change to SEARCH MODE. To hide, just
                  //add FALSE as value on the stream
                  appBarController.stream.add(true);
                },
              ),
            ],
          ),
        ),
        body: Provider.of<PopularMangaProvider>(context,listen:false).getCatalog() == null || Provider.of<PopularMangaProvider>(context,listen:false).getCatalog() != widget.catalog.catalogName ? FutureBuilder(
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
        ) : RefreshIndicator(
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
        ),
    );
  }
}
