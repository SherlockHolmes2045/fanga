import 'package:Fanga/screens/readmangatoday/readmangatoday_manga_details.dart';
import 'package:Fanga/state/readmangatoday/readmangatoday_manga_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/custom/widgets/empty.dart';
import 'package:Fanga/custom/widgets/error.dart';
import 'package:Fanga/custom/widgets/manga_item.dart';
import 'package:Fanga/custom/widgets/scale_route_transition.dart';
import 'package:Fanga/state/LoadingState.dart';
import 'package:Fanga/state/library_provider.dart';
import 'package:Fanga/utils/n_exception.dart';
import 'package:Fanga/utils/size_config.dart';
import 'package:provider/provider.dart';

class AllManga extends StatefulWidget {
  @override
  _AllMangaState createState() => _AllMangaState();
}

class _AllMangaState extends State<AllManga> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          var triggerFetchMoreSize =
              0.75 * _scrollController.position.maxScrollExtent;

          if (_scrollController.position.pixels > triggerFetchMoreSize) {
            if (context.read<ReadmangatodayMangaListProvider>().hasNext)
              context.read<ReadmangatodayMangaListProvider>().getMangaList(
                  Assets.readmangatodayCatalogName,
                  context.read<ReadmangatodayMangaListProvider>().nextPage,
                  false);
          }
        }
      });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<ReadmangatodayMangaListProvider>().mangaList.fold((l) => null, (r) {
        if (r.isEmpty) {
          context.read<ReadmangatodayMangaListProvider>().getMangaList(
              Assets.readmangatodayCatalogName,
              context.read<ReadmangatodayMangaListProvider>().currentPage,
              false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
        child: context.watch<ReadmangatodayMangaListProvider>().loadingState ==
            LoadingState.loading
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.blue),
          ),
        )
            : context
            .select((ReadmangatodayMangaListProvider provider) => provider)
            .mangaList
            .fold((NException error) {
          return Error(
              reload: () {
                context.read<ReadmangatodayMangaListProvider>().getMangaList(
                    Assets.readmangatodayCatalogName,
                    context.read<ReadmangatodayMangaListProvider>().currentPage,
                    true);
              },
              error: error);
        }, (mangaList) {
          return mangaList.isEmpty
              ? Empty(
            reload: () {
              context.read<ReadmangatodayMangaListProvider>().getMangaList(
                  Assets.readmangatodayCatalogName,
                  context
                      .read<ReadmangatodayMangaListProvider>()
                      .currentPage,
                  true);
            },
          )
              : GridView.count(
            crossAxisCount: 2,
            controller: _scrollController,
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
    context.read<ReadmangatodayMangaListProvider>().clearList();
    context.read<ReadmangatodayMangaListProvider>().getMangaList(
        Assets.readmangatodayCatalogName,
        context.read<ReadmangatodayMangaListProvider>().currentPage,
        true);
  }
}
