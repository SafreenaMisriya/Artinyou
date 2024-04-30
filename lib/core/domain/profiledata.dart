import 'package:art_inyou/core/data/model/profilemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
