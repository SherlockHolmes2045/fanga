import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/empty.dart';
import 'package:manga_reader/custom/widgets/error.dart';
import 'package:manga_reader/custom/widgets/manga_item.dart';
import 'package:manga_reader/custom/widgets/scale_route_transition.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/lelscan/lelscan_top_manga_provider.dart';
import 'package:manga_reader/state/library_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'manga_details.dart';

class TopManga extends StatefulWidget {
  @override
  _TopMangaState createState() => _TopMangaState();
}

class _TopMangaState extends State<TopManga> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context
          .read<LelscanTopMangaProvider>()
          .getTopMangaList(Assets.lelscanCatalogName, 1, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
        child: context.watch<LelscanTopMangaProvider>().loadingState ==
                LoadingState.loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              )
            : context
                .select((LelscanTopMangaProvider provider) => provider)
                .topMangaList
                .fold((NException error) {
                return Error(
                    reload: () {
                      context
                          .read<LelscanTopMangaProvider>()
                          .getTopMangaList(Assets.lelscanCatalogName, 1, true);
                    },
                    error: error);
              }, (mangaList) {
                return mangaList!.isEmpty
                    ? Empty(reload: () {
                        context.read<LelscanTopMangaProvider>().getTopMangaList(
                            Assets.lelscanCatalogName, 1, true);
                      })
                    : GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal! * 2.5,
                          right: SizeConfig.blockSizeHorizontal! * 2.5,
                          top: SizeConfig.blockSizeVertical! * 4,
                          bottom: SizeConfig.blockSizeVertical! * 4,
                        ),
                        crossAxisSpacing: SizeConfig.blockSizeHorizontal! * 2,
                        mainAxisSpacing: SizeConfig.blockSizeVertical!,
                        children: List.generate(mangaList.length, (index) {
                          return MangaItem(
                            detailsNavigation: () {
                              Navigator.push(
                                  context,
                                  ScaleRoute(
                                      page: LelscanDetail(
                                    manga: mangaList[index],
                                  )));
                            },
                            addLibrary: () {
                              context.read<LibraryProvider>().addToLibrary(
                                  mangaList[index],
                                  MediaQuery.of(context).size);
                            },
                            libraryList:
                                context.watch<LibraryProvider>().libraryList,
                            manga: mangaList[index],
                            img: (mangaList[index].thumbnailUrl!.split("/")[0] +
                                    "/" +
                                    mangaList[index]
                                        .thumbnailUrl!
                                        .split("/")[1] +
                                    "/" +
                                    mangaList[index]
                                        .thumbnailUrl!
                                        .split("/")[2] +
                                    "/" +
                                    mangaList[index]
                                        .thumbnailUrl!
                                        .split("/")[3] +
                                    "/" +
                                    mangaList[index]
                                        .thumbnailUrl!
                                        .split("/")[4] +
                                    "/" +
                                    mangaList[index]
                                        .thumbnailUrl!
                                        .split("/")[5] +
                                    "/" +
                                    mangaList[index]
                                        .thumbnailUrl!
                                        .split("/")[6] +
                                    "/cover_250x350." +
                                    mangaList[index]
                                        .thumbnailUrl!
                                        .split("/")[7]
                                        .split(".")[1])
                                .replaceAll('http', "https"),
                          );
                        }),
                      );
              }),
        onRefresh: _refreshData);
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    context
        .read<LelscanTopMangaProvider>()
        .getTopMangaList(Assets.lelscanCatalogName, 1, true);
  }
}
