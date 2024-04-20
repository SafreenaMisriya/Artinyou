 import 'package:flutter/material.dart';
class Responsive{
  static MediaQueryData getMediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  static double screenWidth(BuildContext context) {
    return getMediaQueryData(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return getMediaQueryData(context).size.height;
  }
}