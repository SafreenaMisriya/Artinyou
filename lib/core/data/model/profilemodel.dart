import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileModel {
  final String imageurl;
  final String username;
  final String bio;
  final String userid;
  
  ProfileModel(
      {required this.username,
      required this.bio,
      required this.imageurl,
      required this.userid,
});

  factory ProfileModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return ProfileModel(
      imageurl: json['imageUrl'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      userid: id,

    );
  }
}

class Profilestorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addprofile(ProfileModel profile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        await firestore.collection('profile').doc(userId).set({
          'imageUrl': profile.imageurl,
          'username': profile.username,
          'bio': profile.bio,
          'userId': userId,
        });
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

  Future<void> updateProfile(ProfileModel profile) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference profileRef =
          firestore.collection('profile').doc(userId);
      DocumentSnapshot profileSnapshot = await profileRef.get();

      if (profileSnapshot.exists) {
        await profileRef.update({
          'imageUrl': profile.imageurl,
          'username': profile.username,
          'bio': profile.bio,
          'userId': userId,
        });
      } else {
        await profileRef.set({
          'imageUrl': profile.imageurl,
          'username': profile.username,
          'bio': profile.bio,
          'userId': userId,
        });
      }
    } else {
      throw Exception('User not authenticated');
    }
  } catch (e) {
    throw Exception('Failed to update profile: $e');
  }
}
 Future<ProfileModel?> getProfile(String userId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('profile').doc(userId).get();
    if (snapshot.exists) {
      return ProfileModel.fromJson(snapshot.data()!, id: snapshot.id);
    } else {
      return null;
    }
  } catch (e) {
    throw Exception('Failed to fetch profile: $e');
  }
}


}
