import 'package:flutter/material.dart';


getSize(taille, type, resp) {
  double size = 0;
  if (type == "width") {
    size = MediaQuery.of(resp).size.width * (taille / 375);
  }
  if (type == "height") {
    size = MediaQuery.of(resp).size.height * (taille / 667);
  }
  return size;
}

/*extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1)}";
    }
}*/

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static double? screenWidth;
  static late double screenHeight;
  static double? blockSizeHorizontal;
  static double? blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight / 100;
  }
}
T? cast<T>(x) => x is T ? x : null;