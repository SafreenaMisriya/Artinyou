import 'package:art_inyou/models/model/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Profilestorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Stream<void> addprofile(ProfileModel profile) async* {
    try {
      String userid = FirebaseAuth.instance.currentUser!.uid;
      await firestore.collection('profile').doc(userid).set({
        'imageUrl': profile.imageurl,
        'username': profile.username,
        'bio': profile.bio,
        'userId': userid,
        'followers': profile.followers,
        'following': profile.following,
      });
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  Stream<String> updateProfile(ProfileModel profile) async* {
    try {
      String userid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference profileRef =
          firestore.collection('profile').doc(userid);
      await profileRef.set({
        'imageUrl': profile.imageurl,
        'username': profile.username,
        'bio': profile.bio,
        'userId': userid,
      }, SetOptions(merge: true));
      yield userid;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<ProfileModel?> getProfile(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('profile')
          .doc(userId)
          .get();
      if (snapshot.exists) {
        return ProfileModel.fromJson(snapshot.data()!, id: snapshot.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<void> unfollowUser(String otheruserid) async {
    String currentuserid = FirebaseAuth.instance.currentUser!.uid;
    await firestore.collection('profile').doc(currentuserid).update({
      'following': FieldValue.arrayRemove([otheruserid])
    });
    await firestore.collection('profile').doc(otheruserid).update({
      'followers': FieldValue.arrayRemove([currentuserid])
    });
  }

  Future<void> followUser(String otheruserid) async {

    String currentuserid = FirebaseAuth.instance.currentUser!.uid;
    await firestore.collection('profile').doc(currentuserid).update({
      'following': FieldValue.arrayUnion([otheruserid])
    });
    await firestore.collection('profile').doc(otheruserid).update({
      'followers': FieldValue.arrayUnion([currentuserid])
    });
  }

  Future<bool> checkIfFollowing(
    String otherUserId,
  ) async {
    String currentuserid = FirebaseAuth.instance.currentUser!.uid;
    try {
      var userDoc =
          await firestore.collection('profile').doc(currentuserid).get();
      if (userDoc.exists) {
        List<dynamic> following = userDoc.data()?['following'] ?? [];
        bool isFollowing =  following.contains(otherUserId);
          return isFollowing;
      }
      return false;
    } catch (e) {

      return false;
    }
  }
}
