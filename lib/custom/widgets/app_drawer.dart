import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(),
            _createDrawerItem(
              imagePath: Assets.lelscanIcon,
              text: 'LelScan',
              onTap: (){
                Navigator.pushReplacementNamed(context, Routes.lelscan);
              }
            ),
            /*_createDrawerItem(
              imagePath: Assets.mangakawaiiIcon,
              text: 'MangaKawaii',
                onTap: (){
                  Navigator.pushReplacementNamed(context, Routes.mangakawaii);
                }
            ),
            _createDrawerItem(
              imagePath: Assets.mangahereIcon,
              text: 'MangaHere',
                onTap: (){
                  Navigator.pushReplacementNamed(context, Routes.mangahere);
                }
            ),
            _createDrawerItem(
              imagePath: Assets.mangafoxIcon,
              text: 'MangaFox',
                onTap: (){
                  Navigator.pushReplacementNamed(context, Routes.mangafox);
                }
            ),*/
            _createDrawerItem(
              imagePath: Assets.readmangatodayIcon,
              text: 'ReadMangaToday',
                onTap: (){
                Navigator.pushReplacementNamed(context, Routes.readmangatoday);
              }
            ),
            //For the next updates
            /*_createDrawerItem(
              icon: Icons.note,
              text: 'Light Novels',
            ),*/
            Divider(
              color: Colors.white.withOpacity(0.5),
            ),
            _createDrawerItem(icon: Icons.collections_bookmark, text: 'Bibliothèque', onTap: () => Navigator.pushReplacementNamed(context, Routes.library)),
            _createDrawerItem(icon: Icons.download_rounded, text: 'Téléchargements',onTap: () => Navigator.pushNamed(context, Routes.downloads)),
            Divider(
              color: Colors.white.withOpacity(0.5),
            ),
            /*_createDrawerItem(
                icon: Icons.settings, text: 'Paramètres'),
            _createDrawerItem(icon: Icons.info_outline, text: 'A propos'),
            Divider(
              color: Colors.white.withOpacity(0.5),
            ),
            _createDrawerItem(icon: Icons.bug_report, text: 'Signaler un bug'),*/
          ],
        ),
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage(Assets.background))),
        child: ClipRRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Stack(children: <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("Fanga",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500))),
              ])),
        ));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap,String imagePath}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          imagePath == null ? Icon(icon,color: Colors.white,):Image.asset(imagePath),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text,style: TextStyle(
              color: Colors.white
            ),),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
