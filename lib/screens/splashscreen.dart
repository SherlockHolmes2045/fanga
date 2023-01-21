import 'package:flutter/material.dart';
import 'package:fanga/constants/assets.dart';
import 'package:fanga/custom/widgets/AppIconWidget.dart';
import 'package:fanga/routes.dart';
import 'package:fanga/state/bookmark_provider.dart';
import 'package:fanga/state/lelscan/lelscan_manga_list_provider.dart';
import 'package:fanga/state/lelscan/lelscan_provider.dart';
import 'package:fanga/state/lelscan/lelscan_top_manga_provider.dart';
import 'package:fanga/state/lelscan/lelscan_updates_provider.dart';
import 'package:fanga/state/library_provider.dart';
import 'package:fanga/state/page_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  Animation<double>? iconAnimation;
  late AnimationController iconAnimationController;

  @override
  void initState() {
    super.initState();
    iconAnimationController = AnimationController(
        duration: const Duration(seconds: 5), vsync: this);
    iconAnimation =
        Tween<double>(begin: 2, end: 4).animate(iconAnimationController);
    iconAnimationController.repeat(reverse: true);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<LibraryProvider>().loadLibrary();
      context.read<BookmarkProvider>().loadBookmarked();
      context.read<PageProvider>().loadAllPages();
      context.read<LelscanProvider>().getPopularMangaList(Assets.lelscanCatalogName, 1,false);
      context.read<LelscanTopMangaProvider>().getTopMangaList(Assets.lelscanCatalogName, 1,false);
      context.read<LelscanUpdatesProvider>().getUpdatedMangaList(Assets.lelscanCatalogName, 1,false);
      context.read<LelscanMangaListProvider>().getMangaList(Assets.lelscanCatalogName,context.read<LelscanMangaListProvider>().currentPage,false);
      Future.delayed(Duration(seconds: 5),(){
        iconAnimationController.stop();
        Navigator.pushReplacementNamed(context, Routes.lelscan);
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    iconAnimationController.dispose(); // you need this
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
          color: Colors.black,
          child: Center(
              child: AnimatedBuilder(
                animation: iconAnimationController,
                builder: (BuildContext context, Widget? child) {
                  return AppIconWidget(
                      scale: iconAnimationController.value, image: Assets.appLogo);
                },
              )),
        )
    );
  }

}