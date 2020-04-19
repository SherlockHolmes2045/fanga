import 'package:flutter/material.dart';
import 'package:manga_reader/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

class Page extends StatefulWidget {
  String catalog;
  String page;
  String index;
  String path;
  Page(this.catalog,this.page,this.index,this.path);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    if(widget.path != null){
      return
        Center(
          child: Column(
            children: <Widget>[
              Image.file(
                new File(widget.path),
                fit: BoxFit.contain,
              ),
              Container(
                child: Center(
                  child: Text(
                    widget.index,
                    style:TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                    ) ,
                  ),
                ),
              )
            ],
          ),
        );
    }else{
      return FutureBuilder(
        future: getImageUrl(widget.catalog,widget.page),
        builder: (context,snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }else{
            if(snapshot.data == null){
              return RaisedButton(
                color: Colors.grey,
                child: Text(
                    "Réessayez"
                ),
                onPressed: (){
                  setState(() {
                  });
                },
              );
            }else{
              return  Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: snapshot.data,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => RaisedButton(
                            child: Text("Retry"),
                            onPressed: (){
                              setState(() {
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            widget.index,
                            style:TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold
                            ) ,
                          ),
                        ),
                      )
                    ],
                  ),
              );
            }
          }
        },
      );
    }

  }
}
