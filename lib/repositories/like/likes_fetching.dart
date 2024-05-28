import 'package:cloud_firestore/cloud_firestore.dart';

Future<int> getPostLikeCount(String postId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get();

    return querySnapshot.size;
  } catch (e) {
    throw Exception('Failed to get like count: $e');
  }
}
