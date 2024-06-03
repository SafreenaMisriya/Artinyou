
import 'package:flutter/material.dart';
Widget followlabelwidget({
  required String labelText,
  required void Function()? onTap,
  Widget? child, 
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 45,
      width: 300,
      decoration: BoxDecoration(
        color:  color ,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: child ?? Text( 
          labelText,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
