import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/pages/home/gridview.dart';
import 'package:flutter/material.dart';

class  CreativeScreen extends StatelessWidget {
    final String userId;

  const CreativeScreen({
    super.key,
    required this.userId,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GridViewScreen(postsFuture: getPostsByCategory('Creative'),userId: userId,),
    );
  }




}
