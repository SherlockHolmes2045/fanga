import 'package:fanga/screens/readmangatoday/readmangatoday_manga_details.dart';
import 'package:fanga/state/readmangatoday/readmangatoday_updates_provider.dart';
import 'package:flutter/material.dart';
import 'package:fanga/constants/assets.dart';
import 'package:fanga/custom/widgets/empty.dart';
import 'package:fanga/custom/widgets/error.dart';
import 'package:fanga/custom/widgets/manga_item.dart';
import 'package:fanga/custom/widgets/scale_route_transition.dart';
import 'package:fanga/state/LoadingState.dart';
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
          .read<ReadmangatodayUpdatesProvider>()
          .getUpdatedMangaList(Assets.readmangatodayCatalogName, 1, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
        child: context.watch<ReadmangatodayUpdatesProvider>().loadingState ==
            LoadingState.loading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        )
            : context
            .select((ReadmangatodayUpdatesProvider provider) => provider)
            .updatedMangaList
            .fold((NException error) {
          return Error(
              reload: () {
                context
                    .read<ReadmangatodayUpdatesProvider>()
                    .getUpdatedMangaList(
                    Assets.readmangatodayCatalogName, 1, true);
              },
              error: error);
        }, (mangaList) {
          return mangaList.isEmpty
              ? Empty(
            reload: () {
              context
                  .read<ReadmangatodayUpdatesProvider>()
                  .getUpdatedMangaList(
                  Assets.readmangatodayCatalogName, 1, true);
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
        .read<ReadmangatodayUpdatesProvider>()
        .getUpdatedMangaList(Assets.readmangatodayCatalogName, 1, true);
  }
}
