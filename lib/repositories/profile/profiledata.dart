import 'dart:async';
import 'package:art_inyou/models/model/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
Stream<List<ProfileModel>> getAllProfile() {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  try {
    return FirebaseFirestore.instance
        .collection('profile')
        .where('userId', isNotEqualTo: userId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => ProfileModel.fromJson(doc.data(), id: doc.id))
            .toList());
  } catch (e) {
    throw Exception('Failed to fetch profiles: $e');
  }
}

Future<List<Map<String, dynamic>>> getUserDetails(List<String> userIds) async {
  List<Map<String, dynamic>> userDetails = [];
  for (String userId in userIds) {
    var userDoc = await firestore.collection('profile').doc(userId).get();
    if (userDoc.exists) {
      userDetails.add(userDoc.data()!);
    }
  }
  return userDetails;
}

Stream<List<Map<String, dynamic>>> getFollowers(String userId) {
  return firestore
      .collection('profile')
      .doc(userId)
      .snapshots()
      .asyncMap((snapshot) async {
    if (snapshot.exists) {
      List<String> followersIds =
          List<String>.from(snapshot.data()?['followers'] ?? []);
      return await getUserDetails(followersIds);

    }
    return [];
  });
}

Stream<List<Map<String, dynamic>>> getFollowingStream(String userId) {
  return firestore.collection('profile').doc(userId).snapshots().asyncMap(
    (snapshot) async {
      if (snapshot.exists) {
        List<String> followingIds =
            List<String>.from(snapshot.data()?['following'] ?? []);
        return await getUserDetails(followingIds);
        
      }
      return [];
    },
  );
}
 Stream<int> getFollowersCount(String userId) {
    return firestore.collection('profile').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<String> followersIds = List<String>.from(snapshot.data()?['followers'] ?? []);
        return followersIds.length;
      }
      return 0;
    });
  }

  Stream<int> getFollowingCount(String userId) {
    return firestore.collection('profile').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<String> followingIds = List<String>.from(snapshot.data()?['following'] ?? []);
        return followingIds.length;
      }
      return 0;
    });
  }

  Future<int> getPostCount(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firestore.collection('posts').where('postId', isEqualTo: userId).get();
      return querySnapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }
