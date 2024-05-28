import 'package:art_inyou/utils/fonts/font.dart';
import 'package:flutter/material.dart';

customAppbartop(BuildContext context,String title){
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(title,style: MyFonts.headingTextStyle,),
     leading: IconButton(onPressed: (){
      Navigator.pop(context);
     }, icon: const Icon(Icons.arrow_back)),
  );
}