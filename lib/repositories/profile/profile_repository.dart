import 'package:art_inyou/models/model/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
Future<Map<String, dynamic>?> getLastMessageWithProfile(String chatroomId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> lastMessageSnapshot =
          await firestore.collection('conversations').doc(chatroomId).collection('lastMessage').doc(chatroomId).get();

      if (lastMessageSnapshot.exists) {
        // Get the sender's user ID from the last message
        String userId = lastMessageSnapshot.data()!['userId'];

        // Fetch the sender's profile information
        ProfileModel? senderProfile = await getProfile(userId);

        if (senderProfile != null) {
          // Construct the result with last message, sender's profile, and last message time
          return {
            'lastMessageTime': lastMessageSnapshot.data()!['time'],
            'lastMessage': lastMessageSnapshot.data()!['message'],
            'senderProfile': senderProfile,
          };
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch last message with profile: $e');
    }
  }


}
