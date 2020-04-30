import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:manga_reader/downloads.dart';
import 'dart:io';
import 'package:manga_reader/read_manga.dart';
import 'package:manga_reader/Chapter.dart';
import 'package:manga_reader/task_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader/Manga.dart';
import 'package:manga_reader/services.dart';
import 'package:provider/provider.dart';

class Chapitre extends StatefulWidget with WidgetsBindingObserver {

  final String catalog;
  final Chapter chapter;
  final Manga manga;
  Chapitre(this.catalog,this.chapter,this.manga);
  @override
  _ChapitreState createState() => _ChapitreState();
}

class _ChapitreState extends State<Chapitre> {

  bool isDownloading = false;
  double percentage = 0.0;
  ReceivePort _port = ReceivePort();

  @override
  void initState(){
    super.initState();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _unbindBackgroundIsolate();
    super.dispose();
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];


        setState(() {

          for(int i= 0; i < Provider.of<Downloads>(context,listen: false).getDownloads().length;i++){
            print(Provider.of<Downloads>(context,listen: false).getDownloads()[i]["count"]);
            for(int j = 0; j  < Provider.of<Downloads>(context,listen: false).getDownloads()[i]["tasks"].length;j++){
              if(id == Provider.of<Downloads>(context,listen: false).getDownloads()[i]["tasks"][j].taskId){

                Provider.of<Downloads>(context,listen: false).getDownloads()[i]["tasks"][j].progress = progress;
                if(progress == 100){
                  Provider.of<Downloads>(context,listen: false).getDownloads()[i]["percentage"]+=Provider.of<Downloads>(context,listen: false).getDownloads()[i]["count"];
                }
              }
            }
          }
        });
      //}
    });
  }


    void _unbindBackgroundIsolate() {
      IsolateNameServer.removePortNameMapping('downloader_send_port');
    }

    static void downloadCallback(
        String id, DownloadTaskStatus status, int progress) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
      final SendPort send =
      IsolateNameServer.lookupPortByName('downloader_send_port');
      send.send([id, status, progress]);
    }

  @override
  Widget build(BuildContext context) {

    return Padding(
          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/51.43,right: MediaQuery.of(context).size.width/51.3),
        child: ListTile(
          onTap: ()async {
            PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
            if (permission != PermissionStatus.granted) {
              Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
            }
            if(permission == PermissionStatus.granted) {
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (c) =>
                      ReadManga(widget.catalog, widget.chapter, widget.manga)
              )
              );
            }else{
              showDialog(
                context:context,
                builder: (BuildContext context){
                  return AlertDialog(
                    content: Text(
                    "Vous n'avez pas accordé la permission"
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Fermer"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
              );
            }
            },
                  title: Text(
                    widget.chapter.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width/30
                    ),
                  ),
                  trailing:
                      InkWell(

                          onTap: ()async {

                            PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

                            if (permission != PermissionStatus.granted) {
                              Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                            }

                            if(permission == PermissionStatus.granted){
                              Directory appDocDir = await getApplicationSupportDirectory();
                              String appDocPath = appDocDir.path;
                              print(appDocPath);
                              final myDir = new Directory("/storage/emulated/0"+'/Fanga/' + widget.catalog +"/" + widget.manga.title + "/" + widget.chapter.title);
                              myDir.exists().then((isThere) {
                                if (isThere) {
                                  getPages(widget.catalog, widget.chapter).then((onValue) async {
                                    final File file = File('${myDir.path}/.nomedia');
                                    file.create();
                                    final File map = File(appDocPath+"/"+widget.catalog +"/" + widget.manga.title + "/" + widget.chapter.title+"/map.txt");
                                    map.create(recursive: true);

                                    List<TaskInfo> tasks = [];
                                    Provider.of<Downloads>(context,listen: false).addTask(tasks, widget.manga.title, widget.chapter.title,onValue.length/100);
                                    for (var i = 0; i < onValue.length; i++) {
                                      map.writeAsStringSync((i+1).toString()+".png,",mode: FileMode.append);
                                      getImageUrl(
                                          widget.catalog, onValue[i]).then((url) async {

                                            final taskId = await FlutterDownloader.enqueue(
                                              url: url,
                                              savedDir: myDir.path,
                                              fileName: (i+1).toString()+".png",
                                              showNotification: true,
                                              // show download progress in status bar (for Android)
                                              openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                            );
                                            Provider.of<Downloads>(context,listen: false).getDownloads()[Provider.of<Downloads>(context,listen: false).getDownloads().length-1]["tasks"].add(new TaskInfo(taskId: taskId));
                                            Provider.of<Downloads>(context,listen: false).getDownloads()[Provider.of<Downloads>(context,listen: false).getDownloads().length-1]["count"] = i+1;

                                          });
                                    }
                                    print(Provider.of<Downloads>(context,listen: false).getDownloads().toString());

                                  });

                                } else {
                                  new Directory(
                                      "/storage/emulated/0"+'/Fanga/' + widget.catalog +"/" + widget.manga.title + "/" + widget.chapter.title).create(recursive: true).then((Directory directory) {

                                        getPages(widget.catalog, widget.chapter).then((onValue) async {
                                          final File file = File('${myDir.path}/.nomedia');
                                          file.create();
                                          final File map = File(appDocPath+"/"+widget.catalog +"/" + widget.manga.title + "/" + widget.chapter.title+"/map.txt");
                                          map.create(recursive: true);
                                          List<TaskInfo> tasks = [];

                                          Provider.of<Downloads>(context,listen: false).addTask(tasks, widget.manga.title, widget.chapter.title,onValue.length/100);
                                          for (var i = 0; i < onValue.length; i++) {
                                            map.writeAsStringSync((i+1).toString()+".png,",mode: FileMode.append);
                                            getImageUrl(
                                                widget.catalog, onValue[i]).then((url) async {

                                                  final taskId = await FlutterDownloader.enqueue(
                                                    url: url,
                                                    fileName: (i+1).toString()+".png",
                                                    savedDir: directory.path,
                                                    showNotification: true,
                                                    // show download progress in status bar (for Android)
                                                     openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                                  );

                                                  Provider.of<Downloads>(context,listen: false).getDownloads()[Provider.of<Downloads>(context,listen: false).getDownloads().length-1]["tasks"].add(new TaskInfo(taskId: taskId));

                                                });
                                          }
                                          print(Provider.of<Downloads>(context,listen: false).getDownloads().toString());

                                        });

                                      });
                                }
                              });
                            }
                            },
                          child: !isDownloading ? Icon(Icons.get_app,color: Colors.grey) : Icon(Icons.pause, color: Colors.grey)
                      ),

                )
    );
  }
}

