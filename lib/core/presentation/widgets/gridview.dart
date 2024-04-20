import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: MasonryGridView.builder(
          itemCount: 9,
          gridDelegate:
              const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(13), child: Image.asset('assets/image/img${index+1}.jpg')),
          ),
        
      ),
    );
  }
}
