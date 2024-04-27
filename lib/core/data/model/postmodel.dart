import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String imageUrl;
  final String title;
  final String price;
  final String category;
  final String about;

  PostModel({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.category,
    required this.about,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      imageUrl: json['imageUrl'] ?? '',
      title: json['title'] ?? '',
      price: json['price'] ?? '',
      category: json['category'] ?? '',
      about: json['about'] ?? '',
    );
  }
}
class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addPost(PostModel post) async {
    try {
      await firestore.collection('posts').add({
        'imageUrl':post.imageUrl,
        'title': post.title,
        'price': post.price,
        'category': post.category,
        'about': post.about,
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }
}