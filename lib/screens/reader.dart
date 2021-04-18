import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manga_reader/custom/widgets/sliding_appbar.dart';
import 'package:manga_reader/utils/size_config.dart';

class Reader extends StatefulWidget {
  final List<String> pages;
  Reader(this.pages);
  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> with TickerProviderStateMixin{

  final CarouselController _controller = CarouselController();
  bool enabledAppBar = false;
  AnimationController _appbarController;
  double currentPage = 1;

  @override
  void didChangeDependencies() {
    widget.pages.forEach((imageUrl) {
      precacheImage(NetworkImage(imageUrl), context);
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setEnabledSystemUIOverlays([]);
    _appbarController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
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
      //extendBodyBehindAppBar: true,
      appBar: SlidingAppBar(
        controller: _appbarController,
        visible: enabledAppBar,
        child: AppBar(
          backgroundColor: Color.fromRGBO(28, 28, 28, 1),
            title: Column(
              children: [
                Text('AppBar'),
                
              ],
            ),
          actions: [
            IconButton(icon: Icon(Icons.bookmark_border,color: Colors.white,), onPressed: null),
            IconButton(icon: Icon(Icons.settings_outlined,color: Colors.white,), onPressed: null),
          ],
        )
        ,
      ),
      body: Builder(
        builder: (context) {
          return InkWell(
            onTap: (){
              setState(() {
                enabledAppBar = !enabledAppBar;
                if(enabledAppBar){
                  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                }else{
                  SystemChrome.setEnabledSystemUIOverlays([]);
                }
              });
            },
            child: Stack(
              children: [
                Padding(
                  padding:  EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 10),
                  child: Align(
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
                              child: InteractiveViewer(
                                child: Image.network(
                                  item,
                                  height: height,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null ?
                                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (BuildContext context,Object exception, StackTrace stackTrace){
                                    print(exception);
                                    print(stackTrace);
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Une erreur est survenue",
                                            style: TextStyle(
                                              color: Colors.white
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                minScale: 0.2,
                                maxScale: 100.2,
                                boundaryMargin: const EdgeInsets.all(double.infinity),)
                          ),
                        )).toList(),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: enabledAppBar ? Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.blockSizeVertical * 7,
                    color: Color.fromRGBO(28, 28, 28, 1),
                    child: Padding(
                      padding: EdgeInsets.only(left:SizeConfig.blockSizeHorizontal * 6 ,right: SizeConfig.blockSizeHorizontal * 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.fastBackward,
                            color: Colors.white,
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 75 ,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  currentPage.toInt().toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: SizeConfig.blockSizeHorizontal * 4
                                  ),
                                ),
                                Slider(
                                  activeColor: Colors.blue,
                                  inactiveColor: Colors.grey,
                                  onChanged: (newValue){
                                    setState(() {
                                      currentPage = newValue;
                                    });
                                  },
                                  value: currentPage,
                                  min: 1,
                                  max: 6,
                                  divisions: 5,
                                ),
                                Text(
                                  widget.pages.length.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: SizeConfig.blockSizeHorizontal * 4
                                  ),
                                ),
                              ],
                            )
                          ),
                          Icon(
                            FontAwesomeIcons.fastForward,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ) : SizedBox(),
                )
              ]
            ),
          );
        },
      ),
    );
  }
}
