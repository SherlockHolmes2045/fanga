import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/app_drawer.dart';
import 'package:manga_reader/custom/widgets/error.dart';
import 'package:manga_reader/custom/widgets/library_search_delegate.dart';
import 'package:manga_reader/custom/widgets/manga_item.dart';
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
                showSearch(context: context, delegate: LibrarySearch());
              },
            ),
            IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onPressed: () {},
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
                    return Error(reload: context.read<LibraryProvider>().loadLibrary(), error: error);
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
                              return MangaItem(detailsNavigation: () {
                                switch (mangaList[index].catalog) {
                                  case Assets.lelscanCatalogName:
                                    {
                                      Navigator.push(
                                          context,
                                          ScaleRoute(
                                              page: LelscanDetail(
                                                manga: mangaList[index],
                                              )));
                                    }
                                    break;

                                  case Assets
                                      .readmangatodayCatalogName:
                                    {
                                      Navigator.push(
                                          context,
                                          ScaleRoute(
                                              page:
                                              ReadmangatodayDetail(
                                                manga: mangaList[index],
                                              )));
                                    }
                                    break;

                                  default:
                                    {
                                      //statements;
                                    }
                                    break;
                                }
                              }, addLibrary: (){}, libraryList: [], manga:mangaList[index]);
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
