import 'package:art_inyou/models/model/commentmodel.dart';
import 'package:art_inyou/models/model/likemodel.dart';
import 'package:art_inyou/models/model/postmodel.dart';
import 'package:art_inyou/models/model/profilemodel.dart';
import 'package:art_inyou/repositories/profile/profile_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Profilestorage profileStorage = Profilestorage();
  Future<void> addPost(PostModel post) async {
    try {
      ProfileModel? userProfile = await profileStorage.getProfile(post.userid);

      if (userProfile != null) {
        Map<String, dynamic> postData = {
          'imageUrl': post.imageUrl,
          'title': post.title,
          'softprice': post.softprice,
          'hardprice': post.hardprice,
          'category': post.category,
          'about': post.about,
          'postId': post.userid,
          'username': userProfile.username,
          'profileImageUrl': userProfile.imageurl,
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
        'softprice': post.softprice,
        'hardprice': post.hardprice,
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

  Future<void> addcomment(CommentModel comment, String postId) async {
    try {
      ProfileModel? userProfile =
          await profileStorage.getProfile(comment.userid);
      Map<String, dynamic> commentdata = {
        "comment": comment.text,
        'commentedby': userProfile?.username,
        'commenttime': comment.time,
        'commentedprofile': userProfile?.imageurl,
        'commenteduserId': comment.userid,
      };
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('comment')
          .add(commentdata);
    } catch (e) {
      throw Exception('Failed to comment post: $e');
    }
  }
  Future<bool> getUserLikeStatus(String userId, String postId) async {
  return await hasUserLikedPost(userId, postId);
  }

  Future<bool> hasUserLikedPost(String userId, String postId) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .doc(userId)
          .get();

      return snapshot.exists;
    } catch (e) {
      throw Exception('Failed to check like status: $e');
    }
  }
  
  Future<void> toggleLikePost(LikeModel model, String postId) async {
    try {
      bool hasLiked = await hasUserLikedPost(model.userid, postId);

      if (!hasLiked) {
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(model.userid)
            .set({'liked': model.isliked});
      } else {
        await firestore
            .collection('posts')
            .doc(postId)
            .collection('likes')
            .doc(model.userid)
            .delete();
      }
    } catch (e) {
      throw Exception('Failed to toggle like status: $e');
    }
  }

  Future<void> deleteComment(String postId, String commentid) async {
    try {
      await firestore
          .collection('posts')
          .doc(postId)
          .collection('comment')
          .doc(commentid)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }
   Future<PostModel> getPostDetails(String postId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = 
          await firestore.collection('posts').doc(postId).get();
      
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        PostModel post = PostModel.fromJson(data, id: docSnapshot.id);
        return post;
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      throw Exception('Failed to fetch post details: $e');
    }
  }
}
