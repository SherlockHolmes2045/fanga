import 'package:flutter/material.dart';
import 'package:fanga/models/chapter.dart';
import 'package:fanga/models/manga.dart';
import 'package:fanga/state/LoadingState.dart';
import 'package:fanga/state/lelscan/lelscan_reader_provider.dart';
import 'package:fanga/utils/size_config.dart';
import 'package:provider/provider.dart';

class ReaderLoader extends StatefulWidget {
  final Manga? manga;
  final Chapter? chapter;
  final String? catalog;

  ReaderLoader({this.manga, this.chapter, this.catalog});

  @override
  _ReaderLoaderState createState() => _ReaderLoaderState();
}

class _ReaderLoaderState extends State<ReaderLoader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context
          .read<LelscanReaderProvider>()
          .getPages(widget.catalog, widget.chapter, context, widget.manga,false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: context.watch<LelscanReaderProvider>().loadingState ==
              LoadingState.loading
              ? CircularProgressIndicator()
              : context.watch<LelscanReaderProvider>().exception != null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context
                    .watch<LelscanReaderProvider>()
                    .exception!
                    .message,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<LelscanReaderProvider>().getPages(
                      widget.catalog,
                      widget.chapter,
                      context,
                      widget.manga,true);
                },
                child: Text("Réessayer"),
              )
            ],
          )
              : SizedBox(),
        ),
      ),
    );
  }
}