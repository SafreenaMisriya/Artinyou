import 'package:art_inyou/core/presentation/utils/colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

   shimmerloading() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.builder(
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: greycolor,
              highlightColor: Colors.white,
              child: const SizedBox(
                height: 200,
                width: 200,
              )),
          itemCount: 10,
        ),
      );
    
  }
