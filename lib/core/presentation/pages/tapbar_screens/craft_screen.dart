import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/pages/home/gridview.dart';
import 'package:flutter/material.dart';

class CraftScreen extends StatelessWidget {
  final String userId;

  const CraftScreen({super.key,
  required this.userId,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GridViewScreen(postsFuture:getPostsByCategory('Craft'),userId: userId,),
    );
  }
}