import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';

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
              icon: Icons.contacts,
              text: 'LelScan',
            ),
            _createDrawerItem(
              icon: Icons.event,
              text: 'MangaKawaii',
            ),
            _createDrawerItem(
              icon: Icons.note,
              text: 'MangaHere',
            ),
            _createDrawerItem(
              icon: Icons.note,
              text: 'Light Novels',
            ),
            Divider(
              color: Colors.white,
            ),
            _createDrawerItem(icon: Icons.collections_bookmark, text: 'Bibliothèque'),
            _createDrawerItem(icon: Icons.download_rounded, text: 'Téléchargements'),
            Divider(
              color: Colors.white,
            ),
            _createDrawerItem(
                icon: Icons.settings, text: 'Paramètres'),
            _createDrawerItem(icon: Icons.info_outline, text: 'A propos'),
            Divider(),
            _createDrawerItem(icon: Icons.bug_report, text: 'Signaler un bug'),
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
              filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
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
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon,color: Colors.white,),
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
