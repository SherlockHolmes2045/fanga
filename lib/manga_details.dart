import 'package:flutter/material.dart';
import 'package:manga_reader/services.dart';
import 'package:manga_reader/Catalog.dart';
import 'package:manga_reader/Manga.dart';
import 'package:manga_reader/read_manga.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class MangaDetails extends StatefulWidget {
  Manga manga;
  final Catalog catalog;
  MangaDetails(this.catalog,this.manga);
  @override
  _MangaDetailsState createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> {

  buildListChapters(data,BuildContext context){
    List<Widget> result = [];
    for(var i=data.length-1;i>0;i--){
      result.add(
          Padding(
              padding: EdgeInsets.only(left:7.0,right: 7.0),
              child:
              Card(
                elevation: 0.75,
                color: Color.fromRGBO(32, 32, 32, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: ListTile(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder:  (c) => ReadManga(widget.catalog,data[i])
                    ));
                  },
                  title: Text(
                    data[i].title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0
                    ),
                  ),
                  trailing: InkWell(
                    onTap: ()async {
                      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                      Directory tempDir = await getExternalStorageDirectory();
                      print(tempDir.path);
      final myDir = new Directory(
      "/storage/emulated/"+"/Sunbae/" + widget.manga.title + "/" + data[i].title);
      myDir.exists().then((isThere) {
        if (isThere) {
          getPages(widget.catalog.catalogName, data[i]).then((onValue) {
            for (var i = 0; i < onValue.length; i++) {
              getImageUrl(
                  widget.catalog.catalogName, onValue[i]).then((url) async {
                final taskId = await FlutterDownloader.enqueue(
                  url: url,
                  savedDir: myDir.path,
                  showNotification: true,
                  // show download progress in status bar (for Android)
                  openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                );
              });
            }
          });
        } else {
          new Directory("/storage/emulated/0"+'/Sunbae/' + widget.manga.title + "/" +
              data[i].title).create(recursive: true)

              .then((Directory directory) {
            getPages(widget.catalog.catalogName, data[i]).then((onValue) {
              for (var i = 0; i < onValue.length; i++) {
                getImageUrl(
                    widget.catalog.catalogName, onValue[i])
                    .then((url) async {
                  final taskId = await FlutterDownloader
                      .enqueue(
                    url: url,
                    savedDir: directory.path,
                    showNotification: true,
                    // show download progress in status bar (for Android)
                    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                  );
                });
              }
            });
          });
        }
      });

                    },
                    child: Icon(Icons.get_app,color: Colors.grey)
                  ),
                ),
              )
          )
      );
    }
    return result;
  }
  Future<Null> getRefresh() async{
    await Future.delayed (Duration(seconds:3));
    setState(() {
      getMangaDetails(widget.catalog.catalogName,widget.manga);
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
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
              ]
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: getMangaDetails(widget.catalog.catalogName,widget.manga),
              builder: (context,snapshot){
                if(snapshot.connectionState== ConnectionState.waiting){
                  return Container(
                    color: Color.fromRGBO(20, 20, 20, 1),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }else{
                  widget.manga = snapshot.data;
                  return RefreshIndicator(
                    onRefresh: getRefresh,
                    child: Container(
                        color: Color.fromRGBO(20, 20, 20, 1),
                      child: Container(
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.manga.thumbnailUrl,
                              ),
                              fit: BoxFit.scaleDown
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            FutureBuilder(
              future: getChapters(widget.catalog.catalogName,widget.manga),
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
                      child: ListView(
                        children: buildListChapters(snapshot.data, context),
                      )
                    ),
                  );
                }
              },
            ),
          ],
        ),
      )
    );
  }
}
