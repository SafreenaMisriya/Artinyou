import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/widgets/gridview.dart';
import 'package:flutter/material.dart';

class GameArtScreen extends StatelessWidget {
  final String userid;
  const GameArtScreen({super.key,required this.userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          GridViewScreen(postsFuture: getPostsByCategory('Wallpapers'), userId: userid),
      
    );
  }
}