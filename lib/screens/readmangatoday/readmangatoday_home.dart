import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/app_drawer.dart';
import 'package:manga_reader/custom/widgets/search_delegate.dart';
import 'package:manga_reader/screens/mangakawaii/all_manga.dart';
import 'package:manga_reader/screens/mangakawaii/latest_update.dart';
import 'package:manga_reader/screens/mangakawaii/top_manga.dart';
import 'package:manga_reader/screens/readmangatoday/readmangatoday_manga_list.dart';

class Readmangatoday extends StatefulWidget {
  @override
  _ReadmangatodayState createState() => _ReadmangatodayState();
}

class _ReadmangatodayState extends State<Readmangatoday> {

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
                "ReadMangaToday",
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
                    icon: Icon(
                      Icons.sort,
                      color: Colors.white,
                    )
                ),
              ],
            ),
            drawer: AppDrawer(),
            body: TabBarView(
              children: [
                ReadmangatodayMangaList(),
                LatestUpdates(),
                AllManga(),
                TopManga(),
              ],
            ),
          ),
        ));
  }
}
