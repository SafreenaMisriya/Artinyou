import 'package:cloud_firestore/cloud_firestore.dart';

class SaveRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> savePost(String postId, String userId) async {
    try {
      bool isSaved = await hasUserSavedPost(userId, postId);
      if (!isSaved) {
        await firestore
            .collection('users_collection')
            .doc(userId)
            .collection('saved_posts')
            .doc(postId)
            .set({'saved': true});
      } else {
        throw Exception('Post is already saved by the user');
      }
    } catch (e) {
      throw Exception('Failed to save post: $e');
    }
  }

  Future<bool> hasUserSavedPost(String userId, String postId) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('users_collection')
          .doc(userId)
          .collection('saved_posts')
          .doc(postId)
          .get();

      return snapshot.exists;
    } catch (e) {
      throw Exception('Failed to check saved status: $e');
    }
  }

  Future<void> deleteSavedPost(String postId, String userId) async {
    try {
      await firestore
          .collection('users_collection')
          .doc(userId)
          .collection('saved_posts')
          .doc(postId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete saved post: $e');
    }
  }
}
