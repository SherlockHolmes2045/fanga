import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:manga_reader/utils/size_config.dart';

class Rating extends StatelessWidget {
  final String? rate;
  const Rating({Key? key,this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    if (rate != null) {
      var data = rate!.split(" ");
      var mark = data[0].split("/");
      return Container(
        width: SizeConfig.screenWidth! / 1.2,
        child: RatingBar.builder(
          initialRating: double.parse(mark[0]),
          itemSize: SizeConfig.blockSizeHorizontal! * 8,
          tapOnlyMode: false,
          onRatingUpdate: (double value){

          },
          minRating: 0,
          itemPadding: EdgeInsets.all(0.8),
          updateOnDrag: false,
          ignoreGestures: true,
          unratedColor: Colors.amber.withOpacity(0.5),
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: int.parse(mark[1]),
          itemBuilder: (context, _) => Container(
            width: SizeConfig.blockSizeHorizontal! * 5,
            child: Icon(
              Icons.star,
              size: SizeConfig.blockSizeHorizontal! * 4,
              color: Colors.amber,
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: SizeConfig.screenWidth! / 1.5,
        child: RatingBar.builder(
          initialRating: 0,
          tapOnlyMode: true,
          updateOnDrag: false,
          unratedColor: Colors.amber.withOpacity(0.5),
          minRating: 0,
          onRatingUpdate: (double value){

          },
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemBuilder: (context, _) => Container(
            width: SizeConfig.blockSizeHorizontal! * 4,
            child: Icon(
              Icons.star,
              size: 8,
              color: Colors.amber,
            ),
          ),
        ),
      );
    }
  }
}
