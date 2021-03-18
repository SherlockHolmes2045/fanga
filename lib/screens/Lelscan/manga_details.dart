import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/app_drawer.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/details_provider.dart';
import 'package:manga_reader/state/lelscan_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:provider/provider.dart';

class LelscanDetail extends StatefulWidget {
  final Manga manga;
  LelscanDetail({this.manga});
  @override
  _LelscanDetailState createState() => _LelscanDetailState();
}

class _LelscanDetailState extends State<LelscanDetail> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DetailsProvider>().getMangaDetails(Assets.lelscanCatalogName, widget.manga);
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
              widget.manga.title,
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
        ),
        body: RefreshIndicator(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  context.watch<DetailsProvider>().loadingState ==
                          LoadingState.loading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        )
                      : context
                          .select((DetailsProvider provider) => provider)
                          .mangaDetails
                          .fold((NException error) {
                          return Center(
                            child: Text(
                              error.message,
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }, (mangaDetails) {
                          return mangaDetails.detailsFetched != true
                              ? Container(
                                  child: Center(
                                    child: Text("Service unavailable"),
                                  ),
                                )
                              : Padding(
                                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                                child: _buildMangaDetails(mangaDetails),
                              );
                        })
                ],
              ),
            ),
            onRefresh: _refreshData),
      ),
    );
  }

  Widget _buildMangaDetails(Manga manga) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth / 2.2,
            child: CachedNetworkImage(
              imageUrl: widget.manga.thumbnailUrl,
              width: double.infinity,
              height: 300,
              errorWidget: (context,text,data){
                return Image.asset(
                  Assets.errorImage,
                  width: double.infinity,
                  height: 300,
                );
              },
             fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:SizeConfig.blockSizeVertical),
            child: Container(
              width: SizeConfig.screenWidth / 2.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.title,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'by ',
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
                      ]
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'by ',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: manga.artist,
                            style: TextStyle(
                              color: Colors.cyan,
                            ),
                          )
                        ]
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  _buildGenres(manga.genre),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Text(
                    manga.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _buildGenres(String genres){
    final data = genres.split(",");
    return Row(
      children:
        List.generate(data.length, (index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.cyan),
                borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Text(
              data[index],
              style: TextStyle(
                color: Colors.cyan
              ),
            ),
          );
        })
    );
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    context.read<DetailsProvider>().getMangaDetails(Assets.lelscanCatalogName, widget.manga);
  }
}
