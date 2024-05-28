import 'package:art_inyou/repositories/post/fetching.dart';
import 'package:art_inyou/screens/home/gridview.dart';
import 'package:flutter/material.dart';

class DigitalArtScreen extends StatelessWidget {
  final String userid;
  const DigitalArtScreen({super.key,required this.userid, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:  GridViewScreen(postsFuture: getPostsByCategory('DigitalArt'),userId: userid,),
         
        
      );
    
  }
}