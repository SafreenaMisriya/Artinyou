import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:art_inyou/core/domain/fetching.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

  Future<List<DocumentSnapshot>> fetchSavedPosts(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users_collection')
          .doc(userId)
          .collection('saved_posts')
          .get();

      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Failed to fetch saved posts: $e');
    }
    
  }
   Future<List<PostModel>> fetchSaved(String userId) async {
    try {
      List<DocumentSnapshot> savedPostsSnapshots = await fetchSavedPosts(userId);
      List<String> savedPostIds = savedPostsSnapshots.map((snapshot) => snapshot.id).toList();

      List<PostModel> allPosts = await getPosts();

      List<PostModel> savedPosts = allPosts.where((post) => savedPostIds.contains(post.postid)).toList();

      return savedPosts;
    } catch (e) {
      throw Exception('Failed to fetch saved posts and corresponding posts: $e');
    }
  }
