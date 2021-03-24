import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/models/Manga.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/action_provider.dart';
import 'package:manga_reader/state/chapter_provider.dart';
import 'package:manga_reader/state/details_provider.dart';
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
      context
          .read<DetailsProvider>()
          .getMangaDetails(Assets.lelscanCatalogName, widget.manga);
      context
          .read<ChapterProvider>()
          .getChapters(Assets.lelscanCatalogName, widget.manga);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    context.read<ActionProvider>().emptyItems();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        floatingActionButton: context
                .watch<ActionProvider>()
                .selectedItems
                .isNotEmpty
            ? Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 7),
                child: SizedBox(
                  width: SizeConfig.screenWidth,
                  height: 65.0,
                  child: Card(
                    elevation: 5.0,
                    color: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockSizeHorizontal * 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.download_outlined,
                                color: Colors.white,
                              ),
                              onPressed: null),
                          IconButton(
                              icon: Icon(
                                Icons.bookmark_border,
                                color: Colors.white,
                              ),
                              onPressed: null),
                          IconButton(
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              onPressed: null),
                          IconButton(
                              icon: Icon(
                                Icons.check_circle_outline_rounded,
                                color: Colors.white,
                              ),
                              onPressed: null),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            : FloatingActionButton(
                backgroundColor: Colors.cyan,
                child: Icon(Icons.play_arrow, color: Colors.white),
              ),
        appBar: context.watch<ActionProvider>()
            .selectedItems
            .isEmpty ?
        AppBar(
          backgroundColor: Colors.black,
          title: Text(
            widget.manga.title,
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
        ) :
        AppBar(
          backgroundColor: Colors.black,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => context.read<ActionProvider>().emptyItems()),
          bottom: PreferredSize(
              child: Container(
                color: Colors.cyan,
                height: 4.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
          title: Text(
            context.watch<ActionProvider>().selectedItems.length.toString(),
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
                              : Container(
                                  //color: Colors.grey.withOpacity(0.2),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.blockSizeVertical *
                                                3),
                                        child: _buildMangaDetails(mangaDetails),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 2,
                                      ),
                                      _builButtons(),
                                      SizedBox(
                                        height: SizeConfig.blockSizeVertical,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "A propos",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container(
                                              height:
                                                  SizeConfig.blockSizeVertical *
                                                      4,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.5)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: Colors.white,
                                                  ),
                                                  Text(
                                                    "Moins",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.blockSizeVertical,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),
                                        child: Text(
                                          mangaDetails.description,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              color: Colors.white, height: 1.3),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            SizeConfig.blockSizeVertical * 2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),
                                        child: Container(
                                          child: Column(
                                            children: [
                                              context
                                                          .watch<
                                                              ChapterProvider>()
                                                          .loadingState ==
                                                      LoadingState.loading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Colors.blue),
                                                      ),
                                                    )
                                                  : context
                                                      .select((ChapterProvider
                                                              provider) =>
                                                          provider)
                                                      .mangaChapters
                                                      .fold((NException error) {
                                                      return Center(
                                                        child: Text(
                                                          error.message,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      );
                                                    }, (mangaChapters) {
                                                      return mangaChapters
                                                              .isEmpty
                                                          ? Container(
                                                              child: Center(
                                                                child: Text(
                                                                    "Service unavailable"),
                                                              ),
                                                            )
                                                          : Container(
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        mangaChapters.length.toString() +
                                                                            " chapitres",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 17),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            SizeConfig.blockSizeVertical *
                                                                                4,
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 5.0),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          border:
                                                                              Border.all(color: Colors.grey.withOpacity(0.5)),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(25)),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            Icon(
                                                                              Icons.filter_list_sharp,
                                                                              color: Colors.white,
                                                                            ),
                                                                            SizedBox(
                                                                              width: SizeConfig.blockSizeHorizontal * 2,
                                                                            ),
                                                                            Text(
                                                                              "Filtre",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: SizeConfig
                                                                        .blockSizeVertical,
                                                                  ),
                                                                  ListView.builder(
                                                                      shrinkWrap: true,
                                                                      physics: NeverScrollableScrollPhysics(),
                                                                      itemCount: mangaChapters.length,
                                                                      itemBuilder: (context, int index) {
                                                                        return Container(
                                                                          color: context.watch<ActionProvider>().selectedItems.contains(mangaChapters[index]) ?
                                                                          Colors.grey[400] :
                                                                          Colors.black54,
                                                                          child:
                                                                              ListTile(
                                                                            contentPadding:
                                                                                EdgeInsets.symmetric(vertical: 5.0),
                                                                            title:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                                                                              child: Text(
                                                                                'Chapitre ${mangaChapters[index].number} ${mangaChapters[index].title}',
                                                                                overflow: TextOverflow.clip,
                                                                                style: TextStyle(color: Colors.white, fontSize: 13.0),
                                                                              ),
                                                                            ),
                                                                            subtitle:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                                                                              child: Text(
                                                                                mangaChapters[index].publishedAt,
                                                                                style: TextStyle(color: Colors.white),
                                                                              ),
                                                                            ),
                                                                            trailing:
                                                                                Icon(
                                                                              Icons.more_vert,
                                                                              color: Colors.white,
                                                                            ),
                                                                                onLongPress: (){
                                                                              context.read<ActionProvider>().selectItems(mangaChapters[index]);
                                                                                },
                                                                                onTap: (){
                                                                              if(context.read<ActionProvider>().selectedItems.isNotEmpty){
                                                                                if(context.read<ActionProvider>().selectedItems.contains(mangaChapters[index])){
                                                                                  context.read<ActionProvider>().removeItem(mangaChapters[index]);
                                                                                }else{
                                                                                  context.read<ActionProvider>().selectItems(mangaChapters[index]);
                                                                                }
                                                                              }else{
                                                                                context.read<ActionProvider>().downloadChapter(mangaChapters[index], Assets.lelscanCatalogName,mangaDetails.title);
                                                                              }
                                                                                },
                                                                          ),
                                                                        );
                                                                      })
                                                                ],
                                                              ),
                                                            );
                                                    })
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        }),
                ],
              ),
            ),
            onRefresh: _refreshData),
      ),
    );
  }

  Widget _buildMangaDetails(Manga manga) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeConfig.screenWidth / 2.2,
            child: CachedNetworkImage(
              imageUrl: widget.manga.thumbnailUrl.startsWith("//")
                  ? "https:" + widget.manga.thumbnailUrl
                  : widget.manga.thumbnailUrl.replaceAll("http", "https"),
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
                  _buildGenres(manga.genre),
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
                  _buildRating(manga.rating)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRating(String rate) {
    if (rate != null) {
      var data = rate.split(" ");
      var mark = data[0].split("/");
      return Container(
        width: SizeConfig.screenWidth / 1.5,
        child: RatingBar.builder(
          initialRating: double.parse(mark[0]),
          tapOnlyMode: true,
          minRating: 0,
          updateOnDrag: false,
          unratedColor: Colors.amber.withOpacity(0.5),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: int.parse(mark[1]),
          itemBuilder: (context, _) => Container(
            width: SizeConfig.blockSizeHorizontal * 4,
            child: Icon(
              Icons.star,
              size: 8,
              color: Colors.amber,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: SizeConfig.screenWidth / 1.5,
        child: RatingBar.builder(
          initialRating: 0,
          tapOnlyMode: true,
          updateOnDrag: false,
          unratedColor: Colors.amber.withOpacity(0.5),
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => Container(
            width: SizeConfig.blockSizeHorizontal * 4,
            child: Icon(
              Icons.star,
              size: 8,
              color: Colors.amber,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildGenres(String genres) {
    final data = genres.split(",");
    return Row(
        children: List.generate(data.length, (index) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.cyan),
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Text(
          data[index],
          style: TextStyle(color: Colors.cyan),
        ),
      );
    }));
  }

  Widget _builButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.play_arrow_outlined,
                  color: Colors.cyan,
                  size: 35,
                ),
                onPressed: null),
            Text(
              "Resume",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        Container(
          height: SizeConfig.blockSizeVertical * 4.5,
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Row(
            children: [
              IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.cyan,
                  ),
                  onPressed: null),
              Text(
                "Ajouter à la bibliothèque",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        IconButton(
            icon: FaIcon(
              FontAwesomeIcons.globe,
              color: Colors.cyan,
            ),
            onPressed: null)
      ],
    );
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    context
        .read<DetailsProvider>()
        .getMangaDetails(Assets.lelscanCatalogName, widget.manga);
  }
}
