import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileModel {
  final String imageurl;
  final String username;
  final String bio;
  final String userid;
  // final String createdAt;
  // final bool isOnline;
  // final String lastActive;
  // final String pushToken;
  
  ProfileModel(
      {required this.username,
      required this.bio,
      required this.imageurl,
      required this.userid,
      // this.createdAt,
      // this.isOnline,
      // this.lastActive,
      // this.pushToken,
});

  factory ProfileModel.fromJson(Map<String, dynamic> json, {String id = ''}) {
    return ProfileModel(
      imageurl: json['imageUrl'] ?? '',
      username: json['username'] ?? '',
      // createdAt: json['createdAt']?? '',
      // isOnline: json['isOnline']?? '',
      // lastActive: json['lastActive']??'',
      // pushToken: json['pushToken'] ??'',
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
          'lastActive': DateTime.fromMicrosecondsSinceEpoch.toString(),
          'isOnline':false,
          'createdAt':DateTime.fromMicrosecondsSinceEpoch.toString(),
          'pushToken':''
        });
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception('Failed to add post: $e');
    }
  }

Future<String> updateProfile(ProfileModel profile) async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      DocumentReference profileRef = firestore.collection('profile').doc(userId);

      await profileRef.set({
        'imageUrl': profile.imageurl,
        'username': profile.username,
        'bio': profile.bio,
        'userId': userId,
      }, SetOptions(merge: true)); 
      return userId;
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
