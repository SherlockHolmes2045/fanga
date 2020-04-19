import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/mangaDetailsprovider.dart';
import 'package:manga_reader/services.dart';
import 'package:manga_reader/Manga.dart';
import 'package:manga_reader/manga_dao.dart';
import 'package:manga_reader/error.dart';
import 'package:manga_reader/chapitre.dart';
import 'package:provider/provider.dart';

class MangaDetails extends StatefulWidget {
  Manga manga;
  final String catalog;
  MangaDetails(this.catalog,this.manga);
  @override
  _MangaDetailsState createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> {

  bool fav = false;
  @override
  void initState(){
    FruitDao fruitDao = new FruitDao();
    fruitDao.findManga(widget.catalog, widget.manga.title).then((onValue){
      if(onValue.length != 0){
        setState(() {
          fav = true;
        });
      }
    });

    super.initState();
  }
  buildGenre(data){

    List<Widget> result = new List<Widget>();

    var genres = data.split("\n");

    for(var i = 0; i < genres.length; i++){

      result.add(
        Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.blueAccent)
          ),
          child: Center(
            child: Text(
              genres[i],
              style: TextStyle(
                color: Colors.blueAccent,
              ),
              softWrap: true,
            ),
          )
        ),
      );
      result.add(
        SizedBox(
          width: 7.0,
        )
      );
    }
    return result;
  }
  buildListChapters(data,BuildContext context){
    List<Widget> result = [];
    for(var i=data.length-1;i>0;i--){
      result.add(
          Chapitre(widget.catalog,data[i],widget.manga)
      );
    }
    return result;
  }
  Future<Null> getRefresh() async{
    await Future.delayed (Duration(seconds:1));
    setState(() {
      getMangaDetails(widget.catalog,widget.manga);
    });
  }
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.manga.title),
          bottom: TabBar(
              tabs:
              [
                Tab(child:Text("INFO"),),
                Tab(child: Text("CHAPITRES"),),
              ]
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Provider.of<MangaDetailsProvider>(context,listen:false).getCatalog() == null || Provider.of<MangaDetailsProvider>(context,listen:false).getCatalog() != widget.catalog ||
            Provider.of<MangaDetailsProvider>(context,listen:false).getManga().title != widget.manga.title ?
            FutureBuilder(
              future: getMangaDetails(widget.catalog,widget.manga),
              builder: (context,snapshot){
                if(snapshot.connectionState== ConnectionState.waiting){
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
                              setState(() {

                              });
                            }
                        )
                    );
                  }else {
                    widget.manga = snapshot.data;
                    Provider.of<MangaDetailsProvider>(context,listen: false).setCatalog(widget.catalog);
                    Provider.of<MangaDetailsProvider>(context,listen: false).setManga(widget.manga);
                    return RefreshIndicator(
                      color: Color.fromRGBO(20, 20, 20, 1),
                      onRefresh: getRefresh,
                      child: Container(
                        color: Color.fromRGBO(20, 20, 20, 1),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height/2.87,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        snapshot.data.thumbnailUrl,
                                      )
                                  )
                              ),
                              child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 2.7, sigmaY: 2.7),
                                  child: new Container(
                                    decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                                  )
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/28.6,
                              left: -(MediaQuery.of(context).size.width/59.33),
                              child: CachedNetworkImage(
                                imageUrl:snapshot.data.thumbnailUrl,
                                fit: BoxFit.scaleDown,
                              ),
                              height: MediaQuery.of(context).size.height/3.56,
                              width: MediaQuery.of(context).size.width/1.8,
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/23.73,
                              left: MediaQuery.of(context).size.width/2.14,
                              child:SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/36),
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height,
                                  child: Text(
                                    snapshot.data.title,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/26.7
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.clip,
                                  ),
                                ),
                              )
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/7.91,
                              left:MediaQuery.of(context).size.width/2,
                              child:Row(
                                children: <Widget>[
                                  Text(
                                    "Auteur",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/26.7
                                    ),
                                  ),
                                  SizedBox(
                                          width: MediaQuery.of(context).size.width/71.2,
                                  ),
                                  Text(
                                    snapshot.data.author,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/34.29
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/5.93,
                              left: MediaQuery.of(context).size.width/2,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Artiste",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/26.7
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width/71.2,
                                  ),
                                  Text(
                                    snapshot.data.artist == "" ? "Unknow" : snapshot.data.artist,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/34.29
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/4.75,
                              left: MediaQuery.of(context).size.width/2,
                              child:Row(
                                children: <Widget>[
                                  Text(
                                    "Statut",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/26.7
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width/71.2,
                                  ),
                                  Text(
                                    snapshot.data.status,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: MediaQuery.of(context).size.width/34.29
                                    ),
                                  )
                                ],
                              ),
                            ),
                             Positioned(
                               top: MediaQuery.of(context).size.height/3.95,
                               left: MediaQuery.of(context).size.width/2,
                               child: Row(
                                 children: <Widget>[
                                   Text(
                                     "Source",
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.bold,
                                         fontSize: MediaQuery.of(context).size.width/26.7
                                     ),
                                   ),
                                   SizedBox(
                                     width: MediaQuery.of(context).size.width/71.2,
                                   ),
                                   Text(
                                     widget.catalog,
                                     style: TextStyle(
                                         color: Colors.blueGrey,
                                         fontWeight: FontWeight.bold,
                                         fontSize: MediaQuery.of(context).size.width/33
                                     ),
                                   )
                                 ],
                               ),
                             ) ,

                            Positioned(
                              top:MediaQuery.of(context).size.height/3.24,
                              left: MediaQuery.of(context).size.width/1.31,
                              child: InkWell(
                                onTap:(){
                                  if(fav){
                                    FruitDao fruitDao = new FruitDao();
                                    fruitDao.delete(widget.catalog, widget.manga.title).then((onValue){
                                      setState(() {
                                        fav = false;
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text('${widget.manga.title} a été supprimé à votre bibliothèque'),
                                          duration: Duration(seconds: 2),
                                        ));
                                      });
                                    });
                                  }else{
                                    FruitDao fruitDao = new FruitDao();
                                    fruitDao.insert(widget.manga).then((onValue){
                                      setState(() {
                                        fav = true;
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                          content: Text('${widget.manga.title} a été ajouté à votre bibliothèque'),
                                          duration: Duration(seconds: 2),
                                        ));
                                      });
                                      });
                                  }

                                },
                                child: Card(
                                    elevation: 3.0,
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0)
                                    ),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height/11.9,
                                      width: MediaQuery.of(context).size.width/6,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue
                                      ),
                                      child: Center(
                                        child: Icon(
                                          fav ? Icons.bookmark : Icons.book,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height/2.65,
                              child: Padding(
                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/24),
                                child:Text(
                                  "Description",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ) ,
                              ),
                            ),

                            Positioned(
                                top: MediaQuery.of(context).size.height/2.6,
                                child:Container(
                                    padding: EdgeInsets.all(15.0),
                                    width: MediaQuery.of(context).size.width,
                                    height: 200.0,
                                    child:SingleChildScrollView(
                                      child: Text(
                                        snapshot.data.description,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                        softWrap: true,
                                        textAlign: TextAlign.justify,
                                      ) ,
                                    )
                                )
                            ),
                            Positioned(
                              top: 480.0,
                              left: 20.0,
                              child: Container(
                                child:Row(
                                    children: buildGenre(snapshot.data.genre)
                                ),
                              )
                            )
                          ],
                        ),
                        /* ],
                        )*/
                      ),
                    );
                  }

                }
              },
            ): RefreshIndicator(
              color: Color.fromRGBO(20, 20, 20, 1),
              onRefresh: getRefresh,
              child: Consumer<MangaDetailsProvider>(
                builder: (context,mangaDetails,child) =>
                    Container(
                color: Color.fromRGBO(20, 20, 20, 1),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height/2.87,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                mangaDetails.manga.thumbnailUrl,
                              )
                          )
                      ),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2.7, sigmaY: 2.7),
                          child: new Container(
                            decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
                          )
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/28.6,
                      left: -(MediaQuery.of(context).size.width/59.33),
                      child: CachedNetworkImage(
                        imageUrl:mangaDetails.manga.thumbnailUrl,
                        fit: BoxFit.scaleDown,
                      ),
                      height: MediaQuery.of(context).size.height/3.56,
                      width: MediaQuery.of(context).size.width/1.8,
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height/23.73,
                        left: MediaQuery.of(context).size.width/2.14,
                        child:SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/36),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Text(
                              mangaDetails.manga.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width/26.7
                              ),
                              softWrap: true,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        )
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/7.91,
                      left:MediaQuery.of(context).size.width/2,
                      child:Row(
                        children: <Widget>[
                          Text(
                            "Auteur",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/26.7
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/71.2,
                          ),
                          Text(
                            mangaDetails.manga.author,
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/34.29
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/5.93,
                      left: MediaQuery.of(context).size.width/2,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Artiste",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/26.7
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/71.2,
                          ),
                          Text(
                            mangaDetails.manga.artist == "" ? "Unknow" : mangaDetails.manga.artist,
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/34.29
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/4.75,
                      left: MediaQuery.of(context).size.width/2,
                      child:Row(
                        children: <Widget>[
                          Text(
                            "Statut",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/26.7
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/71.2,
                          ),
                          Text(
                            mangaDetails.manga.status,
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/34.29
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/3.95,
                      left: MediaQuery.of(context).size.width/2,
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Source",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/26.7
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width/71.2,
                          ),
                          Text(
                            widget.catalog,
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                fontSize: MediaQuery.of(context).size.width/33
                            ),
                          )
                        ],
                      ),
                    ) ,

                    Positioned(
                      top:MediaQuery.of(context).size.height/3.24,
                      left: MediaQuery.of(context).size.width/1.31,
                      child: InkWell(
                        onTap:(){
                          if(fav){
                            FruitDao fruitDao = new FruitDao();
                            fruitDao.delete(widget.catalog, widget.manga.title).then((onValue){
                              setState(() {
                                fav = false;
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('${widget.manga.title} a été supprimé à votre bibliothèque'),
                                  duration: Duration(seconds: 2),
                                ));
                              });
                            });
                          }else{
                            FruitDao fruitDao = new FruitDao();
                            fruitDao.insert(widget.manga).then((onValue){
                              setState(() {
                                fav = true;
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('${widget.manga.title} a été ajouté à votre bibliothèque'),
                                  duration: Duration(seconds: 2),
                                ));
                              });

                            });
                          }

                        },
                        child: Card(
                            elevation: 3.0,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height/11.9,
                              width: MediaQuery.of(context).size.width/6,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue
                              ),
                              child: Center(
                                child: Icon(
                                  fav ? Icons.bookmark : Icons.book,
                                  color: Colors.white,
                                ),
                              ),
                            )
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height/2.65,
                      child: Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/24),
                        child:Text(
                          "Description",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ) ,
                      ),
                    ),

                    Positioned(
                        top: MediaQuery.of(context).size.height/2.6,
                        child:Container(
                            padding: EdgeInsets.all(15.0),
                            width: MediaQuery.of(context).size.width,
                            height: 200.0,
                            child:SingleChildScrollView(
                              child: Text(
                                mangaDetails.manga.description,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                softWrap: true,
                                textAlign: TextAlign.justify,
                              ) ,
                            )
                        )
                    ),
                    Positioned(
                        top: 480.0,
                        left: 20.0,
                        child: Container(
                          child:Row(
                              children: buildGenre(mangaDetails.manga.genre)
                          ),
                        )
                    )
                  ],
                ),
                /* ],
                        )*/
              ),
            ),
            ),

            Provider.of<MangaDetailsProvider>(context,listen: false).getCatalog() == null || Provider.of<MangaDetailsProvider>(context,listen: false).getCatalog() != widget.catalog ||
                Provider.of<MangaDetailsProvider>(context,listen: false).getChapters() == null || Provider.of<MangaDetailsProvider>(context,listen:false).getManga().title != widget.manga.title ?
                FutureBuilder(
              future: getChapters(widget.catalog,widget.manga),
              builder: (context,snapshot){
                if(snapshot.connectionState== ConnectionState.waiting){
                  return Container(
                    color: Color.fromRGBO(20, 20, 20, 1),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color.fromRGBO(20, 20, 20, 1),
                      ),
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
                              setState(() {
                              });
                            }
                            )
                    );
                  }else{
                    Provider.of<MangaDetailsProvider>(context,listen: false).setCatalog(widget.catalog);
                    Provider.of<MangaDetailsProvider>(context,listen: false).setChapters(snapshot.data);
                    return RefreshIndicator(
                      onRefresh: getRefresh,
                      child: Container(
                          color: Color.fromRGBO(20, 20, 20, 1),
                          child: ListView(
                            children: buildListChapters(snapshot.data, context),
                          )
                      ),
                    );
                  }

                }
              },
            ) : RefreshIndicator(
              onRefresh: getRefresh,
              child: Consumer<MangaDetailsProvider>(
                builder: (context,mangaDetails,child) => Container(
                  color: Color.fromRGBO(20, 20, 20, 1),
                  child: ListView(
                    children: buildListChapters(mangaDetails.getChapters(), context),
                  )
              ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
