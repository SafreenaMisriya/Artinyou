
import 'package:art_inyou/utils/color/colour.dart';
import 'package:flutter/material.dart';

class AddressTextform extends StatelessWidget {
  final String labelText;
  final TextInputType keyboardType;
  final int? maxLength;
 final int? maxLines;
  final String? Function(String?)? validator;
  final TextEditingController controller;

   const AddressTextform({ super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
     this.validator,
    required this.labelText,
    this.maxLength,
     this.maxLines,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      controller: controller,
      maxLength: maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType, 
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: greycolor)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: labelText,
        labelStyle: TextStyle(color: greycolor)
      ),
      validator: validator,
    );
  }
}