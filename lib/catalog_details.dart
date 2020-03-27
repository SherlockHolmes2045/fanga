import 'package:flutter/material.dart';
import 'package:manga_reader/Catalog.dart';
import 'package:manga_reader/services.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:manga_reader/manga_details.dart';
class CatalogDetails extends StatefulWidget {
  final Catalog catalog;
  const CatalogDetails(this.catalog);
  @override
  _CatalogDetailsState createState() => _CatalogDetailsState();
}

class _CatalogDetailsState extends State<CatalogDetails> {

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
                    image: NetworkImage(
                        data[i].thumbnailUrl
                    ),
                    fit: BoxFit.cover
                ),
              ),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.0),
                    child: Text(
                      data[i].title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  )
              )
          ),
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(
                builder:  (c) => MangaDetails(widget.catalog,data[i])
            ));
          },
        )
      );
    }
    return result;
  }
  Future<Null> getRefresh() async{
    await Future.delayed (Duration(seconds:3));
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
            //Your function to filter list. It should interact with
            //the Stream that generate the final list
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
                  appBarController.stream.add(false);
                },
              ),
            ],
          ),
        ),
        body:FutureBuilder(
          future: fetchPopularManga(widget.catalog.catalogName,"1"),
          builder: (context,snapshot){
            if(snapshot.connectionState== ConnectionState.waiting){
              return Container(
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else{

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
                        children: buildPopularManga(snapshot.data)
                    )
                ),
              );
            }
          },
        )
    );
  }
}
