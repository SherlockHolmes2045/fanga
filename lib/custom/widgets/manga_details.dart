import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/genre_widget.dart';
import 'package:manga_reader/custom/widgets/rating_widget.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/utils/size_config.dart';

class MangaDetails extends StatelessWidget {
  final Manga manga;
  const MangaDetails({Key key,this.manga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth / 2.2,
            child: CachedNetworkImage(
              imageUrl: manga.thumbnailUrl,
              width: double.infinity,
              height: 250,
              errorWidget: (context, text, data) {
                return Image.asset(
                  Assets.errorImage,
                  width: double.infinity,
                  height: 250,
                );
              },
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeVertical),
            child: Container(
              width: SizeConfig.screenWidth / 2.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'de ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: manga.author,
                            style: TextStyle(
                              color: Colors.cyan,
                            ),
                          )
                        ]),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'dessiné par ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                            manga.artist.isEmpty ? "inconnu" : manga.artist,
                            style: TextStyle(
                              color: Colors.cyan,
                            ),
                          )
                        ]),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Genres(genres:manga.genre),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'statut ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: manga.status,
                            style: TextStyle(
                              color: Colors.cyan,
                            ),
                          )
                        ]),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'source ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: manga.catalog,
                            style: TextStyle(
                              color: Colors.cyan,
                            ),
                          )
                        ]),
                  ),
                  Rating(rate:manga.rating)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
