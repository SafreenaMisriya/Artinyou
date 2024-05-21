
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

snakbarSuccessMessage(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding:const EdgeInsets.all(12),
    backgroundColor: Colors.green,
    content: Text(text),
    behavior: SnackBarBehavior.floating,
  ));
}
snakbarDeleteMessage(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding:const EdgeInsets.all(12),
    backgroundColor: Colors.red,
    content: Text(text),
    behavior: SnackBarBehavior.floating,
  ));
}

showfluttertoast(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.green,
      fontSize: 20,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_SHORT);
}
showErrorfluttertoast(String msg) {
  return Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red,
      fontSize: 20,
      gravity: ToastGravity.TOP,
      toastLength: Toast.LENGTH_LONG);
}
