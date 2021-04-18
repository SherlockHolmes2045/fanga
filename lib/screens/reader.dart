import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:photo_view/photo_view.dart';

class Reader extends StatefulWidget {
  final List<String> pages;
  Reader(this.pages);
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {

  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.pages.forEach((imageUrl) {
      precacheImage(NetworkImage(imageUrl), context);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight / 1.4,
                  child: CarouselSlider(
                    carouselController: _controller,
                    options: CarouselOptions(
                      height: height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      // autoPlay: false,
                    ),
                    items: widget.pages.map((item) => Container(
                      child: Center(
                          child:  PhotoView(imageProvider: NetworkImage(item, /*fit: BoxFit.cover, height: height,*/),)
                      ),
                    )).toList(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: RaisedButton(
                        onPressed: () => _controller.previousPage(),
                        child: Text('←'),
                      ),
                    ),
                    Flexible(
                      child: RaisedButton(
                        onPressed: () => _controller.nextPage(),
                        child: Text('→'),
                      ),
                    ),
                    ...Iterable<int>.generate(widget.pages.length).map(
                          (int pageIndex) => Flexible(
                        child: RaisedButton(
                          onPressed: () => _controller.animateToPage(pageIndex),
                          child: Text("$pageIndex"),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]
          );
        },
      ),
    );
  }
}
