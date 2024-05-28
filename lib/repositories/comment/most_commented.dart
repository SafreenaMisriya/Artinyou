import 'package:art_inyou/models/model/postmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<PostModel>> mostCommentedPosts() async {
  List<PostModel> mostCommentedPosts = [];

  try {
    QuerySnapshot<Map<String, dynamic>> postsSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    int maxCommentCount = 0;

    for (var postDoc in postsSnapshot.docs) {
      String postId = postDoc.id;
      QuerySnapshot<Map<String, dynamic>> commentsSnapshot =
          await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comment').get();

      int commentCount = commentsSnapshot.docs.length;

      if (commentCount > maxCommentCount) {
        maxCommentCount = commentCount;
        mostCommentedPosts = [PostModel.fromJson(postDoc.data(), id: postId)];
      } else if (commentCount == maxCommentCount) {
        mostCommentedPosts.add(PostModel.fromJson(postDoc.data(), id: postId));
      }
    }
  } catch (e) {
    throw Exception('Failed to find most commented posts: $e');
  }

  return mostCommentedPosts;
}
Future<List<PostModel>> mostlikedPosts() async {
  List<PostModel> mostCommentedPosts = [];

  try {
    QuerySnapshot<Map<String, dynamic>> postsSnapshot =
        await FirebaseFirestore.instance.collection('posts').get();

    int maxCommentCount = 0;

    for (var postDoc in postsSnapshot.docs) {
      String postId = postDoc.id;
      QuerySnapshot<Map<String, dynamic>> commentsSnapshot =
          await FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').get();

      int commentCount = commentsSnapshot.docs.length;

      if (commentCount > maxCommentCount) {
        maxCommentCount = commentCount;
        mostCommentedPosts = [PostModel.fromJson(postDoc.data(), id: postId)];
      } else if (commentCount == maxCommentCount) {
        mostCommentedPosts.add(PostModel.fromJson(postDoc.data(), id: postId));
      }
    }
  } catch (e) {
    throw Exception('Failed to find most liked posts: $e');
  }

  return mostCommentedPosts;
}
