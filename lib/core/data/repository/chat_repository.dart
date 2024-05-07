import 'package:art_inyou/core/data/model/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class ChatRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addMessages(MessageModel message) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        await firestore
            .collection('conversations')
            .doc(userId)
            .collection('chat')
            .doc(message.toId)
            .collection('message')
            .add(message.toJson());

        await firestore
            .collection('conversations')
            .doc(message.toId)
            .collection('chat')
            .doc(userId)
            .collection('message')
            .add(message.toJson());
      }
    } catch (e) {
      throw Exception('Failed to send messages: $e');
    }
  }

  Stream<List<MessageModel>> getMessages(String toId) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return firestore
          .collection('conversations')
          .doc(userId)
          .collection('chat')
          .doc(toId)
          .collection('message')
          .orderBy('time')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.data()))
            .toList();
      });
    } else {
      return Stream.value([]);
    }
  }
  Future<void> markMessageAsRead(String conversationId, String messageId) async {
    try {
      // Update the message document to mark it as read
      await firestore
          .collection('conversations')
          .doc(conversationId)
          .collection('chat')
          .doc(messageId)
          .update({
        'read': true,
        // Optionally, you might want to update a timestamp indicating when the message was read
        'readTimestamp': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to mark message as read: $e');
    }
  }
}


