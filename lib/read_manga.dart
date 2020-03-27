import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_reader/Catalog.dart';
import 'package:manga_reader/Chapter.dart';
import 'package:manga_reader/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_advanced_networkimage/zoomable.dart';
import 'package:flutter_image/network.dart';

class ReadManga extends StatefulWidget {
  final Catalog catalog;
  final Chapter chapter;
  ReadManga(this.catalog,this.chapter);
  @override
  _ReadMangaState createState() => _ReadMangaState();
}

class _ReadMangaState extends State<ReadManga> {

  var pages=[];

  buildImages(data,BuildContext context){
    List<Widget> result = [];
    for(var i=0;i<data.length;i++){
      result.add(
        FutureBuilder(
          future: getImageUrl(widget.catalog.catalogName,data[i]),
          builder: (context,snapshot){
            if(snapshot.connectionState== ConnectionState.waiting){
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }else{
              return
                Center(
                  child: Column(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: snapshot.data,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => RaisedButton(
                          child: Text("Retry"),
                          onPressed: (){
                            setState(() {

                            });
                          },
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text((i+1).toString()+"/"+data.length.toString(),
                            style:TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                            ) ,
                          ),
                        ),
                      )
                    ],
                  ),
                );
            }
          },
        )
      );
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

      return Scaffold(
        body: FutureBuilder(
          future: getPages(widget.catalog.catalogName, widget.chapter),
          builder: (context,snapshot){
            if(snapshot.connectionState== ConnectionState.waiting){
              return Container(
              );
            }else{
              pages = snapshot.data;
              print(pages.toString());
              getImageUrl(widget.catalog.catalogName, pages[0]);
              return PageView(
                children: buildImages(pages, context)
              );
    }
          },
        )
      );

     /* return Scaffold(
        body: PageView(
          children: <Widget>[
            Container(
              color: Colors.pink,
            ),
            Container(
              color: Colors.cyan,
            ),
            Container(
              color: Colors.deepPurple,
            ),
          ],
        ),
      );*/
  }
}
