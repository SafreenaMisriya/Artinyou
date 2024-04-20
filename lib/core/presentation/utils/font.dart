import 'package:flutter/material.dart';

class MyFonts {
  static const TextStyle headingTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
  );
   static const TextStyle normalTextStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w300,
  );
   static const TextStyle boldTextStyle = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
  );
}
Widget myfonts(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    ),
  );
}
