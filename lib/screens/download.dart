import 'package:flutter/material.dart';
import 'package:manga_reader/state/action_provider.dart';
import 'package:provider/provider.dart';

class Download extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        child: ListView.builder(
            itemCount: context.watch<ActionProvider>().downloadTasks.length,
            itemBuilder: (context, int index) {
              return ListTile(
                title: Text(context.watch<ActionProvider>().downloadTasks[index].filename,style: TextStyle(color: Colors.white),),
                subtitle: Text(
                    context.watch<ActionProvider>().downloadTasks[index].progress.toString(),
              style: TextStyle(color: Colors.white)
                ),
              );
            }),
      ),
    );
  }
}
