import 'package:flutter/material.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:manga_reader/bibliotheque.dart';
import 'package:manga_reader/services.dart';
import 'catalogues.dart';
class Home extends StatefulWidget{
  @override

  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home>{

  List<Widget> result= [];
  buildPopularManga(data){
    //List<Widget> result = [];
    for(var i =0;i<data.length;i++){
      result.add(
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  data[i].thumbnailUrl
              ),
                  fit: BoxFit.cover
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: Text(
                  data[i].title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                  ),
                ),
              )
            )
          ),

      );
    }
    return result;
  }
  Future<Null> getRefresh() async{
    await Future.delayed (Duration(seconds:3));
    setState(() {
      fetchPopularManga("readmangtoday","1");
    });
  }

  final AppBarController appBarController = AppBarController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: SearchAppBar(
        primary: Color.fromRGBO(32, 32, 32, 1),
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Rechercher...",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Bibliothèque"),
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.search,
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                appBarController.stream.add(false);
              },
            ),
          ],
        ),
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
                    ));
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
      body:FutureBuilder(
        future: fetchPopularManga("readmangatoday","1"),
        builder: (context,snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return Container(
              color: Color.fromRGBO(20, 20, 20, 1),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }else{
            return RefreshIndicator(
              onRefresh: getRefresh,
              child: Container(
                  color: Color.fromRGBO(20, 20, 20, 1),
                  child:GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(10),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: buildPopularManga(snapshot.data)
                  )
              ),
            );
          }
        },
      )
    );
  }

}
