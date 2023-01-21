import 'package:flutter/material.dart';
import 'package:fanga/constants/assets.dart';
import 'package:fanga/custom/widgets/empty.dart';
import 'package:fanga/custom/widgets/error.dart';
import 'package:fanga/custom/widgets/manga_item.dart';
import 'package:fanga/custom/widgets/scale_route_transition.dart';
import 'package:fanga/screens/Lelscan/manga_details.dart';
import 'package:fanga/state/LoadingState.dart';
import 'package:fanga/state/lelscan/lelscan_updates_provider.dart';
import 'package:fanga/state/library_provider.dart';
import 'package:fanga/utils/n_exception.dart';
import 'package:fanga/utils/size_config.dart';
import 'package:provider/provider.dart';

class LatestUpdates extends StatefulWidget {
  @override
  _LatestUpdatesState createState() => _LatestUpdatesState();
}

class _LatestUpdatesState extends State<LatestUpdates> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context
          .read<LelscanUpdatesProvider>()
          .getUpdatedMangaList(Assets.lelscanCatalogName, 1, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
        child: context.watch<LelscanUpdatesProvider>().loadingState ==
                LoadingState.loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              )
            : context
                .select((LelscanUpdatesProvider provider) => provider)
                .updatedMangaList
                .fold((NException error) {
                return Error(
                    reload: () {
                      context
                          .read<LelscanUpdatesProvider>()
                          .getUpdatedMangaList(
                              Assets.lelscanCatalogName, 1, true);
                    },
                    error: error);
              }, (mangaList) {
                return mangaList!.isEmpty
                    ? Empty(
                        reload: () {
                          context
                              .read<LelscanUpdatesProvider>()
                              .getUpdatedMangaList(
                                  Assets.lelscanCatalogName, 1, true);
                        },
                      )
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
                              manga: mangaList[index]);
                        }),
                      );
              }),
        onRefresh: _refreshData);
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    context
        .read<LelscanUpdatesProvider>()
        .getUpdatedMangaList(Assets.lelscanCatalogName, 1, true);
  }
}
