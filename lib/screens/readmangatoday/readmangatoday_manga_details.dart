import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/manga_details.dart';
import 'package:manga_reader/custom/widgets/scale_route_transition.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/screens/reader_loader.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/action_provider.dart';
import 'package:manga_reader/state/bookmark_provider.dart';
import 'package:manga_reader/state/library_provider.dart';
import 'package:manga_reader/state/page_provider.dart';
import 'package:manga_reader/state/readmangatoday/readmangatoday_chapter_provider.dart';
import 'package:manga_reader/state/readmangatoday/readmangatoday_details_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:manga_reader/models/page.dart' as Model;

class ReadmangatodayDetail extends StatefulWidget {
  final Manga manga;
  ReadmangatodayDetail({this.manga});
  @override
  _ReadmangatodayDetailState createState() => _ReadmangatodayDetailState();
}

class _ReadmangatodayDetailState extends State<ReadmangatodayDetail> {
  List<String> menu = [
    "Télécharger",
    "Marquer ce chapitre",
    "Marquer comme lu",
    "Télécharger et marquer comme lu"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ReadmangatodayDetailsProvider>().mangaDetails.fold((l) => null, (r) {
        if (r.url == null || r.url != widget.manga.url) {
          context
              .read<ReadmangatodayDetailsProvider>()
              .getMangaDetails(Assets.readmangatodayCatalogName, widget.manga);
        }
      });
      context.read<ReadmangatodayChapterProvider>().mangaChapters.fold((l) => null, (r) {
        print(context.read<ReadmangatodayChapterProvider>().currentManga.url);
        if (r.isEmpty ||
            widget.manga != context.read<ReadmangatodayChapterProvider>().currentManga) {
          context
              .read<ReadmangatodayChapterProvider>()
              .getChapters(Assets.readmangatodayCatalogName, widget.manga);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async{
          context.read<ActionProvider>().emptyItems();
          return true;
        },
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
                color: Color.fromRGBO(28, 28, 28, 1),
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
                          onPressed: () {
                            context
                                .read<ActionProvider>()
                                .downloadMultipleChapters(
                                Assets.readmangatodayCatalogName,
                                widget.manga.title,
                                MediaQuery.of(context).size);
                          }),
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
          appBar: context.watch<ActionProvider>().selectedItems.isEmpty
              ? AppBar(
            backgroundColor: Color.fromRGBO(28, 28, 28, 1),
            title: Text(
              widget.manga.title,
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
          )
              : AppBar(
            backgroundColor: Colors.black,
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  if (context
                      .read<ActionProvider>()
                      .selectedItems
                      .isEmpty) {
                    Navigator.pop(context);
                  } else {
                    context.read<ActionProvider>().emptyItems();
                  }
                }),
            bottom: PreferredSize(
                child: Container(
                  color: Colors.cyan,
                  height: 4.0,
                ),
                preferredSize: Size.fromHeight(4.0)),
            title: Text(
              context
                  .watch<ActionProvider>()
                  .selectedItems
                  .length
                  .toString(),
              style: TextStyle(color: Colors.white, fontSize: 22.0),
            ),
          ),
          body: RefreshIndicator(
              child: WillPopScope(
                onWillPop: () async {
                  if (context.read<ActionProvider>().selectedItems.isEmpty) {
                    return true;
                  } else {
                    context.read<ActionProvider>().emptyItems();
                    return false;
                  }
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      context.watch<ReadmangatodayDetailsProvider>().loadingState ==
                          LoadingState.loading
                          ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                        ),
                      )
                          : context
                          .select((ReadmangatodayDetailsProvider provider) => provider)
                          .mangaDetails
                          .fold((NException error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                error.message,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  context
                                      .read<ReadmangatodayDetailsProvider>()
                                      .getMangaDetails(
                                      Assets.readmangatodayCatalogName,
                                      widget.manga);
                                  context
                                      .read<ReadmangatodayChapterProvider>()
                                      .getChapters(
                                      Assets.readmangatodayCatalogName,
                                      widget.manga);
                                },
                                child: Text("Réessayer"),
                              )
                            ],
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
                                    top:
                                    SizeConfig.blockSizeVertical *
                                        3),
                                child:
                                MangaDetails(manga:mangaDetails),
                              ),
                              SizedBox(
                                height:
                                SizeConfig.blockSizeVertical * 2,
                              ),
                              _builButtons(),
                              SizedBox(
                                height:
                                SizeConfig.blockSizeVertical * 2,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig
                                        .blockSizeHorizontal *
                                        5),
                                child: ExpandableTheme(
                                  data: ExpandableThemeData(
                                    iconColor: Colors.white,
                                    hasIcon: true,
                                    tapHeaderToExpand: true,
                                  ),
                                  child: ExpandablePanel(
                                    header: Text(
                                      "A propos",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold),
                                    ),
                                    collapsed: Text(
                                      mangaDetails.description,
                                      softWrap: true,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: Colors.white,
                                        height: 1.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    expanded: InkWell(
                                      child: Text(
                                        mangaDetails.description,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(
                                            color: Colors.white,
                                            height: 1.3),
                                      ),
                                      onLongPress: () {
                                        Clipboard.setData(
                                            new ClipboardData(
                                                text: mangaDetails
                                                    .description))
                                            .then((value) {
                                          BotToast.showText(
                                            text:
                                            "Copié dans le presse papier",
                                          );
                                        });
                                      },
                                    ),
                                    //isExpanded: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                SizeConfig.blockSizeVertical * 2,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig
                                        .blockSizeHorizontal *
                                        5),
                                child: Container(
                                  child: Column(
                                    children: [
                                      context
                                          .watch<
                                          ReadmangatodayChapterProvider>()
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
                                          .select((ReadmangatodayChapterProvider
                                      provider) =>
                                      provider)
                                          .mangaChapters
                                          .fold(
                                              (NException error) {
                                            return Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    error.message,
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white),
                                                  ),
                                                  SizedBox(
                                                    height: SizeConfig
                                                        .blockSizeVertical,
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      context
                                                          .read<
                                                          ReadmangatodayChapterProvider>()
                                                          .getChapters(
                                                          Assets
                                                              .readmangatodayCatalogName,
                                                          widget
                                                              .manga);
                                                    },
                                                    child: Text(
                                                        "Réessayer"),
                                                  )
                                                ],
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
                                                        color: Colors.white,
                                                        fontSize: 17),
                                                  ),
                                                  Container(
                                                    height:
                                                    SizeConfig.blockSizeVertical * 4,
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
                                              ListView.separated(
                                                  shrinkWrap: true,
                                                  separatorBuilder: (context,int index){
                                                    return Divider(
                                                      color: Color.fromRGBO(28, 28, 28, 1),
                                                      thickness: 1.15,
                                                    );
                                                  },
                                                  physics: NeverScrollableScrollPhysics(),
                                                  itemCount: mangaChapters.length,
                                                  itemBuilder: (context, int index) {
                                                    return Container(
                                                      color: context.watch<ActionProvider>().selectedItems.contains(mangaChapters[index])
                                                          ? Color.fromRGBO(28, 28, 28, 1)
                                                          : Colors.black54,
                                                      child:
                                                      ListTile(
                                                        contentPadding: EdgeInsets.symmetric(vertical: 5.0),
                                                        leading: !context.watch<BookmarkProvider>().bookmarked.contains(mangaChapters[index])
                                                            ? null
                                                            : Icon(
                                                          Icons.bookmark,
                                                          color: Colors.cyan,
                                                        ),
                                                        title: Padding(
                                                            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5,bottom: SizeConfig.blockSizeVertical),
                                                            child: FutureBuilder(
                                                                future: context.read<PageProvider>().findChapter(mangaChapters[index]),
                                                                builder: (context, AsyncSnapshot<Model.Page> snapshot){
                                                                  if(snapshot.hasData){
                                                                    return Text(
                                                                      'Chapitre ${mangaChapters[index].number} ${mangaChapters[index].title}',
                                                                      overflow: TextOverflow.clip,
                                                                      style: TextStyle(
                                                                          color: context.watch<PageProvider>().pages.contains(mangaChapters[index]) && snapshot.data.finished ? Colors.grey
                                                                              : !context.watch<BookmarkProvider>().bookmarked.contains(mangaChapters[index])
                                                                              ? Colors.white
                                                                              : Colors.cyan,
                                                                          fontSize: 13.0),
                                                                    );
                                                                  }else{
                                                                    return Text(
                                                                      'Chapitre ${mangaChapters[index].number} ${mangaChapters[index].title}',
                                                                      overflow: TextOverflow.clip,
                                                                      style: TextStyle(
                                                                          color: !context.watch<BookmarkProvider>().bookmarked.contains(mangaChapters[index])
                                                                              ? Colors.white
                                                                              : Colors.cyan,
                                                                          fontSize: 13.0),
                                                                    );
                                                                  }
                                                                }
                                                            )
                                                        ),
                                                        subtitle: Padding(
                                                            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 5),
                                                            child: FutureBuilder(
                                                                future: context.read<PageProvider>().findChapter(mangaChapters[index]),
                                                                builder: (context, AsyncSnapshot<Model.Page> snapshot) {
                                                                  if (snapshot.hasData) {
                                                                    return RichText(
                                                                        text: TextSpan(
                                                                            text: mangaChapters[index].publishedAt,
                                                                            style: TextStyle(
                                                                              color: context.watch<PageProvider>().pages.contains(mangaChapters[index]) && snapshot.data.finished ? Colors.grey :
                                                                              !context.watch<BookmarkProvider>().bookmarked.contains(mangaChapters[index])
                                                                                  ? Colors.white
                                                                                  : Colors.cyan,
                                                                            ),
                                                                            children: <TextSpan>[
                                                                              if(!snapshot.data.finished)
                                                                                TextSpan(
                                                                                    text: " \u22C5 ",
                                                                                    style: TextStyle(
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    )
                                                                                ),
                                                                              if(!snapshot.data.finished) TextSpan(text: " Page ${snapshot.data.page + 1}", style: TextStyle(color: Colors.grey))
                                                                            ])
                                                                    );
                                                                  } else {
                                                                    return RichText(
                                                                        text: TextSpan(
                                                                          text: mangaChapters[index].publishedAt,
                                                                          style: TextStyle(
                                                                            color:  !context.watch<BookmarkProvider>().bookmarked.contains(mangaChapters[index])
                                                                                ? Colors.white
                                                                                : Colors.cyan,
                                                                          ),
                                                                        )
                                                                    );
                                                                  }
                                                                })),
                                                        trailing: context.watch<ActionProvider>().selectedItems.isEmpty
                                                            ? PopupMenuButton(
                                                          onSelected: (dynamic result) {
                                                            print(result);
                                                            if (result == 0) {
                                                              context.read<ActionProvider>().downloadChapter(mangaChapters[index], Assets.readmangatodayCatalogName, widget.manga.title, MediaQuery.of(context).size);
                                                            } else if (result == 1) {
                                                              context.read<BookmarkProvider>().bookmark(mangaChapters[index], MediaQuery.of(context).size);
                                                            } else if (result == 2) {
                                                              context.read<PageProvider>().markAsRead(mangaChapters[index], MediaQuery.of(context).size);
                                                            }
                                                          },
                                                          color: Color.fromRGBO(28, 28, 28, 1),
                                                          child: Icon(
                                                            Icons.more_vert,
                                                            color: Colors.white,
                                                          ),
                                                          itemBuilder: (context) {
                                                            return List.generate(menu.length, (index) {
                                                              return PopupMenuItem(
                                                                value: index,
                                                                child: Text(
                                                                  menu[index],
                                                                  style: TextStyle(color: Colors.white),
                                                                ),
                                                              );
                                                            });
                                                          },
                                                        )
                                                            : Icon(
                                                          Icons.more_vert,
                                                          color: Colors.white,
                                                        ),
                                                        onLongPress: () {
                                                          context.read<ActionProvider>().selectItems(mangaChapters[index]);
                                                        },
                                                        onTap: () {
                                                          if (context.read<ActionProvider>().selectedItems.isNotEmpty) {
                                                            if (context.read<ActionProvider>().selectedItems.contains(mangaChapters[index])) {
                                                              context.read<ActionProvider>().removeItem(mangaChapters[index]);
                                                            } else {
                                                              context.read<ActionProvider>().selectItems(mangaChapters[index]);
                                                            }
                                                          } else {
                                                            Navigator.push(
                                                                context,
                                                                ScaleRoute(
                                                                    page: ReaderLoader(
                                                                      manga: widget.manga,
                                                                      catalog: Assets.readmangatodayCatalogName,
                                                                      chapter: mangaChapters[index],
                                                                    )));
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
              ),
              onRefresh: _refreshData),
        ),
      ),
    );
  }

  Widget _builButtons() {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              context
                  .read<LibraryProvider>()
                  .addToLibrary(widget.manga, MediaQuery.of(context).size);
            },
            child: Container(
              height: SizeConfig.blockSizeVertical * 4.5,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.cyan, width: 0.5),
                color: context
                    .watch<LibraryProvider>()
                    .libraryList
                    .contains(widget.manga)
                    ? Colors.cyan.withOpacity(0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.blockSizeHorizontal * 10)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 1.5),
                child: Row(
                  children: [
                    Icon(
                      context
                          .watch<LibraryProvider>()
                          .libraryList
                          .contains(widget.manga)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.cyan,
                    ),
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal,
                    ),
                    Text(
                      context
                          .watch<LibraryProvider>()
                          .libraryList
                          .contains(widget.manga)
                          ? "Dans la bibliothèque"
                          : "Ajouter à la bibliothèque",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.globe,
                color: Colors.cyan,
              ),
              onPressed: () async {
                await canLaunch(widget.manga.url)
                    ? await launch(widget.manga.url)
                    : BotToast.showText(text: "Impossible d'ouvrir ce lien");
              })
        ],
      ),
    );
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    context
        .read<ReadmangatodayDetailsProvider>()
        .getMangaDetails(Assets.readmangatodayCatalogName, widget.manga);
    context
        .read<ReadmangatodayChapterProvider>()
        .getChapters(Assets.readmangatodayCatalogName, widget.manga);
  }
}
