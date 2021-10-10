import 'package:flutter/material.dart';
import 'package:manga_reader/custom/widgets/download_item.dart';
import 'package:manga_reader/state/action_provider.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:manga_reader/models/download.dart' as Model;
import 'package:provider/provider.dart';

class Download extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
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
            //reverse: true,
            shrinkWrap: true,
            separatorBuilder: (context, int index) => Divider(
                  color: Colors.grey.withOpacity(0.3),
                  endIndent: SizeConfig.blockSizeHorizontal! * 5,
                  indent: SizeConfig.blockSizeHorizontal! * 5,
                ),
            itemBuilder: (context, int index) {
              return FutureBuilder(
                  future: context.read<ActionProvider>().findDownload(context
                      .watch<ActionProvider>()
                      .downloadTasks[index]
                      .taskId),
                  builder: (context, AsyncSnapshot<Model.Download?> snapshot) {
                    if (snapshot.hasData) {
                      return DownloadItem(
                          download: snapshot.data,
                          downloadTask: context
                              .watch<ActionProvider>()
                              .downloadTasks[index]);
                    } else {
                      return DownloadItem(
                          download: null,
                          downloadTask: context
                              .watch<ActionProvider>()
                              .downloadTasks[index]);
                    }
                  });
            }),
      ),
    );
  }
}
