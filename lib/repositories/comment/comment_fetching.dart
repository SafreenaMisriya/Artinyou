import 'package:art_inyou/models/model/commentmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<CommentModel>> getComments(String postId) async {
  List<CommentModel> comments = [];
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
       .collection('posts')
       .doc(postId)
       .collection('comment')
       .orderBy('commenttime',descending: true) 
       .get();

    for (var doc in querySnapshot.docs) {
      CommentModel p = CommentModel.fromJson(doc.data(),id: doc.id);
      comments.add(p);
    }
    return comments;

  } catch (e) {
    throw Exception('Failed to fetch comments: $e');
  }
}
Future<int> getCommentCount(String postId) async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comment') 
        .get();

    return querySnapshot.size;
  } catch (e) {
    throw Exception('Failed to fetch comment count: $e');
  }
}
