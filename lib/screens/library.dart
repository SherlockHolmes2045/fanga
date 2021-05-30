import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/app_drawer.dart';
import 'package:manga_reader/custom/widgets/scale_route_transition.dart';
import 'package:manga_reader/screens/readmangatoday/readmangatoday_manga_details.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/lelscan/lelscan_provider.dart';
import 'package:manga_reader/state/library_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'Lelscan/manga_details.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!context.read<LibraryProvider>().fetched) {
        context.read<LibraryProvider>().loadLibrary();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(28, 28, 28, 1),
          title: Text("Bibliothèque"),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                /*showSearch(
                      context: context,
                     delegate: SearchManga(Assets.lelscanCatalogName));*/
              },
            ),
            IconButton(
                icon: Icon(
              Icons.sort,
              color: Colors.white,
            ),
              onPressed: (){},
            )
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: context.watch<LelscanProvider>().loadingState ==
                  LoadingState.loading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                )
              : context
                  .select((LibraryProvider provider) => provider)
                  .library
                  .fold(
                  (NException error) {
                    return Center(
                      child: Text(
                        error.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                  (mangaList) {
                    return mangaList.isEmpty
                        ? context.watch<LibraryProvider>().fetched
                            ? Center(
                                child: Text(
                                  "Aucun manga pour le moment dans votre bibliothèque",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            : Center(
                                child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Une erreur est survenue lors du chargement de votre bibliothèque veuillez réessayer",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical,
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      context
                                          .read<LibraryProvider>()
                                          .loadLibrary();
                                    },
                                    child: Text("Recharger"),
                                  )
                                ],
                              ))
                        : GridView.count(
                            crossAxisCount: 2,
                            padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 2.5,
                              right: SizeConfig.blockSizeHorizontal * 2.5,
                              top: SizeConfig.blockSizeVertical * 4,
                              bottom: SizeConfig.blockSizeVertical * 4,
                            ),
                            crossAxisSpacing:
                                SizeConfig.blockSizeHorizontal * 2,
                            mainAxisSpacing: SizeConfig.blockSizeVertical,
                            children: List.generate(mangaList.length, (index) {
                              return Container(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          print(mangaList[index].catalog);
                                          switch(mangaList[index].catalog) {
                                            case Assets.lelscanCatalogName: {
                                              Navigator.push(
                                                  context,
                                                  ScaleRoute(
                                                      page: LelscanDetail(
                                                        manga: mangaList[index],
                                                      )));
                                            }
                                            break;

                                            case Assets.readmangatodayCatalogName: {
                                              Navigator.push(
                                                  context,
                                                  ScaleRoute(
                                                      page: ReadmangatodayDetail(
                                                        manga: mangaList[index],
                                                      )));
                                            }
                                            break;

                                            default: {
                                              //statements;
                                            }
                                            break;
                                          }
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: mangaList[index].thumbnailUrl,
                                          width: double.infinity,
                                          height: 350,
                                          errorWidget: (context, text, data) {
                                            return GestureDetector(
                                              onTap: () {
                                                switch(mangaList[index].catalog) {
                                                  case Assets.lelscanCatalogName: {
                                                    Navigator.push(
                                                        context,
                                                        ScaleRoute(
                                                            page: LelscanDetail(
                                                              manga: mangaList[index],
                                                            )));
                                                  }
                                                  break;

                                                  case Assets.readmangatodayCatalogName: {
                                                    Navigator.push(
                                                        context,
                                                        ScaleRoute(
                                                            page: ReadmangatodayDetail(
                                                              manga: mangaList[index],
                                                            )));
                                                  }
                                                  break;

                                                  default: {
                                                    //statements;
                                                  }
                                                  break;
                                                }
                                              },
                                              child: Image.asset(
                                                Assets.errorImage,
                                                width: double.infinity,
                                                height: 350,
                                              ),
                                            );
                                          },
                                          //fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.blockSizeVertical),
                                      child: Text(
                                        mangaList[index].title,
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
                            }),
                          );
                  },
                ),
        ));
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    context.read<LibraryProvider>().loadLibrary();
  }
}
