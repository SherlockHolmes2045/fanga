import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_reader/Chapter.dart';
import 'package:manga_reader/services.dart';
import 'package:manga_reader/page.dart';
import 'Manga.dart';

class ReadManga extends StatefulWidget {
  final String catalog;
  final Chapter chapter;
  final Manga manga;
  ReadManga(this.catalog,this.chapter,this.manga);
  @override
  _ReadMangaState createState() => _ReadMangaState();
}

class _ReadMangaState extends State<ReadManga> {

  var pages=[];
  List paths = new List();
  String extension = "";
  bool downloaded = false;

  verifyDownload(){
    final dir = Directory("/storage/emulated/0"+'/Sunbae/' + widget.catalog +"/" + widget.manga.title + "/" +
        widget.chapter.title);
    dir.exists().then((isThere){
      if(isThere){

        var files = dir.listSync().toList();

        files.forEach((e){
          var temp = e.path.split("/");
          var temp2 = temp[temp.length-1].split(".");
          extension = temp2[1];
          paths.add(int.parse(temp2[0]));
        });
        paths.sort();
        downloaded = true;
        print(paths.toString());
      }
    });
  }
  @override
  void initState(){
    verifyDownload();
    super.initState();
  }

  buildImages(data,BuildContext context){
    List<Widget> result = [];
    if(downloaded){
      print("downloaded");
      for(var i=0;i<paths.length;i++){
        result.add(
            Page(widget.catalog,null,((i+1).toString()+"/"+data.length.toString()).toString(),"/storage/emulated/0"+'/Sunbae/' + widget.catalog +"/" + widget.manga.title + "/" +
                widget.chapter.title+"/"+paths[i].toString()+"."+extension)
        );
      }
    }else{
      for(var i=0;i<data.length;i++){
        result.add(
            Page(widget.catalog,data[i],((i+1).toString()+"/"+data.length.toString()).toString(),null)
        );
      }
    }

    return result;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    if(downloaded){
      return PageView(
        children: buildImages(pages, context)
      );
    }else{
      return Scaffold(
          body: FutureBuilder(
            future: getPages(widget.catalog, widget.chapter),
            builder: (context,snapshot){
              if(snapshot.connectionState== ConnectionState.waiting){
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }else{
                pages = snapshot.data;

                return PageView(
                    children: buildImages(pages, context)
                );
              }
            },
          )
      );
    }

  }
}

