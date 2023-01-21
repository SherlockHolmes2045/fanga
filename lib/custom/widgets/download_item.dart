import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fanga/constants/assets.dart';
import 'package:fanga/custom/widgets/scale_route_transition.dart';
import 'package:fanga/models/download.dart';
import 'package:fanga/screens/reader_loader.dart';
import 'package:fanga/utils/size_config.dart';
import 'package:fanga/utils/task_info.dart';


class DownloadItem extends StatelessWidget {
  final Download? download;
  final DownloadTask? downloadTask;
  const DownloadItem({Key? key,required this.download,required this.downloadTask})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if(downloadTask!.status == DownloadTaskStatus.running){
      print(downloadTask!.progress);
    }
    return ListTile(
        leading: Container(
          height: SizeConfig.blockSizeVertical! * 6,
          width: SizeConfig.blockSizeHorizontal! * 12,
          child: download != null
              ? CachedNetworkImage(
            imageUrl: download!.manga!.thumbnailUrl!,
            width: double.infinity,
            height: 350,
            errorWidget: (context, text, data) {
              return Image.asset(
                Assets.errorImage,
                width: double.infinity,
                height: 350,
              );
            },
            //fit: BoxFit.fill,
          )
              : Image.asset(Assets.errorImage),
        ),
        title: Text(
          downloadTask!.url.split("/")[5],
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                downloadTask!.filename != null
                    ? downloadTask!.filename!.split(".")[0]
                    : "",
                style: TextStyle(color: Colors.white)),
            if (downloadTask!.status == DownloadTaskStatus.running) ...[
              Padding(
                padding: EdgeInsets.only(
                    right: SizeConfig.blockSizeHorizontal! * 20,
                    top: SizeConfig.blockSizeVertical!),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey,
                  value: downloadTask!.progress / 100,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.cyan,
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical,
              ),
              Row(
                children: [
                  Text(
                    "${downloadTask!.progress.toString()} %",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            ] else if (downloadTask!.status == DownloadTaskStatus.complete) ...[
              SizedBox(
                height: SizeConfig.blockSizeVertical,
              ),
              Row(
                children: [
                  Text(
                    "${dirStatSync(downloadTask!.savedDir + "/" + downloadTask!.filename!.split('.')[0])["size"]!.toStringAsFixed(2)} Mo  ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    DateTime.fromMillisecondsSinceEpoch(
                        downloadTask!.timeCreated)
                        .year
                        .toString() +
                        "/" +
                        DateTime.fromMillisecondsSinceEpoch(
                            downloadTask!.timeCreated)
                            .day
                            .toString() +
                        "/" +
                        DateTime.fromMillisecondsSinceEpoch(
                            downloadTask!.timeCreated)
                            .month
                            .toString(),
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            ]
          ],
        ),
        trailing: downloadTask!.status == DownloadTaskStatus.running
            ? IconButton(
            icon: Icon(
              Icons.pause,
              color: Colors.grey,
            ),
            onPressed: () {
              //FlutterDownloader.pause(taskId: downloadTask.taskId);
            })
            : downloadTask!.status == DownloadTaskStatus.paused
            ? IconButton(
            icon: Icon(
              Icons.play_arrow,
              color: Colors.grey,
            ),
            onPressed: () {
              /*FlutterDownloader.resume(taskId: downloadTask.taskId).then((value) async{
                        if(download != null){
                          Download newDownload = Download(chapter: download.chapter,manga: download.manga,taskId:value);
                          await context.read<ActionProvider>().updateDownload(newDownload, downloadTask.taskId);
                        }
                      });*/
            })
            : downloadTask!.status == DownloadTaskStatus.failed
            ? IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.grey,
            ),
            onPressed: () {
              /*FlutterDownloader.retry(taskId: downloadTask.taskId).then((value) async{
                            if(download != null){
                              Download newDownload = Download(chapter: download.chapter,manga: download.manga,taskId:value);
                              await context.read<ActionProvider>().updateDownload(newDownload, downloadTask.taskId);
                            }
                          });*/
            })
            : IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          onPressed: () {
            if(download != null){
              Navigator.push(
                  context,
                  ScaleRoute(
                      page: ReaderLoader(
                        manga: download!.manga,
                        catalog: download!.manga!.catalog,
                        chapter: download!.chapter,
                      )));
            }
          },
        ));
  }
}