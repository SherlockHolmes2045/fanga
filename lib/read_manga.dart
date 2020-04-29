import 'dart:io';
import 'package:manga_reader/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_reader/Chapter.dart';
import 'package:manga_reader/services.dart';
import 'package:manga_reader/page.dart';
import 'package:path_provider/path_provider.dart';
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
        setState(() {
          downloaded = true;
        });

        print(paths.toString());
      }
    });
  }
  @override
  void initState(){
    //verifyDownload();
    super.initState();
  }

  buildImages(data,BuildContext context) async {
    List<Widget> result = [];
    List<Widget> finalResult = [];
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    final File map = File(appDocPath+"/"+widget.catalog +"/" + widget.manga.title + "/" + widget.chapter.title+"/map.txt");

    finalResult = await map.exists().then((isTrue) async {
      if(isTrue){
        String contents = await map.readAsString();

        var pages = contents.split(",");
        pages.removeLast();
        for(int i=0; i < pages.length;i++){
          File file = new File("/storage/emulated/0"+'/Fanga/' + widget.catalog +"/" + widget.manga.title + "/" +
              widget.chapter.title+"/"+pages[i]);
          file.exists().then((isTrue){
            if(isTrue){
              result.add(
                  Page(widget.catalog,null,((i+1).toString()+"/"+data.length.toString()).toString(),file.path)
              );
            }else{
              result.add(
                  Page(widget.catalog,data[i],((i+1).toString()+"/"+data.length.toString()).toString(),null)
              );
            }
          });
        }
        return result;
      }else{
        for(var i=0;i<data.length;i++){
          result.add(
              Page(widget.catalog,data[i],((i+1).toString()+"/"+data.length.toString()).toString(),null)
          );
        }
        return result;
      }
    });
    return finalResult;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

      return Scaffold(
          body: FutureBuilder(
            future: getPages(widget.catalog, widget.chapter),
            builder: (context,snapshot){
              if(snapshot.connectionState== ConnectionState.waiting){
                return Container(
                );
              }else{
                if(snapshot.data == null){
                  return Container(
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
                  pages = snapshot.data;

                  return PageView(
                      children: buildImages(pages, context).then((onValue){
                        return onValue;
                      })
                  );
                }
              }
            },
          )
      );
    }
}

