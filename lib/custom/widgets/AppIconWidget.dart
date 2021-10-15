import 'package:flutter/material.dart';

class AppIconWidget extends StatefulWidget {
  final image;
  final scale;

  const AppIconWidget({
    Key? key,
    this.image,
    this.scale,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppIconWidgetState();
}

class AppIconWidgetState extends State<AppIconWidget> {

  @override
  Widget build(BuildContext context) {
    //getting screen size
    var size = MediaQuery.of(context).size;

    //calculating container width
    double imageSize;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      imageSize = (size.width * 0.20);
    } else {
      imageSize = (size.height * 0.20);
    }

    return Image.asset(
      widget.image,
      height: imageSize*(widget.scale+1),
    );
  }
}
