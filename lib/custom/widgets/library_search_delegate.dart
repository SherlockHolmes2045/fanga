import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Fanga/constants/assets.dart';
import 'package:Fanga/custom/widgets/scale_route_transition.dart';
import 'package:Fanga/models/manga.dart';
import 'package:Fanga/state/library_provider.dart';
import 'package:provider/provider.dart';
import 'package:Fanga/screens/Lelscan/manga_details.dart';
import 'package:Fanga/screens/readmangatoday/readmangatoday_manga_details.dart';
import 'package:Fanga/utils/size_config.dart';

class LibrarySearch extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        primaryColor: Color.fromRGBO(28, 28, 28, 1),
        textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    print(ModalRoute.of(context).settings.name);
    SizeConfig().init(context);
    return FutureBuilder(
        future: context.read<LibraryProvider>().findManga(query),
        builder: (context, AsyncSnapshot<List<Manga>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If we got an error
            if (snapshot.hasError) {
              return Container(
                color: Colors.black,
                child: Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              print(snapshot.data);
              if (snapshot.data.isEmpty) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      "Pas de résultat pour cette recherche",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              } else {
                return Container(
                  color: Colors.black,
                  child: GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 2.5,
                        right: SizeConfig.blockSizeHorizontal * 2.5,
                        top: SizeConfig.blockSizeVertical * 4,
                        bottom: SizeConfig.blockSizeVertical * 4,
                      ),
                      crossAxisSpacing: SizeConfig.blockSizeHorizontal * 2,
                      mainAxisSpacing: SizeConfig.blockSizeVertical,
                      children: List.generate(snapshot.data.length, (index) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () {
                                    switch (snapshot.data[index].catalog) {
                                      case Assets.lelscanCatalogName:
                                        {
                                          Navigator.push(
                                              context,
                                              ScaleRoute(
                                                  page: LelscanDetail(
                                                manga: snapshot.data[index],
                                              )));
                                        }
                                        break;

                                      case Assets.readmangatodayCatalogName:
                                        {
                                          Navigator.push(
                                              context,
                                              ScaleRoute(
                                                  page: ReadmangatodayDetail(
                                                manga: snapshot.data[index],
                                              )));
                                        }
                                        break;

                                      default:
                                        {
                                          //statements;
                                        }
                                        break;
                                    }
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data[index].thumbnailUrl,
                                    width: double.infinity,
                                    height: 350,
                                    errorWidget: (context, text, data) {
                                      return GestureDetector(
                                        onTap: () {
                                          switch (
                                              snapshot.data[index].catalog) {
                                            case Assets.lelscanCatalogName:
                                              {
                                                Navigator.push(
                                                    context,
                                                    ScaleRoute(
                                                        page: LelscanDetail(
                                                      manga:
                                                          snapshot.data[index],
                                                    )));
                                              }
                                              break;

                                            case Assets
                                                .readmangatodayCatalogName:
                                              {
                                                Navigator.push(
                                                    context,
                                                    ScaleRoute(
                                                        page:
                                                            ReadmangatodayDetail(
                                                      manga:
                                                          snapshot.data[index],
                                                    )));
                                              }
                                              break;

                                            default:
                                              {
                                                //statements;
                                              }
                                              break;
                                          }
                                        },
                                        child: Image.asset(
                                          Assets.errorImage,
                                          width: double.infinity,
                                          height: 350,
                                        ),
                                      );
                                    },
                                    //fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical),
                                child: Text(
                                  snapshot.data[index].title,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      })),
                );
              }
            }
          }
          // Displaying LoadingSpinner to indicate waiting state
          return Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
