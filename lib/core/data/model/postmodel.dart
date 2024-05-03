import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String imageUrl;
  final String title;
  final String price;
  final String category;
  final String about;
  final String userid;
  final String postid;
  String username; 
  String profileImageUrl;
   

  PostModel({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.category,
    required this.about,
        this.postid='',
        this.userid = '',
        this.username='',
        this.profileImageUrl=''
      
      
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return PostModel(
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      category: json['category'] ?? '',
      about: json['about'] ?? '',
      postid: id,
      userid: json['postId'] ?? '',
      username: json['username'] ?? '', 
      profileImageUrl: json['profileImageUrl'] ?? '', 
    );
  }
}

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
