import 'package:flutter/material.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:manga_reader/globals.dart';
import 'package:manga_reader/Home.dart';
import 'package:manga_reader/catalogues.dart';


class Downloads extends StatefulWidget {
  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar:  AppBar(
          title: Text("Télechargements"),
        ),
      drawer: Drawer(
          child: Container(
              color: Color.fromRGBO(28, 28, 28, 1),
              child:ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: null,
                    accountName: Text("Sherlock Holmes",
                      style: TextStyle(
                          fontSize: 20.0
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(54, 117, 158, 1)
                    ),
                  ),
                  ListTileTheme(
                    selectedColor: Colors.blue,
                    child: ListTile(
                      selected: true,
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder:  (c) => Home()
                        )
                        );
                        }, 
                      title: Text("Ma bibliothèque", 
                        style: TextStyle(
                            fontSize: 17.0, 
                            color: Colors.white
                        ),
                      ), 
                      leading: Icon(Icons.phone,color: Colors.grey),
                    ),
                  ),
                  
                  ListTile(
                    title: Text("Catalogues", 
                      style: TextStyle(
                          fontSize: 17.0, 
                          color: Colors.white),), 
                    leading: Icon(Icons.photo,color: Colors.grey,), 
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder:  (c) => Catalogues()
                      )
                      );
                      },
                  ), 
                  ListTile(
                    
                    title: Text("File de téléchargement", 
                      style: TextStyle(
                          fontSize: 17.0, 
                          color: Colors.white),), 
                    leading: Icon(Icons.more,color: Colors.grey),
                  ), 
                  ListTile(
                    title: Text("Paramètres", 
                      style: TextStyle(
                          fontSize: 17.0, 
                          color: Colors.white),), 
                    leading: Icon(Icons.settings,color: Colors.grey),
                  ),
                ],
              )
          )
      ),
      body: Container(
        color: Color.fromRGBO(20, 20, 20, 1),
        child: ListView.builder(
            itemCount: downloads.length,
            itemBuilder: (context,int index){
              return Text(
                downloads[index]["tasks"].toString(),
                style: TextStyle(
                    color: Colors.white
                ),
              );
            }
        ),
      )
      );
  }
}
