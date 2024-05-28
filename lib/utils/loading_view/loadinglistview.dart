import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerChatListView() {
  return Expanded(
    child: ListView.builder(
      itemCount: 10, // Number of shimmer items you want to show
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
              ),
              title: Container(
                width: double.infinity,
                height: 25.0,
                color: Colors.white,
              ),
              subtitle: Container(
                width: double.infinity,
                height: 25.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    ),
  );
}
