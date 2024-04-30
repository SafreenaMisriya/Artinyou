import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/widgets/gridview.dart';
import 'package:flutter/material.dart';

class Screen3d extends StatelessWidget {
  final String userId;
  const Screen3d({super.key,
  required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GridViewScreen(postsFuture: getPostsByCategory('3D Art'),userId: userId,),
    );
  }
}