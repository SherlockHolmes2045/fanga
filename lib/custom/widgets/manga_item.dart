import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/utils/size_config.dart';

class MangaItem extends StatelessWidget {
  final Function detailsNavigation;
  final Function addLibrary;
  final List<Manga> libraryList;
  final Manga manga;
  final String img;
  const MangaItem(
      {Key key,
      @required this.detailsNavigation,
      @required this.addLibrary,
      @required this.libraryList,
      @required this.manga,
      this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: InkWell(
                onTap: detailsNavigation,
                onLongPress: addLibrary,
                child: !libraryList.contains(manga)
                    ? CachedNetworkImage(
                        imageUrl: img == null ? manga.thumbnailUrl : img,
                        width: double.infinity,
                        height: 350,
                        errorWidget: (context, text, data) {
                          return GestureDetector(
                            onTap: detailsNavigation,
                            child: Image.asset(
                              Assets.errorImage,
                              width: double.infinity,
                              height: 350,
                            ),
                          );
                        },
                        //fit: BoxFit.fill,
                      )
                    : ClipRect(
                        child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                                child: CachedNetworkImage(
                              imageUrl: img == null ? manga.thumbnailUrl : img,
                              width: double.infinity,
                              height: 350,
                              errorWidget: (context, text, data) {
                                return GestureDetector(
                                  onTap: detailsNavigation,
                                  child: Image.asset(
                                    Assets.errorImage,
                                    width: double.infinity,
                                    height: 350,
                                  ),
                                );
                              },
                              //fit: BoxFit.fill,
                            ))),
                      )),
          ),
          Padding(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
            child: Text(
              manga.title,
              overflow: TextOverflow.clip,
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
