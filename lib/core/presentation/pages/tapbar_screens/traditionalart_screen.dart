import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/widgets/gridview.dart';
import 'package:flutter/material.dart';

class TraditionalArtScreen extends StatelessWidget {
  final String userid;
  const TraditionalArtScreen({super.key,required this.userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
             GridViewScreen(postsFuture: getPostsByCategory('TraditionalArt'), userId: userid),
      
    );
  }
}