import 'dart:math';
import 'package:flutter/material.dart';
import 'package:manga_reader/ctalogs_provider.dart';
import 'package:provider/provider.dart';
import 'package:manga_reader/services.dart';
import 'package:manga_reader/Home.dart';
import 'package:manga_reader/catalog_details.dart';
import 'package:manga_reader/error.dart';
class Catalogues extends StatefulWidget {
  @override
  _CataloguesState createState() => _CataloguesState();
}

class _CataloguesState extends State<Catalogues> {

  List<MaterialColor> _colorItem = [
    Colors.deepOrange,
    Colors.blueGrey,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.green,
    Colors.yellow,
    Colors.indigo
  ];
  List<Widget> resultEn = [];
  List<Widget> resultFr = [];
  
  List<Widget> buildCatalogsEn(data,BuildContext context){
    resultEn = [];

    for(var i =0;i<data.length;i++){
      var random = (Random().nextInt(_colorItem.length));
        resultEn.add(
            Padding(
                padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/51.43,right: MediaQuery.of(context).size.width/51.3),
                child:
                Card(
                  elevation: 0.75,
                  color: Color.fromRGBO(32, 32, 32, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                          data[i].name[0],
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width/20)
                      ),
                      backgroundColor: _colorItem[random],
                    ),
                    title: Text(
                      data[i].name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/21.2
                      ),
                    ),
                    trailing: InkWell(
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder:  (c) => CatalogDetails(data[i])
                        ));
                      },
                      child: Text("Explorer",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width/24,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                )
            )
        );
    }
    return resultEn;
  }

  List<Widget> buildCatalogsFr(data,BuildContext context){
    resultFr = [];

    for(var i =0;i<data.length;i++){
      var random = (Random().nextInt(_colorItem.length));
      if(data[i].lang =="fr")
        resultFr.add(
            Padding(
                padding: EdgeInsets.only(left:MediaQuery.of(context).size.width/51.43,right: MediaQuery.of(context).size.width/51.3),
                child:
                Card(
                  elevation: 0.75,
                  color: Color.fromRGBO(32, 32, 32, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(
                          data[i].name[0],
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width/20)
                      ),
                      backgroundColor: _colorItem[random],
                    ),
                    title: Text(
                      data[i].name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width/21.2
                      ),
                    ),
                    trailing: InkWell(
                      onTap: (){
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder:  (c) => CatalogDetails(data[i])
                        ));
                      },
                      child: Text("Explorer",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: MediaQuery.of(context).size.width/24,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                )
            )
        );
    }
    return resultFr;
  }
  Future<Null> getRefresh() async{
    await Future.delayed (Duration(seconds:1));
    setState(() {
      getCatalogues();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          title: Text("Catalogues"),
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
                      ),),
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
                        ));
                      },
                      title: Text("Ma bibliothèque",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width/21.2,
                            color: Colors.white
                        ),
                      ),
                      leading: Icon(Icons.book,color: Colors.grey),
                    ),
                  ),

                  ListTile(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder:  (c) => Catalogues()
                      ));
                    },
                    title: Text("Catalogues",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/21.2,
                          color: Colors.white),),
                    leading: Icon(Icons.explore,color: Colors.grey,),
                  ),
                  /*ListTile(

                    title: Text("File de téléchargement",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/21.2,
                          color: Colors.white),),
                    leading: Icon(Icons.file_download,color: Colors.grey),
                  ),
                  ListTile(
                    title: Text("Paramètres",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/21.2,
                          color: Colors.white),),
                    leading: Icon(Icons.settings,color: Colors.grey),
                  ),*/
                ],
              )
          )
      ),
      body: Provider.of<CatalogsProvider>(context,listen: false).getCatalogs() == null ?
      FutureBuilder(
        future: getCatalogues(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Color.fromRGBO(20, 20, 20, 1),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            if(snapshot.data == null){
              return Container(
                  color: Color.fromRGBO(20, 20, 20, 1),
                child: Error(
                  errorMessage: "Verifiez votre connexion Internet",
                  onRetryPressed: (){
                    print("retry");
                    getRefresh();
                  }
          )
          );
            }else{
              Provider.of<CatalogsProvider>(context,listen: false).setCatalogs(snapshot.data);
              return RefreshIndicator(
                color: Color.fromRGBO(20, 20, 20, 1),
                onRefresh: getRefresh,
                child: Container(
                    color: Color.fromRGBO(20, 20, 20, 1),
                    child: Padding(
                      padding: EdgeInsets.only(top:10.0),
                      child: ListView(
                        children: buildCatalogsEn(snapshot.data,context),
                      ),
                    )
                ),
              );
            }
          }
        }
      ) : RefreshIndicator(
        color: Color.fromRGBO(20, 20, 20, 1),
        onRefresh: getRefresh,
        child: Consumer<CatalogsProvider>(
          builder: (context,catalogs,child) => Container(
            color: Color.fromRGBO(20, 20, 20, 1),
            child: Padding(
                padding: EdgeInsets.only(top:10.0),
                child: ListView(
                  children: buildCatalogsEn(catalogs.getCatalogs(),context),
                )
            ),
        ),
      ),
    ),
    );
  }
}
