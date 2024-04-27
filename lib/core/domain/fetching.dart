  import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<PostModel>> getPosts() async {
    List<PostModel> posts = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      for (var doc in querySnapshot.docs) {
        posts.add(PostModel.fromJson(doc.data()));
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
    return posts;
  }
  Future<List<PostModel>> getPostsByCategory(String category) async {
  List<PostModel> posts = [];
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('posts').get();
    for (var doc in querySnapshot.docs) {
      var postModel = PostModel.fromJson(doc.data());
      // Check if the post belongs to the selected category
      if (postModel.category == category) {
        posts.add(postModel);
      }
    }
  } catch (e) {
    throw Exception('Failed to fetch posts: $e');
  }
  return posts;
}
