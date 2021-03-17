import 'package:flutter/material.dart';
import 'package:manga_reader/custom/widgets/app_drawer.dart';
import 'package:manga_reader/screens/Lelscan/manga_list.dart';
import 'package:manga_reader/utils/size_config.dart';

class LelScan extends StatefulWidget {
  @override
  _LelScanState createState() => _LelScanState();
}

class _LelScanState extends State<LelScan> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          bottom: TabBar(
            onTap: (index) {
              // Tab index when user select it, it start from zero
            },
            tabs: [
              Tab(
                text: "Liste Des Mangas",
              ),
              Tab(
                text: "Favoris",
              ),
              Tab(
                text: "Manga Populaires",
              ),
              Tab(
                text: "Top Mangas",
              ),
            ],
          ),
          title: Text(
            "LelScan",
            style: TextStyle(color: Colors.white, fontSize: 22.0),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.sort,
              color: Colors.white,
            )
          ],
        ),
        drawer: AppDrawer(),
        body: TabBarView(
          children: [
            MangaList(),
            Center(
                child: Text(
              "1",
              style: TextStyle(fontSize: 40),
            )),
            Center(
                child: Text(
              "2",
              style: TextStyle(fontSize: 40),
            )),
            Center(
                child: Text(
              "3",
              style: TextStyle(fontSize: 40),
            )),
          ],
        ),
      ),
    ));
  }
}
