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
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:your_app/firestore_service.dart';

// class YourUI extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final firestoreService = Provider.of<FirestoreService>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 // Example: Save a post
//                 try {
//                   await firestoreService.savePost(postId, userId);
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post saved successfully')));
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save post: $e')));
//                 }
//               },
//               child: Text('Save Post'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Example: Check if user has saved a post
//                 bool isSaved = await firestoreService.hasUserSavedPost(userId, postId);
//                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post saved: $isSaved')));
//               },
//               child: Text('Check Saved Post'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Example: Fetch saved posts for the user
//                 List<DocumentSnapshot> savedPosts = await firestoreService.fetchSavedPosts(userId);
//                 // Process the fetched saved posts as needed
//               },
//               child: Text('Fetch Saved Posts'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 // Example: Delete a saved post
//                 try {
//                   await firestoreService.deleteSavedPost(postId, userId);
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post deleted successfully')));
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete post: $e')));
//                 }
//               },
//               child: Text('Delete Saved Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

