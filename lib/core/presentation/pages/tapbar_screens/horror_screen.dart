import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/pages/home/gridview.dart';
import 'package:flutter/material.dart';

class HorrorScreen extends StatelessWidget {
  final String userid;
  const HorrorScreen({super.key,required this.userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
           GridViewScreen(postsFuture: getPostsByCategory('Horror'), userId: userid),
    );
  }
}