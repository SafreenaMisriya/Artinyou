import 'package:art_inyou/core/domain/fetching.dart';
import 'package:art_inyou/core/presentation/widgets/gridview.dart';
import 'package:flutter/material.dart';

class PhotographyScreen extends StatelessWidget {
  const PhotographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridViewScreen(postsFuture: getPostsByCategory('Photography')),
    );
  }
}