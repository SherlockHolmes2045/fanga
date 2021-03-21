import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/scale_route_transition.dart';
import 'package:manga_reader/screens/Lelscan/manga_details.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/search_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:provider/provider.dart';

class SearchManga extends SearchDelegate {
  String source;
  SearchManga(this.source);

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
    SizeConfig().init(context);
    context.read<SearchProvider>().getSearchResults(source, query, 1);
    return Container(
      color: Colors.black,
      child:
          context.watch<SearchProvider>().loadingState == LoadingState.loading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                )
              : context
                  .select((SearchProvider provider) => provider)
                  .searchResults
                  .fold((NException error) {
                  return Center(
                    child: Text(
                      error.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }, (searchResult) {
                  return searchResult.isEmpty
                      ? Center(
                          child: Text(
                            "No results for your search sorry",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          padding: EdgeInsets.only(
                            left: SizeConfig.blockSizeHorizontal * 2.5,
                            right: SizeConfig.blockSizeHorizontal * 2.5,
                            top: SizeConfig.blockSizeVertical * 4,
                            bottom: SizeConfig.blockSizeVertical * 4,
                          ),
                          crossAxisSpacing: SizeConfig.blockSizeHorizontal * 2,
                          mainAxisSpacing: SizeConfig.blockSizeVertical,
                          children: List.generate(searchResult.length, (index) {
                            return Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            ScaleRoute(
                                                page: LelscanDetail(
                                              manga: searchResult[index],
                                            )));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: searchResult[index]
                                            .thumbnailUrl.startsWith("//")?
                                            "https:"+searchResult[index]
                                                .thumbnailUrl:
                                        searchResult[index]
                                            .thumbnailUrl
                                            .replaceAll('http', "https"),
                                        width: double.infinity,
                                        height: 350,
                                        errorWidget: (context, text, data) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  ScaleRoute(
                                                      page: LelscanDetail(
                                                    manga: searchResult[index],
                                                  )));
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
                                      searchResult[index].title,
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
                          }),
                        );
                }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }
}
