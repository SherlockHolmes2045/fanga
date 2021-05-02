import 'package:flutter/material.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/state/lelscan_reader_provider.dart';
import 'package:provider/provider.dart';

class ReaderLoader extends StatefulWidget {
  final Manga manga;
  final Chapter chapter;
  final String catalog;

  ReaderLoader({this.manga,this.chapter,this.catalog});

  @override
  _ReaderLoaderState createState() => _ReaderLoaderState();
}

class _ReaderLoaderState extends State<ReaderLoader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LelscanReaderProvider>().getPages(widget.catalog,widget.chapter, context,widget.manga);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: CircularProgressIndicator(

        ),
      ),
    );
  }
}
