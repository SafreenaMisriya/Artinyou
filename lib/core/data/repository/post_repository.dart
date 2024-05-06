import 'package:art_inyou/core/data/model/postmodel.dart';
import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:art_inyou/core/data/repository/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
   final Profilestorage profileStorage = Profilestorage(); 
  Future<void> addPost(PostModel post) async {
    try {
       ProfileModel? userProfile = await profileStorage. getProfile(post.userid);

      if (userProfile != null) {
        Map<String, dynamic> postData = {
          'imageUrl': post.imageUrl,
          'title': post.title,
          'price': post.price,
          'category': post.category,
          'about': post.about,
          'postId': post.userid,
          'username': userProfile.username,
          'profileImageUrl':userProfile.imageurl,
          'createdAt': DateTime.now(),
        };
        await firestore.collection('posts').add(postData);
      } else {
        throw Exception('Profile not found for post: ${post.userid}');
      }
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

Future<void> updatePost(String postId, PostModel post) async {
  try {
    Map<String, dynamic> updateData = {
      'imageUrl': post.imageUrl,
      'title': post.title,
      'price': post.price,
      'category': post.category,
      'about': post.about,
      'createdAt': DateTime.now(),
    };
    
    await firestore.collection('posts').doc(postId).update(updateData);
  } catch (e) {
    throw Exception('Failed to update post: $e');
  }
}



   Future<void> deletePost(String postId) async {
    try {
      await firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
  
}