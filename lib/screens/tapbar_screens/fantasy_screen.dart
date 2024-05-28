import 'package:art_inyou/repositories/post/fetching.dart';
import 'package:art_inyou/screens/home/gridview.dart';
import 'package:flutter/material.dart';

class FantasyScreen extends StatelessWidget {
  final String userId;

  const FantasyScreen({super.key,required this.userId,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridViewScreen(postsFuture: getPostsByCategory('Fantasy'),userId: userId,),
    );
  }
}