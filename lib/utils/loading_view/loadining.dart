import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerGridView(double height, double width) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: MasonryGridView.builder(
      itemCount: 10,  // Define the number of shimmer items you want to display
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height * 0.3,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.03,
                  width: height * 0.03,
                  color: Colors.white,
                ),
                SizedBox(width: width * 0.02),
                Container(
                  width: width * 0.3,
                  height: height * 0.02,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
