import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:manga_reader/downloads.dart';
import 'dart:io';
import 'package:manga_reader/read_manga.dart';
import 'package:manga_reader/Chapter.dart';
import 'package:manga_reader/task_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader/Manga.dart';
import 'package:manga_reader/services.dart';
import 'package:dio/dio.dart';
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

     /* final task = _tasks?.firstWhere((task) => task.taskId == id);
      if (task != null) {*/
        setState(() {
          /*task.status = status;
          task.progress = progress;*/
          for(int i= 0; i < Provider.of<Downloads>(context,listen: false).getDownloads().length;i++){

            for(int j = 0; j  < Provider.of<Downloads>(context,listen: false).getDownloads()[i]["tasks"].length;i++){
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
      padding: EdgeInsets.all(MediaQuery.of(context).size.width/90),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(new MaterialPageRoute(
              builder:  (c) => ReadManga(widget.catalog,widget.chapter,widget.manga)
          ));
        },
        child: Padding(
          padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/51.43,right: MediaQuery.of(context).size.width/51.3),
    child:
    Card(
    elevation: 0.75,
    color: Color.fromRGBO(32, 32, 32, 1),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0)
    ),
    child: ListTile(
    title: Text(
    widget.chapter.title,
    style: TextStyle(
    color: Colors.white,
    fontSize: MediaQuery.of(context).size.width/30
    ),
    ),
    trailing: Row(
    children: <Widget>[
    InkWell(

    onTap: ()async {

    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    }

    if(permission == PermissionStatus.granted){
    final myDir = new Directory(
    "/storage/emulated/0"+'/Sunbae/' + widget.catalog +"/" + widget.manga.title + "/" +
    widget.chapter.title
    );

    myDir.exists().then((isThere) {
    if (isThere) {
    List<TaskInfo> tasks = [];
    getPages(widget.catalog, widget.chapter).then((onValue) async {
    for (var i = 0; i < onValue.length; i++) {
    getImageUrl(
    widget.catalog, onValue[i]).then((url) async {
    final taskId = await FlutterDownloader.enqueue(
    url: url,
    savedDir: myDir.path,
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    tasks.add(new TaskInfo(taskId: taskId));
    });
    }
    Provider.of<Downloads>(context,listen: false).addTask(tasks, widget.manga.title, widget.chapter.title,tasks.length);
    print(Provider.of<Downloads>(context,listen: false).getDownloads().toString());
    });
    } else {
    new Directory(
    "/storage/emulated/0"+'/Sunbae/' + widget.catalog +"/" + widget.manga.title + "/" +
    widget.chapter.title).create(recursive: true).then((Directory directory) {
    getPages(widget.catalog, widget.chapter).then((onValue) async {

    Dio dio = new Dio();
    List<TaskInfo> tasks = [];
    for (var i = 0; i < onValue.length; i++) {
    getImageUrl(
    widget.catalog, onValue[i]).then((url) async {
    /*tasks.add(
                                              dio.download(url,directory.path+"/"+(i+1).toString()+".png",onReceiveProgress: (int sent, int total) {
                                                if(sent==total){
                                                  setState(() {
                                                    percentage += ((sent/total)*100)/onValue.length;
                                                    print(percentage);
                                                  });
                                                }
                                              },)
                                            );*/
    final taskId = await FlutterDownloader.enqueue(
    url: url,
    savedDir: directory.path,
    showNotification: true,
    // show download progress in status bar (for Android)
    openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    tasks.add(new TaskInfo(taskId: taskId));
    });
    }
    Provider.of<Downloads>(context,listen: false).addTask(tasks, widget.manga.title, widget.chapter.title,tasks.length);
    print(Provider.of<Downloads>(context,listen: false).getDownloads().toString());
    });
    });
    }
    });
    }

    },
    child: !isDownloading ? Icon(Icons.get_app,color: Colors.grey) : Icon(Icons.pause, color: Colors.grey)
    ),
    ],
    ),
    )Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 17.0,right: 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.0),
              color: Color.fromRGBO(32, 32,32, 1),
            ),
            child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.chapter.title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width/30
                        ),
                      ),
                      InkWell(

                          onTap: ()async {

                            PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);

                            if (permission != PermissionStatus.granted) {
                              Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                            }

                            if(permission == PermissionStatus.granted){
                              final myDir = new Directory(
                                  "/storage/emulated/0"+'/Sunbae/' + widget.catalog +"/" + widget.manga.title + "/" +
                                      widget.chapter.title
                              );

                              myDir.exists().then((isThere) {
                                if (isThere) {
                                  List<TaskInfo> tasks = [];
                                  getPages(widget.catalog, widget.chapter).then((onValue) async {
                                    for (var i = 0; i < onValue.length; i++) {
                                      getImageUrl(
                                          widget.catalog, onValue[i]).then((url) async {
                                        final taskId = await FlutterDownloader.enqueue(
                                          url: url,
                                          savedDir: myDir.path,
                                          showNotification: true,
                                          // show download progress in status bar (for Android)
                                          openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                        );
                                        tasks.add(new TaskInfo(taskId: taskId));
                                      });
                                    }
                                    Provider.of<Downloads>(context,listen: false).addTask(tasks, widget.manga.title, widget.chapter.title,tasks.length);
                                    print(Provider.of<Downloads>(context,listen: false).getDownloads().toString());
                                  });
                                } else {
                                  new Directory(
                                      "/storage/emulated/0"+'/Sunbae/' + widget.catalog +"/" + widget.manga.title + "/" +
                                          widget.chapter.title).create(recursive: true).then((Directory directory) {
                                    getPages(widget.catalog, widget.chapter).then((onValue) async {

                                      Dio dio = new Dio();
                                      List<TaskInfo> tasks = [];
                                      for (var i = 0; i < onValue.length; i++) {
                                        getImageUrl(
                                            widget.catalog, onValue[i]).then((url) async {
                                          /*tasks.add(
                                              dio.download(url,directory.path+"/"+(i+1).toString()+".png",onReceiveProgress: (int sent, int total) {
                                                if(sent==total){
                                                  setState(() {
                                                    percentage += ((sent/total)*100)/onValue.length;
                                                    print(percentage);
                                                  });
                                                }
                                              },)
                                            );*/
                                          final taskId = await FlutterDownloader.enqueue(
                                            url: url,
                                            savedDir: directory.path,
                                            showNotification: true,
                                            // show download progress in status bar (for Android)
                                            openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                                          );
                                          tasks.add(new TaskInfo(taskId: taskId));
                                        });
                                      }
                                      Provider.of<Downloads>(context,listen: false).addTask(tasks, widget.manga.title, widget.chapter.title,tasks.length);
                                      print(Provider.of<Downloads>(context,listen: false).getDownloads().toString());
                                    });
                                  });
                                }
                              });
                            }

                          },
                          child: !isDownloading ? Icon(Icons.get_app,color: Colors.grey) : Icon(Icons.pause, color: Colors.grey)
                      ),
                    ],
                  ),
                  isDownloading ? Padding(
                    padding: EdgeInsets.only(top:10.0),
                    child: LinearProgressIndicator(
                      value: percentage,
                    ),
                  ): SizedBox()
                ]
            )
        ),
      ),/*ListTile(
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
                ),*/
    );
  }
}

