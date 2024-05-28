import 'package:art_inyou/utils/color/colour.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

final defaultPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
        fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)));
