import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/state/action_provider.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:manga_reader/models/download.dart' as Model;
import 'package:manga_reader/utils/task_info.dart';
import 'package:provider/provider.dart';

class Download extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ActionProvider>().getAllDownloads();
    });
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Téléchargements",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          )),
      body: Container(
        child: ListView.separated(
            itemCount: context.watch<ActionProvider>().downloadTasks.length,
            reverse: true,
            shrinkWrap: true,
            separatorBuilder: (context, int index) => Divider(
                  color: Colors.grey.withOpacity(0.3),
                  endIndent: SizeConfig.blockSizeHorizontal * 5,
                  indent: SizeConfig.blockSizeHorizontal * 5,
                ),
            itemBuilder: (context, int index) {
              return FutureBuilder(
                  future: context.read<ActionProvider>().findDownload(context
                      .watch<ActionProvider>()
                      .downloadTasks[index]
                      .taskId),
                  builder: (context, AsyncSnapshot<Model.Download> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return ListTile(
                          leading: Container(
                            height: SizeConfig.blockSizeVertical * 6,
                            width: SizeConfig.blockSizeHorizontal * 12,
                            child: CachedNetworkImage(
                              imageUrl: snapshot.data.manga.thumbnailUrl,
                              width: double.infinity,
                              height: 350,
                              errorWidget:
                                  (context, text, data) {
                                return Image.asset(
                                    Assets.errorImage,
                                    width: double.infinity,
                                    height: 350,
                                );
                              },
                              //fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(
                            context
                                .watch<ActionProvider>()
                                .downloadTasks[index]
                                .url
                                .split("/")[5],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  context
                                      .watch<ActionProvider>()
                                      .downloadTasks[index]
                                      .filename != null ?
                                  context
                                      .watch<ActionProvider>()
                                      .downloadTasks[index]
                                      .filename
                                      .split(".")[0] : "",
                                  style: TextStyle(color: Colors.white)),
                              if(context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.running)...[
                                Padding(
                                  padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 20,top: SizeConfig.blockSizeVertical),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    value: context.watch<ActionProvider>().downloadTasks[index].progress / 100,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan,),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${dirStatSync(context.watch<ActionProvider>().downloadTasks[index].savedDir +"/"+context.watch<ActionProvider>().downloadTasks[index].filename.split('.')[0])["size"].toStringAsFixed(2)
                                      } Mo",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              ]else if(context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.complete)...[
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${dirStatSync(context.watch<ActionProvider>().downloadTasks[index].savedDir +"/"+context.watch<ActionProvider>().downloadTasks[index].filename.split('.')[0])["size"].toStringAsFixed(2)
                                      } Mo  ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      DateTime.fromMillisecondsSinceEpoch(context.watch<ActionProvider>().downloadTasks[index].timeCreated).year.toString() +"/"+DateTime.fromMillisecondsSinceEpoch(context.watch<ActionProvider>().downloadTasks[index].timeCreated).day.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(context.watch<ActionProvider>().downloadTasks[index].timeCreated).month.toString(),
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              ]
                            ],
                          ),
                          trailing: context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.running ? IconButton(icon: Icon(Icons.pause,color: Colors.grey,), onPressed: (){}) : context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.paused ? IconButton(icon: Icon(Icons.play_arrow,color: Colors.grey,), onPressed: (){}) : context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.failed ? IconButton(icon: Icon(Icons.refresh,color: Colors.grey,), onPressed: (){}) : IconButton(icon: Icon(Icons.arrow_forward_ios,color: Colors.grey,),
                          )
                      );
                    } else {
                      return ListTile(
                          leading: Container(
                            height: SizeConfig.blockSizeVertical * 6,
                            width: SizeConfig.blockSizeHorizontal * 12,
                            child: Image.asset(Assets.errorImage),
                          ),
                          title: Text(
                            context
                                .watch<ActionProvider>()
                                .downloadTasks[index]
                                .url
                                .split("/")[5],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  context
                                      .watch<ActionProvider>()
                                      .downloadTasks[index]
                                      .filename != null ?
                                  context
                                      .watch<ActionProvider>()
                                      .downloadTasks[index]
                                      .filename
                                      .split(".")[0] : "",
                                  style: TextStyle(color: Colors.white)),
                              if(context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.running)...[
                                Padding(
                                  padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 20,top: SizeConfig.blockSizeVertical),
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    value: context.watch<ActionProvider>().downloadTasks[index].progress / 100,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan,),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${dirStatSync(context.watch<ActionProvider>().downloadTasks[index].savedDir +"/"+context.watch<ActionProvider>().downloadTasks[index].filename.split('.')[0])["size"].toStringAsFixed(2)
                                      } Mo",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              ]else if(context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.complete)...[
                                SizedBox(
                                  height: SizeConfig.blockSizeVertical,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "${dirStatSync(context.watch<ActionProvider>().downloadTasks[index].savedDir +"/"+context.watch<ActionProvider>().downloadTasks[index].filename.split('.')[0])["size"].toStringAsFixed(2)
                                      } Mo  ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      DateTime.fromMillisecondsSinceEpoch(context.watch<ActionProvider>().downloadTasks[index].timeCreated).year.toString() +"/"+DateTime.fromMillisecondsSinceEpoch(context.watch<ActionProvider>().downloadTasks[index].timeCreated).day.toString()+"/"+DateTime.fromMillisecondsSinceEpoch(context.watch<ActionProvider>().downloadTasks[index].timeCreated).month.toString(),
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              ]
                            ],
                          ),
                          trailing: context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.running ? IconButton(icon: Icon(Icons.pause,color: Colors.grey,), onPressed: (){}) : context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.paused ? IconButton(icon: Icon(Icons.play_arrow,color: Colors.grey,), onPressed: (){}) : context.watch<ActionProvider>().downloadTasks[index].status == DownloadTaskStatus.failed ? IconButton(icon: Icon(Icons.refresh,color: Colors.grey,), onPressed: (){}) : IconButton(icon: Icon(Icons.arrow_forward_ios,color: Colors.grey,),
                          )
                      );
                    }
                  });
            }),
      ),
    );
  }
}
