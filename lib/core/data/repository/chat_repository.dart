import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chatrepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addmessage(MessageModel messageModel) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        await firestore.collection('profile').doc(userId).set({
          'fromId': userId,
          'toId': messageModel.toId,
          'message': messageModel.message,
          'timestamp': messageModel.timestamp,
        });
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }
}
