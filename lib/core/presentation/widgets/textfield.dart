// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final int? maxLength;
  final int? maxLines;
  final String? Function(String?)? validator;
  final TextEditingController controller;
   bool obscureText;

  CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
     this.validator,
    required this.labelText,
    this.maxLength,
    this.maxLines,
    this.obscureText = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorErrorColor: Colors.blueAccent,
      maxLines: widget.maxLines,
      controller: widget.controller,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType, 
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
                icon: Icon(widget.obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,color: Colors.grey,),
              )
            : null,
        fillColor: const Color.fromARGB(255, 238, 231, 231),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(18),
        ),
        labelText: widget.labelText,
      ),
      validator: widget.validator,
    );
  }
}
