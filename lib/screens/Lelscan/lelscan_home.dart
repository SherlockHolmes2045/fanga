import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/custom/widgets/app_drawer.dart';
import 'package:Fanga/custom/widgets/search_delegate.dart';
import 'package:Fanga/screens/Lelscan/all_manga.dart';
import 'package:Fanga/screens/Lelscan/latest_update.dart';
import 'package:Fanga/screens/Lelscan/manga_list.dart';
import 'package:Fanga/screens/Lelscan/top_manga.dart';
import 'package:Fanga/utils/size_config.dart';
import 'package:url_launcher/url_launcher.dart';

class LelScan extends StatefulWidget {
  @override
  _LelScanState createState() => _LelScanState();
}

class _LelScanState extends State<LelScan> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
        child: DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(28, 28, 28, 1),
          bottom: TabBar(
            isScrollable: true,
            onTap: (index) {
              // Tab index when user select it, it start from zero
            },
            tabs: [
              Tab(
                text: "Manga Populaires",
              ),
              Tab(
                text: "Mises à jour",
              ),
              Tab(
                text: "Liste Des Mangas",
              ),
              Tab(
                text: "Top Mangas",
              ),
            ],
          ),
          title: Text(
            "Lelscan",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchManga(Assets.lelscanCatalogName));
              },
            ),
            IconButton(
              iconSize: SizeConfig.blockSizeHorizontal! * 4.75,
              icon: FaIcon(
                FontAwesomeIcons.globe,
                color: Colors.white,
                size: SizeConfig.blockSizeHorizontal! * 4.75,
              ),
              onPressed: () async {
                await canLaunch("https://lelscan-vf.co/")
                    ? await launch("https://lelscan-vf.co/")
                    : BotToast.showText(text: "Impossible d'ouvrir ce lien");
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: [
            MangaList(),
            LatestUpdates(),
            AllManga(),
            TopManga(),
          ],
        ),
      ),
    ));
  }
}
