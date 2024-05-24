import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/pages/home/gridview.dart';
import 'package:flutter/material.dart';

class PhotographyScreen extends StatelessWidget {
  final String userId;
  const PhotographyScreen({super.key,required this.userId,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridViewScreen(postsFuture: getPostsByCategory('Photography'),userId: userId,),
    );
  }
}