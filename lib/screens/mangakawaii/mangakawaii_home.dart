import 'package:flutter/material.dart';
import 'package:fanga/constants/assets.dart';
import 'package:fanga/custom/widgets/app_drawer.dart';
import 'package:fanga/custom/widgets/search_delegate.dart';
import 'package:fanga/screens/mangakawaii/all_manga.dart';
import 'package:fanga/screens/mangakawaii/latest_update.dart';
import 'package:fanga/screens/mangakawaii/popular_manga_list.dart';
import 'package:fanga/screens/mangakawaii/top_manga.dart';

class Mangakawaii extends StatefulWidget {
  @override
  _MangakawaiiState createState() => _MangakawaiiState();
}

class _MangakawaiiState extends State<Mangakawaii> {
  @override
  Widget build(BuildContext context) {
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
                text: "Nouveautés Mangas",
              ),
            ],
          ),
          title: Text(
            "Mangakawaii",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.white,
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchManga(Assets.mangakawaiiCatalogName));
              },
            ),
            IconButton(
              icon: Icon(
                Icons.sort,
                color: Colors.white,
              ),
              onPressed: () {},
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
