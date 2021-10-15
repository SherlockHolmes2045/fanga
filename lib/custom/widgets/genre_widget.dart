import 'package:flutter/material.dart';

class Genres extends StatelessWidget {
  final String? genres;
  const Genres({Key? key,this.genres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data;
    if(genres!.contains(",")){
      data = genres!.split(",");
    }else{
      data = genres!.split("\n");
    }
    return Wrap(
        runSpacing: 5.0,
        spacing: 5.0,
        children: List.generate(data.length, (index) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyan),
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Text(
              data[index],
              style: TextStyle(color: Colors.cyan),
            ),
          );
        }));
  }
}
