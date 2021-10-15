import 'package:flutter/material.dart';
import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/custom/widgets/empty.dart';
import 'package:Fanga/custom/widgets/error.dart';
import 'package:Fanga/custom/widgets/manga_item.dart';
import 'package:Fanga/custom/widgets/scale_route_transition.dart';
import 'package:Fanga/screens/readmangatoday/readmangatoday_manga_details.dart';
import 'package:Fanga/state/LoadingState.dart';
import 'package:Fanga/state/library_provider.dart';
import 'package:Fanga/state/readmangatoday/readmangatoday_provider.dart';
import 'package:Fanga/utils/n_exception.dart';
import 'package:Fanga/utils/size_config.dart';
import 'package:provider/provider.dart';

class ReadmangatodayMangaList extends StatefulWidget {
  @override
  _ReadmangatodayMangaListState createState() =>
      _ReadmangatodayMangaListState();
}

class _ReadmangatodayMangaListState extends State<ReadmangatodayMangaList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context
          .read<ReadmangatodayProvider>()
          .getPopularMangaList(Assets.readmangatodayCatalogName, 1, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
        child: context.watch<ReadmangatodayProvider>().loadingState ==
                LoadingState.loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              )
            : context
                .select((ReadmangatodayProvider provider) => provider)
                .popularMangaList
                .fold((NException error) {
                return Error(
                    reload: () {
                      context
                          .read<ReadmangatodayProvider>()
                          .getPopularMangaList(
                              Assets.readmangatodayCatalogName, 1, true);
                    },
                    error: error);
              }, (mangaList) {
                return mangaList!.isEmpty
                    ? Empty(reload: () {
                        context
                            .read<ReadmangatodayProvider>()
                            .getPopularMangaList(
                                Assets.readmangatodayCatalogName, 1, true);
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
                                        page: ReadmangatodayDetail(
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
        .read<ReadmangatodayProvider>()
        .getPopularMangaList(Assets.readmangatodayCatalogName, 1, true);
  }
}
